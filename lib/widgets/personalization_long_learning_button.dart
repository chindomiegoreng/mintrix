import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mintrix/shared/theme.dart';

enum DurationOption {
  easy(duration: 5, title: '5 menit/hari', subtitle: 'Santai tapi asik'),
  moderate(duration: 10, title: '10 menit/hari', subtitle: 'Tambah kece'),
  hard(duration: 15, title: '15 menit/hari', subtitle: 'Jagoan'),
  extreme(duration: 30, title: '30 menit/hari', subtitle: 'Super duper keren');

  final int duration;
  final String title;
  final String subtitle;

  const DurationOption({
    required this.duration,
    required this.title,
    required this.subtitle,
  });
}

class CustomDurationSelector extends StatefulWidget {
  final DurationOption? selectedOption;
  final Function(DurationOption) onSelected;

  const CustomDurationSelector({
    super.key,
    this.selectedOption,
    required this.onSelected,
  });

  @override
  State<CustomDurationSelector> createState() => _CustomDurationSelectorState();
}

class _CustomDurationSelectorState extends State<CustomDurationSelector> {
  DurationOption? _selectedOption;

  @override
  void initState() {
    super.initState();
    _selectedOption = widget.selectedOption;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: DurationOption.values.map((option) {
        final isSelected = _selectedOption == option;

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: GestureDetector(
            onTap: () {
              setState(() {
                _selectedOption = option;
              });
              widget.onSelected(option);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isSelected ? bluePrimaryColor : thirdColor,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isSelected
                        ? bluePrimaryColor
                        : const Color(0xFFE5E5E5),
                    offset: const Offset(0, 4),
                    blurRadius: 0,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/personalization_long_learning.svg',
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          option.title,
                          style: primaryTextStyle.copyWith(
                            fontSize: 16,
                            fontWeight: semiBold,
                            color: isSelected ? primaryColor : primaryColor,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          option.subtitle,
                          style: secondaryTextStyle.copyWith(
                            fontSize: 16,
                            fontWeight: semiBold,
                            color: isSelected
                                ? bluePrimaryColor
                                : secondaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// // usage

// CustomDurationSelector(
//   selectedOption: DurationOption.moderate,
//   onSelected: (option) {
//     print('Selected: ${option.title}');
//     print('Duration: ${option.duration} minutes');
//   },
// )
