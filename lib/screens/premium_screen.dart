import 'package:flutter/material.dart';
import 'package:fitto/models/subscription_plan.dart';
import 'package:fitto/widgets/gradient_button.dart';
import 'package:fitto/utils/localizations.dart';

class PremiumScreen extends StatefulWidget {
  const PremiumScreen({super.key});

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  int _selectedPlanIndex = 1;

  final List<SubscriptionPlan> _plans = [
    SubscriptionPlan(
      id: 'monthly',
      name: 'Monthly',
      price: 9.99,
      duration: 'per month',
      features: ['AI Coach', 'Advanced Analytics', 'Custom Workouts', 'Nutrition Tracking', 'Priority Support'],
      isPopular: false,
    ),
    SubscriptionPlan(
      id: 'yearly',
      name: 'Yearly',
      price: 79.99,
      duration: 'per year',
      features: ['Everything in Monthly', 'Save 33%', 'Exclusive Content', 'Early Access', 'Offline Mode'],
      isPopular: true,
    ),
    SubscriptionPlan(
      id: 'lifetime',
      name: 'Lifetime',
      price: 199.99,
      duration: 'one-time',
      features: ['Everything in Yearly', 'Lifetime Access', 'All Future Features', 'Premium Badge', 'VIP Support'],
      isPopular: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final locale = 'en';

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFB4C8), Color(0xFFE8C5E5), Color(0xFFA8D8EA)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Column(
                        children: [
                          _buildFeaturesList(),
                          SizedBox(height: 32),
                          ..._plans.asMap().entries.map((entry) => _buildPlanCard(entry.value, entry.key)),
                          SizedBox(height: 24),
                          GradientButton(
                            text: AppLocalizations.get('subscribe', locale),
                            onPressed: _handleSubscribe,
                            colors: [Color(0xFFFFB4C8), Color(0xFFE8C5E5)],
                          ),
                          SizedBox(height: 16),
                          Text('Cancel anytime. 7-day free trial.', style: TextStyle(fontSize: 12, color: Colors.grey.shade600), textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          SizedBox(height: 16),
          Icon(Icons.star, color: Colors.white, size: 64),
          SizedBox(height: 16),
          Text('Unlock Premium', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text('Get unlimited access to all features', style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildFeaturesList() {
    final features = [
      {'icon': Icons.psychology, 'title': 'AI-Powered Coach', 'desc': 'Personalized fitness guidance'},
      {'icon': Icons.analytics, 'title': 'Advanced Analytics', 'desc': 'Track your progress in detail'},
      {'icon': Icons.fitness_center, 'title': 'Custom Workouts', 'desc': 'Tailored to your goals'},
      {'icon': Icons.restaurant, 'title': 'Nutrition Tracking', 'desc': 'AI food recognition'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Premium Features', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        SizedBox(height: 16),
        ...features.map((feature) => Container(
          margin: EdgeInsets.only(bottom: 12),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark ? Color(0xFF2A2A2A) : Color(0xFFFFFBFE),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Color(0xFFFFB4C8).withOpacity(0.2)),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Color(0xFFFFB4C8), Color(0xFFE8C5E5)]),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(feature['icon'] as IconData, color: Colors.white),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(feature['title'] as String, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    Text(feature['desc'] as String, style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
                  ],
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }

  Widget _buildPlanCard(SubscriptionPlan plan, int index) {
    final isSelected = _selectedPlanIndex == index;
    final locale = 'en';

    return GestureDetector(
      onTap: () => setState(() => _selectedPlanIndex = index),
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: isSelected ? LinearGradient(colors: [Color(0xFFFFB4C8), Color(0xFFE8C5E5)]) : null,
          color: isSelected ? null : (Theme.of(context).brightness == Brightness.dark ? Color(0xFF2A2A2A) : Colors.white),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.transparent : (plan.isPopular ? Color(0xFFFFB4C8) : Colors.grey.shade300),
            width: 2,
          ),
          boxShadow: isSelected ? [BoxShadow(color: Color(0xFFFFB4C8).withOpacity(0.3), blurRadius: 12, offset: Offset(0, 6))] : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.get(plan.name.toLowerCase(), locale),
                      style: TextStyle(
                        color: isSelected ? Colors.white : Theme.of(context).colorScheme.onSurface,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      plan.duration,
                      style: TextStyle(
                        color: isSelected ? Colors.white.withOpacity(0.9) : Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${plan.price}',
                      style: TextStyle(
                        color: isSelected ? Colors.white : Theme.of(context).colorScheme.onSurface,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (plan.isPopular)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.white.withOpacity(0.3) : Color(0xFFFFEAA7),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text('POPULAR', style: TextStyle(color: isSelected ? Colors.white : Colors.orange.shade800, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            ...plan.features.map((feature) => Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: isSelected ? Colors.white : Color(0xFFFFB4C8), size: 20),
                  SizedBox(width: 8),
                  Text(feature, style: TextStyle(color: isSelected ? Colors.white.withOpacity(0.9) : Colors.grey.shade700, fontSize: 14)),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  void _handleSubscribe() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Coming Soon', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text('Payment integration will be available soon.\n\nSelected plan: ${_plans[_selectedPlanIndex].name}\nPrice: \$${_plans[_selectedPlanIndex].price}'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('OK')),
        ],
      ),
    );
  }
}
