import 'package:flutter/material.dart';
import 'package:mintrix/shared/theme.dart';

enum FormFieldType { text, password }

class CustomFormField extends StatefulWidget {
  final String title;
  final FormFieldType type;
  final TextEditingController? controller;
  final bool isShowTitle;
  final TextInputType? keyboardType;
  final Function(String)? onFieldSubmitted;
  final String? hintText;
  final FormFieldValidator<String>? validator;
  final bool isTextArea;

  const CustomFormField({
    super.key,
    required this.title,
    this.type = FormFieldType.text,
    this.controller,
    this.isShowTitle = true,
    this.keyboardType,
    this.onFieldSubmitted,
    this.hintText,
    this.validator,
     this.isTextArea = false,
  });

  @override
  State<CustomFormField> createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {
  bool _isObscure = true;

  @override
  void initState() {
    super.initState();
    _isObscure = widget.type == FormFieldType.password;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.isShowTitle)
          Text(
            widget.title,
            style: primaryTextStyle.copyWith(
              fontWeight: semiBold,
              fontSize: 16,
            ),
          ),
        if (widget.isShowTitle) const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(56),
            boxShadow: const [
              BoxShadow(
                color: Color(0xFFE5E5E5),
                offset: Offset(0, 4),
                blurRadius: 0,
                spreadRadius: 0,
              ),
            ],
          ),
          child: TextFormField(
            obscureText: _isObscure,
            controller: widget.controller,
            keyboardType: widget.keyboardType,
            validator: widget.validator,
            onFieldSubmitted: widget.onFieldSubmitted,
            style: primaryTextStyle.copyWith(
              fontSize: 16,
              fontWeight: semiBold,
            ),
            textAlign: TextAlign.left,
            decoration: InputDecoration(
              hintText:
                  widget.hintText ??
                  (!widget.isShowTitle ? widget.title : null),
              hintStyle: secondaryTextStyle.copyWith(fontSize: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(56),
                // borderSide: BorderSide.none,
                borderSide: BorderSide(color: thirdColor, width: 2),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(56),
                // borderSide: BorderSide.none,
                borderSide: BorderSide(color: thirdColor, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(56),
                borderSide: BorderSide(color: bluePrimaryColor, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(56),
                borderSide: BorderSide(color: redColor, width: 2),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(56),
                borderSide: BorderSide(color: redColor, width: 2),
              ),
              filled: true,
              fillColor: whiteColor,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              suffixIcon: widget.type == FormFieldType.password
                  ? IconButton(
                      icon: Icon(
                        _isObscure ? Icons.visibility_off : Icons.visibility,
                        color: secondaryColor,
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          _isObscure = !_isObscure;
                        });
                      },
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}

// // usage

// CustomFormField(
//   title: 'Email',
//   type: FormFieldType.text,
//   keyboardType: TextInputType.emailAddress,
//   controller: emailController,
// )

// // Password type dengan toggle visibility
// CustomFormField(
//   title: 'Password',
//   type: FormFieldType.password,
//   controller: passwordController,
//   validator: (value) {
//     if (value == null || value.isEmpty) {
//       return 'Password tidak boleh kosong';
//     }
//     return null;
//   },
// )

// // Tanpa title
// CustomFormField(
//   title: 'Email',
//   isShowTitle: false,
//   hintText: 'Masukkan email anda',
// )
