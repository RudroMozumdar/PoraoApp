String formatTimeDifference(Duration difference) {
  final seconds = difference.inSeconds;
  final minutes = difference.inMinutes;
  final hours = difference.inHours;
  final days = difference.inDays;

  if (days > 0) {
    return '$days day${days > 1 ? 's' : ''}';
  } else if (hours > 0) {
    return '$hours hr${hours > 1 ? 's' : ''}';
  } else if (minutes > 0) {
    return '$minutes min${minutes > 1 ? 's' : ''}';
  } else {
    return '$seconds sec${seconds > 1 ? 's' : ''}';
  }
}
