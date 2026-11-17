import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../theme/app_theme.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  final AuthController _authController = Get.put(AuthController());

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _fillCredentials() {
    _usernameController.text = '124240002';
    _passwordController.text = '123';
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      _authController.login(
        _usernameController.text,
        _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Brand / Logo Icon
                    Center(
                      child: Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppTheme.primaryRed, AppTheme.accentRed],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryRed.withAlpha(102),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.local_movies_rounded,
                          size: 48,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Title
                    const Text(
                      'NontonSkuy!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textWhite,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Streaming TV Shows & Serial Favoritmu',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.textMuted,
                      ),
                    ),
                    const SizedBox(height: 36),

                    // Input Username (NIM)
                    TextFormField(
                      controller: _usernameController,
                      keyboardType: TextInputType.text,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Username (NIM)',
                        hintText: '124240002',
                        prefixIcon: Icon(Icons.person_outline_rounded),
                      ),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Username (NIM) wajib diisi';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 18),

                    // Input Password
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: '123',
                        prefixIcon: const Icon(Icons.lock_outline_rounded),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Password wajib diisi';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 28),

                    // Tombol Login
                    Obx(() {
                      final loading = _authController.isLoading.value;
                      return SizedBox(
                        height: 54,
                        child: ElevatedButton(
                          onPressed: loading ? null : _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryRed,
                            elevation: 8,
                            shadowColor: AppTheme.primaryRed.withAlpha(128),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: loading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : const Text(
                                  'Login',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                        ),
                      );
                    }),
                    const SizedBox(height: 24),

                    // Quick Credential Helper Pill
                    InkWell(
                      onTap: _fillCredentials,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceDark,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppTheme.cardBorder,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryRed.withAlpha(38),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.touch_app_outlined,
                                size: 18,
                                color: AppTheme.primaryRed,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Kredensial Login:',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  Text(
                                    'NIM: 124240002 • Password: 123 (Tap isi otomatis)',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: AppTheme.textMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
