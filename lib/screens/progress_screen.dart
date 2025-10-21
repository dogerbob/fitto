import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fitto/services/progress_service.dart';
import 'package:fitto/utils/localizations.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/rendering.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> with SingleTickerProviderStateMixin {
  final ProgressService _progressService = ProgressService();
  bool _isLoading = true;
  late TabController _tabController;
  final GlobalKey _captureKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _initialize();
  }

  Future<void> _initialize() async {
    await _progressService.initialize();
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = 'en';

    return Scaffold(
      body: SafeArea(
        child: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(AppLocalizations.get('progress', locale), style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                      ),
                      IconButton(
                        tooltip: 'Share',
                        icon: Icon(Icons.ios_share, color: Color(0xFFFFB4C8)),
                        onPressed: _shareProgress,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        gradient: LinearGradient(colors: [Color(0xFFFFB4C8), Color(0xFFE8C5E5)]),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.grey.shade600,
                      dividerColor: Colors.transparent,
                      tabs: [
                        Tab(text: AppLocalizations.get('weight', locale)),
                        Tab(text: AppLocalizations.get('water', locale)),
                        Tab(text: AppLocalizations.get('steps', locale)),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: RepaintBoundary(
                    key: _captureKey,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildWeightChart(),
                        _buildWaterChart(),
                        _buildStepsChart(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
      ),
    );
  }

  Widget _buildWeightChart() {
    final entries = _progressService.getEntriesByType('weight');
    if (entries.isEmpty) return _buildEmptyState('No weight data');

    entries.sort((a, b) => a.date.compareTo(b.date));
    final spots = entries.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.value)).toList();

    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Color(0xFFFFB4C8), Color(0xFFE8C5E5)]),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Text('Current Weight', style: TextStyle(color: Colors.white.withOpacity( 0.9), fontSize: 14)),
                SizedBox(height: 8),
                Text('${entries.last.value} kg', style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          SizedBox(height: 24),
          Text('Weight Trend', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40)),
                  bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: Color(0xFFFFB4C8),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Color(0xFFFFB4C8).withOpacity( 0.2),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWaterChart() {
    final entries = _progressService.getEntriesByType('water');
    if (entries.isEmpty) return _buildEmptyState('No water data');

    entries.sort((a, b) => a.date.compareTo(b.date));
    final spots = entries.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.value)).toList();

    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Color(0xFFA8D8EA), Color(0xFF7FBFD4)]),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Text('Today\'s Water', style: TextStyle(color: Colors.white.withOpacity( 0.9), fontSize: 14)),
                SizedBox(height: 8),
                Text('${entries.last.value.toInt()} glasses', style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          SizedBox(height: 24),
          Text('Water Intake', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          Expanded(
            child: BarChart(
              BarChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40)),
                  bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                barGroups: spots.map((spot) {
                  return BarChartGroupData(
                    x: spot.x.toInt(),
                    barRods: [
                      BarChartRodData(
                        toY: spot.y,
                        color: Color(0xFFA8D8EA),
                        width: 20,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepsChart() {
    final entries = _progressService.getEntriesByType('steps');
    if (entries.isEmpty) return _buildEmptyState('No steps data');

    entries.sort((a, b) => a.date.compareTo(b.date));
    final spots = entries.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.value)).toList();

    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Color(0xFFE8C5E5), Color(0xFFD4A5D1)]),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Text('Today\'s Steps', style: TextStyle(color: Colors.white.withOpacity( 0.9), fontSize: 14)),
                SizedBox(height: 8),
                Text('${entries.last.value.toInt()}', style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          SizedBox(height: 24),
          Text('Step Count', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 50)),
                  bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: Color(0xFFE8C5E5),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Color(0xFFE8C5E5).withOpacity( 0.2),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.insert_chart_outlined, size: 64, color: Colors.grey.shade400),
          SizedBox(height: 16),
          Text(message, style: TextStyle(fontSize: 16, color: Colors.grey.shade600)),
        ],
      ),
    );
  }

  Future<void> _shareProgress() async {
    try {
      final boundary = _captureKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return;
      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return;
      final Uint8List bytes = byteData.buffer.asUint8List();
      final xfile = XFile.fromData(bytes, mimeType: 'image/png', name: 'fitto_progress.png');
      await SharePlus.instance.share(ShareParams(
        text: 'My progress with Fitto',
        subject: 'Fitto Progress',
        files: [xfile],
      ));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Unable to share right now')));
    }
  }

}
