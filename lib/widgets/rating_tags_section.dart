import 'package:flutter/material.dart';
import 'package:vans/exports.dart';

class RatingTagsSection extends StatelessWidget {
  final int starCount;
  final List<String> tags;

  const RatingTagsSection({
    super.key,
    this.starCount = 5,
    this.tags = const ['Boa rota', 'Equipamentos em boas condições'],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightGray),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Estrelas
          Row(
            children: List.generate(
              starCount,
              (index) => const Padding(
                padding: EdgeInsets.only(right: 4),
                child: Icon(Icons.star, color: AppColors.starFilled, size: 20),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Tags
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: tags.map<Widget>((tag) => InfoTag(label: tag)).toList(),
          ),
        ],
      ),
    );
  }
}
