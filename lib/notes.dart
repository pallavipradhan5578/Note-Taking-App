class NotesModel {
   int? id;
  final String title;
  final String description;
  final String email;
  final String age;

  NotesModel({
    required this.title,
    required this.description,
    required this.age,
    required this.email,
     this.id,
  });
  NotesModel.fromMap(Map<String, dynamic> res)
      :  id = res['id'],
        title = res['title'],
        description = res['description'],
        email = res['email'],
        age = res['age'];
  Map<String, Object?> toMap() {
    return {'id': id,
      'title': title,
      'description': description,
      'email': email,
      'age': age,

    };
  }
}
