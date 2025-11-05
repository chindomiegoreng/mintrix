import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mintrix/shared/theme.dart';
import 'package:mintrix/widgets/buttons.dart';
import 'package:mintrix/widgets/form.dart';
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
  final TextEditingController _weaknessController = TextEditingController();
  List<String> selectedWeaknesses = [];

  void _addWeakness(String value) {
    if (value.trim().isNotEmpty) {
      setState(() {
        selectedWeaknesses.add(value.trim());
        _weaknessController.clear();
      });
      context.read<PersonalizationBloc>().add(
        UpdateWeaknesses(selectedWeaknesses),
      );
    }
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
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Satu Langkah Lebih Dekat',
              style: primaryTextStyle.copyWith(fontSize: 24, fontWeight: bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Berikan kekuranganmu biar kami bisa bikin petualangan karakter yang super pas buat kamu.',
              style: secondaryTextStyle.copyWith(fontSize: 14),
            ),
            const SizedBox(height: 24),
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
            CustomFormField(
              title: 'Malas',
              isShowTitle: false,
              hintText: 'Malas',
              controller: _weaknessController,
              onFieldSubmitted: _addWeakness,
            ),
            const SizedBox(height: 16),
            if (selectedWeaknesses.isNotEmpty) ...[
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: selectedWeaknesses.map((weakness) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: bluePrimaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          weakness,
                          style: TextStyle(
                            color: whiteColor,
                            fontSize: 14,
                            fontWeight: medium,
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () => _removeWeakness(weakness),
                          child: Icon(Icons.close, color: whiteColor, size: 16),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
            ],
            const Spacer(),
            CustomFilledButton(
              title: 'Selanjutnya',
              variant: ButtonColorVariant.blue,
              onPressed: widget.onNext,
            ),
            const SizedBox(height: 16),
          ],
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

  @override
  void dispose() {
    _weaknessController.dispose();
    super.dispose();
  }
}
