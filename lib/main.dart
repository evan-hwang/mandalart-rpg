import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mandalart/app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // iOS 상태바 스타일 설정
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarBrightness: Brightness.light),
  );

  runApp(const MandalartApp());
}
