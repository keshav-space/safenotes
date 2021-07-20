import 'dart:ui';
import 'dart:io';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:safe_notes/main.dart';
import 'package:safe_notes/model/safe_note.dart';
import 'package:safe_notes/widget/search_widget.dart';
import 'package:safe_notes/model/import_file_parser.dart';
import 'package:safe_notes/page/edit_safe_note_page.dart';
import 'package:safe_notes/widget/theme_toggle_widget.dart';
import 'package:safe_notes/page/safe_note_detail_page.dart';
import 'package:safe_notes/widget/safe_note_card_widget.dart';
import 'package:safe_notes/dialogs/change_passphrase_dialog.dart';
import 'package:safe_notes/dialogs/import_passphrase_dialog.dart';
import 'package:safe_notes/dialogs/toggle_undecrypt_flag_dialog.dart';
import 'package:safe_notes/databaseAndStorage/safe_notes_database.dart';
import 'package:safe_notes/databaseAndStorage/prefrence_sotorage_and_state_controls.dart';

class NotesPage extends StatefulWidget {
  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  late List<SafeNote> notes;
  late List<SafeNote> allnotes;
  bool isLoading = false;
  String query = '';
  bool isHiddenImport = true;
  final importPassphraseController = TextEditingController();
  bool isLogout = false;

  @override
  void initState() {
    super.initState();

    refreshNotes();
  }

  @override
  void dispose() {
    // Bcz if user has log in for undecrypted data then they can move back and log in again so not closing data base
    if (!UnDecryptedLoginControl.getAllowLogUnDecrypted() && !isLogout)
      NotesDatabase.instance.close();

    super.dispose();
  }

