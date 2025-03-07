
import 'package:blott/core/models/NewsItem.dart';
import 'package:blott/features/main/ui/screens/NewsWebView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewsItemWidget extends StatelessWidget {
  final NewsItem newsItem;

  const NewsItemWidget({
    super.key,
    required this.newsItem,
  });

  void _openNewsInWebView() {
    Get.to(() => NewsWebView(url: newsItem.url, title: newsItem.source),
      transition: Transition.rightToLeft,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _openNewsInWebView,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.network(
                newsItem.image,
                width: 100,
                height: 70,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 100,
                    height: 70,
                    color: Colors.grey[800],
                    child: const Icon(Icons.image_not_supported, color: Colors.grey),
                  );
                },
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(left: 12),
                height: 100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          newsItem.source.toUpperCase(),
                          style: TextStyle(fontSize: 12, color: Colors.white60),
                        ),
                        Text(
                          newsItem.getFormattedDate(),
                          style: TextStyle(fontSize: 12, color: Colors.white60),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Expanded(
                      child: Text(
                        newsItem.headline,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


