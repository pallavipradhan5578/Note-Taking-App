import 'package:flutter/material.dart';
import 'package:note_taking_app/db_handler.dart';
import 'notes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DBHelper dbHelper = DBHelper();
  late Future<List<NotesModel>> notesList;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() {
    setState(() {
      notesList = dbHelper.getNotesList();
    });
  }

  void showNoteBottomSheet({NotesModel? note}) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    TextEditingController titleController =
        TextEditingController(text: note?.title ?? "");
    TextEditingController descriptionController =
        TextEditingController(text: note?.description ?? "");
    TextEditingController emailController =
        TextEditingController(text: note?.email ?? "");
    TextEditingController ageController =
        TextEditingController(text: note?.age ?? "");

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 15,
            right: 15,
            top: 15,
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 20),
                _buildTextField(titleController, "Title"),
                const SizedBox(height: 5),
                _buildTextField(descriptionController, "Description"),
                const SizedBox(height: 5),
                _buildTextField(emailController, "Email"),
                const SizedBox(height: 5),
                _buildTextField(ageController, "Age"),
                const SizedBox(height: 15),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Change button color
                      foregroundColor: Colors.white, // Change text color
                      padding: const EdgeInsets.symmetric(
                          vertical: 15), // Add padding
                    ),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        if (note == null) {
                          dbHelper.insert(
                            NotesModel(
                              title: titleController.text,
                              description: descriptionController.text,
                              email: emailController.text,
                              age: ageController.text,
                            ),
                          );
                        } else {
                          dbHelper.update(
                            NotesModel(
                              id: note.id,
                              title: titleController.text,
                              description: descriptionController.text,
                              email: emailController.text,
                              age: ageController.text,
                            ),
                          );
                        }
                        Navigator.pop(context);
                        loadData();
                      }
                    },
                    child: Text(note == null ? "Add Note" : "Update Note"),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        validator: (value) => value!.isEmpty ? "Enter $label" : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "Note App",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<NotesModel>>(
        future: notesList,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final note = snapshot.data![index];
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Card(
                  color: Colors.blue.shade50,
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                    title: Text(note.title),
                    subtitle: Text(note.description),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => showNoteBottomSheet(note: note),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            dbHelper.delete(note.id!);
                            loadData();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () => showNoteBottomSheet(),
        child: const Icon(Icons.add,color: Colors.white,),
      ),
    );
  }
}
