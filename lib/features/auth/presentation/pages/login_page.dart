import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mintrix/shared/theme.dart';
import 'package:mintrix/widgets/buttons.dart';
import 'package:mintrix/widgets/form.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'Masuk',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 26),
        ),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const Center(child: CircularProgressIndicator()),
            );
          } else if (state is AuthAuthenticated) {
            Navigator.pop(context);
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/main',
              (route) => false,
            );
          } else if (state is AuthError) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  CustomFormField(
                    title: 'Emailmu',
                    controller: _usernameController,
                    hintText: 'Masukkan email kamu',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email pengguna tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomFormField(
                    title: 'Kata Sandi',
                    type: FormFieldType.password,
                    controller: _passwordController,
                    hintText: 'Masukkan kata sandi',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Kata sandi tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  CustomFilledButton(
                    title: 'Masuk Sekarang',
                    variant: ButtonColorVariant.blue,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<AuthBloc>().add(
                          LoginEvent(
                            username: _usernameController.text,
                            password: _passwordController.text,
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 18),
                  CustomFilledButton(
                    title: 'Daftar Yuk',
                    variant: ButtonColorVariant.white,
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/register');
                    },
                    withShadow: true,
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        'Lupa Kata Sandimu?',
                        style: primaryTextStyle.copyWith(
                          fontSize: 14,
                          fontWeight: semiBold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(child: Divider(color: Colors.grey[300])),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'atau',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                      Expanded(child: Divider(color: Colors.grey[300])),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // ✅ GOOGLE SIGN IN BUTTON
                  CustomFilledButton(
                    title: 'Masuk dengan Google',
                    variant: ButtonColorVariant.white,
                    withShadow: true,
                    icon: Image.asset(
                      'assets/icons/logo_google.png',
                      width: 20,
                      height: 20,
                    ),
                    onPressed: () {
                      // ✅ Trigger Google Sign In
                      context.read<AuthBloc>().add(GoogleSignInEvent());
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
