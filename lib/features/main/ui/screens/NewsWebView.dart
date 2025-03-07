

import 'package:blott/core/utils/constants/Colors.dart';
import 'package:blott/features/main/controller/NewsWebViewController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewsWebView extends StatelessWidget {
  final String url;
  final String title;

  NewsWebView({
    Key? key,
    required this.url,
    required this.title,
  }) : super(key: key);

  NewsWebViewController webViewController = Get.put(NewsWebViewController());

  @override
  Widget build(BuildContext context) {
    webViewController.loadUrl(url);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: accentBlue,
        title: Text(
          title,
          style: const TextStyle(fontSize: 18,fontWeight:FontWeight.w500,color: Colors.white),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,color: Colors.white),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.open_in_browser,color: Colors.white),
            onPressed: () async {
              final Uri uri = Uri.parse(url);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh,color: Colors.white),
            onPressed: () {
              webViewController.reload();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: webViewController.controller),
          Obx(
                () => webViewController.isLoading.value
                ? const Center(
              child: CircularProgressIndicator(),
            )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
