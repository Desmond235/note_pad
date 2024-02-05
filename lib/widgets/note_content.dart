import 'package:flutter/material.dart';

class NoteContent extends StatelessWidget {
  const NoteContent({
    super.key,
    required this.isLoading,
    required this.controller,
    required this.cController,
    required this.focusNode,
    required this.fNode

  });
  final bool isLoading;
  final TextEditingController controller;
  final TextEditingController cController;
  final FocusNode focusNode;
  final FocusNode fNode;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  TextField(
                    controller: controller,
                    cursorColor: Colors.white,
                    focusNode: focusNode,
                    style: const TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      border: InputBorder.none,
                      hintText: 'Title',
                      hintStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextField(
                    controller: cController,
                    cursorColor: Colors.white,
                    focusNode: fNode,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      border: InputBorder.none,
                      hintText: 'Type your note here',
                      hintStyle: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
