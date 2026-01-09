import 'package:flutter/material.dart';
import 'package:vans/exports.dart';

class QRCodeSection extends StatelessWidget {
  final String beneficiary;
  final String pixKey;

  const QRCodeSection({
    super.key,
    this.beneficiary = 'GoRotas Transportes',
    this.pixKey = 'contato@gorotas.com.br',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Escaneie o QR Code com seu banco',
          style: TextStyle(fontSize: 13, color: AppColors.primaryGray),
        ),
        const SizedBox(height: 20),

        // QR Code Placeholder
        Container(
          width: 250,
          height: 250,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.lightGray, width: 2),
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
                  Text(
                    beneficiary,
                    style: const TextStyle(
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
                  Text(
                    pixKey,
                    style: const TextStyle(
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
    );
  }
}
