import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mintrix/shared/theme.dart';
import 'package:mintrix/core/models/duration_option_model.dart';

class CustomDurationSelector extends StatefulWidget {
  final List<DurationOptionModel> options; // ✅ Terima list dari luar
  final DurationOptionModel? selectedOption;
  final Function(DurationOptionModel) onSelected;
  final bool isLoading;

  const CustomDurationSelector({
    super.key,
    required this.options, // ✅ Required list options
    this.selectedOption,
    required this.onSelected,
    this.isLoading = false,
  });

  @override
  State<CustomDurationSelector> createState() => _CustomDurationSelectorState();
}

class _CustomDurationSelectorState extends State<CustomDurationSelector> {
  DurationOptionModel? _selectedOption;

  @override
  void initState() {
    super.initState();
    _selectedOption = widget.selectedOption;
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Show loading indicator
    if (widget.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // ✅ Show empty state
    if (widget.options.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Tidak ada pilihan waktu belajar',
              style: secondaryTextStyle.copyWith(fontSize: 16),
            ),
          ],
        ),
      );
    }

    return Column(
      children: widget.options.map((option) {
        final isSelected = _selectedOption?.id == option.id;

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
                  // ✅ Dynamic icon (bisa dari API atau default)
                  option.icon != null && option.icon!.isNotEmpty
                      ? Image.network(
                          option.icon!,
                          width: 40,
                          height: 40,
                          errorBuilder: (context, error, stackTrace) {
                            return SvgPicture.asset(
                              'assets/icons/personalization_long_learning.svg',
                              width: 40,
                              height: 40,
                            );
                          },
                        )
                      : SvgPicture.asset(
                          'assets/icons/personalization_long_learning.svg',
                          width: 40,
                          height: 40,
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
                            color: primaryColor,
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
//   options: [
//     DurationOptionModel(
//       id: 1,
//       title: '5 menit/hari',
//       subtitle: 'Santai tapi asik',
//       duration: 5,
//       icon: 'assets/icons/option1.svg',
//     ),
//     DurationOptionModel(
//       id: 2,
//       title: '10 menit/hari',
//       subtitle: 'Tambah kece',
//       duration: 10,
//       icon: 'assets/icons/option2.svg',
//     ),
//     DurationOptionModel(
//       id: 3,
//       title: '15 menit/hari',
//       subtitle: 'Jagoan',
//       duration: 15,
//       icon: 'assets/icons/option3.svg',
//     ),
//     DurationOptionModel(
//       id: 4,
//       title: '30 menit/hari',
//       subtitle: 'Super duper keren',
//       duration: 30,
//       icon: 'assets/icons/option4.svg',
//     ),
//   ],
//   selectedOption: DurationOptionModel(
//     id: 2,
//     title: '10 menit/hari',
//     subtitle: 'Tambah kece',
//     duration: 10,
//     icon: 'assets/icons/option2.svg',
//   ),
//   onSelected: (option) {
//     print('Selected: ${option.title}');
//     print('Duration: ${option.duration} minutes');
//   },
//   isLoading: false,
// )
