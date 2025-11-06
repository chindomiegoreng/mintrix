import 'package:flutter/material.dart';
import 'package:mintrix/shared/theme.dart';

enum ButtonColorVariant { green, blue, white, secondary }

class CustomFilledButton extends StatelessWidget {
  final String title;
  final double height;
  final double width;
  final VoidCallback? onPressed;
  final ButtonColorVariant? variant;
  final Color? backgroundColor;
  final Color? shadowColor;
  final TextStyle? textStyle;
  final double borderRadius;
  final bool withShadow;
  final Widget? icon;

  const CustomFilledButton({
    super.key,
    required this.title,
    this.width = double.infinity,
    this.height = 46,
    this.onPressed,
    this.variant,
    this.backgroundColor,
    this.shadowColor,
    this.textStyle,
    this.borderRadius = 56,
    this.withShadow = true,
    this.icon, // 🔹 inisialisasi
  });

  Color _getBackgroundColor() {
    if (backgroundColor != null) return backgroundColor!;

    switch (variant) {
      case ButtonColorVariant.green:
        return greenColor;
      case ButtonColorVariant.blue:
        return bluePrimaryColor;
      case ButtonColorVariant.white:
        return whiteColor;
      case ButtonColorVariant.secondary:
        return secondaryColor;
      default:
        return bluePrimaryColor;
    }
  }

  Color _getShadowColor() {
    if (shadowColor != null) return shadowColor!;

    switch (variant) {
      case ButtonColorVariant.green:
        return const Color(0xFF1C8C3C);
      case ButtonColorVariant.blue:
        return const Color(0xFF3D94B5);
      case ButtonColorVariant.white:
        return const Color(0xFFE5E5E5);
      case ButtonColorVariant.secondary:
        return const Color(0xFF636363);
      default:
        return Colors.black.withAlpha(125);
    }
  }

  TextStyle _getTextStyle() {
    if (textStyle != null) return textStyle!;

    if (variant == ButtonColorVariant.white) {
      return primaryTextStyle.copyWith(fontSize: 16, fontWeight: semiBold);
    }

    return whiteTextStyle.copyWith(fontSize: 16, fontWeight: semiBold);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: withShadow
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              boxShadow: [
                BoxShadow(
                  color: _getShadowColor(),
                  offset: const Offset(0, 4),
                  blurRadius: 0,
                  spreadRadius: 0,
                ),
              ],
            )
          : null,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: _getBackgroundColor(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: variant == ButtonColorVariant.white
                ? const BorderSide(color: Colors.grey)
                : BorderSide.none,
          ),
          padding: EdgeInsets.zero,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              icon!,
              const SizedBox(width: 10),
            ],
            Text(title, style: _getTextStyle()),
          ],
        ),
      ),
    );
  }
}


// // usage

// // Menggunakan variant
// CustomFilledButton(
//   title: 'Button Green',
//   variant: ButtonColorVariant.green,
//   onPressed: () {},
// )

// // Menggunakan custom color (override variant)
// CustomFilledButton(
//   title: 'Custom Button',
//   backgroundColor: Colors.red,
//   shadowColor: Colors.red.shade700,
//   onPressed: () {},
// )

// // Tanpa shadow
// CustomFilledButton(
//   title: 'No Shadow',
//   variant: ButtonColorVariant.blue,
//   withShadow: false,
//   onPressed: () {},
// )
