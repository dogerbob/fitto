import 'package:flutter/material.dart';
import 'package:fitto/services/food_search_service.dart';
import 'package:fitto/services/nutrition_service.dart';
import 'package:fitto/models/nutrition_entry.dart';
import 'package:fitto/widgets/gradient_button.dart';

class FoodSearchScreen extends StatefulWidget {
  final String mealType;
  
  const FoodSearchScreen({super.key, required this.mealType});

  @override
  State<FoodSearchScreen> createState() => _FoodSearchScreenState();
}

class _FoodSearchScreenState extends State<FoodSearchScreen> {
  final FoodSearchService _foodSearchService = FoodSearchService();
  final NutritionService _nutritionService = NutritionService();
  final TextEditingController _searchController = TextEditingController();
  
  List<Map<String, dynamic>> _searchResults = [];
  bool _isLoading = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadPopularFoods();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadPopularFoods() async {
    setState(() => _isLoading = true);
    
    try {
      // Load some popular breakfast items as default
      final results = await _foodSearchService.searchFood('breakfast cereal');
      if (mounted) {
        setState(() {
          _searchResults = results;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _searchFood(String query) async {
    if (query.trim().isEmpty) return;
    
    setState(() {
      _isLoading = true;
      _searchQuery = query;
    });
    
    try {
      final results = await _foodSearchService.searchFood(query);
      if (mounted) {
        setState(() {
          _searchResults = results;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error searching for food. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _addFoodToLog(Map<String, dynamic> product) async {
    try {
      final nutritionEntry = _foodSearchService.createNutritionEntry(product, widget.mealType);
      await _nutritionService.addEntry(nutritionEntry);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${product['name']} added to ${widget.mealType.toLowerCase()}!'),
            backgroundColor: Color(0xFFFF8A65),
          ),
        );
        Navigator.pop(context, true); // Return true to indicate food was added
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding food to log. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Food for ${widget.mealType}'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFF8A65), Color(0xFFFFAB91)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: _isLoading
                ? _buildLoadingState()
                : _searchResults.isEmpty
                    ? _buildEmptyState()
                    : _buildSearchResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Color(0xFFFF8A65).withOpacity(0.3)),
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search for food...',
                  hintStyle: TextStyle(color: Colors.grey.shade500),
                  prefixIcon: Icon(Icons.search, color: Color(0xFFFF8A65)),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                onSubmitted: _searchFood,
              ),
            ),
          ),
          SizedBox(width: 12),
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFF8A65), Color(0xFFFFAB91)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: Icon(Icons.search, color: Colors.white),
              onPressed: () => _searchFood(_searchController.text),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF8A65)),
          ),
          SizedBox(height: 16),
          Text('Searching for food...', style: TextStyle(color: Colors.grey.shade600)),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey.shade400),
          SizedBox(height: 16),
          Text(
            'No food items found',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey.shade700),
          ),
          SizedBox(height: 8),
          Text(
            'Try searching for something else',
            style: TextStyle(color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final product = _searchResults[index];
        return _buildFoodCard(product);
      },
    );
  }

  Widget _buildFoodCard(Map<String, dynamic> product) {
    final nutrition = product['nutrition'] as Map<String, dynamic>;
    final calories = nutrition['calories'] as int? ?? 0;
    final protein = nutrition['protein'] as double? ?? 0.0;
    final carbs = nutrition['carbs'] as double? ?? 0.0;
    final fats = nutrition['fats'] as double? ?? 0.0;
    
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
        border: Border.all(color: Color(0xFFFF8A65).withOpacity(0.1)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _addFoodToLog(product),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                // Product image placeholder
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: product['imageUrl'] != null && product['imageUrl'].isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            product['imageUrl'],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Icon(
                              Icons.fastfood,
                              color: Colors.grey.shade400,
                              size: 24,
                            ),
                          ),
                        )
                      : Icon(
                          Icons.fastfood,
                          color: Colors.grey.shade400,
                          size: 24,
                        ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product['name'] as String,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade800,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (product['brand'] != null && product['brand'].isNotEmpty) ...[
                        SizedBox(height: 4),
                        Text(
                          product['brand'] as String,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                      SizedBox(height: 8),
                      Row(
                        children: [
                          _buildNutrientChip('${calories} kcal', Color(0xFFFF8A65)),
                          SizedBox(width: 8),
                          _buildNutrientChip('P: ${protein.toInt()}g', Color(0xFFFFAB91)),
                          SizedBox(width: 8),
                          _buildNutrientChip('C: ${carbs.toInt()}g', Color(0xFFFFCC80)),
                          SizedBox(width: 8),
                          _buildNutrientChip('F: ${fats.toInt()}g', Color(0xFFFFD54F)),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.add_circle_outline,
                  color: Color(0xFFFF8A65),
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNutrientChip(String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}