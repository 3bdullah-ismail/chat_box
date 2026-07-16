import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

String formatTime(int milliseconds) {
  if (milliseconds == 0) return "";
  final date = DateTime.fromMillisecondsSinceEpoch(milliseconds);
  return DateFormat('hh:mm a').format(date);
}

String formatLastSeen(int timestamp) {
  if (timestamp == 0) return "";
  final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
  final now = DateTime.now();
  final diff = now.difference(date);

  if (diff.inMinutes < 1) {
    return "Just now";
  }

  if (diff.inHours < 1) {
    return "${diff.inMinutes} min ago";
  }

  if (diff.inHours < 24) {
    return DateFormat("h:mm a").format(date);
  }

  if (diff.inDays < 7) {
    return timeago.format(date);
  }

  return DateFormat("dd/MM/yyyy").format(date);
}
