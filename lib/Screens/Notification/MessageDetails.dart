class MessageDetails {
  int id;
  String title;
  String body;
  int hour;
  int minute;
  bool repeats;
  int active;
  MessageDetails({
    required this.id,
    required this.title,
    required this.body,
    required this.hour,
    required this.repeats,
    required this.minute,
    required this.active
  });
}
