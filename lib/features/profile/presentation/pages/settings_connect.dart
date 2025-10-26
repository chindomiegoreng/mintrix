import 'package:flutter/material.dart';
import 'package:mintrix/shared/theme.dart';

class SettingsConnectPage extends StatefulWidget {
  const SettingsConnectPage({super.key});

  @override
  State<SettingsConnectPage> createState() => _SettingsConnectPageState();
}

class _SettingsConnectPageState extends State<SettingsConnectPage> {
  bool isDailyReminderEnabled = true;

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
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [SizedBox(height: 133), buildContainer()],
      ),
    );
  }

  Widget buildContainer() {
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
          "1. Buka aplikasi di HP Ayah atau Ibu.\n2. Pilih tombol 'Tambahkan Akun Anak'.\n3. Pindai kode di bawah ini.",
          style: secondaryTextStyle.copyWith(
            fontSize: 14,
            fontWeight: medium,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 38),
        Center(child: Image.asset("assets/images/qrcode.png", height: 250)),
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
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: bluePrimaryColor, width: 1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              "HEWAN-748",
              style: bluePrimaryTextStyle.copyWith(
                fontSize: 16,
                fontWeight: medium,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
