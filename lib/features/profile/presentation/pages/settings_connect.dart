import 'package:flutter/material.dart';
import 'package:mintrix/core/api/api_client.dart';
import 'package:mintrix/core/api/api_endpoints.dart';
import 'package:mintrix/shared/theme.dart';
import 'dart:convert';

class SettingsConnectPage extends StatefulWidget {
  const SettingsConnectPage({super.key});

  @override
  State<SettingsConnectPage> createState() => _SettingsConnectPageState();
}

class _SettingsConnectPageState extends State<SettingsConnectPage> {
  final ApiClient _apiClient = ApiClient();
  bool _isLoading = true;
  String? _errorMessage;
  String? _qrcodeBase64;
  String? _userId;

  @override
  void initState() {
    super.initState();
    _loadQRCode();
  }

  Future<void> _loadQRCode() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      print('📡 Loading QR Code...');

      final response = await _apiClient.get(
        ApiEndpoints.generateQRCode,
        requiresAuth: true,
      );

      print('✅ QR Code response: $response');

      final data = response['data'] ?? {};

      setState(() {
        _qrcodeBase64 = data['qrcode'];
        _userId = data['_id'];
        _isLoading = false;
      });

      print('🎉 QR Code loaded for user: $_userId');
    } catch (e) {
      print('❌ QR Code error: $e');
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: lightBackgoundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("Hubungkan"),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    _errorMessage!,
                    style: primaryTextStyle.copyWith(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadQRCode,
                    child: Text(
                      'Coba Lagi',
                      style: whiteTextStyle.copyWith(
                        fontSize: 14,
                        fontWeight: semiBold,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadQRCode,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [const SizedBox(height: 133), _buildContainer()],
              ),
            ),
    );
  }

  Widget _buildContainer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Hubungkan dengan orang tua!",
          style: primaryTextStyle.copyWith(fontSize: 20, fontWeight: semiBold),
        ),
        const SizedBox(height: 8),
        Text(
          "Ikuti langkah berikut ini agar terhubung dengan orang tua:",
          style: secondaryTextStyle.copyWith(
            fontSize: 14,
            fontWeight: medium,
            overflow: TextOverflow.ellipsis,
          ),
          maxLines: 2,
        ),
        const SizedBox(height: 4),
        Text(
          "1. Buka aplikasi di HP Ayah atau Ibu.\n2. Pindai kode di bawah ini.",
          style: secondaryTextStyle.copyWith(
            fontSize: 14,
            fontWeight: medium,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 38),

        // ✅ Dynamic QR Code from API
        Center(
          child: _qrcodeBase64 != null
              ? Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Image.memory(
                    base64Decode(
                      _qrcodeBase64!.split(',')[1],
                    ), // Remove "data:image/png;base64," prefix
                    width: 250,
                    height: 250,
                    fit: BoxFit.contain,
                  ),
                )
              : Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Icon(Icons.qr_code, size: 100, color: Colors.grey),
                  ),
                ),
        ),

        const SizedBox(height: 41),
        Row(
          children: [
            Expanded(child: Divider(color: secondaryColor)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                "atau",
                style: primaryTextStyle.copyWith(
                  fontSize: 16,
                  fontWeight: semiBold,
                ),
              ),
            ),
            Expanded(child: Divider(color: secondaryColor)),
          ],
        ),
        const SizedBox(height: 25),
        Center(
          child: Text(
            "Masukkan kode ini secara manual:",
            style: primaryTextStyle.copyWith(fontSize: 14, fontWeight: medium),
          ),
        ),
        const SizedBox(height: 25),

        // ✅ Dynamic User ID from API
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: bluePrimaryColor, width: 1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              _userId != null ? _userId! : "LOADING...",
              style: bluePrimaryTextStyle.copyWith(
                fontSize: 16,
                fontWeight: medium,
                letterSpacing: 2,
              ),
            ),
          ),
        ),
        const SizedBox(height: 50),
      ],
    );
  }
}
