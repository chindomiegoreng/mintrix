import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mintrix/widgets/buttons.dart';
import 'package:mintrix/widgets/form.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'Daftar Akun',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is AuthAuthenticated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Registrasi berhasil! Silakan login.'),
              ),
            );
            Navigator.pushReplacementNamed(context, '/login');
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomFormField(
                title: 'Nama Kerenmu',
                type: FormFieldType.text,
                controller: _usernameController,
                hintText: 'Masukkan nama kerenmu',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Kata sandi tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
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

              // 🔹 Tombol Register
              CustomFilledButton(
                title: 'Gabung Sekarang',
                variant: ButtonColorVariant.blue,
                onPressed: () {
                  context.read<AuthBloc>().add(
                    RegisterEvent(
                      username: _usernameController.text.trim(),
                      email: _emailController.text.trim(),
                      password: _passwordController.text.trim(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),

              // 🔹 Tombol ke halaman login
              CustomFilledButton(
                title: 'Masuk Yuk',
                variant: ButtonColorVariant.white,
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
                withShadow: true,
              ),

              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey[300])),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'atau',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.grey[300])),
                ],
              ),
              const SizedBox(height: 20),

              // 🔹 Tombol Google Sign In
              CustomFilledButton(
                title: 'Masuk dengan Google',
                variant: ButtonColorVariant.white,
                icon: const FaIcon(
                  FontAwesomeIcons.google,
                  color: Colors.red,
                  size: 20,
                ),
                onPressed: () {
                },
                withShadow: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
