/*
* Copyright (C) Keshav Priyadarshi and others - All Rights Reserved.
*
* SPDX-License-Identifier: GPL-3.0-or-later
* You may use, distribute and modify this code under the
* terms of the GPL-3.0+ license.
*
* You should have received a copy of the GNU General Public License v3.0 with
* this file. If not, please visit https://www.gnu.org/licenses/gpl-3.0.html
*
* See https://safenotes.dev for support or download.
*/

// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:local_session_timeout/local_session_timeout.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:safenotes/data/database_handler.dart';
import 'package:safenotes/data/preference_and_config.dart';
import 'package:safenotes/dialogs/backup_import.dart';
import 'package:safenotes/models/safenote.dart';
import 'package:safenotes/models/session.dart';
import 'package:safenotes/routes/route_generator.dart';
import 'package:safenotes/utils/notes_color.dart';
import 'package:safenotes/utils/styles.dart';
import 'package:safenotes/widgets/drawer.dart';
import 'package:safenotes/widgets/note_card.dart';
import 'package:safenotes/widgets/note_card_compact.dart';
import 'package:safenotes/widgets/note_tile.dart';
import 'package:safenotes/widgets/note_tile_compact.dart';
import 'package:safenotes/widgets/search_widget.dart';

class HomePage extends StatefulWidget {
  final StreamController<SessionState> sessionStateStream;

