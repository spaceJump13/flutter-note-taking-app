import 'package:flutter/material.dart';
import 'package:flutter_uas/HomePage.dart';
import 'package:flutter_uas/model/note.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class DetailNotePage extends StatefulWidget {
  final int noteIndex;

  const DetailNotePage({Key? key, required this.noteIndex}) : super(key: key);

  @override
  _DetailNotePageState createState() => _DetailNotePageState();
}

class _DetailNotePageState extends State<DetailNotePage> {
  final _notesBox = Hive.box<Note>('boxnotes');
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late DateTime _createdAt;

  @override
  void initState() {
    super.initState();
    final note = _notesBox.getAt(widget.noteIndex)!;
    _titleController = TextEditingController(text: note.title);
    _contentController = TextEditingController(text: note.content);
    _createdAt = note.createdAt; // Assign createdAt value
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _updateNote() {
    final note = _notesBox.getAt(widget.noteIndex)!;
    note.title = _titleController.text;
    note.content = _contentController.text;
    note.updatedAt = DateTime.now();
    note.save();
    setState(() {});
    _navigateToHomePage(context);
  }

  void _navigateToHomePage(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat timeFormatter = DateFormat('MMMM dd, yyyy HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Note Detail', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700))),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: _updateNote,
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  hintText: 'Title',
                  border: InputBorder.none,
                ),
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 22.0,
                ),
              ),
              Text(
                'Created at: ${timeFormatter.format(_createdAt)}',
                style: const TextStyle(
                  color: Color.fromARGB(255, 175, 175, 175),
                  fontSize: 15.0,
                ),
              ),
              const SizedBox(height: 10.0),
              TextField(
                controller: _contentController,
                decoration: const InputDecoration(
                  hintText: 'Content',
                  border: InputBorder.none,
                ),
                style: const TextStyle(fontSize: 18.0),
                maxLines: null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
