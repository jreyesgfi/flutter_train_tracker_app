String clipText(String text, int maxLength, [bool? dots]) {
  if (text.length <= maxLength) {
    return text;
  } else {
    return '${text.substring(0, maxLength)}${dots==false? '':'...'}';
  }
}