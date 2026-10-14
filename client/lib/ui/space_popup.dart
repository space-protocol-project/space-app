import 'package:flutter/material.dart';

import 'space_appearance.dart';

Future<T?> showSpacePopup<T>(
  BuildContext context, {
  required WidgetBuilder builder,
  double top = 98,
  double width = 420,
  Key? surfaceKey,
}) => showGeneralDialog<T>(
  context: context,
  barrierDismissible: true,
  barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
  barrierColor: Colors.transparent,
  // Opacity перехода DialogRoute задерживает стеклянный BackdropFilter.
  transitionDuration: Duration.zero,
  pageBuilder: (context, _, _) => Dialog(
    alignment: Alignment.topRight,
    insetPadding: EdgeInsets.fromLTRB(16, top, 22, 16),
    backgroundColor: Colors.transparent,
    elevation: 0,
    child: SizedBox(
      width: width,
      child: GlassSurface(
        key: surfaceKey,
        blur: 24,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: builder(context),
        ),
      ),
    ),
  ),
);
