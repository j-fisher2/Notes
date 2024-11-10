import 'package:flutter/material.dart';

void main() {
  runApp(NoteTakingApp());
}

class NoteTakingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Note-Taking App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Note> notes = [];

  void addNote(Note note) {
    setState(() {
      notes.add(note);
    });
  }

  void replaceNote(Note newNote, int index){
    setState((){
      notes[index] = newNote;
    });
  }

  void deleteNote(int index){
    setState((){
      notes.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Notes'),
      ),
      body: notes.isEmpty
          ? Center(child: Text('No notes here.'))
          : ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          return GestureDetector(
              onTap: () async {
                final Note = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditNoteScreen(note: notes[index]),
                  ),
                );
                replaceNote(Note,index);
              },
          child: Card(
              color: notes[index].color,
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notes[index].title,
                        style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                          ),
                          ),
                    SizedBox(height: 8),
                      Text(
                            notes[index].description,
                            style: TextStyle(
                            fontSize: 14,
                            color: notes[index].color == Colors.yellow ? Colors.black : Colors.white,
                            ),
                          ),
                      SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            deleteNote(index);
                          },
                        ),
                      ),
                      ],
                  ),
                ),
            )
          );

        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newNote = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewNoteScreen()),
          );
          if (newNote != null) {
            addNote(newNote);
          }
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}

class NewNoteScreen extends StatefulWidget {
  @override
  _NewNoteScreenState createState() => _NewNoteScreenState();
}

class _NewNoteScreenState extends State<NewNoteScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String? errorMessage;
  Color color = Colors.blue;

  void saveNote() {
    final title = titleController.text.trim();
    final description = descriptionController.text.trim();

    if (title.isEmpty || description.isEmpty) {
      setState(() {
        errorMessage = 'Please fill in both fields';
      });
      return;
    }

    final newNote = Note(title: title, description: description, color:color);
    Navigator.pop(context, newNote);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Note'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (errorMessage != null)
              Text(
                errorMessage!,
                style: TextStyle(color: Colors.red),
              ),
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 8),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
              maxLines: 5,
            ),
            SizedBox(height: 16),
            Row(

              children: [
                Text("Blue"),
                Radio<Color>(
                  value: Colors.blue,
                  groupValue: color,
                  onChanged: (Color? value) {
                    setState(() {
                      color = value!;
                    });
                  },
                ),
                Text("Red"),
                Radio<Color>(
                  value: Colors.red,
                  groupValue: color,
                  onChanged: (Color? value) {
                    setState(() {
                      color = value!;
                    });
                  },
                ),
                Text("Yellow"),
                Radio<Color>(
                  value: Colors.yellow,
                  groupValue: color,
                  onChanged: (Color? value) {
                    setState(() {
                      color = value!;
                    });
                  },
                ),
                Text("Green"),
                Radio<Color>(
                  value: Colors.green,
                  groupValue: color,
                  onChanged: (Color? value) {
                    setState(() {
                      color = value!;
                    });
                  },
                ),
              ],
            ),
            Center(
              child: ElevatedButton(
                onPressed: saveNote,
                child: Text('Submit/Save'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EditNoteScreen extends StatefulWidget {
  final Note note;

  EditNoteScreen({required this.note});

  @override
  _EditNoteScreenState createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.note.title);
    descriptionController = TextEditingController(text: widget.note.description);
  }

  @override
  void dispose() {
    // Dispose controllers to avoid memory leaks
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
              onChanged: (value) {
                // Update the new title if needed
              },
            ),
            SizedBox(height: 8),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
              maxLines: 5,
              onChanged: (value) {
                // Update the new description if needed
              },
            ),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0), // Add top margin here
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  Note(
                    title: titleController.text,
                    description: descriptionController.text,
                    color: widget.note.color,
                  ),
                );
              },
              child: Text('Submit/Save'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ),
        ),
        ],
        ),
      ),
    );
  }
}

class Note {
  final String title;
  final String description;
  Color color;

  Note({
    required this.title,
    required this.description,
    required this.color,
  });
}
