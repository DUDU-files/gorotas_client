import 'package:flutter/material.dart';
import 'package:vans/exports.dart';

class AddPixScreen extends StatefulWidget {
  const AddPixScreen({super.key});

  @override
  State<AddPixScreen> createState() => _AddPixScreenState();
}

class _AddPixScreenState extends State<AddPixScreen> {
  final TextEditingController _pixKeyController = TextEditingController();
  bool _showQRCode = true;

  @override
  void dispose() {
    _pixKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const ScreenAppBar(title: 'MENU'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título
              const Text(
                'Adicionar Saldo via Pix',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 20),

              // Abas: QR Code / Chave Pix
              TabSelector(
                tabs: const ['QR Code', 'Chave Pix'],
                selectedIndex: _showQRCode ? 0 : 1,
                onTabSelected: (index) {
                  setState(() {
                    _showQRCode = index == 0;
                  });
                },
              ),
              const SizedBox(height: 24),

              // Conteúdo: QR Code
              if (_showQRCode)
                const QRCodeSection()
              else
                // Conteúdo: Chave Pix
                PixKeySection(controller: _pixKeyController),

              const SizedBox(height: 32),

              // Botões de Cancelar e Confirmar
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ConfirmationButton(
                      label: 'Confirmar',
                      onPressed: () {
                        if (_showQRCode) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'QR Code copiado para a área de transferência',
                              ),
                            ),
                          );
                          Future.delayed(const Duration(seconds: 1), () {
                            Navigator.pop(context);
                          });
                        } else {
                          if (_pixKeyController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Por favor, cole a chave Pix'),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Chave Pix copiada! Use seu banco para transferir',
                                ),
                              ),
                            );
                            Future.delayed(const Duration(seconds: 1), () {
                              Navigator.pop(context);
                            });
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
