import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vans/exports.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLogin = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, preencha todos os campos'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final userProvider = Provider.of<UserProvider>(context, listen: false);

    String? error = await userProvider.login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: Colors.red),
      );
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlue,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo e Título
                const AppLogo(size: 100),
                const SizedBox(height: 40),

                // Card de Login/Cadastro
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.backgroudGray,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Abas Entrar/Cadastrar
                      AuthTabs(
                        isLoginSelected: _isLogin,
                        onLoginTap: () {
                          setState(() {
                            _isLogin = true;
                          });
                        },
                        onRegisterTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 24),

                      // Título da seção
                      const Text(
                        'Acesse sua conta',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Email Input
                      AppTextField(
                        label: 'E-mail',
                        hintText: 'seu@gmail.com',
                        controller: _emailController,
                        prefixIcon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),

                      // Password Input
                      AppTextField(
                        label: 'Senha',
                        hintText: '••••••••',
                        controller: _passwordController,
                        prefixIcon: Icons.lock_outline,
                        isPassword: true,
                      ),
                      const SizedBox(height: 24),

                      // Botão Entrar
                      Consumer<UserProvider>(
                        builder: (context, userProvider, child) {
                          return ConfirmationButton(
                            label: userProvider.isLoading
                                ? 'Entrando...'
                                : 'Entrar',
                            onPressed: userProvider.isLoading
                                ? null
                                : _handleLogin,
                          );
                        },
                      ),
                      const SizedBox(height: 16),

                      // Link "Esqueceu a senha?"
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ForgotPasswordScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            'Esqueceu a senha?',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.primaryBlue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
