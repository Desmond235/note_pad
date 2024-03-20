import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:note_app/database/note_database.dart';
import 'package:note_app/model/note_model.dart';
import 'package:note_app/screen/note_details_view.dart';
import 'package:note_app/widgets/search_bar.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  NoteDatabase noteDatabase = NoteDatabase.instance;
  List<NoteModel> notes = [];
  bool noteFound = true;

  void searchNote(String text) async {
    final noteItems = await noteDatabase.search(text);
    if (noteItems.isEmpty) {
      setState(() {
        noteFound = false;
      });
    } else {
      noteFound = true;
    }
    setState(() {
      notes = noteItems;
    });
  }

  void goToNoteDetailsView({int? id}) async {
    await Navigator.of(context).push<NoteDetailsView>(
      MaterialPageRoute(
        builder: ((context) => NoteDetailsView(noteId: id)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content = ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return Padding(
          padding: const EdgeInsets.all(10),
          child: GestureDetector(
            onTap: () => goToNoteDetailsView(id: note.id),
            child: Card(
              color: Theme.of(context).colorScheme.secondaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      note.title!,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      note.content!.trim(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Colors.black,
                          ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      note.createdTime.toString().split(' ')[0],
                      maxLines: 1,
                      style: TextStyle(color: Colors.black.withOpacity(0.6)),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    if (!noteFound) {
      content = Column(
        children: [
          const SizedBox(height: 10),
          Lottie.asset(
            'assets/lottiefiles/search.json',
            width: 200,
            height: 200,
            frameRate: FrameRate.max,
          ),
          Text(
            'Note not found',
            style:
                TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 18),
          ),
        ],
      );
    }

    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 50),
        child: Column(
          children: [
            SearchBars(
              onQueryChandged: searchNote,
            ),
            // const SizedBox(height: 10)
            Expanded(child: content)
          ],
        ),
      ),
    );
  }
}
