import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewsWebViewController extends GetxController {
  final isLoading = true.obs;
  late final WebViewController controller;

  @override
  void onInit() {
    super.onInit();
    controller = WebViewController();
  }

  void loadUrl(String url) {
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            isLoading.value = true;
          },
          onPageFinished: (String url) {
            isLoading.value = false;
          },
        ),
      )
      ..loadRequest(Uri.parse(url));
  }

  void reload() {
    controller.reload();
  }
}