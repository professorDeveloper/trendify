import 'notificaiton_model.dart';

final List<NotificationModel> generalNotifications = [
  NotificationModel(
    id: '1',
    title: 'Account Security Alert',
    emoji: '🔒',
    body:
    "We've noticed some unusual activity on your account. Please review your recent logins and update your password if necessary.",
    time: '09:41 AM',
    isRead: false,
    group: 'Today',
  ),
  NotificationModel(
    id: '2',
    title: 'System Update Available',
    emoji: '🔄',
    body:
    'A new system update is ready for installation. It includes performance improvements and bug fixes.',
    time: '08:46 AM',
    isRead: false,
    group: 'Today',
  ),
  NotificationModel(
    id: '3',
    title: 'Password Reset Successful',
    emoji: '✅',
    body:
    "Your password has been successfully reset. If you didn't request this change, please contact support immediately.",
    time: '20:30 PM',
    isRead: true,
    group: 'Yesterday',
  ),
  NotificationModel(
    id: '4',
    title: 'Exciting New Feature',
    emoji: '🆕',
    body:
    "We've just launched a new feature that will enhance your user experience. Check it out now!",
    time: '16:29 PM',
    isRead: true,
    group: 'Yesterday',
  ),
  NotificationModel(
    id: '5',
    title: 'Payment Confirmed',
    emoji: '💳',
    body:
    'Your payment of \$49.99 has been successfully processed. Thank you for your purchase.',
    time: '11:00 AM',
    isRead: true,
    group: 'Yesterday',
  ),
];

final List<NotificationModel> promotionNotifications = [
  NotificationModel(
    id: '6',
    title: 'Flash Sale — 50% Off!',
    emoji: '🔥',
    body:
    'Limited time offer! Get 50% off on all premium plans. Hurry, the sale ends tonight.',
    time: '10:00 AM',
    isRead: false,
    group: 'Today',
  ),
  NotificationModel(
    id: '7',
    title: 'Refer & Earn',
    emoji: '🎁',
    body:
    'Invite your friends and earn \$10 for every successful referral. Start sharing now!',
    time: '09:00 AM',
    isRead: true,
    group: 'Today',
  ),
  NotificationModel(
    id: '8',
    title: 'Weekend Deal',
    emoji: '🛍️',
    body:
    "This weekend only — upgrade to Pro and get 3 months free. Don't miss out!",
    time: '18:00 PM',
    isRead: true,
    group: 'Yesterday',
  ),
];