import 'package:flutter/material.dart';
import 'package:mintrix/features/ai/data/services/dino_api_service.dart';
import 'package:mintrix/features/ai/data/models/chat_title_model.dart';
import 'package:mintrix/features/ai/presentation/pages/ai_page.dart';
import 'package:mintrix/shared/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class AIHistoryPage extends StatefulWidget {
  const AIHistoryPage({super.key});

  @override
  State<AIHistoryPage> createState() => _AIHistoryPageState();
}

class _AIHistoryPageState extends State<AIHistoryPage> {
  late DinoApiService _apiService;
  List<ChatTitleModel> _histories = [];
  bool _isLoading = true;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeService();
  }

  Future<void> _initializeService() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? ''; // ✅ Ganti dengan 'auth_token'
    
    if (token.isEmpty) {
      print('❌ Token tidak ditemukan di SharedPreferences');
      setState(() {
        _isInitialized = true;
        _isLoading = false;
      });
      return;
    }
    
    print('✅ Token ditemukan: ${token.substring(0, 20)}...'); // Debug print
    
    _apiService = DinoApiService(authToken: token);
    
    setState(() {
      _isInitialized = true;
    });
    
    await _loadHistory();
  }

  Future<void> _loadHistory() async {
    if (!_isInitialized) return;
    
    setState(() {
      _isLoading = true;
    });

    try {
      final histories = await _apiService.getChatTitles();
      setState(() {
        _histories = histories;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error loading history: $e');
    }
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

  Widget _buildHistoryItem(ChatTitleModel history) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AIPage(titleId: history.id),
          ),
        );
      },
      child: Container(
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
              DateFormat('dd MMM yyyy, HH:mm').format(history.createdAt),
              style: secondaryTextStyle.copyWith(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
