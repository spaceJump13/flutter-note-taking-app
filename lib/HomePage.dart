import 'package:flutter/material.dart';
import 'package:flutter_uas/AddNote.dart';
import 'package:flutter_uas/ChangePin.dart';
import 'package:flutter_uas/DetailNote.dart';
import 'package:flutter_uas/LoginPage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_uas/model/note.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isSortedByLastModified = false;
  final _notesBox = Hive.box<Note>('boxnotes');
  final _searchController = TextEditingController();

  void _deleteNoteAt(int index) {
    _confirmDeleteDialog(index);
  }

  void _confirmDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Note", style: TextStyle(fontSize: 22.0),),
          content: const Text("Are you sure you want to delete this note?", style: TextStyle(fontSize: 17.0),),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text("Delete"),
              onPressed: () {
                _notesBox.deleteAt(index);
                setState(() {});
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  void _sortNotesByLastModified() {
    setState(() {
      _isSortedByLastModified = !_isSortedByLastModified;
    });
  }

  void _navigateToChangePINPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ChangePin()),
    );
  }

  void _logout(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  void _navigateToDetailNotePage(BuildContext context, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetailNotePage(noteIndex: index)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat timeFormatter = DateFormat('dd-MM-yyyy HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Notes',
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.lock_open),
            onPressed: () => _navigateToChangePINPage(context),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: 17.0, top: 20.0, right: 17.0, bottom: 12.0),
            child: TextField(
              controller: _searchController, // Link to the controller
              onChanged: (value) => setState(() {
                _searchController.text = value;
              }),
              decoration: const InputDecoration(
                focusColor: Colors.orange,
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  borderSide: BorderSide(color: Colors.orange),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.sort),
                onPressed: _sortNotesByLastModified,
              ),
            ],
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: _notesBox.listenable(),
              builder: (context, Box<Note> box, _) {
                if (box.values.isEmpty) {
                  return const Center(
                    child: Text('No Records', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20.0)),
                  );
                }

                List<Note> notes = List.from(box.values.cast<Note>());

                // buat jalankan sortir
                if (_isSortedByLastModified) {
                  notes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
                }

                // buat jalankan live search
                if (_searchController.text.isNotEmpty) {
                  final searchText = _searchController.text.toLowerCase();
                  notes = notes
                      .where((note) =>
                          note.title.toLowerCase().contains(searchText) ||
                          note.content.toLowerCase().contains(searchText))
                      .toList();
                }

                return ListView.builder(
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    final note = notes[index];

                    return GestureDetector(
                      onTap: () {
                        _navigateToDetailNotePage(context, index);
                      },
                      child: Card(
                        margin: const EdgeInsets.only(
                            left: 17.0, right: 17.0, bottom: 12.0, top: 12.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          // side: const BorderSide(
                          //     color: Colors.grey, width: 2),
                        ),
                        elevation: 5.0,
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                note.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 22.0,
                                ),
                              ),
                              const SizedBox(height: 7.0),
                              Text(
                                note.content,
                                style: const TextStyle(
                                  fontSize: 18.0,
                                ),
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 10.0),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Created: ${timeFormatter.format(note.createdAt)}',
                                        style: const TextStyle(
                                          fontSize: 13.0,
                                          color: Color.fromARGB(
                                              255, 175, 175, 175),
                                        ),
                                      ),
                                      Text(
                                        'Last Modified: ${timeFormatter.format(note.updatedAt)}',
                                        style: const TextStyle(
                                          fontSize: 13.0,
                                          color: Color.fromARGB(
                                              255, 175, 175, 175),
                                        ),
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () => _deleteNoteAt(index),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddNotePage()),
          );
        },
        backgroundColor: const Color.fromARGB(255, 16, 29, 40), // Ubah warna background sesuai kebutuhan
        child: const Icon(Icons.edit), // Ubah ikon menjadi ikon edit
      ),
    );
  }
}
