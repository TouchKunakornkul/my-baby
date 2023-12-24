import 'package:age_calculator/age_calculator.dart';

String getAgeString(DateTime birthDate) {
  final age = AgeCalculator.age(birthDate);
  String result = "${age.days}d";
  if (age.months > 0) {
    result = "${age.months}m $result";
  }
  if (age.years > 0) {
    result = "${age.years}y $result";
  }
  return result;
}
