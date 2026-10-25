import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../l10n/strings.dart';
import '../src/personal_inbox_controller.dart';
import '../src/personal_notification_target.dart';
import '../src/personal_notifications_controller.dart';
import '../src/generated/space/v1/personal_notifications.pb.dart';

class PersonalInbox extends StatelessWidget {
  const PersonalInbox({super.key, required this.controller});
  final PersonalInboxController controller;

  @override
  Widget build(BuildContext context) => Dialog(
    child: ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: 720,
        maxHeight: (MediaQuery.sizeOf(context).height - 48).clamp(200, 680),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child:
            BlocBuilder<
              PersonalNotificationsController,
              PersonalNotificationsState
            >(
              bloc: controller.notifications,
              builder: (context, sources) =>
                  BlocBuilder<PersonalInboxController, PersonalInboxState>(
                    bloc: controller,
                    builder: (context, state) =>
                        _content(context, sources, state),
                  ),
            ),
      ),
    ),
  );

  Widget _content(
    BuildContext context,
    PersonalNotificationsState sources,
    PersonalInboxState state,
  ) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Row(
        children: [
          Expanded(
            child: Text(
              context.strings.notifications,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          IconButton(
            key: const ValueKey('personal-inbox-refresh'),
            tooltip: context.strings.notificationRefresh,
            onPressed: state.loading || state.marking
                ? null
                : controller.refresh,
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      const SizedBox(height: 16),
      DropdownButtonFormField<String>(
        key: ValueKey(state.scope?.key),
        initialValue: state.scope?.key,
        isExpanded: true,
        decoration: InputDecoration(
          labelText: context.strings.notificationSection,
        ),
        items: sources.scopes
            .map(
              (scope) => DropdownMenuItem(
                value: scope.key,
                child: Text(
                  scope.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
            .toList(),
        onChanged: (key) => controller.select(
          sources.scopes.where((s) => s.key == key).firstOrNull,
        ),
      ),
      const SizedBox(height: 16),
      if (state.failed)
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(context.strings.notificationInboxFailed),
        ),
      Expanded(child: _list(context, state)),
      const SizedBox(height: 16),
      Wrap(
        alignment: WrapAlignment.spaceBetween,
        spacing: 12,
        runSpacing: 8,
        children: [
          TextButton.icon(
            onPressed: state.loading || state.marking || state.history.isEmpty
                ? null
                : controller.previous,
            icon: const Icon(Icons.chevron_left),
            label: Text(context.strings.notificationPrevious),
          ),
          TextButton.icon(
            onPressed: state.loading || state.marking || !state.hasMore
                ? null
                : controller.next,
            icon: const Icon(Icons.chevron_right),
            label: Text(context.strings.notificationNext),
          ),
        ],
      ),
    ],
  );

  Widget _list(BuildContext context, PersonalInboxState state) {
    if (state.loading) return const Center(child: CircularProgressIndicator());
    if (state.scope == null) {
      return Center(child: Text(context.strings.notificationUnavailable));
    }
    if (state.items.isEmpty) {
      return Center(child: Text(context.strings.notificationInboxEmpty));
    }
    return ListView.separated(
      itemCount: state.items.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) => _row(context, state, state.items[index]),
    );
  }

  Widget _row(
    BuildContext context,
    PersonalInboxState state,
    PersonalNotification notice,
  ) {
    final mention = (notice.unreadReasons & 1) != 0;
    final reason = mention
        ? context.strings.dashboardMention
        : context.strings.notificationReply;
    return ListTile(
      key: ValueKey('personal-notice-${notice.id}'),
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      leading: Icon(mention ? Icons.alternate_email : Icons.reply),
      title: Text(
        notice.title.isEmpty ? reason : notice.title,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        [
          reason,
          notice.authorName,
          notice.snippet,
        ].where((s) => s.isNotEmpty).join('\n'),
        maxLines: 5,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: state.marking
          ? null
          : () => Navigator.of(context)
                .pop<PersonalNotificationTarget>(state.scope!.target(notice)),
      trailing: IconButton(
        key: ValueKey('personal-read-${notice.id}'),
        tooltip: context.strings.notificationMarkRead,
        onPressed: state.marking ? null : () => controller.markRead(notice),
        icon: const Icon(Icons.done),
      ),
    );
  }
}
