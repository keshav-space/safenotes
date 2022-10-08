// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_nord_theme/flutter_nord_theme.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:local_session_timeout/local_session_timeout.dart';
import 'package:url_launcher/url_launcher.dart';

// Project imports:
import 'package:safenotes/data/database_handler.dart';
import 'package:safenotes/data/preference_and_config.dart';
import 'package:safenotes/dialogs/change_passphrase.dart';
import 'package:safenotes/dialogs/export_methord.dart';
import 'package:safenotes/dialogs/file_import.dart';
import 'package:safenotes/models/file_handler.dart';
import 'package:safenotes/models/safenote.dart';
import 'package:safenotes/models/session.dart';
import 'package:safenotes/utils/snack_message.dart';
import 'package:safenotes/widgets/note_card.dart';
import 'package:safenotes/widgets/search_widget.dart';
import 'package:safenotes/widgets/theme_toggle_widget.dart';

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
  final importPassphraseController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _refreshNotes();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _refreshNotes() async {
    setState(() => isLoading = true);
    // storing copy of notes in allnotes so that it does not change while doing search
    // show recently created notes first
    this.allnotes =
        this.notes = await NotesDatabase.instance.decryptReadAllNotes()
          ..sort((a, b) => b.createdTime.compareTo(a.createdTime));

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final String officialAppName = SafeNotesConfig.getAppName();
    final double appNameFontSize = 24.0;

    return GestureDetector(
      //onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        drawer: _buildDrawer(context),
        appBar: AppBar(
            title: Text(officialAppName,
                style: TextStyle(fontSize: appNameFontSize))),
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

  Widget _handleAndBuildNotes() {
    final String noNotes = 'No Notes';
    final double fontSize = 24.0;

    return Expanded(
      child: !isLoading
          ? (notes.isEmpty
              ? Text(noNotes, style: TextStyle(fontSize: fontSize))
              : _buildNotes())
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
    final String searchBoxHint = 'Title or Content';

    return SearchWidget(
      text: query,
      hintText: searchBoxHint,
      onChanged: _searchNote,
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final drawerPaddingHorizontal = 15.0;
    final double itemSpacing = 10.0;
    final double dividerSpacing = 5.0;
    final double drawerRadius = 20.0;

    final String importDataText = 'Import Data';
    final String exportDataText = 'Export Data';
    final String snackMsgFileNotSaved = 'File not saved!';
    final String changePassText = 'Change Passphrase';
    final String darkModeText = 'Dark Mode';
    final String helpText = 'Help and Feedback';
    final String sourceCodeText = 'Source Code';
    final String reportBugText = 'Report Bug';
    final String logoutText = 'LogOut';

    return ClipRRect(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(drawerRadius),
        bottomRight: Radius.circular(drawerRadius),
      ),
      child: Drawer(
        child: Material(
          //color: Color.fromRGBO(0, 290, 55, 50),
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: drawerPaddingHorizontal),
            children: <Widget>[
              _drawerHeader(topPadding: 40),
              _divide(topPadding: 15),
              _buildMenuItem(
                topPadding: 15,
                text: importDataText,
                icon: Icons.file_download_outlined,
                onClicked: () async {
                  Navigator.of(context).pop();
                  await showImportDialog(context);
                },
              ),
              _buildMenuItem(
                topPadding: itemSpacing,
                text: exportDataText,
                icon: Icons.file_upload_outlined,
                onClicked: () async {
                  Navigator.of(context).pop();
                  bool wasExportMethordChoosen = false;
                  try {
                    wasExportMethordChoosen = await showExportDialog(context);
                  } catch (e) {
                    showSnackBarMessage(context, snackMsgFileNotSaved);
                    return;
                  }
                  if (!wasExportMethordChoosen) return;

                  String? snackMsg =
                      await FileHandler().fileSave(allnotes.length);
                  showSnackBarMessage(context, snackMsg);
                },
              ),
              _buildMenuItem(
                topPadding: itemSpacing,
                text: changePassText,
                icon: Icons.lock_sharp,
                onClicked: () async {
                  Navigator.of(context).pop();
                  await changePassphraseDialog(context);
                },
              ),
              _buildMenuItem(
                topPadding: itemSpacing,
                text: darkModeText,
                icon: Icons.format_paint,
                toggle: TheamToggle(),
              ),
              _divide(topPadding: dividerSpacing),
              _buildMenuItem(
                topPadding: dividerSpacing,
                text: helpText,
                icon: Icons.feedback,
                onClicked: () async {
                  Navigator.of(context).pop();
                  var mailUrl = SafeNotesConfig.getMailToForFeedback();
                  try {
                    await _launchUrl(Uri.parse(mailUrl));
                  } catch (e) {}
                },
              ),
              _buildMenuItem(
                topPadding: itemSpacing,
                text: sourceCodeText,
                icon: Icons.folder,
                onClicked: () async {
                  var sourceCodeUrl = SafeNotesConfig.getSourceCodeUrl();
                  try {
                    await _launchUrl(Uri.parse(sourceCodeUrl));
                  } catch (e) {}
                },
              ),
              _buildMenuItem(
                topPadding: itemSpacing,
                text: reportBugText,
                icon: Icons.bug_report,
                onClicked: () async {
                  Navigator.of(context).pop();
                  var mailUrl = SafeNotesConfig.getBugReportUrl();
                  try {
                    await _launchUrl(Uri.parse(mailUrl));
                  } catch (e) {}
                },
              ),
              _divide(topPadding: dividerSpacing),
              _buildMenuItem(
                topPadding: dividerSpacing,
                text: logoutText,
                icon: Icons.logout_sharp,
                onClicked: () async {
                  Navigator.of(context).pop();
                  Session.logout();
                  widget.sessionStateStream.add(SessionState.stopListening);
                  await Navigator.pushNamedAndRemoveUntil(
                      context, '/login', (Route<dynamic> route) => false,
                      arguments: widget.sessionStateStream);
                },
              ),
            ],
          ),
        ),
      ),
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
      builder: (BuildContext context) {
        return ExportMethordDialog();
      },
    );
  }

  showImportDialog(BuildContext context) async {
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

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  Widget _divide({required double topPadding}) {
    final bool isDarkTheme = PreferencesStorage.getIsThemeDark();

    return Padding(
      padding: EdgeInsets.only(top: topPadding),
      child: Divider(
        color: isDarkTheme
            ? NordColors.snowStorm.lightest
            : NordColors.polarNight.darker,
      ),
    );
  }

  Widget _drawerHeader({required double topPadding}) {
    final logoPath = SafeNotesConfig.getAppLogoPath();
    final officialAppName = SafeNotesConfig.getAppName();
    final appSlogan = SafeNotesConfig.getAppSlogan();
    final double logoHightWidth = 75.0;
    final double appNameFontSize = 22;
    final double appSloganFontSize = 15;
    final double logoNameGap = 15.0;

    return Padding(
      padding: EdgeInsets.only(top: topPadding),
      child: InkWell(
        onTap: () {},
        child: Container(
          padding: (EdgeInsets.symmetric(vertical: 5)),
          child: Row(
            children: [
              Center(
                child: Container(
                    width: logoHightWidth,
                    height: logoHightWidth,
                    child: Image.asset(logoPath)),
              ),
              Padding(
                padding: EdgeInsets.only(left: logoNameGap),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      officialAppName,
                      style: TextStyle(fontSize: appNameFontSize),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 4),
                      child: Text(
                        appSlogan,
                        style: TextStyle(fontSize: appSloganFontSize),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required String text,
    required IconData icon,
    required double topPadding,
    Widget? toggle,
    VoidCallback? onClicked,
  }) {
    final double fontSize = 15.0;
    final double leftPaddingMenuItem = 10.0;

    return Padding(
      padding: EdgeInsets.only(top: topPadding),
      child: ListTile(
        horizontalTitleGap: 0,
        contentPadding: EdgeInsets.only(left: leftPaddingMenuItem),
        visualDensity: VisualDensity.compact,
        leading: Icon(icon),
        title: Text(
          text,
          style: TextStyle(fontSize: fontSize),
        ),
        trailing: toggle,
        onTap: onClicked,
      ),
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
            await Navigator.pushNamed(context, '/viewnote', arguments: note);
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
