import 'package:blott/core/http/http-client.dart';
import 'package:blott/core/models/NewsItem.dart';
import 'package:get/get.dart';

class NewsController extends GetxController {
  var isLoading = false.obs;
  var hasError = false.obs;
  var news = <NewsItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchNews();
  }

  void fetchNews() async {
    try {
      isLoading.value = true;
      hasError.value = false;

      final response = await HttpHandler.getMarketNews();

      final List<NewsItem> newsItems = response
          .map((item) => NewsItem.fromJson(item))
          .toList();

      news.value = newsItems;
    } catch (e) {
      hasError.value = true;
      print('Error fetching news: $e');
    } finally {
      isLoading.value = false;
    }
  }
}