  const HomePage({
    Key? key,
    required this.sessionStateStream,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<SafeNote> notes;
  late List<SafeNote> allnotes;
  bool isLoading = false;
  String query = '';
  bool isHiddenImport = true;
  bool isNewFirst = PreferencesStorage.isNewFirst;
  bool isGridView = PreferencesStorage.isGridView;
  final importPassphraseController = TextEditingController();
  //bool isListner = false;
  @override
  void initState() {
    super.initState();
    refreshNotes();
  }

  Future<void> refreshNotes() async {
    setState(() => isLoading = true);
    await _sortAndStoreNotes();
    setState(() => isLoading = false);
  }

  Future<void> _sortAndStoreNotes() async {
    // storing copy of notes in allnotes so that it does not change while doing search
    // show recently created notes first
    List<SafeNote> _tmpNotes;
    if (isNewFirst)
      _tmpNotes = await NotesDatabase.instance.decryptReadAllNotes()
        ..sort((a, b) => b.createdTime.compareTo(a.createdTime));
    else
      _tmpNotes = await NotesDatabase.instance.decryptReadAllNotes()
        ..sort((a, b) => a.createdTime.compareTo(b.createdTime));
    setState(() {
      this.allnotes = this.notes = _tmpNotes;
    });
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<NotesColor>(context);

    return GestureDetector(
      onTap: dismissKeyboard,
      onVerticalDragStart: dismissKeyboard,
      onVerticalDragDown: dismissKeyboard,
      child: Scaffold(
        drawer: _buildDrawer(context),
        appBar: AppBar(
          title: Text(
            'Safe Notes'.tr(),
            style: appBarTitle,
          ),
          actions: isLoading
              ? null
              : [
                  //_DevSessionListner(),
                  _gridListView(),
                  _shortNotes(),
                ],
        ),
        body: Column(
          children: [
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
      icon: !isGridView
          ? Icon(Icons.grid_view_outlined)
          : Icon(Icons.splitscreen_outlined),
      onPressed: () {
        setState(() {
          PreferencesStorage.setIsGridView(!isGridView);
          isGridView = !isGridView;
        });
      },
    );
  }

  // Widget _DevSessionListner() {
  //   return IconButton(
  //     icon: isListner ? Icon(Icons.toggle_on) : Icon(Icons.toggle_off),
  //     onPressed: () {
  //       if (isListner == true)
  //         widget.sessionStateStream.add(SessionState.stopListening);
  //       else
  //         widget.sessionStateStream.add(SessionState.startListening);

  //       setState(() {
  //         this.isListner = !this.isListner;
  //       });
  //     },
  //   );
  // }

  Widget _shortNotes() {
    return IconButton(
      icon: !isNewFirst
          ? Icon(MdiIcons.sortCalendarAscending)
          : Icon(MdiIcons.sortCalendarDescending),
      onPressed: () {
        setState(() {
          this.isNewFirst = !this.isNewFirst;
          _sortAndStoreNotes();
        });
      },
    );
  }

  Widget _handleAndBuildNotes() {
    final String noNotes = 'No Notes'.tr();
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
        await Navigator.pushNamed(
          context,
          '/addnote',
          arguments: widget.sessionStateStream,
        );
        refreshNotes();
      },
    );
  }

  Widget _buildSearch() {
    final String searchBoxHint = 'Search...'.tr();

    return SearchWidget(
      text: query,
      hintText: searchBoxHint,
      onChanged: _searchNote,
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return HomeDrawer(
      onImportCallback: () async {
        Navigator.of(context).pop();
        widget.sessionStateStream.add(SessionState.stopListening);
        await showImportDialog(context, homeRefresh: refreshNotes);
        widget.sessionStateStream.add(SessionState.startListening);
      },
      onChangePassCallback: () async {
        await Navigator.pushNamed(context, '/changepassphrase');
        Navigator.of(context).pop();
      },
      onLogoutCallback: () async {
        Session.logout();
        widget.sessionStateStream.add(SessionState.stopListening);
        await Navigator.pushNamedAndRemoveUntil(
          context,
          '/login',
          (Route<dynamic> route) => false,
          arguments: SessionArguments(
            sessionStream: widget.sessionStateStream,
            isKeyboardFocused: false,
          ),
        );
      },
      onSettingsCallback: () async {
        await Navigator.pushNamed(
          context,
          '/settings',
          arguments: widget.sessionStateStream,
        );
        Navigator.of(context).pop();
        refreshNotes();
      },
      onBiometricsCallback: () async {
        await Navigator.pushNamed(
          context,
          '/biometricSetting',
        );
        Navigator.of(context).pop();
      },
    );
  }

  Widget _buildNotesTile() {
    return ListView.separated(
      padding: EdgeInsets.all(15),
      itemCount: notes.length,
      itemBuilder: ((context, index) {
        final note = notes[index];
        return GestureDetector(
          onTap: () async {
            await Navigator.pushNamed(
              context,
              '/viewnote',
              arguments: NoteDetailPageArguments(
                note: note,
                sessionStream: widget.sessionStateStream,
              ),
            );
            refreshNotes();
          },
          child: PreferencesStorage.isCompactPreview
              ? NoteTileWidgetCompact(note: note, index: index)
              : NoteTileWidget(note: note, index: index),
        );
      }),
      separatorBuilder: (BuildContext context, int index) {
        return Container(
          height: 7,
          color: Colors.transparent,
        );
      },
    );
  }

  Widget _buildNotes() {
    return StaggeredGridView.countBuilder(
      padding: EdgeInsets.all(12),
      itemCount: notes.length,
      staggeredTileBuilder: (index) => StaggeredTile.fit(2),
      crossAxisCount: 4,
      mainAxisSpacing: 0,
      crossAxisSpacing: 0,
      itemBuilder: (context, index) {
        final note = notes[index];

        return GestureDetector(
          onTap: () async {
            await Navigator.pushNamed(
              context,
              '/viewnote',
              arguments: NoteDetailPageArguments(
                note: note,
                sessionStream: widget.sessionStateStream,
              ),
            );
            refreshNotes();
          },
          child: PreferencesStorage.isCompactPreview
              ? NoteCardWidgetCompact(note: note, index: index)
              : NoteCardWidget(note: note, index: index),
        );
      },
    );
  }

  void _searchNote(String query) {
    final notes = allnotes.where((note) {
      final titleLower = note.title.toLowerCase();
      final descriptionLower = note.description.toLowerCase();
      final queryLower = query.toLowerCase().trim();

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

  void dismissKeyboard([var _]) {
    final FocusScopeNode currentScope = FocusScope.of(context);
    if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }
}
