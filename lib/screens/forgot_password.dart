import 'package:flutter/material.dart';
import 'package:vans/colors/app_colors.dart';
import 'package:vans/widgets/app_text_field.dart';
import 'package:vans/widgets/app_logo.dart';
import 'package:vans/widgets/confirmation_button.dart';
import 'package:vans/widgets/success_modal.dart';
import 'package:vans/screens/login.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _showSuccessModal(BuildContext context) {
    SuccessModal.show(
      context,
      description: 'Solicitação de recuperação enviada.',
      buttonLabel: 'Voltar para o Login',
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
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo e título - centralizado
                const AppLogo(),

                const SizedBox(height: 40),

                // Card principal - centralizado e compacto
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryBlue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Título
                      const Text(
                        'Recuperar Senha',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Subtítulo
                      const Text(
                        'Digite o e-mail cadastrado',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.primaryGray,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Campo de e-mail
                      AppTextField(
                        hintText: 'seu@email.com',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                      ),

                      const SizedBox(height: 20),

                      // Botão Solicitar
                      SizedBox(
                        width: double.infinity,
                        child: ConfirmationButton(
                          label: 'Solicitar',
                          onPressed: () {
                            if (_emailController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Por favor, digite seu e-mail'),
                                ),
                              );
                            } else {
                              _showSuccessModal(context);
                            }
                          },
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Botão Retornar
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Retornar',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