  Future refreshNotes() async {
    setState(() => isLoading = true);
    // storing copy of notes in allnotes so that it does not change while doing search
    this.allnotes =
        this.notes = await NotesDatabase.instance.decryptReadAllNotes();

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        drawer: UnDecryptedLoginControl.getNoDecryptionFlag()
            ? null
            : navigatioDrawerWidget(context),
        appBar: AppBar(
          title: Text(
            AppInfo.getAppName(),
            style: TextStyle(fontSize: 24),
          ),
          /*  actions: UnDecryptedLoginControl.getNoDecryptionFlag()
              ? null
              : [exportButton(), importButton()], */
        ),
        body: Column(
          children: <Widget>[
            buildSearch(),
            Expanded(
              child: !isLoading
                  ? (notes.isEmpty
                      ? Text(
                          'No Notes',
                          style: TextStyle(color: Colors.white, fontSize: 24),
                        )
                      : buildNotes())
                  : Text('Loading',
                      style: TextStyle(color: Colors.white, fontSize: 24)),
              /* isLoading
                  ? CircularProgressIndicator(
                      strokeWidth: 2,
                    )
                  : notes.isEmpty
                      ? Text(
                          'No Notes',
                          style: TextStyle(color: Colors.white, fontSize: 24),
                        )
                      : 
              buildNotes(), */
            ),
          ],
        ),
        floatingActionButton: UnDecryptedLoginControl.getNoDecryptionFlag()
            ? null
            : FloatingActionButton(
                /*  backgroundColor: Colors.black, */
                child: Icon(Icons.add),
                onPressed: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AddEditNotePage()),
                  );
                  refreshNotes();
                },
              ),
      ));

  Widget buildSearch() => SearchWidget(
        text: query,
        hintText: 'Title or Content',
        onChanged: searchNote,
      );

  Widget navigatioDrawerWidget(BuildContext context) {
    final padding = EdgeInsets.symmetric(horizontal: 20);
    final visualName = AppInfo.getAppName();
    final imgPath = AppInfo.getLogoAsProfile();
    final slogan = AppInfo.getAppSlogan();
    return ClipRRect(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
        child: Drawer(
          child: Material(
            color: Color.fromRGBO(0, 290, 55, 50),
            child: ListView(
              padding: padding,
              children: <Widget>[
                const SizedBox(height: 40),
                buildNavigationHeader(
                  imgPath: imgPath,
                  name: visualName,
                  msg: slogan,
                ),
                /* Divider(
              color: Colors.white70,
            ), */
                const SizedBox(height: 10),
                buildMenuItem(
                    text: 'Import Data',
                    icon: Icons.file_download_outlined,
                    onClicked: () async {
                      Navigator.of(context).pop();
                      await showImportDialog(context);
                    }),
                const SizedBox(height: 10),
                buildMenuItem(
                    text: 'Export Data',
                    icon: Icons.file_upload_outlined,
                    onClicked: () async {
                      Navigator.of(context).pop();
                      bool rat = false;
                      try {
                        rat = await showExportDialog(context);
                      } catch (e) {
                        showSnackBar("File not saved!");
                        return;
                      }
                      if (!rat) return;
                      await fileSave();
                      ExportEncryptionControl.setIsExportEncrypted(true);
                    }),
                const SizedBox(height: 10),
                buildMenuItem(
                    text: 'Change Passphrase',
                    icon: Icons.lock_sharp,
                    onClicked: () async {
                      Navigator.of(context).pop();
                      await changePassphraseDialog(context);
                    }),
                const SizedBox(height: 10),
                buildMenuItem(
                    text: 'UnDecrypted Control',
                    icon: Icons.settings_sharp,
                    onClicked: () async {
                      Navigator.of(context).pop();
                      await toggleUndecryptionDialog(context);
                    }),
                const SizedBox(height: 10),
                buildMenuItem(
                  text: 'Dark Mode',
                  icon: Icons.format_paint,
                  toggle: TheamToggle(),
                ),
                const SizedBox(height: 5),
                Divider(
                  color: Colors.white70,
                ),
                const SizedBox(height: 5),
                buildMenuItem(
                    text: 'Help and Feedback',
                    icon: Icons.feedback,
                    onClicked: () async {
                      Navigator.of(context).pop();
                      var mailUrl = AppInfo.getMailToForFeedback();
                      try {
                        await launch(mailUrl);
                      } catch (e) {}
                    }),
                const SizedBox(height: 10),
                buildMenuItem(
                    text: 'Source Code',
                    icon: Icons.folder,
                    onClicked: () async {
                      var sourceCodeUrl = AppInfo.getSourceCodeUrl();
                      try {
                        await launch(sourceCodeUrl);
                      } catch (e) {}
                    }),
                const SizedBox(height: 10),
                buildMenuItem(
                    text: 'Report Bug',
                    icon: Icons.bug_report,
                    onClicked: () async {
                      Navigator.of(context).pop();
                      var mailUrl = AppInfo.getBugReportUrl();
                      try {
                        await launch(mailUrl);
                      } catch (e) {}
                    }),
                const SizedBox(height: 5),
                Divider(
                  color: Colors.white70,
                ),
                const SizedBox(height: 5),
                buildMenuItem(
                    text: 'LogOut',
                    icon: Icons.logout_sharp,
                    onClicked: () async {
                      Navigator.of(context).pop();
                      setState(() {
                        isLogout = true;
                      });
                      await Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => SafeNotes()));
                    }),
              ],
            ),
          ),
        ));
  }

  changePassphraseDialog(BuildContext context) => showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return ChangePassphraseDialog(
          allnotes: allnotes,
        );
      });
  toggleUndecryptionDialog(BuildContext context) => showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return ToggleUndecryptionFlag();
      });
  Widget buildNavigationHeader({
    required String imgPath,
    required String name,
    required String msg,
    //VoidCallback? onClicked,
  }) =>
      InkWell(
        onTap: () {},
        child: Container(
          padding: (EdgeInsets.symmetric(vertical: 5)),
          child: Row(
            children: [
              Center(
                child: Container(
                    width: 75,
                    height: 75,
                    child: Image.asset(AppInfo.getAppLogoPath())),
              ),
              SizedBox(
                width: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    msg,
                    style: TextStyle(fontSize: 17, color: Colors.white),
                  ),
                ],
              )
            ],
          ),
        ),
      );

  Widget buildMenuItem({
    required String text,
    required IconData icon,
    Widget? toggle,
    VoidCallback? onClicked,
  }) {
    final color = Colors.white;
    return ListTile(
      leading: Icon(
        icon,
        color: color,
      ),
      title: Text(
        text,
        style: TextStyle(color: color),
      ),
      trailing: toggle,
      onTap: onClicked,
    );
  }

