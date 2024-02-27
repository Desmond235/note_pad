import 'package:flutter/material.dart';

class SearchBars extends StatelessWidget {
  const SearchBars({super.key, required this.onQueryChandged});
  final void Function(String) onQueryChandged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: TextField(
          cursorColor: Colors.white,
          style: const TextStyle(color: Colors.white),
          textInputAction: TextInputAction.search,
          onChanged: onQueryChandged,
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white.withOpacity(0.7)),
              borderRadius: BorderRadius.circular(20),
            ),
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                borderSide: BorderSide()),
            hintText: 'Search notes',
            hintStyle: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
