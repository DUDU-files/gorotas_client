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
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'MENU',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
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
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: AppColors.lightGray, width: 2),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _showQRCode = true;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: _showQRCode
                                    ? AppColors.primaryOrange
                                    : Colors.transparent,
                                width: 3,
                              ),
                            ),
                          ),
                          child: Text(
                            'QR Code',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: _showQRCode
                                  ? AppColors.primaryOrange
                                  : AppColors.primaryGray,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _showQRCode = false;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: !_showQRCode
                                    ? AppColors.primaryOrange
                                    : Colors.transparent,
                                width: 3,
                              ),
                            ),
                          ),
                          child: Text(
                            'Chave Pix',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: !_showQRCode
                                  ? AppColors.primaryOrange
                                  : AppColors.primaryGray,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Conteúdo: QR Code
              if (_showQRCode)
                Column(
                  children: [
                    const Text(
                      'Escaneie o QR Code com seu banco',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.primaryGray,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // QR Code Placeholder
                    Container(
                      width: 250,
                      height: 250,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.lightGray,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        color: AppColors.backgroudGray,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.qr_code_2,
                          size: 100,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    const Text(
                      'Informações da Transferência',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Dados da transferência
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.backgroudGray,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.lightGray),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Beneficiário:',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.primaryGray,
                                ),
                              ),
                              const Text(
                                'GoRotas Transportes',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.black,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Chave Pix:',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.primaryGray,
                                ),
                              ),
                              const Text(
                                'contato@gorotas.com.br',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryBlue,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              else
                // Conteúdo: Chave Pix
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Cole a chave Pix para fazer a transferência',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.primaryGray,
                      ),
                    ),
                    const SizedBox(height: 16),

                    const Text(
                      'Chave Pix',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryGray,
                      ),
                    ),
                    const SizedBox(height: 8),
                    AppTextField(
                      hintText: 'contato@gorotas.com.br',
                      controller: _pixKeyController,
                    ),
                    const SizedBox(height: 24),

                    // Informações adicionais
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.secondaryBlue,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.lightGray),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Dados da transferência',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.black,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Beneficiário:',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.primaryGray,
                                ),
                              ),
                              const Text(
                                'GoRotas Transportes',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.black,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'CNPJ:',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.primaryGray,
                                ),
                              ),
                              const Text(
                                '12.345.678/0001-00',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

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
