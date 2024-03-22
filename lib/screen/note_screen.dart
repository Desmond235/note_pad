import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:note_app/database/note_database.dart';
import 'package:note_app/model/note_model.dart';
import 'package:note_app/screen/note_details_view.dart';
import 'package:note_app/screen/search_screen.dart';
import 'package:note_app/widgets/dialog.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({super.key});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  NoteDatabase noteDatabase = NoteDatabase.instance;
  List<NoteModel> notes = [];
  late NoteModel note;
  bool isLoading = true;
  bool isDeleted = false;

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
    noteDatabase.readAll().then((value) {
      setState(() {
        notes = value;
        isLoading = false;
      });
    });
  }

  // delete note
  void deleteNote(int id, NoteModel note) async {
    setState(() {
      isDeleted = true;
    });

    final mode =
        NoteModel(isDeleted: isDeleted, number: 2, createdTime: DateTime.now());
    if (isDeleted) {
      mode.id = id;
      noteDatabase.update(mode);
    }
    Navigator.of(context).pop();
    setState(() {
      notes.remove(note);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        padding:  EdgeInsets.all(10),
        content: Center(child: Text('note deleted')),
      ),
    );
  }

  // Navigates to the NoteDetailsView screen
  void goToNoteDetailsView({int? id}) async {
    await Navigator.of(context).push<NoteDetailsView>(
      MaterialPageRoute(
        builder: ((context) => NoteDetailsView(noteId: id)),
      ),
    );
    refreshNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Text(
          'NotePad',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              );
            },
            icon: Icon(
              Icons.search,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : notes.isEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        Center(
                          child: Lottie.asset(
                            'assets/lottiefiles/notepad.json',
                            width: 200,
                            height: 180,
                          ),
                        ),
                        const Positioned(
                          top: 140,
                          left: 130,
                          child: Center(
                            child: Text(
                              'No notes yet',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                )
              : Container(
                  margin: const EdgeInsets.only(top: 25),
                  padding: const EdgeInsets.all(5),
                  child: ListView.builder(
                      itemCount: notes.length,
                      itemBuilder: (context, index) {
                        final note = notes[index];
                        return Padding(
                          padding: const EdgeInsets.all(10),
                          child: GestureDetector(
                            onTap: () => goToNoteDetailsView(
                              id: note.id,
                            ),
                            child: Card(
                              margin: const EdgeInsets.all(2),
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer,
                              child: ListTile(
                                trailing: IconButton.filledTonal(
                                  onPressed: () => showAlertDialog(context, () {
                                    deleteNote(note.id!, note);
                                  }),
                                  icon: const Icon(Icons.delete),
                                ),
                                title: Padding(
                                  padding: const EdgeInsets.all(2),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        note.title,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium!
                                            .copyWith(color: Colors.black),
                                      ),
                                      Text(
                                        note.content.trim(),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(color: Colors.black),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        note.createdTime
                                            .toString()
                                            .split(' ')[0],
                                        maxLines: 1,
                                        style: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.8)),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: goToNoteDetailsView,
        tooltip: 'Create notes',
        child: Lottie.asset(
          'assets/lottiefiles/add.json',
          width: 50,
          height: 50,
          frameRate: FrameRate.max,
        ),
      ),
    );
  }
}
