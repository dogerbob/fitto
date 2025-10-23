import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:fitto/models/nutrition_entry.dart';

class FoodSearchService {
  final Dio _dio = Dio();
  static const String _baseUrl = 'https://world.openfoodfacts.org/api/v0';
  
  FoodSearchService() {
    _dio.options.baseUrl = _baseUrl;
    _dio.options.connectTimeout = Duration(seconds: 10);
    _dio.options.receiveTimeout = Duration(seconds: 10);
  }

  /// Search for food products using OpenFoodFacts API
  Future<List<Map<String, dynamic>>> searchFood(String query) async {
    try {
      if (query.trim().isEmpty) return [];
      
      final response = await _dio.get(
        '/cgi/search.pl',
        queryParameters: {
          'search_terms': query.trim(),
          'search_simple': '1',
          'action': 'process',
          'json': '1',
          'page_size': '20',
          'page': '1',
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final products = data['products'] as List<dynamic>? ?? [];
        
        return products.map((product) => _parseProduct(product)).toList();
      }
      
      return [];
    } catch (e) {
      print('Error searching food: $e');
      return [];
    }
  }

  /// Get detailed product information by barcode
  Future<Map<String, dynamic>?> getProductByBarcode(String barcode) async {
    try {
      final response = await _dio.get('/product/$barcode.json');
      
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == 1) {
          return _parseProduct(data['product']);
        }
      }
      
      return null;
    } catch (e) {
      print('Error getting product by barcode: $e');
      return null;
    }
  }

  /// Parse OpenFoodFacts product data into our format
  Map<String, dynamic> _parseProduct(Map<String, dynamic> product) {
    final nutriments = product['nutriments'] as Map<String, dynamic>? ?? {};
    
    // Extract nutrition information with fallbacks
    final calories = _extractNutrient(nutriments, 'energy-kcal_100g', 'energy_100g') ?? 0;
    final protein = _extractNutrient(nutriments, 'proteins_100g') ?? 0.0;
    final carbs = _extractNutrient(nutriments, 'carbohydrates_100g') ?? 0.0;
    final fats = _extractNutrient(nutriments, 'fat_100g') ?? 0.0;
    final fiber = _extractNutrient(nutriments, 'fiber_100g') ?? 0.0;
    final sugar = _extractNutrient(nutriments, 'sugars_100g') ?? 0.0;
    final sodium = _extractNutrient(nutriments, 'sodium_100g') ?? 0.0;
    
    // Get serving size information
    final servingSize = product['serving_size'] as String? ?? '100g';
    final quantity = product['quantity'] as String? ?? '100g';
    
    return {
      'id': product['_id'] as String? ?? '',
      'name': product['product_name'] as String? ?? 'Unknown Product',
      'brand': product['brands'] as String? ?? '',
      'barcode': product['code'] as String? ?? '',
      'imageUrl': product['image_url'] as String? ?? product['image_front_url'] as String? ?? '',
      'servingSize': servingSize,
      'quantity': quantity,
      'nutrition': {
        'calories': calories,
        'protein': protein,
        'carbs': carbs,
        'fats': fats,
        'fiber': fiber,
        'sugar': sugar,
        'sodium': sodium,
      },
      'ingredients': product['ingredients_text'] as String? ?? '',
      'allergens': _parseAllergens(product['allergens_tags'] as List<dynamic>? ?? []),
      'nutriscore': product['nutriscore_grade'] as String? ?? '',
      'ecoscore': product['ecoscore_grade'] as String? ?? '',
    };
  }

  /// Extract nutrient value with fallback options
  dynamic _extractNutrient(Map<String, dynamic> nutriments, String primaryKey, [String? fallbackKey]) {
    if (nutriments.containsKey(primaryKey)) {
      final value = nutriments[primaryKey];
      if (value is num) return value;
      if (value is String) return double.tryParse(value);
    }
    
    if (fallbackKey != null && nutriments.containsKey(fallbackKey)) {
      final value = nutriments[fallbackKey];
      if (value is num) return value;
      if (value is String) return double.tryParse(value);
    }
    
    return null;
  }

  /// Parse allergens from OpenFoodFacts format
  List<String> _parseAllergens(List<dynamic> allergenTags) {
    return allergenTags
        .map((tag) => tag.toString().replaceAll('en:', '').replaceAll('-', ' '))
        .toList();
  }

  /// Convert search result to NutritionEntry
  NutritionEntry createNutritionEntry(Map<String, dynamic> product, String mealType) {
    final now = DateTime.now();
    final nutrition = product['nutrition'] as Map<String, dynamic>;
    
    return NutritionEntry(
      id: 'openfoodfacts_${product['id']}_${now.millisecondsSinceEpoch}',
      userId: 'user_1', // This should come from auth service
      date: now,
      mealType: mealType,
      name: product['name'] as String,
      calories: (nutrition['calories'] as num?)?.toInt() ?? 0,
      protein: (nutrition['protein'] as num?)?.toDouble() ?? 0.0,
      carbs: (nutrition['carbs'] as num?)?.toDouble() ?? 0.0,
      fats: (nutrition['fats'] as num?)?.toDouble() ?? 0.0,
      servingSize: product['servingSize'] as String,
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Get popular food categories for quick search
  List<String> getPopularCategories() {
    return [
      'Breakfast Cereals',
      'Dairy Products',
      'Beverages',
      'Snacks',
      'Fruits',
      'Vegetables',
      'Meat',
      'Fish',
      'Bread',
      'Pasta',
      'Rice',
      'Nuts',
      'Chocolate',
      'Ice Cream',
      'Yogurt',
    ];
  }

  /// Search by category
  Future<List<Map<String, dynamic>>> searchByCategory(String category) async {
    return searchFood(category);
  }
}