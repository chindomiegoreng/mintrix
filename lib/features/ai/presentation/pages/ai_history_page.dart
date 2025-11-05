import 'package:flutter/material.dart';
import 'package:mintrix/shared/theme.dart';

class AIHistoryPage extends StatelessWidget {
  const AIHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final histories = [
      {"title": "title histori ai", "progress": 20, "date": "2 Nov 2025"},
      {"title": "title histori ai", "progress": 35, "date": "1 Nov 2025"},
      {"title": "title histori ai", "progress": 50, "date": "31 Okt 2025"},
      {"title": "title histori ai", "progress": 80, "date": "30 Okt 2025"},
      {"title": "title histori ai", "progress": 60, "date": "29 Okt 2025"},
      {"title": "title histori ai", "progress": 40, "date": "28 Okt 2025"},
      {"title": "title histori ai", "progress": 70, "date": "27 Okt 2025"},
      {"title": "title histori ai", "progress": 100, "date": "26 Okt 2025"},
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xffE1F5F5),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            "Dino",
            style: primaryTextStyle.copyWith(
              fontSize: 14,
              fontWeight: semiBold,
              color: Colors.black,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: histories.length,
        itemBuilder: (context, index) {
          final item = histories[index];
          final title = item["title"] as String;
          final date = item["date"] as String;
          final progress = item["progress"] as int;

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: primaryTextStyle.copyWith(
                        fontWeight: semiBold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      date,
                      style: secondaryTextStyle.copyWith(fontSize: 12),
                    ),
                  ],
                ),
                _buildProgressCircle(progress),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProgressCircle(int progress) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 42,
          height: 42,
          child: CircularProgressIndicator(
            value: progress / 100,
            strokeWidth: 5,
            backgroundColor: const Color(0xffE0F7FA),
            color: const Color(0xff4DD4E8),
          ),
        ),
        Text(
          "$progress%",
          style: primaryTextStyle.copyWith(
            fontSize: 12,
            fontWeight: semiBold,
            color: const Color(0xff4DD4E8),
          ),
        ),
      ],
    );
  }
}
