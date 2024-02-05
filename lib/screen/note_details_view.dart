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
  final _focusNode = FocusNode();
  final _fNode = FocusNode();

  @override
  void initState() {
    refreshNotes();
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

//Gets the note from the database and updates the state if the noteId  is not null
// else it sets the isNewNote to true
  void refreshNotes() {
    if (widget.noteId == null) {
      setState(() {
        isNewNote = true;
      });
      return;
    }
    noteDatabase.read(widget.noteId!).then((noteValue) {
      setState(() {
        note = noteValue;
        titleController.text = note.title;
        contentController.text = note.content;
        isFavorite = note.isFavorite;
      });
    });
  }

//Create a new note i the isNewNote is true else it updates the
// existing note
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
      noteDatabase.create(model);
    } else {
      model.id = note.id;
      noteDatabase.update(model);
    }
    _focusNode.unfocus();
    _fNode.unfocus();
    setState(() {
      isLoading = false;
    });
  }

  void deleteNote() {
    Navigator.pop(context);
    noteDatabase.delete(note.id!);
    Navigator.pop(context);
  }

  void showAlertDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Do you want to delete this note?'),
            content: const Text('This action cannot be undone'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel')),
              TextButton(
                onPressed: deleteNote,
                child: const Text('Delete'),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Color color = Colors.white.withOpacity(0.7);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white.withOpacity(0.7)),
        backgroundColor: const Color.fromARGB(221, 43, 43, 43),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isFavorite = !isFavorite;
              });
            },
            icon: Icon(
              !isFavorite ? Icons.favorite_border : Icons.favorite,
              color: color,
            ),
          ),
          IconButton(
            onPressed: createNote,
            icon: const Icon(Icons.save),
            color: color,
          ),
          if(!isNewNote)
          IconButton(
            onPressed: showAlertDialog,
            icon: const Icon(Icons.delete),
            color: color,
          )
        ],
      ),
      body: NoteContent(
        isLoading: isLoading,
        controller: titleController,
        cController: contentController,
        focusNode: _focusNode,
        fNode: _fNode,
      ),
    );
  }
}
