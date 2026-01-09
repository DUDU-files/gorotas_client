import 'package:flutter/material.dart';
import 'package:vans/exports.dart';

class StarRating extends StatelessWidget {
  final int rating;
  final int maxRating;
  final double size;
  final bool interactive;
  final ValueChanged<int>? onRatingChanged;

  const StarRating({
    super.key,
    required this.rating,
    this.maxRating = 5,
    this.size = 40,
    this.interactive = true,
    this.onRatingChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(maxRating, (index) {
        return GestureDetector(
          onTap: interactive && onRatingChanged != null
              ? () => onRatingChanged!(index + 1)
              : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Icon(
              index < rating ? Icons.star : Icons.star_outline,
              color: AppColors.starFilled,
              size: size,
            ),
          ),
        );
      }),
    );
  }
}
