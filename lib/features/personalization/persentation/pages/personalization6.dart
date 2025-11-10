import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mintrix/shared/theme.dart';
import 'package:mintrix/widgets/buttons.dart';
import 'package:mintrix/widgets/personalization_chips.dart';
import '../bloc/personalization_bloc.dart';
import '../bloc/personalization_event.dart';

class Personalization6 extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const Personalization6({
    super.key,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<Personalization6> createState() => _Personalization6State();
}

class _Personalization6State extends State<Personalization6> {
  List<String> selectedStrengths = [];

  // ✅ Suggested strengths (bisa dari API nanti)
  final List<String> suggestedStrengths = [
    'Pintar',
    'Kreatif',
    'Empati',
    'Mandiri',
    'Pekerja Keras',
    'Komunikatif',
    'Jujur',
    'Disiplin',
    'Tanggung Jawab',
    'Inovatif',
  ];

  void _addStrength(String value) {
    setState(() {
      if (!selectedStrengths.contains(value)) {
        selectedStrengths.add(value);
      }
    });
    context.read<PersonalizationBloc>().add(UpdateStrengths(selectedStrengths));
  }

  void _removeStrength(String strength) {
    setState(() {
      selectedStrengths.remove(strength);
    });
    context.read<PersonalizationBloc>().add(UpdateStrengths(selectedStrengths));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Kenali Kelebihanmu!',
                style: primaryTextStyle.copyWith(
                  fontSize: 24,
                  fontWeight: bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Tulis atau tambahkan hal-hal yang menurutmu menjadi kekuatanmu. '
                'Kami akan bantu menyesuaikan petualangan karakter sesuai dirimu!',
                style: secondaryTextStyle.copyWith(fontSize: 14),
              ),
              const SizedBox(height: 24),

              // ✅ Step Indicator
              Row(
                children: [
                  Transform.translate(
                    offset: const Offset(-12, 0),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: const Icon(Icons.arrow_back_ios_new),
                      onPressed: widget.onBack,
                    ),
                  ),
                  const SizedBox(width: 2),
                  _buildStepIndicator(true, '1'),
                  _buildStepLine(true),
                  _buildStepIndicator(true, '2'),
                  _buildStepLine(false),
                  _buildStepIndicator(false, '3'),
                ],
              ),
              const SizedBox(height: 24),

              // ✅ Dynamic Chips Component
              Expanded(
                child: SingleChildScrollView(
                  child: CustomChip(
                    selectedItems: selectedStrengths,
                    onItemAdded: _addStrength,
                    onItemRemoved: _removeStrength,
                    suggestedItems: suggestedStrengths,
                    hintText: 'Ketik kelebihanmu atau pilih dari saran',
                    showTextField: true,
                    maxItems: 10,
                  ),
                ),
              ),

              const SizedBox(height: 16),
              CustomFilledButton(
                title: 'Selanjutnya',
                variant: ButtonColorVariant.blue,
                onPressed: selectedStrengths.isEmpty ? null : widget.onNext,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepIndicator(bool isActive, String number) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: isActive ? bluePrimaryColor : const Color(0xFFE5E5E5),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          number,
          style: TextStyle(
            color: isActive ? whiteColor : Colors.grey,
            fontWeight: semiBold,
          ),
        ),
      ),
    );
  }

  Widget _buildStepLine(bool isActive) {
    return Expanded(
      child: Container(
        height: 8,
        color: isActive ? bluePrimaryColor : const Color(0xFFE5E5E5),
      ),
    );
  }
}
