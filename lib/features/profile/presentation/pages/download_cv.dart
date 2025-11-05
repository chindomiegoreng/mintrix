import 'package:flutter/material.dart';
import 'package:mintrix/shared/theme.dart';
import 'package:mintrix/widgets/buttons.dart';

class DownloadCv extends StatefulWidget {
  const DownloadCv({super.key});

  @override
  State<DownloadCv> createState() => _DownloadCvState();
}

class _DownloadCvState extends State<DownloadCv> {
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
        title: const Text("Download CV"),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          SizedBox(height: 133),
          buildContainer(),
          SizedBox(height: 150),
          CustomFilledButton(
            title: 'Download',
            variant: ButtonColorVariant.blue,
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget buildContainer() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Image.asset("assets/images/cv.png"),
    );
  }
}
