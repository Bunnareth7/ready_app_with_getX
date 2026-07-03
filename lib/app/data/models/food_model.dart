// food_model.dart
class FoodModel {
  final String id;
  final String imageUrl;

  FoodModel({
    required this.id,
    required this.imageUrl,
  });

  // Dummy data with only images
  static List<FoodModel> dummyFoods = [
    FoodModel(
      id: '1',
      imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaMi7hfJCXSGUfSJ7GrCjb2BuD2ZAXDliMQlLic5PdKxQc17azQN3VAMyP&s=10',
    ),
    FoodModel(
      id: '2',
      imageUrl: 'https://hips.hearstapps.com/hmg-prod/images/roasted-chickpea-tomato-and-chicken-bowls-healthy-chicken-recipes-65e8b8ff3ccf6.jpg?crop=0.936xw:0.936xh;0.0641xw,0.0431xh&resize=640:*',
    ),
    FoodModel(
      id: '3',
      imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTlA7aH_9Ox4NjQ045Yo1vAuTQqNU6sxvDtmiLtn56TmA&s',
    ),
    FoodModel(
      id: '4',
      imageUrl: 'https://www.eatingwell.com/thmb/QYZnBgF72TIKI6-A--NyoPa6avY=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/greek-salmon-bowl-f681500cbe054bb1adb607ff55094075.jpeg',
    ),
    FoodModel(
      id: '5',
      imageUrl: 'https://media.istockphoto.com/id/1416818056/photo/colourful-vegan-bowl-with-quinoa-and-sweet-potato.jpg?s=612x612&w=0&k=20&c=t1I58CqucV6bLRaa4iDy7PIVjnV8D9eWDjEsX9X-87k=',
    ),
  ];

  // Get all image URLs only
  static List<String> get imageUrls {
    return dummyFoods.map((food) => food.imageUrl).toList();
  }

  // Get limited image URLs
  static List<String> getLimitedImages(int limit) {
    return dummyFoods.take(limit).map((food) => food.imageUrl).toList();
  }
}