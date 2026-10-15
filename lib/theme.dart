import 'package:flutter/cupertino.dart';

class AppTheme {
  // الألوان الرئيسية مستخرجة ومطابقة لتصميم iOS الفاخر
  static const Color primaryGreen = Color(0xFF0F3E36);
  static const Color accentGold = Color(0xFFC5A358);
  static const Color activeGreen = Color(0xFF1B5E51);
  
  // خلفيات الـ iOS الفاتحة والداكنة
  static const Color lightBg = Color(0xFFF2F2F7);
  static const Color lightCardBg = Color(0xFFFFFFFF);
  static const Color lightSeparator = Color(0xFFC6C6C8);
  
  static const Color darkBg = Color(0xFF000000);
  static const Color darkCardBg = Color(0xFF1C1C1E);
  static const Color darkSeparator = Color(0xFF38383A);

  static CupertinoThemeData lightTheme = const CupertinoThemeData(
    brightness: Brightness.light,
    primaryColor: activeGreen,
    barBackgroundColor: Color(0xCCF8F8F8),
    scaffoldBackgroundColor: lightBg,
    textTheme: CupertinoTextThemeData(
      primaryColor: CupertinoColors.label,
      textStyle: TextStyle(
        fontFamily: 'SF Pro Text',
        fontSize: 16,
        color: CupertinoColors.black,
      ),
    ),
  );

  static CupertinoThemeData darkTheme = const CupertinoThemeData(
    brightness: Brightness.dark,
    primaryColor: accentGold,
    barBackgroundColor: Color(0xCC1A1A1A),
    scaffoldBackgroundColor: darkBg,
    textTheme: CupertinoTextThemeData(
      primaryColor: CupertinoColors.white,
      textStyle: TextStyle(
        fontFamily: 'SF Pro Text',
        fontSize: 16,
        color: CupertinoColors.white,
      ),
    ),
  );
}
