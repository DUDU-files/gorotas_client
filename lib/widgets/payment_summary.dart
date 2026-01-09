import 'package:flutter/material.dart';
import 'package:vans/exports.dart';

class PaymentSummary extends StatelessWidget {
  final double ticketPrice;
  final double? discount;
  final double? total;

  const PaymentSummary({
    super.key,
    required this.ticketPrice,
    this.discount,
    this.total,
  });

  double get _total => total ?? (ticketPrice - (discount ?? 0));

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroudGray,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightGray),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Valor da passagem:',
                style: TextStyle(fontSize: 13, color: AppColors.primaryGray),
              ),
              Text(
                'R\$ ${ticketPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),
            ],
          ),
          if (discount != null && discount! > 0) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Desconto:',
                  style: TextStyle(fontSize: 13, color: AppColors.primaryGray),
                ),
                Text(
                  '- R\$ ${discount!.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.green,
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 12),
          const Divider(color: AppColors.lightGray),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total a pagar:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
              Text(
                'R\$ ${_total.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
