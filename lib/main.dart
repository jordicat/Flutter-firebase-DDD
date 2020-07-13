import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_firebase_ddd_notes/injection.dart';
import 'package:flutter_firebase_ddd_notes/presentation/core/app_widget.dart';

void main() {
  configureInjection(Environment.prod);
  runApp(AppWidget());
}
