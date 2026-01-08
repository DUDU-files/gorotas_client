import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vans/colors/app_colors.dart';
import 'package:vans/providers/navigation_provider.dart';

class RatingContent extends StatefulWidget {
  final Map<String, dynamic> data;

  const RatingContent({super.key, required this.data});

  @override
  State<RatingContent> createState() => _RatingContentState();
}

class _RatingContentState extends State<RatingContent> {
  int _rating = 0;
  final TextEditingController _feedbackController = TextEditingController();

  void _setRating(int rating) {
    setState(() {
      _rating = rating;
    });
  }

  void _submitRating() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Obrigado! Você avaliou com $_rating estrela(s).'),
      ),
    );
    Future.delayed(const Duration(seconds: 1), () {
      final navProvider = Provider.of<NavigationProvider>(
        context,
        listen: false,
      );
      navProvider.goBack();
    });
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryBlue,
      child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppColors.secondaryBlue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 40,
                        height: 40,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.directions_bus,
                            size: 32,
                            color: AppColors.primaryBlue,
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Título
                  const Text(
                    'GoRotas',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Mensagem de sucesso
                  const Text(
                    'Viagem concluída com sucesso!',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Estrelas interativas
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return GestureDetector(
                        onTap: () => _setRating(index + 1),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Icon(
                            index < _rating ? Icons.star : Icons.star_outline,
                            color: AppColors.starFilled,
                            size: 40,
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 24),

                  // Texto de feedback
                  const Text(
                    'Deixe sugestões, elogios ou críticas para nós: (opcional)',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.primaryGray,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Campo de feedback
                  TextField(
                    controller: _feedbackController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Escreva sua sugestão aqui',
                      hintStyle: const TextStyle(
                        color: AppColors.lightGray,
                        fontSize: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppColors.backgroudGray,
                        ),
                      ),
                      contentPadding: const EdgeInsets.all(12),
                      filled: true,
                      fillColor: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Botão de enviar
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submitRating,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryOrange,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Enviar',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
