import 'package:flutter/material.dart';
import 'package:mintrix/shared/theme.dart';

Widget buildInputCV(
  String label,
  TextEditingController controller, {
  String? hint,
  TextInputType keyboard = TextInputType.text,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: primaryTextStyle.copyWith(fontWeight: semiBold)),
      const SizedBox(height: 6),
      TextField(
        controller: controller,
        keyboardType: keyboard,
        decoration: baseDecoration(hint ?? label),
      ),
      const SizedBox(height: 16),
    ],
  );
}

Widget buildTextAreaCV(
  String label,
  TextEditingController controller, {
  String? hint,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: primaryTextStyle.copyWith(fontWeight: semiBold)),
      const SizedBox(height: 6),
      TextField(
        controller: controller,
        maxLines: 4,
        decoration: baseDecoration(hint ?? label),
      ),
      const SizedBox(height: 16),
    ],
  );
}

Widget buildDropdownCV({
  required String label,
  required String value,
  required List<String> items,
  required ValueChanged<String?> onChanged,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: primaryTextStyle.copyWith(fontWeight: semiBold)),
      const SizedBox(height: 6),
      DropdownButtonFormField(
        value: value,
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: onChanged,
        decoration: baseDecoration(""),
      ),
      const SizedBox(height: 16),
    ],
  );
}

InputDecoration baseDecoration(String hint) {
  return InputDecoration(
    hintText: hint,
    hintStyle: secondaryTextStyle,
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: thirdColor, width: 1.4),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: bluePrimaryColor, width: 2),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  );
}
