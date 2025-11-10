import 'package:flutter/material.dart';
import 'package:mintrix/features/ai/data/services/chat_history_service.dart';
import 'package:mintrix/features/ai/data/models/chat_history.dart';
import 'package:mintrix/shared/theme.dart';

class AIHistoryPage extends StatefulWidget {
  const AIHistoryPage({super.key});

  @override
  State<AIHistoryPage> createState() => _AIHistoryPageState();
}

class _AIHistoryPageState extends State<AIHistoryPage> {
  final ChatHistoryService _historyService = ChatHistoryService();
  List<ChatHistory> _histories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final histories = await _historyService.getChatHistory();
    setState(() {
      _histories = histories;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
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
            "Riwayat Chat",
            style: primaryTextStyle.copyWith(
              fontSize: 14,
              fontWeight: semiBold,
              color: Colors.black,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _histories.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada riwayat chat',
                    style: primaryTextStyle.copyWith(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadHistory,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _histories.length,
                itemBuilder: (context, index) {
                  final history = _histories[index];
                  return _buildHistoryItem(history);
                },
              ),
            ),
    );
  }

  Widget _buildHistoryItem(ChatHistory history) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            history.title,
            style: primaryTextStyle.copyWith(
              fontWeight: semiBold,
              fontSize: 14,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            history.formattedDate,
            style: secondaryTextStyle.copyWith(fontSize: 12),
          ),
          const SizedBox(height: 2),
          Text(
            '${history.messages.length} pesan',
            style: secondaryTextStyle.copyWith(
              fontSize: 10,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}
