import 'package:flutter/material.dart';
import 'dart:ui_web' as ui_web;
import 'package:flutter_web_fullscreen/web_page.dart';
import 'dart:html' as html;

void main() {
  ui_web.platformViewRegistry.registerViewFactory(
    'imageElement',
        (int viewId, {Object? params}) {
      return html.DivElement()
        ..id = 'myDivId'
        ..style.width = '100px'
        ..style.height = '100px';
    },
  );
  runApp(
    MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.blue,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: MyApp(),
    ),
  );
}
