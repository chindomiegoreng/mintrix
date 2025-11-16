import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mintrix/shared/theme.dart';
import 'package:mintrix/widgets/buttons.dart';
import 'package:mintrix/widgets/personalization_chips.dart';
import '../bloc/personalization_bloc.dart';
import '../bloc/personalization_event.dart';

class Personalization5 extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const Personalization5({
    super.key,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<Personalization5> createState() => _Personalization5State();
}

class _Personalization5State extends State<Personalization5> {
  List<String> selectedWeaknesses = [];

  // ✅ Suggested weaknesses (bisa dari API nanti)
  final List<String> suggestedWeaknesses = [
    'Malas',
    'Cuek',
    'Pemalas',
    'Ceroboh',
    'Cemas',
    'Pemalu',
    'Mudah Menyerah',
    'Terlalu Perfeksionis',
    'Sulit Fokus',
    'Mudah Tersinggung',
  ];

  void _addWeakness(String value) {
    setState(() {
      if (!selectedWeaknesses.contains(value)) {
        selectedWeaknesses.add(value);
      }
    });
    context.read<PersonalizationBloc>().add(
      UpdateWeaknesses(selectedWeaknesses),
    );
  }

  void _removeWeakness(String weakness) {
    setState(() {
      selectedWeaknesses.remove(weakness);
    });
    context.read<PersonalizationBloc>().add(
      UpdateWeaknesses(selectedWeaknesses),
    );
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
                'Satu Langkah Lebih Dekat',
                style: primaryTextStyle.copyWith(
                  fontSize: 24,
                  fontWeight: bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Berikan kekuranganmu biar kami bisa bikin petualangan karakter yang super pas buat kamu.',
                style: secondaryTextStyle.copyWith(fontSize: 14),
              ),
              const SizedBox(height: 24),

              // ✅ Step Indicator with Back Button
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
                  _buildStepLine(false),
                  _buildStepIndicator(false, '2'),
                  _buildStepLine(false),
                  _buildStepIndicator(false, '3'),
                ],
              ),
              const SizedBox(height: 24),

              // ✅ Dynamic Chips Component
              Expanded(
                child: SingleChildScrollView(
                  child: CustomChip(
                    selectedItems: selectedWeaknesses,
                    onItemAdded: _addWeakness,
                    onItemRemoved: _removeWeakness,
                    suggestedItems: suggestedWeaknesses,
                    hintText: 'Ketik kekuranganmu atau pilih dari saran',
                    showTextField: true,
                    maxItems: 10, // ✅ Limit maksimal 10 items
                  ),
                ),
              ),

              const SizedBox(height: 16),
              CustomFilledButton(
                title: 'Selanjutnya',
                variant: ButtonColorVariant.blue,
                onPressed: selectedWeaknesses.isEmpty
                    ? null
                    : widget.onNext, // ✅ Disable jika belum ada yang dipilih
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
