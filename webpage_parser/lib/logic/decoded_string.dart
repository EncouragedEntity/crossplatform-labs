import 'package:windows1251/windows1251.dart';

extension DecodedString on String {
  String get decoded => windows1251.decode(runes.toList());
}
