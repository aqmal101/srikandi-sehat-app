import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:srikandi_sehat_app/provider/auth_provider.dart';
import 'package:srikandi_sehat_app/widgets/custom_alert.dart';
import 'package:srikandi_sehat_app/widgets/custom_button.dart';
import 'package:srikandi_sehat_app/widgets/custom_form.dart'; // Updated import

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;

  Future<void> _register() async {
    // Validate form first
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      final name = _nameController.text.trim();
      final email = _emailController.text.trim();
      final password = _passwordController.text;
      final confirmPassword = _confirmPasswordController.text;

      // Additional validation for password confirmation
      if (password != confirmPassword) {
        CustomAlert.show(
          context,
          'Password tidak cocok',
          type: AlertType.warning,
        );
        return;
      }

      final success =
          await authProvider.register(name, email, password, confirmPassword);

      if (success) {
        if (!mounted) return;
        CustomAlert.show(
          context,
          'Akun Berhasil dibuat!',
          type: AlertType.success,
        );
        await Future.delayed(const Duration(milliseconds: 750));
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        CustomAlert.show(
          context,
          authProvider.errorMessage,
          type: AlertType.error,
          duration: const Duration(milliseconds: 1500),
        );
      }
    } catch (e) {
      CustomAlert.show(
        context,
        'Terjadi kesalahan: ${e.toString()}',
        type: AlertType.error,
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'REGISTER',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                CircleAvatar(
                  radius: 80,
                  backgroundColor: Colors.pink[100],
                  child: Icon(
                    Icons.bloodtype_sharp,
                    size: 56,
                    color: Colors.pink[400],
                  ),
                ),
                const SizedBox(height: 20),

                // Name Field
                CustomFormField(
                  label: 'Nama Lengkap',
                  placeholder: 'Masukkan nama lengkap',
                  controller: _nameController,
                  type: CustomFormFieldType.text,
                  prefixIcon: Icons.person,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Nama tidak boleh kosong';
                    }
                    if (value.trim().length < 2) {
                      return 'Nama minimal 2 karakter';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Email Field
                CustomFormField(
                  label: 'Email',
                  placeholder: 'email@example.com',
                  controller: _emailController,
                  type: CustomFormFieldType.email,
                  prefixIcon: Icons.email,
                ),
                const SizedBox(height: 16),

                // Password Field
                CustomFormField(
                  label: 'Password',
                  placeholder: 'Masukkan password',
                  controller: _passwordController,
                  type: CustomFormFieldType.password,
                  prefixIcon: Icons.lock,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password tidak boleh kosong';
                    }
                    if (value.length < 6) {
                      return 'Password minimal 6 karakter';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Confirm Password Field
                CustomFormField(
                  label: 'Konfirmasi Password',
                  placeholder: 'Ulangi password',
                  controller: _confirmPasswordController,
                  type: CustomFormFieldType.password,
                  prefixIcon: Icons.lock_outline,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Konfirmasi password tidak boleh kosong';
                    }
                    if (value != _passwordController.text) {
                      return 'Password tidak cocok';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Register Button
                _isLoading
                    ? const SizedBox(
                        height: 50,
                        child: Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.pink),
                          ),
                        ),
                      )
                    : CustomButton(
                        label: 'REGISTER',
                        textSize: 16,
                        fullWidth: true,
                        isFullRounded: true,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        onPressed: _register,
                      ),
                const SizedBox(height: 20),

                // Login Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Sudah punya akun? ',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.pink,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
