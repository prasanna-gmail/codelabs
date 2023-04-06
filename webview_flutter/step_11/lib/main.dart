// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

// import 'src/globals.dart' as globals;
import 'src/menu.dart';
import 'src/navigation_controls.dart';
import 'src/web_view_stack.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: const WebViewApp(),
    ),
  );
}

class WebViewApp extends StatefulWidget {
  const WebViewApp({super.key});

  @override
  State<WebViewApp> createState() => _WebViewAppState();
}

class _WebViewAppState extends State<WebViewApp> {
  late final WebViewController controller;

  bool showAppbar = true;
  String _urlStr = "https://ce-dev-school.devstudi.com/teachd/index.html";

  TextEditingController myTextEditingController =
      TextEditingController(text: "https://ce-dev-school.devstudi.com/teachd/index.html");

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..loadRequest(
        // Uri.parse('https://flutter.dev'),
        Uri.parse(_urlStr),
      );
  }

  Future<void> setMyAppBar(bool myState) async {
    setState(() {
      showAppbar = myState;
      print("showAppbar :: $showAppbar");
    });
  }

  Future<void> onSubmitClicked() async {
    _urlStr = myTextEditingController.text.trim();
    print("urllllll ::: $_urlStr");
    final myUri = Uri.parse(_urlStr);
    controller.loadRequest(myUri);
    setMyAppBar(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppbar
          ? AppBar(
              title: const Text('Flutter WebView'),
              // toolbarHeight: globals.boolAppBar ? 100 : 0,
              actions: [
                NavigationControls(controller: controller),
                Menu(controller: controller),
              ],
            )
          : null,
      body: Column(
        children: [
          Visibility(
            visible: showAppbar,
            child: Container(
              height: 50,
              padding: EdgeInsets.symmetric(horizontal: 56, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      width: 200,
                      height: 100,
                      child: TextField(
                        controller: myTextEditingController,
                      ),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () => onSubmitClicked(), child: Text("submit"))
                ],
              ),
            ),
          ),
          Expanded(
            child: WebViewStack(
              controller: controller,
              OnTap: () {
                setMyAppBar(false);
                print("showAppbar222 :: $showAppbar");
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.amp_stories_outlined
        ),
        onPressed: () => setMyAppBar(true),
      ),
    );
  }
}
