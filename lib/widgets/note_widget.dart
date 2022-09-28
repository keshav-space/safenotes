import 'package:flutter/material.dart';

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

    return TextFormField(
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
      validator: _titleValidator,
      onChanged: onChangedTitle,
    );
  }

  String? _titleValidator(String? title) {
    final titleCantBeEmptyMsg = 'The title cannot be empty';
    return title == null || title.isEmpty ? titleCantBeEmptyMsg : null;
  }

  Widget buildDescription(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final EdgeInsets padding = MediaQuery.of(context).padding;
    final double keyboard = MediaQuery.of(context).viewInsets.bottom;
    final double topFixed = 200.0;
    final double effectiveHeighOfDevice =
        height - padding.top - padding.bottom - topFixed - keyboard;

    final double adaptiveScreenFactorForDescription = 25.0;
    final int maxLinesToShowAtTimeDescription =
        (effectiveHeighOfDevice / adaptiveScreenFactorForDescription).round();
    final double fontSize = 18.0;
    final String hintDescription = 'Type something...';

    return TextFormField(
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
      validator: _descriptionValidator,
      onChanged: onChangedDescription,
    );
  }

  String? _descriptionValidator(String? description) {
    final String descriptionCantBeEmptyMsg = 'The description cannot be empty';
    return description == null || description.isEmpty
        ? descriptionCantBeEmptyMsg
        : null;
  }
}