//Begin:  Block for handling of data export

/*   Widget exportButton() => IconButton(
      icon: Icon(Icons.file_upload_outlined),
      onPressed: () async {
        bool rat = false;
        try {
          rat = await showExportDialog(context);
        } catch (e) {
          showSnackBar("File not saved!");
          return;
        }
        if (!rat) return;
        await fileSave();
        ExportEncryptionControl.setIsExportEncrypted(true);
      }); */

  showExportDialog(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return new BackdropFilter(
              filter: ImageFilter.blur(),
              child: Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 12),
                      Text(
                        'Data Export Method',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 22),
                      ),
                      SizedBox(height: 12),
                      Text(
                        AppInfo.getExportDialogMsg(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 15),
                      ElevatedButton(
                          child: Text('Encrypted (Recommended)'),
                          onPressed: () {
                            ExportEncryptionControl.setIsExportEncrypted(true);
                            Navigator.of(context).pop(true);
                          }),
                      SizedBox(height: 15),
                      Text(
                        'OR',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 12),
                      ElevatedButton(
                          child: Text('Unencrypted (Unsecure)'),
                          style: ButtonStyle(
                              //Highlight dangers of insecure export
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.redAccent.shade700)),
                          onPressed: () {
                            ExportEncryptionControl.setIsExportEncrypted(false);
                            Navigator.of(context).pop(true);
                          })
                    ],
                  ),
                ),
              ));
        });
  }

  fileSave() async {
    Directory? directory;
    String fileName = AppInfo.getExportFileName();
    print("The fiel name is here for us to see $fileName");
    String preFixToRecord = '{ "records" : ';
    String postFixToRecord = ', "recordHandlerHash" : ' +
        (ExportEncryptionControl.getIsExportEncrypted()
            ? '"${AppSecurePreferencesStorage.getPassPhraseHash().toString()}"'
            : '"null"') +
        ', "total" : ' +
        allnotes.length.toString() +
        '}';
    String record = (allnotes
            .map(
                (i) => i.toJson(ExportEncryptionControl.getIsExportEncrypted()))
            .toList())
        .toString();

    try {
      if (Platform.isIOS) {
        if (await _requestPermission(Permission.storage)) {
          directory = await getApplicationDocumentsDirectory();
          var jsonFile = new File(directory.path + "/" + fileName);
          jsonFile.writeAsStringSync(preFixToRecord + record + postFixToRecord);
          showSnackBar(
              'File saved in Document folder of ${AppInfo.getAppName()}!');
        } else {
          showSnackBar('Storage access Denied!');
        }
      } else if (Platform.isAndroid) {
        if (await _requestPermission(Permission.storage)) {
          directory = await getExternalStorageDirectory();
          String downPath = "";
          List<String> folders = directory!.path.split("/");
          for (final folder in folders.sublist(1, folders.length)) {
            if (folder != "Android") {
              downPath += "/" + folder;
            } else
              break;
          }
          downPath += "/Download";
          directory = Directory(downPath);
          //print(directory.path);
          var jsonFile = new File(directory.path + "/" + fileName);
          //print(jsonFile);
          jsonFile.writeAsStringSync(preFixToRecord + record + postFixToRecord);

          showSnackBar('File saved in Download folder!');
        } else {
          showSnackBar('Storage access Denied!');
        }
      } //Android handler end
    } catch (e) {}
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var status = await permission.request();
      if (status.isGranted) {
        return true;
      }
      return false;
    }
  }
//End:  Block for handling of data export

//Begin:  Block for handling import of data

