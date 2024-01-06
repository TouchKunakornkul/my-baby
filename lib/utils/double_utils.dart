String formatDouble(double value) {
  String stringValue = value.toStringAsFixed(2); // Formats to 2 decimal places

  if (value == value.truncateToDouble()) {
    return value
        .toInt()
        .toString(); // If the number has no decimal, return as integer
  } else {
    return stringValue.replaceAll(RegExp(r"([.]*0)(?!.*\d)"),
        ""); // Removes trailing zeros after the decimal
  }
}
