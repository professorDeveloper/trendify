class NotificationModel {
  final String id;
  final String title;
  final String body;
  final String time;
  final String emoji;
  final bool isRead;
  final String group;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.time,
    required this.emoji,
    required this.isRead,
    required this.group,
  });
}