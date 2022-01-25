import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:android_path_provider/android_path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:maktampos/ui/login/login_page.dart';
import 'package:maktampos/utils/screen_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class WebViewExample extends StatefulWidget {
  @override
  _WebViewExampleState createState() => new _WebViewExampleState();
}

class _WebViewExampleState extends State<WebViewExample> {
  late InAppWebViewController webView;
  late String _localPath;

  @override
  void initState() {
    super.initState();
    init();
    _prepareSaveDir();
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    print(
        'Background Isolate Callback: task ($id) is in status ($status) and process ($progress)');
    final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send?.send([id, status, progress]);
  }

  void init() async {
    await FlutterDownloader.initialize(
        debug: true // optional: set false to disable printing logs to console
        );
    FlutterDownloader.registerCallback(downloadCallback);
    await Permission.storage.request();
  }

  void downloadNow(String url) async {
    print(url);
    await FlutterDownloader.enqueue(
      url: url,
      savedDir: _localPath,
      // fileName: DateTime.now().millisecondsSinceEpoch.toString() + '.xlsx',
      showNotification: true,
      openFileFromNotification: true,
      saveInPublicStorage: true,
    );
  }

  Future<void> _prepareSaveDir() async {
    _localPath = (await _findLocalPath())!;
    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
  }

  Future<String?> _findLocalPath() async {
    var externalStorageDirPath;
    try {
      externalStorageDirPath = await AndroidPathProvider.downloadsPath;
    } catch (e) {
      final directory = await getExternalStorageDirectory();
      externalStorageDirPath = directory?.path;
    }
    return externalStorageDirPath;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ),
              onPressed: () {
                ScreenUtils(context)
                    .navigateTo(LoginPage(), replaceScreen: true);
              },
            )
          ],
        ),
        body: Container(
            child: Column(children: <Widget>[
          Expanded(
              child: InAppWebView(
            initialUrlRequest: URLRequest(
                url: Uri.parse("http://maktam-admin.susumaktam.com/dashboard")),
            initialOptions: InAppWebViewGroupOptions(
              crossPlatform: InAppWebViewOptions(useOnDownloadStart: true),
            ),
            onWebViewCreated: (InAppWebViewController controller) {
              webView = controller;
            },
            onDownloadStart: (controller, url) async {
              String urlStr = url.toString();
              if (urlStr.contains("blob:")) {
                urlStr = urlStr.replaceAll("blob:", "");
              }
              print("downloadStart : " + urlStr);

              downloadNow(urlStr);
            },
            onConsoleMessage: (controller, message) {
              print("console : " + message.message);
            },
          ))
        ])),
      ),
    );
  }
}
