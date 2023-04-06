// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'globals.dart' as globals;

enum _MenuOptions {
  google,
  ce6localhost,
  ce6AWS,
  ce6QAVPN,
  navigationDelegate,
  userAgent,
  javascriptChannel,
  listCookies,
  clearCookies,
  addCookie,
  setCookie,
  removeCookie,
}

class Menu extends StatefulWidget {
  const Menu({required this.controller, super.key});

  final WebViewController controller;

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  final cookieManager = WebViewCookieManager();

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_MenuOptions>(
      onSelected: (value) async {
        switch (value) {
          case _MenuOptions.navigationDelegate:
            await widget.controller
                .loadRequest(Uri.parse('https://youtube.com'));
            break;
          case _MenuOptions.ce6AWS:
            await widget.controller
                .loadRequest(Uri.parse('https://ce-dev-school.devstudi.com/teachd/index.html'));
            break;
          case _MenuOptions.ce6QAVPN:
            await widget.controller
                .loadRequest(Uri.parse('http://172.16.52.67/teach/index.html'));
            break;
          case _MenuOptions.ce6localhost:
            await widget.controller
                .loadRequest(Uri.parse('http://172.18.3.69:4200/index.html'));
            break;
          case _MenuOptions.google:
            await widget.controller
                .loadRequest(Uri.parse('https://google.com'));
            break;
          case _MenuOptions.userAgent:
            final userAgent = await widget.controller
                .runJavaScriptReturningResult('navigator.userAgent');
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('$userAgent'),
            ));
            break;
          case _MenuOptions.javascriptChannel:
            await widget.controller.runJavaScript('''
var req = new XMLHttpRequest();
req.open('GET', "https://api.ipify.org/?format=json");
req.onload = function() {
  if (req.status == 200) {
    let response = JSON.parse(req.responseText);
    SnackBar.postMessage("IP Address: " + response.ip);
  } else {
    SnackBar.postMessage("Error: " + req.status);
  }
}
req.send();''');
            break;
          case _MenuOptions.clearCookies:
            await _onClearCookies();
            break;
          case _MenuOptions.listCookies:
            await _onListCookies(widget.controller);
            break;
          case _MenuOptions.addCookie:
            await _onAddCookie(widget.controller);
            break;
          case _MenuOptions.setCookie:
            await _onSetCookie(widget.controller);
            break;
          case _MenuOptions.removeCookie:
            await _onRemoveCookie(widget.controller);
            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem<_MenuOptions>(
          value: _MenuOptions.navigationDelegate,
          child: Text('Navigate to YouTube'),
        ),
        const PopupMenuItem<_MenuOptions>(
          value: _MenuOptions.ce6AWS,
          child: Text('Navigate to AWS'),
        ),
        const PopupMenuItem<_MenuOptions>(
          value: _MenuOptions.ce6QAVPN,
          child: Text('Navigate to QA VPN'),
        ),
        const PopupMenuItem<_MenuOptions>(
          value: _MenuOptions.ce6localhost,
          child: Text('Navigate to LocalHost'),
        ),
        const PopupMenuItem<_MenuOptions>(
          value: _MenuOptions.google,
          child: Text('Navigate to Google'),
        ),
        const PopupMenuItem<_MenuOptions>(
          value: _MenuOptions.userAgent,
          child: Text('Show user-agent'),
        ),
        const PopupMenuItem<_MenuOptions>(
          value: _MenuOptions.javascriptChannel,
          child: Text('Lookup IP Address'),
        ),
        const PopupMenuItem<_MenuOptions>(
          value: _MenuOptions.clearCookies,
          child: Text('Clear cookies'),
        ),
        const PopupMenuItem<_MenuOptions>(
          value: _MenuOptions.listCookies,
          child: Text('List cookies'),
        ),
        const PopupMenuItem<_MenuOptions>(
          value: _MenuOptions.addCookie,
          child: Text('Add cookie'),
        ),
        const PopupMenuItem<_MenuOptions>(
          value: _MenuOptions.setCookie,
          child: Text('Set cookie'),
        ),
        const PopupMenuItem<_MenuOptions>(
          value: _MenuOptions.removeCookie,
          child: Text('Remove cookie'),
        ),
      ],
    );
  }

  Future<void> _onListCookies(WebViewController controller) async {
    final String cookies = await controller
        .runJavaScriptReturningResult('document.cookie') as String;
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(cookies.isNotEmpty ? cookies : 'There are no cookies.'),
      ),
    );
  }

  Future<void> _onClearCookies() async {
    final hadCookies = await cookieManager.clearCookies();
    String message = 'There were cookies. Now, they are gone!';
    if (!hadCookies) {
      message = 'There were no cookies to clear.';
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  Future<void> _onAddCookie(WebViewController controller) async {
    await controller.runJavaScript('''var date = new Date();
    date.setTime(date.getTime()+(30*24*60*60*1000));
    document.cookie = "FirstName=John; expires=" + date.toGMTString();''');
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Custom cookie added.'),
      ),
    );
  }

  Future<void> _onSetCookie(WebViewController controller) async {
    await cookieManager.setCookie(
      const WebViewCookie(name: 'foo', value: 'bar', domain: 'flutter.dev'),
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Custom cookie is set.'),
      ),
    );
  }

  Future<void> _onRemoveCookie(WebViewController controller) async {
    await controller.runJavaScript(
        'document.cookie="FirstName=John; expires=Thu, 01 Jan 1970 00:00:00 UTC" ');
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Custom cookie removed.'),
      ),
    );
  }
}
