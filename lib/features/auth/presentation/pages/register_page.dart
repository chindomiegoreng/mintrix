import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:mintrix/shared/theme.dart';
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
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  File? _profileImage;
  bool _isLoading = false;
  final Dio _dio = Dio();

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (picked != null) {
        final file = File(picked.path);

        // Verify file exists and has size
        if (await file.exists()) {
          final fileSize = await file.length();
          print('📷 Image picked: ${file.path}, Size: ${fileSize} bytes');

          setState(() {
            _profileImage = file;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Foto profil berhasil dipilih (${(fileSize / 1024).toStringAsFixed(1)} KB)',
              ),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        } else {
          throw Exception('File gambar tidak ditemukan');
        }
      }
    } catch (e) {
      print('❌ Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memilih foto: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _handleRegister() async {
    // Validasi form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Validasi foto profil
    if (_profileImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih foto profil terlebih dahulu'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Prepare form data
      FormData formData = FormData.fromMap({
        'nama': _namaController.text.trim(),
        'email': _emailController.text.trim(),
        'password': _passwordController.text.trim(),
        'foto': await MultipartFile.fromFile(
          _profileImage!.path,
          filename: 'profile.jpg',
        ),
      });

      // Debug print
      print('🚀 Sending registration data to API...');
      print('  - Nama: ${_namaController.text.trim()}');
      print('  - Email: ${_emailController.text.trim()}');
      print('  - Foto: ${_profileImage!.path}');

      // Make API call
      final response = await _dio.post(
        'https://mintrix.yogawanadityapratama.com/api/auth/register',
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );

      print('✅ Registration successful: ${response.data}');

      // Handle success response
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;
        final user = responseData['user'];
        final token = responseData['token'];

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Selamat datang, ${user['nama']}! 🎉'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );

        // Store token if needed (you can use SharedPreferences or secure storage)
        print('🔑 Token: $token');

        // Navigate to personalization
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/personalization',
            (route) => false,
          );
        });
      }
    } on DioException catch (e) {
      print('❌ Dio error: ${e.message}');
      String errorMessage = 'Terjadi kesalahan saat mendaftar';

      if (e.response != null) {
        print('❌ Response data: ${e.response!.data}');
        print('❌ Status code: ${e.response!.statusCode}');

        // Handle specific error responses
        if (e.response!.data is Map && e.response!.data['message'] != null) {
          errorMessage = e.response!.data['message'];
        } else if (e.response!.statusCode == 400) {
          errorMessage = 'Data yang dikirim tidak valid';
        } else if (e.response!.statusCode == 409) {
          errorMessage = 'Email sudah terdaftar';
        } else if (e.response!.statusCode == 500) {
          errorMessage = 'Server sedang bermasalah, coba lagi nanti';
        }
      } else if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage = 'Koneksi timeout, periksa internet Anda';
      } else if (e.type == DioExceptionType.receiveTimeout) {
        errorMessage = 'Server tidak merespons, coba lagi nanti';
      } else if (e.type == DioExceptionType.unknown) {
        errorMessage = 'Periksa koneksi internet Anda';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      print('❌ Unexpected error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Terjadi kesalahan yang tidak terduga'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Daftar Akun',
          style: primaryTextStyle.copyWith(fontSize: 26, fontWeight: bold),
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
            Navigator.pop(context); // Close loading dialog
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/main',
              (route) => false,
            );
          } else if (state is AuthError) {
            Navigator.pop(context); // Close loading dialog
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Stack(
          children: [
            IgnorePointer(
              ignoring: _isLoading,
              child: Opacity(
                opacity: _isLoading ? 0.6 : 1.0,
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Profile Image Picker
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF81D4FA), Color(0xFF4FC3F7)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(3),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: CircleAvatar(
                                  radius: 55,
                                  backgroundColor: Colors.grey[200],
                                  backgroundImage: _profileImage != null
                                      ? FileImage(_profileImage!)
                                      : null,
                                  child: _profileImage == null
                                      ? const Icon(
                                          Icons.person,
                                          size: 60,
                                          color: Colors.grey,
                                        )
                                      : null,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 12,
                              child: InkWell(
                                onTap: _isLoading ? null : _pickImage,
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: _isLoading
                                        ? Colors.grey
                                        : const Color(0xFF4FC3F7),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),

                        // Username Field
                        CustomFormField(
                          title: 'Nama Kerenmu',
                          type: FormFieldType.text,
                          controller:
                              _namaController, // Changed from _usernameController
                          hintText: 'Masukkan nama kerenmu',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Nama tidak boleh kosong';
                            }
                            if (value.length < 3) {
                              return 'Nama minimal 3 karakter';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Email Field
                        CustomFormField(
                          title: 'Emailmu',
                          controller: _emailController,
                          hintText: 'Masukkan email kamu',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email tidak boleh kosong';
                            }
                            if (!RegExp(
                              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                            ).hasMatch(value)) {
                              return 'Format email tidak valid';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Password Field
                        CustomFormField(
                          title: 'Kata Sandi',
                          type: FormFieldType.password,
                          controller: _passwordController,
                          hintText: 'Minimal 6 karakter',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Kata sandi tidak boleh kosong';
                            }
                            if (value.length < 6) {
                              return 'Kata sandi minimal 6 karakter';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 26),

                        // Register Button
                        CustomFilledButton(
                          title: _isLoading ? 'Mendaftar...' : 'Gabung Sekarang',
                          variant: ButtonColorVariant.blue,
                          onPressed: _isLoading ? null : _handleRegister,
                        ),
                        const SizedBox(height: 18),

                        // Login Button
                        CustomFilledButton(
                          title: 'Masuk Yuk',
                          variant: ButtonColorVariant.white,
                          onPressed: _isLoading
                              ? null
                              : () {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    '/login',
                                  );
                                },
                          withShadow: true,
                        ),

                        const SizedBox(height: 24),

                        // Divider
                        Row(
                          children: [
                            Expanded(child: Divider(color: Colors.grey[300])),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                'atau',
                                style: secondaryTextStyle.copyWith(
                                  fontSize: 16,
                                  fontWeight: semiBold,
                                ),
                              ),
                            ),
                            Expanded(child: Divider(color: Colors.grey[300])),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Google Sign In Button
                        CustomFilledButton(
                          title: 'Daftar dengan Google',
                          variant: ButtonColorVariant.white,
                          icon: Image.asset(
                            'assets/icons/logo_google.png',
                            width: 20,
                            height: 20,
                          ),
                          onPressed: _isLoading
                              ? null
                              : () {
                                  context.read<AuthBloc>().add(GoogleSignInEvent());
                                },
                          withShadow: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Loading Overlay
            if (_isLoading)
              Container(
                color: Colors.black26,
                child: Center(
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text(
                            'Mendaftarkan akun...',
                            style: secondaryTextStyle.copyWith(
                              fontSize: 14,
                              fontWeight: semiBold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _namaController.dispose(); // Changed from _usernameController
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
