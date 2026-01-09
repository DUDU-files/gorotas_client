import 'package:flutter/material.dart';
import 'package:vans/exports.dart';

class PixKeySection extends StatelessWidget {
  final TextEditingController controller;
  final String beneficiary;
  final String cnpj;

  const PixKeySection({
    super.key,
    required this.controller,
    this.beneficiary = 'GoRotas Transportes',
    this.cnpj = '12.345.678/0001-00',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Cole a chave Pix para fazer a transferência',
          style: TextStyle(fontSize: 13, color: AppColors.primaryGray),
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
          controller: controller,
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
                    'CNPJ:',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.primaryGray,
                    ),
                  ),
                  Text(
                    cnpj,
                    style: const TextStyle(
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
    );
  }
}
