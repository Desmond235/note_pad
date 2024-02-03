import 'package:flutter/material.dart';
import 'package:note_app/database/note_database.dart';
import 'package:note_app/model/note_model.dart';
import 'package:note_app/screen/note_details_view.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({super.key});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  NoteDatabase noteDatabase = NoteDatabase.instance;
  List<NoteModel> notes = [];

  @override
  void initState() {
    refreshNotes();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    // close the database
    noteDatabase.close();
  }

//  gets all notes from the database
  void refreshNotes() async {
    final notesValue = await noteDatabase.readAll();
    setState(() {
      notes = notesValue;
    });
  } 

  // Navigates to the NoteDetailsView screen
  goToNoteDetailsView({int? id}) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: ((context) => NoteDetailsView(noteId: id)),
      ),
    );
    refreshNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: notes.isEmpty
          ? const Center(
              child: Text('No notes yet'),
            )
          : ListView.builder(itemBuilder: (context, index) {
              final note = notes[index];

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Card(
                  child: GestureDetector(
                    onTap: goToNoteDetailsView(id: note.id),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          note.title,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 10),
                        Text(note.createdTime.toString().split(' ')[0])
                      ],
                    ),
                  ),
                ),
              );
            }),
      floatingActionButton: FloatingActionButton(
        onPressed: goToNoteDetailsView,
        tooltip: 'Add notes',
        child: const Icon(Icons.add),
      ),
    );
  }
}
