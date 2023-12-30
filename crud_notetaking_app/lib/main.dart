import 'package:flutter/material.dart';
import 'dart:developer' as dev;

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

  @override
  void initState() {
    super.initState();
  }

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
                  tileColor: Colors.greenAccent,
                  onTap: () {
                    //edit note
                    _editNote(index);
                  },
                  onLongPress: () {
                    //delete note
                    _deleteNote(index);
                  },
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
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        var actions2 = [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              //Save the note and update the UI
              setState(() {
                String oneNote = controller.text;
                if (oneNote.isNotEmpty) {
                  notes.add(oneNote);
                }
              });
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ];
        return AlertDialog(
          title: const Text("Add Note"),
          content: TextField(
            controller: controller,
          ),
          actions: actions2,
        );
      },
    );
  }

  void _editNote(int index) {
    TextEditingController controller = TextEditingController();
    controller.text = notes[index];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Note"),
        content: TextField(
          controller: controller,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                String oneNote = controller.text;
                if (oneNote.isNotEmpty) {
                  notes[index] = oneNote;
                }
              });
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void _deleteNote(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Note"),
        content: const Text("Are you sure you want to delete this note?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                notes.removeAt(index);
              });
              Navigator.pop(context);
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }
}
