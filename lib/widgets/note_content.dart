import 'package:flutter/material.dart';

class NoteContent extends StatelessWidget {
  const NoteContent({
    super.key,
    required this.isLoading,
    required this.controller,
    required this.cController,
  });
  final bool isLoading;
  final TextEditingController controller;
  final TextEditingController cController;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: !isLoading
          ? const CircularProgressIndicator()
          : Column(
              children: [
                TextField(
                  controller: controller,
                  cursorColor: Colors.white,
                  style: const TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: const InputDecoration(
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
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Type your note here',
                    hintStyle: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                )
              ],
            ),
    );
  }
}
