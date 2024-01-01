// import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future main() async {
  // Initialize FFI
  sqfliteFfiInit();

  // Change the default factory. On iOS/Android, if not using `sqlite_flutter_lib` you can forget
  // this step, it will use the sqlite version available on the system.
  databaseFactory = databaseFactoryFfi;
  runApp(const SqQLliteNoteApp());
}

class SqQLliteNoteApp extends StatelessWidget {
  const SqQLliteNoteApp({super.key});

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
  // ignore: library_private_types_in_public_api
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  static Database? _database;
  List<String> notes = [];

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'notes.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE notes(id INTEGER PRIMARY KEY, content TEXT)
          ''');
      },
    );

    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final List<Map<String, dynamic>> result = await _database!.query('notes');

    setState(() {
      notes = result.map((e) => e['content'].toString()).toList();
    });
  }

  Future<void> _addNote(String content) async {
    await _database!.insert('notes', {'content': content});
    _loadNotes();
  }

  Future<void> _editNote(int id, String content) async {
    await _database!.update('notes', {'content': content}, where: 'id = ?', whereArgs: [id]);
    _loadNotes();
  }

  Future<void> _deleteNote(int id) async {
    await _database!.delete('notes', where: 'id = ?', whereArgs: [id]);
    _loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cool Note App'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(notes[index]),
                  onTap: () {
                    // For simplicity, let's assume you have an 'id' associated with each note
                    _editNoteDialog(index + 1, notes[index]);
                  },
                  onLongPress: () {
                    _deleteNoteDialog(index + 1);
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                _addNoteDialog();
              },
              child: const Text('Add Note'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _addNoteDialog() async {
    TextEditingController controller = TextEditingController();

    await showDialog(
      context: this.context,
      builder: (context) => AlertDialog(
        title: const Text('Add Note'),
        content: TextField(
          controller: controller,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _addNote(controller.text);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _editNoteDialog(int id, String content) async {
    TextEditingController controller = TextEditingController(text: content);
    await showDialog(
      context: this.context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Note'),
        content: TextField(
          controller: controller,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _editNote(id, controller.text);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteNoteDialog(int id) async {
    await showDialog(
      context: this.context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Note'),
        content: const Text('Are you sure you want to delete this note?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _deleteNote(id);
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
