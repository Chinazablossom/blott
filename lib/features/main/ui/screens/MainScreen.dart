import 'package:blott/core/utils/constants/Colors.dart';
import 'package:blott/features/main/controller/NewsController.dart';
import 'package:blott/features/main/ui/widgets/NewsItemWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final NewsController newsController = Get.put(NewsController());
    final storage = GetStorage();

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 140,
            width: double.infinity,
            decoration: BoxDecoration(color: accentBlue),
            child: Padding(
              padding: const EdgeInsets.only(top: 50, left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      'Hey ${storage.read("firstName")}',
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                    Obx(() {
                      if (newsController.hasError.value) {
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10
                            ),
                            child: Text(
                              'Something went wrong. Please try again later.',
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );}
                      return Container();
                    }),
                ],
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (newsController.isLoading.value) {
                return Center(
                  child: CircularProgressIndicator(
                    color: accentBlue,
                  ),
                );
              }

              if (newsController.hasError.value) {
                return Center(
                  child: Expanded(
                    child: ElevatedButton(
                      onPressed: () => newsController.fetchNews(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[500],
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Retry'),
                    ),
                  ),
                );
              }

              return ListView.builder(
                itemCount: newsController.news.length,
                itemBuilder: (context, index) {
                  final newsItem = newsController.news[index];
                  return Expanded(child: NewsItemWidget(newsItem: newsItem));
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}