import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'dart:ui' as ui;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Web Browser',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const WebViewApp(),
    );
  }
}

class WebViewApp extends StatefulWidget {
  const WebViewApp({super.key});

  @override
  State<WebViewApp> createState() => _WebViewAppState();
}

class _WebViewAppState extends State<WebViewApp> {
  final String initialUrl = 'https://osidosos.com.br/';
  late final String viewId;

  @override
  void initState() {
    super.initState();
    // Registra um view factory com um ID único
    viewId = 'webview_${DateTime.now().millisecondsSinceEpoch}';
    // Ignore o aviso de segurança, pois estamos usando APIs web intencionalmente
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      viewId,
      (int viewId) => html.IFrameElement()
        ..src = initialUrl
        ..style.border = 'none'
        ..style.height = '100%'
        ..style.width = '100%'
        ..allowFullscreen = true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Web Browser'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Recarrega a página
              final iframe = html.window.document.getElementById(viewId) as html.IFrameElement?;
              if (iframe != null) {
                iframe.src = iframe.src;
              }
            },
          ),
        ],
      ),
      body: HtmlElementView(
        viewType: viewId,
      ),
    );
  }
}
