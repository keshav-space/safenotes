// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:safenotes/data/preference_and_config.dart';

class NoteFormWidget extends StatelessWidget {
  final String? title;
  final String? description;

  final ValueChanged<String> onChangedTitle;
  final ValueChanged<String> onChangedDescription;

  const NoteFormWidget({
    Key? key,
    this.title = '',
    this.description = '',
    required this.onChangedTitle,
    required this.onChangedDescription,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double allSidePadding = 16.0;
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Padding(
        padding: EdgeInsets.all(allSidePadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTitle(),
            SizedBox(height: 8),
            buildDescription(context),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    final double fontSize = 24.0;
    final int maxLinesToShowAtTimeTitle = 2;
    final String titleHint = 'Title';
    //Disable IMEPL if keyboard incognito mode is true
    final bool enableIMEPLFlag = !PreferencesStorage.getKeyboardIncognito();

    return TextFormField(
      enableIMEPersonalizedLearning: enableIMEPLFlag,
      maxLines: maxLinesToShowAtTimeTitle,
      initialValue: this.title,
      enableInteractiveSelection: true,
      autofocus: true,
      toolbarOptions: ToolbarOptions(
        paste: true,
        cut: true,
        copy: true,
        selectAll: true,
      ),
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: fontSize,
      ),
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: titleHint,
      ),
      // validator: _titleValidator,
      onChanged: onChangedTitle,
    );
  }

  // String? _titleValidator(String? title) {
  //   final titleCantBeEmptyMsg = 'The title cannot be empty';
  //   return title == null || title.isEmpty ? titleCantBeEmptyMsg : null;
  // }

  Widget buildDescription(BuildContext context) {
    // maxLine is used in resizing description field on keyboard activation or dismissal
    final int maxLinesToShowAtTimeDescription =
        computeMaxLine(context: context, fontHeight: 30.0);
    final double fontSize = 18.0;
    final String hintDescription = 'Type something...';
    final bool enableIMEPLFlag = !PreferencesStorage.getKeyboardIncognito();

    return TextFormField(
      enableIMEPersonalizedLearning: enableIMEPLFlag,
      maxLines: maxLinesToShowAtTimeDescription,
      initialValue: this.description,
      enableInteractiveSelection: true,
      toolbarOptions: ToolbarOptions(
        paste: true,
        cut: true,
        copy: true,
        selectAll: true,
      ),
      style: TextStyle(fontSize: fontSize),
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: hintDescription,
        //hintStyle: TextStyle(color: Colors.white60),
      ),
      //validator: _descriptionValidator,
      onChanged: onChangedDescription,
    );
  }

  // String? _descriptionValidator(String? description) {
  //   final String descriptionCantBeEmptyMsg = 'The description cannot be empty';
  //   return description == null || description.isEmpty
  //       ? descriptionCantBeEmptyMsg
  //       : null;
  // }

  int computeMaxLine(
      {required BuildContext context, required double fontHeight}) {
    final double totalHeight = MediaQuery.of(context).size.height;
    final EdgeInsets paddingInsets = MediaQuery.of(context).padding;
    final double keyboard = MediaQuery.of(context).viewInsets.bottom;
    final double padding = paddingInsets.top + paddingInsets.bottom;

    double totalHeightRatio = (totalHeight - padding) / 100;
    double fontHeightRatio = fontHeight / 100;
    double theXfactor = totalHeightRatio / 3.2;
    /*
    When Keyboard is on screen:-
    Theoretical Ratios for top:description:keyboard 
    theoreticalTitleNTopHeightRatio = x*(3.2-1.6); 
    theoreticalDescriptinHeightRatio = x*1.6; 
    theoreticalKeyboardHeightRatio = x;
    x + x*1.2 + x = totalHeightRatio (i.e total height of screen)
    
    From above:
    if keyboard is on-screen:
      theoreticalDescriptinHeightRatio = x*1.6
    if keyboard not on screen:
      theoreticalDescriptinHeightRatio = x*2.6 (keyboard space is taken by description)
    */
    double descriptionRatio = theXfactor * 2.6;
    if (keyboard > 1) descriptionRatio = theXfactor * 1.6;
    return (descriptionRatio / fontHeightRatio).round();
  }
}
