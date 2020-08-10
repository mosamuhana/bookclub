class TimeLeft {
  static String timeLeft(DateTime due) {
    String result;

    Duration d = due.difference(DateTime.now());

    int days = d.inDays;
    int hours = d.inHours - (days * 24);
    int mins = d.inMinutes - (days * 24 * 60) - (hours * 60);

    if (days > 0) {
      result = '$days days\n$hours hours\n$mins mins';
    } else if (hours > 0) {
      result = '$hours hours\n$mins mins';
    } else if (mins > 0) {
      result = '$mins mins';
    } else if (mins == 0) {
      result = "almost there ";
    } else {
      result = "error";
    }

    return result;
  }
}
