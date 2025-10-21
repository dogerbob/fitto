import 'package:flutter/material.dart';
import 'package:fitto/services/water_service.dart';
import 'package:fitto/widgets/gradient_button.dart';
import 'package:fl_chart/fl_chart.dart';

class WaterScreen extends StatefulWidget {
  const WaterScreen({super.key});

  @override
  State<WaterScreen> createState() => _WaterScreenState();
}

class _WaterScreenState extends State<WaterScreen> with TickerProviderStateMixin {
  final WaterService _waterService = WaterService();
  bool _isLoading = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
    _initialize();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _initialize() async {
    await _waterService.initialize();
    if (mounted) {
      setState(() => _isLoading = false);
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return _buildLoadingState();
    }

    final waterIntake = _waterService.getTodayIntake();
    final waterGoal = _waterService.dailyGoal;
    final progress = _waterService.getWaterProgress();
    final recommendations = _waterService.getWaterRecommendations();
    final history = _waterService.getWaterHistory(7);
    final trends = _waterService.getWaterTrends();

    return Scaffold(
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  SizedBox(height: 24),
                  _buildWaterProgressCard(waterIntake, waterGoal, progress),
                  SizedBox(height: 24),
                  _buildQuickActions(),
                  SizedBox(height: 24),
                  _buildRecommendations(recommendations),
                  SizedBox(height: 24),
                  _buildWaterHistory(history),
                  SizedBox(height: 24),
                  _buildTrendsCard(trends),
                  SizedBox(height: 24),
                  _buildWaterEntries(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFA8D8EA)),
          ),
          SizedBox(height: 16),
          Text('Loading your hydration data...', style: TextStyle(fontSize: 16, color: Colors.grey.shade600)),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Water Intake',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            Text(
              'Stay hydrated, stay healthy!',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Color(0xFFA8D8EA), Color(0xFF7FBFD4)]),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.water_drop, color: Colors.white, size: 16),
              SizedBox(width: 4),
              Text('Hydration', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWaterProgressCard(int waterIntake, int waterGoal, double progress) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFA8D8EA), Color(0xFF7FBFD4)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Color(0xFFA8D8EA).withOpacity( 0.3),
              blurRadius: 16,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Today\'s Progress',
                  style: TextStyle(
                    color: Colors.white.withOpacity( 0.9),
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity( 0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '${(progress * 100).toInt()}%',
                    style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 200,
                  height: 200,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 12,
                    backgroundColor: Colors.white.withOpacity( 0.3),
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                Column(
                  children: [
                    Text(
                      '$waterIntake',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'glasses',
                      style: TextStyle(
                        color: Colors.white.withOpacity( 0.9),
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'of $waterGoal goal',
                      style: TextStyle(
                        color: Colors.white.withOpacity( 0.8),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 24),
            Container(
              height: 8,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity( 0.3),
                borderRadius: BorderRadius.circular(4),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: progress,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Row(
      children: [
        Expanded(
          child: GradientButton(
            text: 'Add 1 Glass',
            onPressed: () => _addWater(8),
            colors: [Color(0xFFA8D8EA), Color(0xFF7FBFD4)],
            height: 48,
            borderRadius: 24,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: GradientButton(
            text: 'Add 2 Glasses',
            onPressed: () => _addWater(16),
            colors: [Color(0xFF7FBFD4), Color(0xFF5A9BC4)],
            height: 48,
            borderRadius: 24,
          ),
        ),
        SizedBox(width: 12),
        Container(
          height: 48,
          width: 48,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Color(0xFFFF8A65), Color(0xFFFFAB91)]),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Color(0xFFFF8A65).withOpacity( 0.3),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: IconButton(
            icon: Icon(Icons.settings, color: Colors.white),
            onPressed: _showWaterSettings,
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendations(Map<String, dynamic> recommendations) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFFF8F5), Color(0xFFFFE0D6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Color(0xFFFF8A65).withOpacity( 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_outline, color: Color(0xFFFF8A65), size: 24),
              SizedBox(width: 8),
              Text(
                'AI Hydration Tips',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF8A65),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            recommendations['recommendation'] ?? 'Keep up the great work!',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (recommendations['tip'] != null) ...[
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color(0xFFFF8A65).withOpacity( 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.tips_and_updates, color: Color(0xFFFF8A65), size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      recommendations['tip'],
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildWaterHistory(List<Map<String, dynamic>> history) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '7-Day History',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(show: false),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index >= 0 && index < history.length) {
                        final date = history[index]['date'] as DateTime;
                        return Text(
                          '${date.day}/${date.month}',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                        );
                      }
                      return Text('');
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: history.asMap().entries.map((entry) {
                    return FlSpot(entry.key.toDouble(), entry.value['intake'].toDouble());
                  }).toList(),
                  isCurved: true,
                  color: Color(0xFFA8D8EA),
                  barWidth: 3,
                  dotData: FlDotData(show: true),
                  belowBarData: BarAreaData(
                    show: true,
                    color: Color(0xFFA8D8EA).withOpacity( 0.2),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTrendsCard(Map<String, dynamic> trends) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity( 0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hydration Trends',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildTrendItem(
                  'Average',
                  '${trends['averageIntake']} glasses',
                  Icons.trending_up,
                  Color(0xFFA8D8EA),
                ),
              ),
              Expanded(
                child: _buildTrendItem(
                  'Consistency',
                  '${(trends['consistency'] * 100).toInt()}%',
                  Icons.check_circle,
                  Color(0xFFFF8A65),
                ),
              ),
              Expanded(
                child: _buildTrendItem(
                  'Trend',
                  trends['trend'],
                  Icons.show_chart,
                  Color(0xFFFFCC80),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTrendItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildWaterEntries() {
    final todayEntries = _waterService.getWaterEntriesByDate(DateTime.now());
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Today\'s Entries',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),
        if (todayEntries.isEmpty)
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                'No water entries today. Start hydrating!',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ),
          )
        else
          ...todayEntries.map((entry) => _buildWaterEntryCard(entry)),
      ],
    );
  }

  Widget _buildWaterEntryCard(Map<String, dynamic> entry) {
    final timestamp = DateTime.parse(entry['timestamp']);
    final time = '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity( 0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFA8D8EA), Color(0xFF7FBFD4)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${entry['amount']} oz',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                if (entry['note'] != null && entry['note'].isNotEmpty)
                  Text(
                    entry['note'],
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
              ],
            ),
          ),
          Text(
            time,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
          SizedBox(width: 8),
          GestureDetector(
            onTap: () => _deleteWaterEntry(entry['id']),
            child: Icon(Icons.delete_outline, color: Colors.red.shade300, size: 20),
          ),
        ],
      ),
    );
  }

  Future<void> _addWater(int amount) async {
    await _waterService.addWaterIntake(amount: amount);
    if (mounted) {
      setState(() {});
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Added $amount oz of water!'),
          backgroundColor: Color(0xFFA8D8EA),
        ),
      );
    }
  }

  Future<void> _deleteWaterEntry(String id) async {
    await _waterService.deleteWaterEntry(id);
    setState(() {});
  }

  void _showWaterSettings() {
    showDialog(
      context: context,
      builder: (context) => _WaterSettingsDialog(
        currentGoal: _waterService.dailyGoal,
        onGoalChanged: (newGoal) {
          _waterService.updateDailyGoal(newGoal);
          setState(() {});
        },
      ),
    );
  }
}

class _WaterSettingsDialog extends StatefulWidget {
  final int currentGoal;
  final Function(int) onGoalChanged;

  const _WaterSettingsDialog({
    required this.currentGoal,
    required this.onGoalChanged,
  });

  @override
  State<_WaterSettingsDialog> createState() => _WaterSettingsDialogState();
}

class _WaterSettingsDialogState extends State<_WaterSettingsDialog> {
  late int _selectedGoal;
  final List<int> _goalOptions = [6, 8, 10, 12, 14, 16];

  @override
  void initState() {
    super.initState();
    _selectedGoal = widget.currentGoal;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: [Color(0xFFFFF8F5), Color(0xFFFFE0D6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Daily Water Goal',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFFF8A65)),
            ),
            SizedBox(height: 24),
            Text(
              'Select your daily water intake goal:',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
            ),
            SizedBox(height: 20),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _goalOptions.map((goal) {
                final isSelected = _selectedGoal == goal;
                return GestureDetector(
                  onTap: () => setState(() => _selectedGoal = goal),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? Color(0xFFFF8A65) : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? Color(0xFFFF8A65) : Color(0xFFFF8A65).withOpacity( 0.3),
                      ),
                    ),
                    child: Text(
                      '$goal glasses',
                      style: TextStyle(
                        color: isSelected ? Colors.white : Color(0xFFFF8A65),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel', style: TextStyle(color: Colors.grey.shade600)),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [Color(0xFFFF8A65), Color(0xFFFFAB91)]),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        widget.onGoalChanged(_selectedGoal);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      ),
                      child: Text(
                        'Save Goal',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}