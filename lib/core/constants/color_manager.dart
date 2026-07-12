import 'package:flutter/material.dart';

abstract class ColorManager {
  static const Color white = Color(0xFFFFFFFF);
  static const Color blue = Color(0xFF0D74CE);
  static const Color gray = Color(0xFF60646C);
  static const Color lightGray = Color(0xFF999999);
  static const Color black = Color(0xFF171717);

  static const Color lightBlue = Color(0xFFE3F2FD);
  static const Color surfaceBlue = Color(0xFFF8F9FA);
  static const Color nearBlack = Color(0xFF1A1A1E);

  static const Color neutralGray = Color(0xFF868E96);
  static const Color borderGray = Color(0xFFE9ECEF);

  // للـ Badges والأزرار الثانوية
  static const Color surfaceGray = Color(
    0xFFF1F3F5,
  ); // فاصل خفيف جداً لا يشتت العين
  // خلفية بيضاء نقية

  static const Color transparent = Colors.transparent; // شفاف للـ Flutter UI
  static const Color overlay = Color(0x3F000000); // طبقة الظل الشفافة
  static const Color danger = Color(0xFFDC2626); // أحمر صريح وواضح للأخطاء
  static const Color error = Color(0xFFDC2626); // نفس درجة الخطأ المريحة
}
