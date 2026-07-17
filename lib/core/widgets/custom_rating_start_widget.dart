import 'package:flutter/material.dart';

class CustomStarRating extends StatelessWidget {
  final double rating;
  final int maxStars;
  final double size;
  final Color color;

  const CustomStarRating({
    super.key,
    required this.rating,
    this.maxStars = 5,
    this.size = 18.0,
    this.color = Colors.amber,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> stars = [];

    for (int i = 1; i <= maxStars; i++) {
      if (i <= rating) {
        // Full Star
        stars.add(Icon(Icons.star, size: size, color: color));
      } else if (i - 0.5 <= rating) {
        // Half Star
        stars.add(Icon(Icons.star_half, size: size, color: color));
      } else {
        // Empty Star
        stars.add(Icon(Icons.star_border, size: size, color: color));
      }
    }

    return Row(mainAxisSize: MainAxisSize.min, children: stars);
  }
}
