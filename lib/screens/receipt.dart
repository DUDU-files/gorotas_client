import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vans/exports.dart';

class Receipt extends StatelessWidget {
  final Map<String, dynamic> data;

  const Receipt({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final origin = data['origin'] ?? '';
    final destination = data['destination'] ?? '';
    final type = data['type'] ?? '';
    final price = (data['price'] ?? 0.0).toDouble();
    final date = data['date'] ?? '';
    final time = data['time'] ?? '';
    final passengerName = data['passengerName'] ?? '';
    final passengerId = data['passengerId'] ?? '';
    final seatNumber = data['seatNumber'] ?? '';

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Logo e título
            const ReceiptHeader(),
            const SizedBox(height: 20),

            // Informações da viagem
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.lightGray),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Informações da Viagem',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Origem e Destino
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'De',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.primaryGray,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            origin,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppColors.black,
                            ),
                          ),
                        ],
                      ),
                      Icon(
                        Icons.arrow_forward,
                        color: AppColors.primaryGray,
                        size: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            'Para',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.primaryGray,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            destination,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppColors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Data, Hora e Tipo
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Data',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.primaryGray,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            date,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppColors.black,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Horário',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.primaryGray,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            time,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppColors.black,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Tipo',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.primaryGray,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            type,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryOrange,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Informações do Passageiro
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.lightGray),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Informações do Passageiro',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Nome',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.primaryGray,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            passengerName,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppColors.black,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'ID',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.primaryGray,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            passengerId,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppColors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.backgroudGray,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.event_seat,
                          color: AppColors.primaryBlue,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Assento: $seatNumber',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Valor da Passagem
            Container(
              decoration: BoxDecoration(
                color: AppColors.backgroudGray,
                border: Border.all(color: AppColors.lightGray),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    'Valor da Passagem',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.primaryGray,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'R\$ ${price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.green,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

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
                    'Informações Importantes',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '• Chegue com 15 minutos de antecedência\n• Leve documento de identificação\n• Guarde este comprovante para embarque',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.primaryGray,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Botão Fechar
            SizedBox(
              width: double.infinity,
              child: ConfirmationButton(
                label: 'Fechar Comprovante',
                onPressed: () {
                  final navProvider = Provider.of<NavigationProvider>(
                    context,
                    listen: false,
                  );
                  navProvider.goBack();
                },
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
