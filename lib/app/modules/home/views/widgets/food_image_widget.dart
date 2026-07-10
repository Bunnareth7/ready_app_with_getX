import 'package:flutter/material.dart';
import 'package:learn_getx2/app/data/models/food_model.dart';

class FoodImages extends StatelessWidget {
  final List<FoodModel> foods;
  final int maxImages;
  final double imageSize;

  const FoodImages({
    super.key,
    required this.foods,
    this.maxImages = 5,
    this.imageSize = 35,
  });

  @override
  Widget build(BuildContext context) {
    final int displayCount = foods.length > maxImages
        ? maxImages
        : foods.length;
    final List<FoodModel> displayFoods = foods.take(displayCount).toList();

    return SizedBox(
      height: 30,
      width: 180,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(displayCount, (index) {
          final food = displayFoods[index];
          return Container(
            width: imageSize,
            height: imageSize,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              border: Border.all(color: const Color(0xFFecf0f1)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.network(
                food.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    child: const Icon(
                      Icons.image_not_supported,
                      size: 20,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
            ),
          );
        }),
      ),
    );
  }
}
