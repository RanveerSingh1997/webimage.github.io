import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

/// Application itself.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Flutter Demo', home: const HomePage());
  }
}

/// [Widget] displaying the home page consisting of an image the the buttons.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

/// State of a [HomePage].
class _HomePageState extends State<HomePage> {
  final TextEditingController _urlController = TextEditingController();
  String? _imageUrl;
  bool _menuOpen = false;
  late String _viewType;

  @override
  void initState() {
    super.initState();
    _viewType = 'imageElement';
  }

  void _toggleFullscreen() {
    final html.Document doc = html.document;
    if (doc.fullscreenElement != null) {
      doc.exitFullscreen();
    } else {
      doc.documentElement?.requestFullscreen();
    }
  }

  void _toggleMenu() {
    setState(() {
      _menuOpen = !_menuOpen;
    });
  }

  void _closeMenu() {
    setState(() {
      _menuOpen = false;
    });
  }

  void _loadImage() {
    setState(() {
      _imageUrl = _urlController.text;
      _viewType =
          'image-${DateTime.now().millisecondsSinceEpoch}';
      final html.ImageElement imgElement = html.ImageElement()
        ..src = _imageUrl!
        ..style.width = '100%'
        ..style.height = '100%'
        ..style.objectFit = 'cover';

      // Register the view factory
      ui_web.platformViewRegistry
          .registerViewFactory(_viewType, (int viewId) => imgElement);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _closeMenu,
      child: Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: _imageUrl != null
                        ? HtmlElementView(
                            viewType: _viewType,
                          )
                        : Center(
                            child: Text("Enter Image Url"),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _urlController,
                      decoration: InputDecoration(hintText: 'Image URL'),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _loadImage,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                      child: Icon(Icons.arrow_forward),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 64),
            ],
          ),
        ),
        floatingActionButton: Stack(
          children: [
            if (_menuOpen)
              Positioned(
                bottom: 80,
                right: 5,
                child: Column(
                  children: [
                    FloatingActionButton(
                      heroTag: 'enterFS',
                      onPressed: () {
                        _toggleFullscreen();
                        _closeMenu();
                      },
                      child: Icon(Icons.fullscreen),
                    ),
                    SizedBox(height: 8),
                    FloatingActionButton(
                      heroTag: 'exitFS',
                      onPressed: () {
                        html.document.exitFullscreen();
                        _closeMenu();
                      },
                      child: Icon(Icons.fullscreen_exit),
                    ),
                  ],
                ),
              ),
            Positioned(
              bottom: 5,
              right: 5,
              child: FloatingActionButton(
                onPressed: _toggleMenu,
                child: Icon(Icons.add),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
