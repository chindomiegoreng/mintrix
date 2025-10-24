import 'package:flutter/material.dart';
import 'package:mintrix/shared/theme.dart';

class CustomChip extends StatefulWidget {
  const CustomChip({super.key});

  @override
  State<CustomChip> createState() => _CustomChipState();
}

class _CustomChipState extends State<CustomChip> {
  List<String> chipData = [
    'Food',
    'Nature',
    'Tech',
    'Programming',
    'Fashion',
    'Cinematic',
    'Games',
    'AI',
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        spacing: 6,
        runSpacing: 6,
        children: List.generate(
          chipData.length,
          (index) => GestureDetector(
            onTap: () {},
            child: Chip(
              onDeleted: () {
                setState(() {
                  chipData.removeAt(index);
                });
              },

              deleteIcon: Icon(Icons.close, size: 18, color: whiteColor),
              labelStyle: primaryTextStyle.copyWith(
                fontWeight: medium,
                fontSize: 14,
              ),
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(30),
              ),
              label: Text(
                chipData[index],
                style: whiteTextStyle.copyWith(
                  fontWeight: medium,
                  fontSize: 14,
                ),
              ),
              backgroundColor: bluePrimaryColor,
            ),
          ),
        ),
      ),
    );
  }
}
