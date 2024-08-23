String formatNumber(double value, int decimalPlaces) {
  return value.toStringAsFixed(decimalPlaces);
}
bool isValidNumber(String input) {
  final numberRegex = RegExp(r'^[0-9]+$');
  return numberRegex.hasMatch(input);
}
bool isValidPhoneNumber(String input) {
  final phoneRegex = RegExp(r'^\d{10}$'); // Adjust the regex for the specific format needed
  return phoneRegex.hasMatch(input);
}
bool isValidText(String input) {
  final textRegex = RegExp(r'^[a-zA-Z]+$');
  return textRegex.hasMatch(input);
}
bool isValidEmail(String input) {
  final emailRegex = RegExp(
    r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$',
  );
  return emailRegex.hasMatch(input);
}
bool isValidAlphaNumeric(String input) {
  final alphaNumericRegex = RegExp(r'^[a-zA-Z0-9]+$');
  return alphaNumericRegex.hasMatch(input);
}
