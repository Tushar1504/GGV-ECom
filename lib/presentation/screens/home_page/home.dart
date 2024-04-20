import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ggv_ecom/presentation/blocs/logged_out/logged_out_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ggv_ecom/presentation/screens/home_page/create_note.dart';
import '../../../utils/json_model/notes_model.dart';
import '../authentication/sqlite/sqlite.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late DataBaseHelper handler;
  late Future<List<NoteModel>> notes;
  final db = DataBaseHelper();

  final title = TextEditingController();
  final content = TextEditingController();
  final keyword = TextEditingController();

  @override
  void initState() {
    handler = DataBaseHelper();
    notes = handler.getNotes();

    handler.initDB().whenComplete(() {
      notes = getAllNotes();
    });
    super.initState();
  }

  Future<List<NoteModel>> getAllNotes() {
    return handler.getNotes();
  }

  Future<List<NoteModel>> searchNote() {
    return handler.searchNotes(keyword.text);
  }

  Future<void> _refresh() async {
    setState(() {
      notes = getAllNotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Text(
                'GG',
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
              ),
              Text(
                'Notes',
                style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w600),
              )
            ],
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                BlocProvider.of<LoggedOutBloc>(context).add(UserRequestedLogout(context));
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateNote())).then((value) {
              if (value) {
                _refresh();
              }
            });
          },
          child: const Icon(Icons.add),
        ),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(color: Colors.grey.withOpacity(.2), borderRadius: BorderRadius.circular(8)),
              child: TextFormField(
                controller: keyword,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    setState(() {
                      notes = searchNote();
                    });
                  } else {
                    setState(() {
                      notes = getAllNotes();
                    });
                  }
                },
                decoration: const InputDecoration(border: InputBorder.none, icon: Icon(Icons.search), hintText: "Search"),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<NoteModel>>(
                future: notes,
                builder: (BuildContext context, AsyncSnapshot<List<NoteModel>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                    return const Center(child: Text("No data"));
                  } else if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  } else {
                    final items = snapshot.data ?? <NoteModel>[];
                    return ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            subtitle: Text(DateFormat("yMd").format(DateTime.parse(items[index].createdAt))),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  items[index].noteTitle,
                                  style: TextStyle(fontSize: 18),
                                ),
                                Text(items[index].noteContent),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                db.deleteNote(items[index].noteId!).whenComplete(() {
                                  _refresh();
                                });
                              },
                            ),
                            onTap: () {
                              //When we click on note
                              setState(() {
                                title.text = items[index].noteTitle;
                                content.text = items[index].noteContent;
                              });
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      actions: [
                                        Row(
                                          children: [
                                            TextButton(
                                              onPressed: () {
                                                //Now update method
                                                db.updateNote(title.text, content.text, items[index].noteId).whenComplete(() {
                                                  //After update, note will refresh
                                                  _refresh();
                                                  Navigator.pop(context);
                                                });
                                              },
                                              child: const Text("Update"),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text("Cancel"),
                                            ),
                                          ],
                                        ),
                                      ],
                                      title: const Text("Update note"),
                                      content: Column(mainAxisSize: MainAxisSize.min, children: [
                                        //We need two textfield
                                        TextFormField(
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
                                      ]),
                                    );
                                  });
                            },
                          );
                        });
                  }
                },
              ),
            ),
          ],
        ));
  }
}
