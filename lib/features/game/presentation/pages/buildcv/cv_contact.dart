import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mintrix/shared/theme.dart';
import 'package:mintrix/widgets/buttons.dart';
import 'package:mintrix/widgets/form_cv.dart';

class CVContact extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const CVContact({super.key, required this.onNext, required this.onBack});

  @override
  State<CVContact> createState() => _CVContactState();
}

class _CVContactState extends State<CVContact> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController jobTitleController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  String selectedCountry = "Indonesia";
  String selectedCity = "Yogyakarta";

  final List<String> cityList = [
    'Jakarta',
    'Surabaya',
    'Bandung',
    'Medan',
    'Semarang',
    'Makassar',
    'Palembang',
    'Tangerang',
    'Denpasar',
    'Yogyakarta',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      extendBody: true,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              Text(
                'Kontak',
                style: primaryTextStyle.copyWith(
                  fontSize: 28,
                  fontWeight: bold,
                ),
              ),

              const SizedBox(height: 8),
              Text(
                'Tambahkan informasi kontak terkini agar perusahaan '
                'dan perekrut dapat dengan mudah menghubungimu',
                style: secondaryTextStyle.copyWith(fontSize: 14),
              ),
              const SizedBox(height: 24),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      buildInputCV("Nama Awal", firstNameController, hint: "Renata"),
                      buildInputCV("Nama Akhir", lastNameController),
                      buildInputCV("Jabatan yang diinginkan", jobTitleController, hint: "Pelajar"),
                      buildInputCV("Nomor Telepon", phoneController,
                          hint: "+62 812 3456 7890", keyboard: TextInputType.phone),
                      buildInputCV("Email", emailController, hint: "renata@mail.com",
                          keyboard: TextInputType.emailAddress),

                      buildDropdownCV(
                        label: "Negara",
                        value: selectedCountry,
                        items: const ["Indonesia"],
                        onChanged: (value) => setState(() => selectedCountry = value!),
                      ),

                      buildDropdownCV(
                        label: "Kota",
                        value: selectedCity,
                        items: cityList,
                        onChanged: (value) => setState(() => selectedCity = value!),
                      ),

                      buildTextAreaCV(
                        "Alamat",
                        addressController,
                        hint: "Jl. Malioboro No. 10, Yogyakarta",
                      ),

                      const SizedBox(height: 140),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0), // bisa dibuat blur bila mau
          child: SafeArea(
            child: Container(
              color: Colors.transparent, // ✅ beneran transparan
              padding: const EdgeInsets.all(24),
              child: CustomFilledButton(
                title: "Selanjutnya",
                variant: ButtonColorVariant.blue,
                onPressed: widget.onNext,
              ),
            ),
          ),
        ),
      ),
    );
  }

  
}
