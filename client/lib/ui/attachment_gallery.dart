import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../l10n/strings.dart';

bool isGalleryImage(String name, [String mediaType = '']) {
  const supported = {
    'image/png',
    'image/jpeg',
    'image/webp',
    'image/gif',
    'image/bmp',
  };
  if (supported.contains(mediaType.toLowerCase())) return true;
  return RegExp(
    r'\.(png|jpe?g|webp|gif|bmp)$',
    caseSensitive: false,
  ).hasMatch(name);
}

class MessageImage {
  const MessageImage({
    required this.id,
    required this.name,
    required this.source,
    this.load,
    this.save,
  });
  final String id, name;
  final Object? source;
  final Future<Uint8List> Function(bool Function() cancelled)? load;
  final Future<void> Function()? save;
}

// Ограничиваем одновременное получение и декодирование файлов всего чата.
class _ImageQueue {
  int active = 0;
  final tasks = <Future<void> Function()>[];
  Future<T> run<T>(Future<T> Function() action, {bool priority = false}) {
    final result = Completer<T>();
    Future<void> task() async {
      try {
        result.complete(await action());
      } catch (error, stack) {
        result.completeError(error, stack);
      } finally {
        active--;
        pump();
      }
    }

    if (priority) {
      tasks.insert(0, task);
    } else {
      tasks.add(task);
    }
    pump();
    return result.future;
  }

  void pump() {
    while (active < 2 && tasks.isNotEmpty) {
      active++;
      unawaited(tasks.removeAt(0)());
    }
  }
}

final _queue = _ImageQueue();

class AttachmentGallery extends StatelessWidget {
  const AttachmentGallery({super.key, required this.images});
  final List<MessageImage> images;
  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) return const SizedBox.shrink();
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 360),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = math.min(360.0, constraints.maxWidth);

          return SizedBox(
            width: width,
            child: GridView.count(
              crossAxisCount: _columnCount(width),
              childAspectRatio: images.length == 1 ? 4 / 3 : 1,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                for (var i = 0; i < images.length && i < 5; i++)
                  _thumbnail(context, i),
              ],
            ),
          );
        },
      ),
    );
  }

  int _columnCount(double width) {
    if (images.length == 1) return 1;
    return images.length >= 3 && width >= 300 ? 3 : 2;
  }

  Widget _thumbnail(BuildContext context, int index) => ClipRRect(
    borderRadius: BorderRadius.circular(10),
    child: Material(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: InkWell(
        onTap: images[index].load == null
            ? null
            : () => showDialog<void>(
                context: context,
                builder: (_) => _GalleryViewer(
                  images: images.take(5).toList(),
                  initial: index,
                ),
              ),
        child: Semantics(
          button: true,
          label: images[index].name,
          child: _ImagePreview(
            key: ValueKey(images[index].id),
            image: images[index],
          ),
        ),
      ),
    ),
  );
}

class _ImagePreview extends StatefulWidget {
  const _ImagePreview({super.key, required this.image, this.full = false});
  final MessageImage image;
  final bool full;
  @override
  State<_ImagePreview> createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<_ImagePreview> {
  ui.Image? image;
  bool failed = false;
  int generation = 0;
  @override
  void initState() {
    super.initState();
    unawaited(load());
  }

  @override
  void didUpdateWidget(covariant _ImagePreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.image.id != widget.image.id ||
        !identical(oldWidget.image.source, widget.image.source)) {
      image?.dispose();
      image = null;
      failed = false;
      unawaited(load());
    }
  }

  Future<void> load() async {
    final current = ++generation;
    final entry = widget.image;
    if (entry.load == null) return;
    try {
      final decoded = await _queue.run(
        () => _loadImage(entry, current),
        priority: widget.full,
      );
      if (!mounted || current != generation) {
        decoded.dispose();
        return;
      }
      setState(() => image = decoded);
    } catch (_) {
      if (mounted && current == generation) setState(() => failed = true);
    }
  }

