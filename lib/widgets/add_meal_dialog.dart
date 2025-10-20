import 'package:flutter/material.dart';
import 'package:fitto/models/nutrition_entry.dart';
import 'package:fitto/services/auth_service.dart';
import 'package:uuid/uuid.dart';

class AddMealDialog extends StatefulWidget {
  final Function(NutritionEntry) onMealAdded;

  const AddMealDialog({
    super.key,
    required this.onMealAdded,
  });

  @override
  State<AddMealDialog> createState() => _AddMealDialogState();
}

class _AddMealDialogState extends State<AddMealDialog>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _servingSizeController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _proteinController = TextEditingController();
  final _carbsController = TextEditingController();
  final _fatsController = TextEditingController();
  
  String _selectedMealType = 'Breakfast';
  TimeOfDay _selectedTime = TimeOfDay.now();
  bool _isLoading = false;
  
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  final List<String> _mealTypes = [
    'Breakfast',
    'Lunch',
    'Dinner',
    'Snacks',
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _servingSizeController.dispose();
    _caloriesController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              elevation: 16,
              child: Container(
                constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.restaurant,
                                color: Theme.of(context).primaryColor,
                                size: 28,
                              ),
                              SizedBox(width: 12),
                              Text(
                                'Add Meal',
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Spacer(),
                              IconButton(
                                onPressed: () => Navigator.pop(context),
                                icon: Icon(Icons.close),
                                style: IconButton.styleFrom(
                                  backgroundColor: Colors.grey.shade100,
                                  shape: CircleBorder(),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 24),
                          
                          // Meal Type Selection
                          Text(
                            'Meal Type',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: DropdownButtonFormField<String>(
                              value: _selectedMealType,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              ),
                              items: _mealTypes.map((type) {
                                return DropdownMenuItem(
                                  value: type,
                                  child: Text(type),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedMealType = value!;
                                });
                              },
                            ),
                          ),
                          SizedBox(height: 16),
                          
                          // Time Selection
                          Text(
                            'Time',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 8),
                          InkWell(
                            onTap: _selectTime,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.access_time, color: Theme.of(context).primaryColor),
                                  SizedBox(width: 12),
                                  Text(
                                    _selectedTime.format(context),
                                    style: Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          
                          // Meal Name
                          Text(
                            'Meal Name',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 8),
                          TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              hintText: 'e.g., Grilled Chicken Salad',
                              prefixIcon: Icon(Icons.fastfood),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter meal name';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),
                          
                          // Serving Size
                          Text(
                            'Serving Size',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 8),
                          TextFormField(
                            controller: _servingSizeController,
                            decoration: InputDecoration(
                              hintText: 'e.g., 1 plate, 2 cups',
                              prefixIcon: Icon(Icons.straighten),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter serving size';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),
                          
                          // Nutritional Information
                          Text(
                            'Nutritional Information',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 8),
                          
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _caloriesController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: 'Calories',
                                    prefixIcon: Icon(Icons.local_fire_department),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Required';
                                    }
                                    if (int.tryParse(value) == null) {
                                      return 'Invalid number';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: TextFormField(
                                  controller: _proteinController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: 'Protein (g)',
                                    prefixIcon: Icon(Icons.fitness_center),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Required';
                                    }
                                    if (double.tryParse(value) == null) {
                                      return 'Invalid number';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _carbsController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: 'Carbs (g)',
                                    prefixIcon: Icon(Icons.grain),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Required';
                                    }
                                    if (double.tryParse(value) == null) {
                                      return 'Invalid number';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: TextFormField(
                                  controller: _fatsController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: 'Fats (g)',
                                    prefixIcon: Icon(Icons.opacity),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Required';
                                    }
                                    if (double.tryParse(value) == null) {
                                      return 'Invalid number';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 24),
                          
                          // Action Buttons
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: _isLoading ? null : () => Navigator.pop(context),
                                  style: OutlinedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child: Text('Cancel'),
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: FilledButton(
                                  onPressed: _isLoading ? null : _saveMeal,
                                  style: FilledButton.styleFrom(
                                    padding: EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child: _isLoading
                                      ? SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                          ),
                                        )
                                      : Text('Add Meal'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _saveMeal() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final now = DateTime.now();
      final mealTime = DateTime(
        now.year,
        now.month,
        now.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      final meal = NutritionEntry(
        id: Uuid().v4(),
        userId: AuthService().currentUser?.id ?? 'user_1',
        date: mealTime,
        mealType: _selectedMealType,
        name: _nameController.text.trim(),
        calories: int.parse(_caloriesController.text),
        protein: double.parse(_proteinController.text),
        carbs: double.parse(_carbsController.text),
        fats: double.parse(_fatsController.text),
        servingSize: _servingSizeController.text.trim(),
        createdAt: now,
        updatedAt: now,
      );

      widget.onMealAdded(meal);
      
      // Show success animation
      _animationController.reverse().then((_) {
        Navigator.pop(context);
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving meal: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }
}