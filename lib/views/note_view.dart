// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';

// Project imports:
import 'package:safenotes/data/database_handler.dart';
import 'package:safenotes/dialogs/delete_confirmation.dart';
import 'package:safenotes/models/safenote.dart';

class NoteDetailPage extends StatefulWidget {
  final int noteId;

  const NoteDetailPage({Key? key, required this.noteId}) : super(key: key);

  @override
  _NoteDetailPageState createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  late SafeNote note;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshNote();
  }

  Future refreshNote() async {
    setState(() => isLoading = true);
    this.note = await NotesDatabase.instance.decryptReadNote(widget.noteId);
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: _body(context),
    );
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      title: isLoading ? Text('Loading...'.tr()) : null,
      actions: isLoading ? null : [editButton(), deleteButton()],
    );
  }

  Widget _body(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : Padding(
            padding: EdgeInsets.all(12),
            child: ListView(
              padding: EdgeInsets.symmetric(vertical: 8),
              children: [
                SelectableText(
                  note.title,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: Text(DateFormat.yMMMd().format(note.createdTime)),
                ),
                SelectableText(
                  note.description,
                  style: TextStyle(fontSize: 18),
                )
              ],
            ),
          );
  }

  Widget editButton() {
    return IconButton(
      icon: Icon(Icons.edit_outlined),
      onPressed: () async {
        if (isLoading) return;
        await Navigator.pushNamed(
          context,
          '/editnote',
          arguments: this.note,
        );
        refreshNote();
      },
    );
  }

  Widget deleteButton() {
    return IconButton(
      icon: Icon(Icons.delete),
      onPressed: () async {
        await confirmAndDeleteDialog(context);
      },
    );
  }

  confirmAndDeleteDialog(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext contextChild) {
        return DeleteConfirmationDialog(
          callback: () async {
            await NotesDatabase.instance.delete(widget.noteId);
            Navigator.of(contextChild).pop();
            Navigator.of(context).pop();
          },
        );
      },
    );
  }
}
