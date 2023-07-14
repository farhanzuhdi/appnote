// ignore_for_file: prefer_typing_uninitialized_variables

class Note {
  int id;
  var title;
  var description;
  String createdAt;
  bool? check;

  Note(
      {required this.id,
      required this.title,
      required this.description,
      required this.createdAt,
      this.check});

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'] ?? 0,
      title: json['title'] ?? '''''',
      description: json['description'] ?? '''''',
      createdAt: json['createdAt'] ?? "",
      check: json['check'] ?? false,
    );
  }
}
