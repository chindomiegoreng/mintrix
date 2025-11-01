import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mintrix/shared/theme.dart';
import 'package:mintrix/widgets/buttons.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
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
        title: const Text("Pengaturan"),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          buildContainer(),
          buildContainer1(),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget buildContainer() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 133),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        image: const DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage("assets/images/settings_container.png"),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Jadikan Petualangan Lebih Seru!",
            style: primaryTextStyle.copyWith(
              fontSize: 16,
              fontWeight: semiBold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Hubungkan akunmu dengan orang tua untuk membagikan progres dan pencapaian hebatmu.",
            style: secondaryTextStyle.copyWith(
              fontSize: 14,
              fontWeight: medium,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 8),
          CustomFilledButton(
            title: 'Hubungkan',
            variant: ButtonColorVariant.blue,
            width: 135,
            borderRadius: 12,
            onPressed: () {
              Navigator.pushNamed(context, "/settings-connect");
            },
          ),
        ],
      ),
    );
  }

  Widget buildContainer1() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Akun",
                style: primaryTextStyle.copyWith(
                  fontSize: 20,
                  fontWeight: semiBold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: whiteColor,
              border: Border.all(color: secondaryColor, width: 1),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  spacing: 3,
                  children: [
                    _buildMenuItem(
                      icon: 'assets/icons/link.svg',
                      title: "Akun Terhubung",
                      subtitle: "Hubungkan dengan orang tua",
                    ),
                    Divider(
                      color: thirdColor,
                      thickness: 1,
                      indent: 1,
                      endIndent: 1,
                    ),
                    _buildMenuItem(
                      icon: 'assets/icons/edit-user.svg',
                      title: "Edit Profil",
                      subtitle: "Edit Avatar dan Nama Panggilanmu",
                    ),
                    Divider(
                      color: thirdColor,
                      thickness: 1,
                      indent: 1,
                      endIndent: 1,
                    ),
                    _buildMenuItem(
                      icon: 'assets/icons/key.svg',
                      title: "Ubah Kata Sandi",
                      subtitle: "Ubah kata sandi anda secara berkala",
                    ),
                    Divider(
                      color: thirdColor,
                      thickness: 1,
                      indent: 1,
                      endIndent: 1,
                    ),
                    _buildMenuItem(
                      icon: 'assets/icons/globe.svg',
                      title: "Bahasa",
                      subtitle: "Pilih bahasa yang digunakan",
                    ),
                    Divider(
                      color: thirdColor,
                      thickness: 1,
                      indent: 1,
                      endIndent: 1,
                    ),
                    // switch
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/bell-ring.svg',
                              width: 24,
                              height: 24,
                            ),
                            const SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Pengingat Misi Harian",
                                  style: primaryTextStyle.copyWith(
                                    fontSize: 16,
                                    fontWeight: semiBold,
                                  ),
                                ),
                                Text(
                                  "Ingatkan Misi Harianku",
                                  style: secondaryTextStyle.copyWith(
                                    fontSize: 11,
                                    fontWeight: medium,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Switch(
                          value: isDailyReminderEnabled,
                          activeThumbColor: bluePrimaryColor,
                          onChanged: (bool value) {
                            setState(() {
                              isDailyReminderEnabled = value;
                            });
                          },
                        ),
                      ],
                    ),
                    Divider(
                      color: thirdColor,
                      thickness: 1,
                      indent: 1,
                      endIndent: 1,
                    ),
                    _buildMenuItem(
                      icon: 'assets/icons/circle-question-mark.svg',
                      title: "Pusat Bantuan",
                      subtitle: "Bantuan & Dukungan",
                    ),
                    Divider(
                      color: thirdColor,
                      thickness: 1,
                      indent: 1,
                      endIndent: 1,
                    ),
                    _buildMenuItem(
                      icon: 'assets/icons/shield-alert.svg',
                      title: "Tentang Aplikasi",
                      subtitle: "Versi aplikasi v.0.1",
                    ),
                    Divider(
                      color: thirdColor,
                      thickness: 1,
                      indent: 1,
                      endIndent: 1,
                    ),
                    _buildMenuItem(
                      icon: 'assets/icons/log-out.svg',
                      title: "Keluar Akun",
                      subtitle: "Keluar dari aplikasi",
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required String icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SvgPicture.asset(icon, width: 24, height: 24),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: primaryTextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: semiBold,
                  ),
                ),
                Text(
                  subtitle,
                  style: secondaryTextStyle.copyWith(
                    fontSize: 11,
                    fontWeight: medium,
                  ),
                ),
              ],
            ),
          ],
        ),
        Icon(
          Icons.arrow_forward_ios_rounded,
          color: bluePrimaryColor,
          size: 24,
        ),
      ],
    );
  }
}