  @override
  void dispose() {
    generation++;
    image?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (image != null) {
      final picture = RawImage(
        image: image,
        fit: widget.full ? BoxFit.contain : BoxFit.cover,
      );
      return widget.full
          ? InteractiveViewer(
              minScale: 1,
              maxScale: 5,
              child: Center(child: picture),
            )
          : picture;
    }
    if (failed || widget.image.load == null) {
      return Center(
        child: failed
            ? IconButton(
                tooltip:
                    '${widget.image.name}\n${context.strings.retryProfile}',
                onPressed: () {
                  setState(() => failed = false);
                  unawaited(load());
                },
                icon: const Icon(Icons.refresh),
              )
            : Tooltip(
                message: widget.image.name,
                child: const Icon(Icons.image_not_supported_outlined),
              ),
      );
    }
    return const Center(
      child: SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }

  Future<ui.Image> _loadImage(MessageImage entry, int current) async {
    final deadline = DateTime.now().add(const Duration(seconds: 30));
    bool cancelled() =>
        !mounted || current != generation || DateTime.now().isAfter(deadline);
    if (cancelled()) throw StateError('Предпросмотр закрыт');
    final bytes = await entry.load!(cancelled);
    if (cancelled() || bytes.length > 20 * 1024 * 1024) {
      throw StateError('Предпросмотр недоступен');
    }
    return _decodeImage(bytes, widget.full ? 2048 : 480);
  }

  Future<ui.Image> _decodeImage(Uint8List bytes, int limit) async {
    final codec = await ui.instantiateImageCodecWithSize(
      await ui.ImmutableBuffer.fromUint8List(bytes),
      getTargetSize: (width, height) => _targetSize(width, height, limit),
    );
    try {
      return (await codec.getNextFrame()).image;
    } finally {
      codec.dispose();
    }
  }

  ui.TargetImageSize _targetSize(int width, int height, int limit) {
    if (width > 20000 || height > 20000 || width * height > 64000000) {
      throw StateError('Слишком большое изображение');
    }
    final scale = math.min(1.0, limit / math.max(width, height));
    return ui.TargetImageSize(
      width: math.max(1, (width * scale).round()),
      height: math.max(1, (height * scale).round()),
    );
  }
}

class _GalleryViewer extends StatefulWidget {
  const _GalleryViewer({required this.images, required this.initial});
  final List<MessageImage> images;
  final int initial;
  @override
  State<_GalleryViewer> createState() => _GalleryViewerState();
}

class _GalleryViewerState extends State<_GalleryViewer> {
  late final pages = PageController(initialPage: widget.initial);
  late int index = widget.initial;
  bool saving = false;
  void move(int offset) {
    final next = index + offset;
    if (next < 0 || next >= widget.images.length) return;
    unawaited(
      pages.animateToPage(
        next,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
      ),
    );
  }

  Future<void> save() async {
    final action = widget.images[index].save;
    if (action == null || saving) return;
    setState(() => saving = true);
    try {
      await action();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(context.strings.downloadFailed)));
      }
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  @override
  void dispose() {
    pages.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Dialog.fullscreen(
    child: CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.escape): () =>
            Navigator.pop(context),
        const SingleActivator(LogicalKeyboardKey.arrowLeft): () => move(-1),
        const SingleActivator(LogicalKeyboardKey.arrowRight): () => move(1),
      },
      child: Focus(
        autofocus: true,
        child: SafeArea(
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    tooltip: context.strings.close,
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                  Expanded(
                    child: Text(
                      widget.images[index].name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text('${index + 1} / ${widget.images.length}'),
                  IconButton(
                    tooltip: context.strings.downloadFile,
                    onPressed: saving || widget.images[index].save == null
                        ? null
                        : save,
                    icon: const Icon(Icons.download),
                  ),
                ],
              ),
              Expanded(
                child: PageView.builder(
                  controller: pages,
                  itemCount: widget.images.length,
                  onPageChanged: (value) => setState(() => index = value),
                  itemBuilder: (_, i) => _ImagePreview(
                    key: ValueKey(widget.images[i].id),
                    image: widget.images[i],
                    full: true,
                  ),
                ),
              ),
              if (widget.images.length > 1)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      tooltip: MaterialLocalizations.of(context)
                          .previousPageTooltip,
                      onPressed: index > 0 ? () => move(-1) : null,
                      icon: const Icon(Icons.chevron_left),
                    ),
                    IconButton(
                      tooltip: MaterialLocalizations.of(context)
                          .nextPageTooltip,
                      onPressed: index + 1 < widget.images.length
                          ? () => move(1)
                          : null,
                      icon: const Icon(Icons.chevron_right),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    ),
  );
}
