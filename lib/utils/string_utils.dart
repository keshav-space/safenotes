String sanitize(String inputString) {
  final multipleSpaces = RegExp(' +'); // replace with ' '
  final emptylines = RegExp(r'(?:[\t ]*(?:\r?\n|\r))+'); // replace with '\n'

  return inputString
      .trim()
      .replaceAll(multipleSpaces, ' ')
      .replaceAll(emptylines, '\n');
}
