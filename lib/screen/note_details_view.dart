import 'package:flutter/material.dart';
import 'package:note_app/database/note_database.dart';
import 'package:note_app/model/note_model.dart';
import 'package:note_app/widgets/note_content.dart';

class NoteDetailsView extends StatefulWidget {
  const NoteDetailsView({super.key, this.noteId});
  final int? noteId;

  @override
  State<NoteDetailsView> createState() => _NoteDetailsViewState();
}

class _NoteDetailsViewState extends State<NoteDetailsView> {
  NoteDatabase noteDatabase = NoteDatabase.instance;
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  late NoteModel note;
  bool isNewNote = false;
  bool isLoading = false;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    refreshNotes();
  }

//
  void refreshNotes() {
    if (widget.noteId == null) {
      setState(() {
        isNewNote = true;
      });
      return;
    }
    noteDatabase.read(note.id!).then((noteValue) {
      setState(() {
        note = noteValue;
        titleController.text = note.title;
        contentController.text = note.content;
        isFavorite = note.isFavorite;
      });
    });
  }

  void createNote() {
    setState(() {
      isLoading = true;
    });

    final model = NoteModel(
      title: titleController.text,
      number: 1,
      content: contentController.text,
      isFavorite: isFavorite,
      createdTime: DateTime.now(),
    );
    if (isNewNote) {
      noteDatabase.create(note);
    } else {
      model.id = note.id;
    }
    setState(() {
      isLoading = false;
    });
  }

  void deleteNote() {
    noteDatabase.delete(note.id!);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isFavorite = !isFavorite;
              });
            },
            icon: Icon(!isFavorite ? Icons.favorite_border : Icons.favorite),
          ),
          Visibility(
            visible: !isNewNote,
            child: IconButton(
              onPressed: createNote,
              icon: const Icon(Icons.save),
            ),
          ),
          IconButton(
            onPressed: deleteNote,
            icon: const Icon(Icons.delete),
          )
        ],
      ),
      body: NoteContent(
        isLoading: isLoading,
        controller: titleController,
        cController: contentController,
      ),
    );
  }
}
