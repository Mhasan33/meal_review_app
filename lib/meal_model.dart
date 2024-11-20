// SDK
import 'package:supabase_flutter/supabase_flutter.dart';

// Supadart Class
abstract class MealModelClass<T> {
  static Map<String, dynamic> insert(Map<String, dynamic> data) {
    throw UnimplementedError();
  }

  static Map<String, dynamic> update(Map<String, dynamic> data) {
    throw UnimplementedError();
  }

  factory MealModelClass.fromJson(Map<String, dynamic> json) {
    throw UnimplementedError();
  }

  static converter(List<Map<String, dynamic>> data) {
    throw UnimplementedError();
  }

  static converterSingle(Map<String, dynamic> data) {
    throw UnimplementedError();
  }
}

// Supabase Client Extension
extension SupadartClient on SupabaseClient {
  SupabaseQueryBuilder get meals => from('Meals');
}

// Utils
class Meals implements MealModelClass<Meals> {
  final BigInt id;
  final DateTime createdAt;
  final String mealName;
  final double mealPrice;
  final String description;
  final String? mealImage;
  final List<String> ingredients;
  final int reviewNum;
  final List<String> userComments;
  final List<int> ingredientReviews; // New property

  const Meals({
    required this.id,
    required this.createdAt,
    required this.mealName,
    required this.mealPrice,
    required this.description,
    this.mealImage,
    required this.ingredients,
    required this.reviewNum,
    required this.userComments,
    required this.ingredientReviews, // Include in constructor
  });

  static String get table_name => 'Meals';
  static String get c_id => 'id';
  static String get c_createdAt => 'created_at';
  static String get c_mealName => 'meal_name';
  static String get c_mealPrice => 'meal_price';
  static String get c_description => 'description';
  static String get c_mealImage => 'meal_image';
  static String get c_ingredients => 'ingredients';
  static String get c_reviewNum => 'review_num';
  static String get c_userComments => 'user_comments';
  static String get c_ingredientReviews => 'ingredient_reviews'; // New constant

  static List<Meals> converter(List<Map<String, dynamic>> data) {
    return data.map(Meals.fromJson).toList();
  }

  static Meals converterSingle(Map<String, dynamic> data) {
    return Meals.fromJson(data);
  }

  static Map<String, dynamic> _generateMap({
    BigInt? id,
    DateTime? createdAt,
    String? mealName,
    double? mealPrice,
    String? description,
    String? mealImage,
    List<String>? ingredients,
    int? reviewNum,
    List<String>? userComments,
    List<int>? ingredientReviews, // New parameter
  }) {
    return {
      if (id != null) 'id': id.toString(),
      if (createdAt != null) 'created_at': createdAt.toUtc().toIso8601String(),
      if (mealName != null) 'meal_name': mealName,
      if (mealPrice != null) 'meal_price': mealPrice,
      if (description != null) 'description': description,
      if (mealImage != null) 'meal_image': mealImage,
      if (ingredients != null) 'ingredients': ingredients,
      if (reviewNum != null) 'review_num': reviewNum,
      if (userComments != null) 'user_comments': userComments,
      if (ingredientReviews != null) 'ingredient_reviews': ingredientReviews, // Add to map
    };
  }

  static Map<String, dynamic> insert({
    BigInt? id,
    DateTime? createdAt,
    String? mealName,
    required double mealPrice,
    String? description,
    String? mealImage,
    required List<String> ingredients,
    required int reviewNum,
    required List<String> userComments,
    required List<int> ingredientReviews, // Include in parameters
  }) {
    return _generateMap(
      id: id,
      createdAt: createdAt,
      mealName: mealName,
      mealPrice: mealPrice,
      description: description,
      mealImage: mealImage,
      ingredients: ingredients,
      reviewNum: reviewNum,
      userComments: userComments,
      ingredientReviews: ingredientReviews, // Pass to map generation
    );
  }

  static Map<String, dynamic> update({
    BigInt? id,
    DateTime? createdAt,
    String? mealName,
    double? mealPrice,
    String? description,
    String? mealImage,
    List<String>? ingredients,
    int? reviewNum,
    List<String>? userComments,
    List<int>? ingredientReviews, // New parameter
  }) {
    return _generateMap(
      id: id,
      createdAt: createdAt,
      mealName: mealName,
      mealPrice: mealPrice,
      description: description,
      mealImage: mealImage,
      ingredients: ingredients,
      reviewNum: reviewNum,
      userComments: userComments,
      ingredientReviews: ingredientReviews, // Pass to map generation
    );
  }

  factory Meals.fromJson(Map<String, dynamic> jsonn) {
    return Meals(
      id: jsonn['id'] != null ? BigInt.parse(jsonn['id'].toString()) : BigInt.from(0),
      createdAt: jsonn['created_at'] != null ? DateTime.parse(jsonn['created_at'].toString()) : DateTime.fromMillisecondsSinceEpoch(0),
      mealName: jsonn['meal_name'] != null ? jsonn['meal_name'].toString() : '',
      mealPrice: jsonn['meal_price'] != null ? double.parse(jsonn['meal_price'].toString()) : 0.0,
      description: jsonn['description'] != null ? jsonn['description'].toString() : '',
      mealImage: jsonn['meal_image'] != null ? jsonn['meal_image'].toString() : '',
      ingredients: jsonn['ingredients'] != null ? List<String>.from(jsonn['ingredients']) : <String>[],
      reviewNum: jsonn['review_num'] != null ? int.parse(jsonn['review_num'].toString()) : 0,
      userComments: jsonn['user_comments'] != null ? List<String>.from(jsonn['user_comments']) : <String>[],
      ingredientReviews: jsonn['ingredient_reviews'] != null ? List<int>.from(jsonn['ingredient_reviews']) : <int>[], // Add this line
    );
  }

  Map<String, dynamic> toJson() {
    return _generateMap(
      id: id,
      createdAt: createdAt,
      mealName: mealName,
      mealPrice: mealPrice,
      description: description,
      mealImage: mealImage,
      ingredients: ingredients,
      reviewNum: reviewNum,
      userComments: userComments,
      ingredientReviews: ingredientReviews, // Include in toJson
    );
  }

  Meals copyWith({
    BigInt? id,
    DateTime? createdAt,
    String? mealName,
    double? mealPrice,
    String? description,
    String? mealImage,
    List<String>? ingredients,
    int? reviewNum,
    List<String>? userComments,
    List<int>? ingredientReviews, // Add to copyWith
  }) {
    return Meals(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      mealName: mealName ?? this.mealName,
      mealPrice: mealPrice ?? this.mealPrice,
      description: description ?? this.description,
      mealImage: mealImage ?? this.mealImage,
      ingredients: ingredients ?? this.ingredients,
      reviewNum: reviewNum ?? this.reviewNum,
      userComments: userComments ?? this.userComments,
      ingredientReviews: ingredientReviews ?? this.ingredientReviews, // Add to copyWith
    );
  }
}
