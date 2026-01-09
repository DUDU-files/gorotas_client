import 'package:flutter/material.dart';
import 'package:vans/exports.dart';

class WalletBalance extends StatelessWidget {
  final double balance;
  final bool isSelected;
  final ValueChanged<bool>? onSelectionChanged;

  const WalletBalance({
    super.key,
    required this.balance,
    this.isSelected = false,
    this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.lightGray, width: 1),
        ),
      ),
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Minha carteira(R\$)',
            style: TextStyle(fontSize: 12, color: AppColors.primaryGray),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'R\$ ${balance.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
              if (onSelectionChanged != null)
                Checkbox(
                  value: isSelected,
                  onChanged: (value) =>
                      onSelectionChanged?.call(value ?? false),
                  activeColor: AppColors.primaryOrange,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
