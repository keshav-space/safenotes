// Dart imports:
import 'dart:async';
import 'dart:math' as math;

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:local_session_timeout/local_session_timeout.dart';

// Project imports:
import 'package:safenotes/data/database_handler.dart';
import 'package:safenotes/data/preference_and_config.dart';
import 'package:safenotes/dialogs/change_passphrase.dart';
import 'package:safenotes/dialogs/file_import.dart';
import 'package:safenotes/dialogs/select_export_folder.dart';
import 'package:safenotes/models/file_handler.dart';
import 'package:safenotes/models/safenote.dart';
import 'package:safenotes/models/session.dart';
import 'package:safenotes/utils/snack_message.dart';
import 'package:safenotes/widgets/drawer.dart';
import 'package:safenotes/widgets/note_card.dart';
import 'package:safenotes/widgets/note_tile.dart';
import 'package:safenotes/widgets/search_widget.dart';

class HomePage extends StatefulWidget {
  final StreamController<SessionState> sessionStateStream;
  const HomePage({Key? key, required this.sessionStateStream})
      : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<SafeNote> notes;
  late List<SafeNote> allnotes;
  bool isLoading = false;
  String query = '';
  bool isHiddenImport = true;
  bool isNewFirst = true;
  bool isGridView = true;
  final importPassphraseController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _refreshNotes();
  }

  Future<void> _refreshNotes() async {
    setState(() => isLoading = true);
    // storing copy of notes in allnotes so that it does not change while doing search
    // show recently created notes first
    if (isNewFirst)
      this.allnotes =
          this.notes = await NotesDatabase.instance.decryptReadAllNotes()
            ..sort((a, b) => b.createdTime.compareTo(a.createdTime));
    else
      this.allnotes =
          this.notes = await NotesDatabase.instance.decryptReadAllNotes()
            ..sort((a, b) => a.createdTime.compareTo(b.createdTime));

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final String officialAppName = SafeNotesConfig.getAppName();
    final double appNameFontSize = 24.0;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        drawer: _buildDrawer(context),
        appBar: AppBar(
          title: Text(
            officialAppName,
            style: TextStyle(fontSize: appNameFontSize),
          ),
          actions: isLoading ? null : [_gridListView(), _shortNotes()],
        ),
        body: Column(
          children: <Widget>[
            _buildSearch(),
            _handleAndBuildNotes(),
          ],
        ),
        floatingActionButton: _addANewNoteButton(context),
      ),
    );
  }

  Widget _gridListView() {
    return IconButton(
      icon: !isGridView ? Icon(Icons.grid_view_sharp) : Icon(Icons.list),
      onPressed: () {
        setState(() {
          isGridView = !isGridView;
        });
      },
    );
  }

  Widget _shortNotes() {
    return IconButton(
      icon: !isNewFirst
          ? Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationX(math.pi),
              child: Icon(Icons.sort_rounded),
            )
          : Icon(Icons.sort_rounded),
      onPressed: () {
        setState(() {
          this.isNewFirst = !this.isNewFirst;
          _refreshNotes();
        });
        // await confirmAndDeleteDialog(context);
      },
    );
  }

  Widget _handleAndBuildNotes() {
    final String noNotes = 'No Notes';
    final double fontSize = 24.0;

    return Expanded(
      child: !isLoading
          ? notes.isEmpty
              ? Text(noNotes, style: TextStyle(fontSize: fontSize))
              : (isGridView ? _buildNotes() : _buildNotesTile())
          : Center(child: CircularProgressIndicator()),
    );
  }

  Widget _addANewNoteButton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () async {
        await Navigator.pushNamed(context, '/addnote');
        _refreshNotes();
      },
    );
  }

  Widget _buildSearch() {
    final String searchBoxHint = 'Search...';

    return SearchWidget(
      text: query,
      hintText: searchBoxHint,
      onChanged: _searchNote,
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final String snackMsgFileNotSaved = 'File not saved!';

    return HomeDrawer(
      onImportCallback: () async {
        Navigator.of(context).pop();
        await showImportDialog(context);
      },
      onExportCallback: () async {
        Navigator.of(context).pop();
        bool wasExportMethordChoosen = false;
        try {
          wasExportMethordChoosen = await showExportDialog(context);
        } catch (e) {
          showSnackBarMessage(context, snackMsgFileNotSaved);
          return;
        }
        if (!wasExportMethordChoosen) return;

        String? snackMsg = await FileHandler().fileSave();
        showSnackBarMessage(context, snackMsg);
      },
      onChangePassCallback: () async {
        Navigator.of(context).pop();
        await changePassphraseDialog(context);
      },
      onLogoutCallback: () async {
        Navigator.of(context).pop();
        Session.logout();
        widget.sessionStateStream.add(SessionState.stopListening);
        await Navigator.pushNamedAndRemoveUntil(
          context,
          '/login',
          (Route<dynamic> route) => false,
          arguments: SessionArguments(sessionStream: widget.sessionStateStream),
        );
      },
    );
  }

  Future<void> changePassphraseDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return ChangePassphraseDialog(allnotes: allnotes);
      },
    );
  }

  showExportDialog(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return ExportChooseDirectoryDialog();
      },
    );
  }

  Future<void> showImportDialog(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext contextChild) {
        return FileImportDialog(
          callback: () async {
            Navigator.of(contextChild).pop();
            String? snackMessage =
                await FileHandler().selectFileAndDoImport(context);
            _refreshNotes();
            showSnackBarMessage(context, snackMessage);
          },
        );
      },
    );
  }

  Widget _buildNotesTile() {
    return ListView.separated(
      padding: EdgeInsets.all(8),
      itemCount: notes.length,
      itemBuilder: ((context, index) {
        final note = notes[index];
        return GestureDetector(
          onTap: () async {
            await Navigator.pushNamed(
              context,
              '/viewnote',
              arguments: note,
            );
            _refreshNotes();
          },
          child: NoteTileWidget(note: note, index: index),
        );
      }),
      separatorBuilder: (BuildContext context, int index) {
        return Container(
          height: 10,
          color: Colors.transparent,
        );
      },
    );
  }

  Widget _buildNotes() {
    return StaggeredGridView.countBuilder(
      padding: EdgeInsets.all(8),
      itemCount: notes.length,
      staggeredTileBuilder: (index) => StaggeredTile.fit(2),
      crossAxisCount: 4,
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      itemBuilder: (context, index) {
        final note = notes[index];

        return GestureDetector(
          onTap: () async {
            await Navigator.pushNamed(
              context,
              '/viewnote',
              arguments: note,
            );
            _refreshNotes();
          },
          child: NoteCardWidget(note: note, index: index),
        );
      },
    );
  }

  void _searchNote(String query) {
    final notes = allnotes.where((note) {
      final titleLower = note.title.toLowerCase();
      final descriptionLower = note.description.toLowerCase();
      final queryLower = query.toLowerCase();

      return titleLower.contains(queryLower) ||
          descriptionLower.contains(queryLower);
    }).toList();

    setState(
      () {
        this.query = query;
        this.notes = notes;
      },
    );
  }
}
