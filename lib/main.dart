import 'package:flutter/material.dart';
import 'package:flutter_news/src/flutter_news_home.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    ProviderScope(
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(useMaterial3: true),
        home: const FlutterNewsHome(),
      ),
    ),
  );
}
