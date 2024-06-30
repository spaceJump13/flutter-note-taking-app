import 'package:flutter/material.dart';
import 'package:flutter_uas/HomePage.dart';
import 'package:flutter_uas/model/note.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class AddNotePage extends StatefulWidget {
  const AddNotePage({super.key});

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  final _notesBox = Hive.box<Note>('boxnotes');
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  int _charCount = 0;

  void _addNote() {
    final newNote = Note(
      title: _titleController.text,
      content: _contentController.text,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    _notesBox.add(newNote);

    _titleController.clear();
    _contentController.clear();
    setState(() {});
    _navigateToHomePage(context);
  }

  void _updateCharCount(String text) {
    setState(() {
      _charCount = text.length;
    });
  }

  void _navigateToHomePage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat timeFormatter = DateFormat('MMMM dd, yyyy HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Add Note', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700))),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _addNote,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'Title...',
                hintStyle: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 22.0), // Adjust font size and weight
                border: InputBorder.none,
              ),
              style: const TextStyle(
                  fontWeight: FontWeight.w900,
                    fontSize: 22.0), // Set text style for entered text
            ),
            Row(
              children: [
                Text(timeFormatter.format(DateTime.now())),
                const SizedBox(
                  width: 10.0,
                ),
                const Text('|'),
                const SizedBox(
                  width: 10.0,
                ),
                Text('${_charCount.toString()} characters'),
              ],
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: TextField(
                controller: _contentController,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: 'Start Typing...',
                  border: InputBorder.none,
                ),
                style: const TextStyle(fontSize: 18.0),
                onChanged: _updateCharCount,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
