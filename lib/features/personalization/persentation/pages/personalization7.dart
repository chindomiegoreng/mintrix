import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mintrix/shared/theme.dart';
import 'package:mintrix/widgets/buttons.dart';
import '../bloc/personalization_bloc.dart';
import '../bloc/personalization_event.dart';

class Personalization7 extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const Personalization7({
    super.key,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<Personalization7> createState() => _Personalization7State();
}

class _Personalization7State extends State<Personalization7> {
  final TextEditingController _storyController = TextEditingController();

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
              'Ceritakan tentang kepribadianmu biar kami bisa bikin petualangan terbaik yang super pas buat kamu.',
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
                _buildStepLine(true), 
                _buildStepIndicator(true, '3'),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE5E5E5)),
                ),
                child: TextField(
                  controller: _storyController,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  style: primaryTextStyle.copyWith(fontSize: 14),
                  decoration: InputDecoration(
                    hintText:
                        'Siapa, siapa ceritaz aku-aku ini karena mau, jajus, tapi belum menemukan bakat yang menonjol di ari saya, jadi sering sekali kepakaran!',
                    hintStyle: secondaryTextStyle.copyWith(fontSize: 14),
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    context.read<PersonalizationBloc>().add(UpdateStory(value));
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Dengan masuk ke Mintrix, anda setuju dengan Ketentuan dan Kebijakan Privasi kami',
              textAlign: TextAlign.center,
              style: secondaryTextStyle.copyWith(fontSize: 12),
            ),
            const SizedBox(height: 16),
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
    _storyController.dispose();
    super.dispose();
  }
}
