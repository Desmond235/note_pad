import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  const SearchBar(this.onQueryChandged, {super.key});
  final void Function(String query) onQueryChandged;

  @override
  Widget build(BuildContext context) {
    FocusNode focusNode = FocusNode();
    return Container(
      padding: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: TextField(
          focusNode: focusNode,
          cursorColor: Colors.white,
          textInputAction: TextInputAction.search,
          onSubmitted: (value) {
            focusNode.unfocus();
          },
          decoration: const InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                borderSide: BorderSide()),
            hintText: 'Search notes',
            hintStyle: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