/*   Widget importButton() => IconButton(
      icon: Icon(Icons.file_download_outlined),
      onPressed: () async {
        await showImportDialog(context);
      }); */

  showImportDialog(BuildContext context) async {
    //final bool isDismissed = true;
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return new BackdropFilter(
              filter: ImageFilter.blur(),
              child: Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 12),
                      Text(
                        'Import Your Data',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 22),
                      ),
                      SizedBox(height: 12),
                      Text(
                        AppInfo.getImortDialogMsg(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 15),
                      ElevatedButton(
                          child: Text('Select File'),
                          onPressed: () async {
                            await selectFileAndDoImport();
                            Navigator.of(context).pop(true);
                          }),
                    ],
                  ),
                ),
              ));
        });
  }

  selectFileAndDoImport() async {
    String dataFromFileAsString = await getFileAsString();
    if (dataFromFileAsString == "null") {
      showSnackBar("File not picked!");
      return;
    } else if (dataFromFileAsString == "unrecognized") {
      showSnackBar("Unrecognized File!");
      return;
    }
    try {
      var jsonDecodedData = jsonDecode(dataFromFileAsString);
      if (jsonDecodedData['recordHandlerHash'] as String == "null") {
        //print("eneterd unencrypted are");
        ImportEncryptionControl.setIsImportEncrypted(false);
        inserNotes(ImportParser.fromJson(jsonDecodedData).getAllNotes());
      } else {
        ImportEncryptionControl.setIsImportEncrypted(true);
        try {
          await getImportPassphraseDialog(context);
        } catch (e) {}
        if (sha256
                .convert(
                    utf8.encode(ImportPassPhraseHandler.getImportPassPhrase()))
                .toString() ==
            jsonDecodedData['recordHandlerHash'] as String) {
          await inserNotes(
              ImportParser.fromJson(jsonDecodedData).getAllNotes());
          ImportPassPhraseHandler.setImportPassPhrase("null");
        } else {
          showSnackBar("Wrong Passphrase!");
          ImportPassPhraseHandler.setImportPassPhrase("null");
          return;
        }
      }
    } catch (e) {
      showSnackBar("Failed to import file!");
    }
  }

  getImportPassphraseDialog(BuildContext context) => showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return ImportPassPhraseDialog();
      });

  Future<String> getFileAsString() async {
    try {
      if (Platform.isAndroid) {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: [AppInfo.getExportFileExtension()],
        );
        if (result != null) {
          PlatformFile file = result.files.first;
          if (file.size == 0) return "null";
          var jsonFile = new File(file.path!);
          String content = jsonFile.readAsStringSync();
          return content;
        }
      } else if (Platform.isIOS) {
        FilePickerResult? result = await FilePicker.platform.pickFiles();
        if (result != null) {
          PlatformFile file = result.files.first;
          if (file.size == 0 ||
              file.extension != AppInfo.getExportFileExtension()) return "null";
          var jsonFile = new File(file.path!);
          String content = jsonFile.readAsStringSync();
          return content;
        }
      }
    } catch (e) {
      showSnackBar("Unrecognized File!");
      return "unrecognized";
    }
    return "null";
  }

  inserNotes(List<SafeNote> imported) async {
    for (final note in imported) {
      await NotesDatabase.instance.encryptAndStore(note);
    }
    refreshNotes();
  }

//End:  Block for handling import of data

//Begin: Handling the render of note cards
  Widget buildNotes() => StaggeredGridView.countBuilder(
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
              await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => NoteDetailPage(noteId: note.id!),
              ));

              refreshNotes();
            },
            child: NoteCardWidget(note: note, index: index),
          );
        },
      );

  void searchNote(String query) {
    // Searching the given query in title and description
    final notes = allnotes.where((note) {
      final titleLower = note.title.toLowerCase();
      final descriptionLower = note.description.toLowerCase();
      final queryLower = query.toLowerCase();

      return titleLower.contains(queryLower) ||
          descriptionLower.contains(queryLower);
    }).toList();

    setState(() {
      this.query = query;
      this.notes = notes;
    });
  }

// Utility for snackback
  showSnackBar(String _msg) {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(_msg),
      ));
  }
}
