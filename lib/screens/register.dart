import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vans/colors/app_colors.dart';
import 'package:vans/widgets/app_text_field.dart';
import 'package:vans/widgets/app_logo.dart';
import 'package:vans/widgets/confirmation_button.dart';
import 'package:vans/widgets/success_modal.dart';
import 'package:vans/screens/login.dart';
import 'package:vans/providers/user_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _cpfController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _cpfController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    // Validação básica
    if (_nameController.text.isEmpty ||
        _cpfController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, preencha todos os campos'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final userProvider = Provider.of<UserProvider>(context, listen: false);

    String? error = await userProvider.register(
      name: _nameController.text.trim(),
      cpf: _cpfController.text.trim(),
      phone: _phoneController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: Colors.red),
      );
    } else {
      _showSuccessModal(context);
    }
  }

  void _showSuccessModal(BuildContext context) {
    SuccessModal.show(
      context,
      description: 'Cadastro realizado com sucesso.',
      buttonLabel: 'Prosseguir para o Login',
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      },
    );
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

                // Card de Cadastro
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.backgroudGray,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Título da seção
                      const Text(
                        'Realizar Cadastro',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Nome Completo Input
                      AppTextField(
                        label: 'Nome Completo',
                        hintText: 'Seu nome completo',
                        controller: _nameController,
                        prefixIcon: Icons.person_outline,
                      ),
                      const SizedBox(height: 16),

                      // CPF Input
                      AppTextField(
                        label: 'CPF',
                        hintText: '000.000.000-00',
                        controller: _cpfController,
                        prefixIcon: Icons.badge_outlined,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),

                      // Telefone Input
                      AppTextField(
                        label: 'Telefone',
                        hintText: '(99) 99999-9999',
                        controller: _phoneController,
                        prefixIcon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 16),

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

                      // Botão Cadastrar
                      Consumer<UserProvider>(
                        builder: (context, userProvider, child) {
                          return ConfirmationButton(
                            label: userProvider.isLoading
                                ? 'Cadastrando...'
                                : 'Cadastrar',
                            onPressed: userProvider.isLoading
                                ? null
                                : _handleRegister,
                          );
                        },
                      ),
                      const SizedBox(height: 16),

                      // Link para ir para login
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Já tem uma conta? Entrar',
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
