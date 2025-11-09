import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mintrix/shared/theme.dart';
import 'package:mintrix/widgets/buttons.dart';
import 'package:mintrix/widgets/personalization_long_learning_button.dart';
import '../bloc/personalization_bloc.dart';
import '../bloc/personalization_event.dart';
import '../bloc/personalization_state.dart';

class Personalization2 extends StatefulWidget {
  final VoidCallback onNext;

  const Personalization2({super.key, required this.onNext});

  @override
  State<Personalization2> createState() => _Personalization2State();
}

class _Personalization2State extends State<Personalization2> {
  @override
  void initState() {
    super.initState();
    // ✅ Load duration options saat page dibuka
    context.read<PersonalizationBloc>().add(LoadDurationOptions());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Row(
            children: [
              Image.asset(
                'assets/icons/icon_clock_personalization.png',
                width: 80,
                height: 80,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    'Pengen Belajar Berapa Lama Tiap Hari?',
                    style: primaryTextStyle.copyWith(
                      fontSize: 16,
                      fontWeight: bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // ✅ Use BlocBuilder to get dynamic options
          Expanded(
            child: BlocBuilder<PersonalizationBloc, PersonalizationState>(
              builder: (context, state) {
                if (state is PersonalizationStage1) {
                  return SingleChildScrollView(
                    child: CustomDurationSelector(
                      options: state.durationOptions, // ✅ Dynamic options
                      selectedOption: state.selectedDuration,
                      onSelected: (option) {
                        context.read<PersonalizationBloc>().add(
                          UpdateLearningDuration(option),
                        );
                      },
                    ),
                  );
                }

                // Default loading
                return const Center(child: CircularProgressIndicator());
              },
            ),
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
    );
  }
}
