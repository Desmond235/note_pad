import 'package:flutter/material.dart';
import 'package:note_app/database/note_database.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  NoteDatabase noteDatabase = NoteDatabase.instance;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Padding(
        padding:const EdgeInsets.all(10),
        child:Container(
          margin:  const EdgeInsets.only(top: 20),
          child: const Column(
            children: [
              SearchBar()
            ],
          ),
        ),
        ),
    );
  }
}
