import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../utils/json_model/notes_model.dart';
import '../authentication/sqlite/sqlite.dart';

class CreateNote extends StatefulWidget {
  const CreateNote({super.key});

  @override
  State<CreateNote> createState() => _CreateNoteState();
}

class _CreateNoteState extends State<CreateNote> {
  final _tiltefocusNode = FocusNode();
  final _contentfocusNode = FocusNode();
  final title = TextEditingController();
  final content = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final db = DataBaseHelper();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create note"),
        actions: [
          IconButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  db
                      .createNote(NoteModel(
                      noteTitle: title.text,
                      noteContent: content.text,
                      createdAt: DateTime.now().toIso8601String()))
                      .whenComplete(() {
                    Navigator.of(context).pop(true);
                  });
                }
                _tiltefocusNode.unfocus();
                _contentfocusNode.unfocus();
              },
              icon: Icon(Icons.check))
        ],
      ),
      body: Form(
        //I forgot to specify key
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                TextFormField(
                  focusNode: _tiltefocusNode,
                  controller: title,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Title is required";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    label: Text("Title"),
                  ),
                ),
                TextFormField(
                  focusNode: _contentfocusNode,
                  controller: content,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Content is required";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    label: Text("Content"),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}