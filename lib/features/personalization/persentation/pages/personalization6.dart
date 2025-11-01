import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mintrix/shared/theme.dart';
import 'package:mintrix/widgets/buttons.dart';
import 'package:mintrix/widgets/form.dart';
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
  final TextEditingController _strengthController = TextEditingController();
  List<String> selectedStrengths = [];

  void _addStrength(String value) {
    if (value.trim().isNotEmpty) {
      setState(() {
        selectedStrengths.add(value.trim());
        _strengthController.clear();
      });
      context.read<PersonalizationBloc>().add(
            UpdateStrengths(selectedStrengths),
          );
    }
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
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Kenali Kelebihanmu!',
              style: primaryTextStyle.copyWith(fontSize: 24, fontWeight: bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Tulis atau tambahkan hal-hal yang menurutmu menjadi kekuatanmu. '
              'Kami akan bantu menyesuaikan petualangan karakter sesuai dirimu!',
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
                _buildStepLine(true), 
                _buildStepIndicator(true, '2'), 
                _buildStepLine(false),
                _buildStepIndicator(false, '3'),
              ],
            ),
            const SizedBox(height: 24),
            CustomFormField(
              title: 'Kreatif',
              isShowTitle: false,
              hintText: 'Kreatif',
              controller: _strengthController,
              onFieldSubmitted: _addStrength,
            ),
            const SizedBox(height: 16),
            if (selectedStrengths.isNotEmpty) ...[
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: selectedStrengths.map((strength) {
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
                          strength,
                          style: TextStyle(
                            color: whiteColor,
                            fontSize: 14,
                            fontWeight: medium,
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () => _removeStrength(strength),
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
    _strengthController.dispose();
    super.dispose();
  }
}