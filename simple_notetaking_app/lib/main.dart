import 'package:flutter/material.dart';

void main() {
  runApp(const SimpleNoteTakingApp());
}

class SimpleNoteTakingApp extends StatelessWidget {
  const SimpleNoteTakingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NoteList(),
    );
  }
}

class NoteList extends StatefulWidget {
  const NoteList({super.key});

  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  List<String> notes = [];
  String _oneNote = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Take Notes Simply"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(notes[index]),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                _addNote();
              },
              child: const Text("Add note"),
            ),
          ),
        ],
      ),
    );
  }

  void _addNote() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Note"),
        content: TextField(
          onChanged: (value) => {
            _oneNote = value,
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              //Save the note and update the UI
              setState(() {
                notes.add(_oneNote);
              });
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }
}
