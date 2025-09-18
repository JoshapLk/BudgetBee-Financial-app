import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/goal.dart';
import 'add_goal_screen.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  List<Goal> _goals = [];
  bool _showCompletedGoals = false;
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _loadMockGoals();
  }

  void _loadMockGoals() {
    // Mock data - in a real app, this would come from a database
    setState(() {
      _goals = [
        Goal(
          id: '1',
          title: 'Emergency Fund',
          targetAmount: 10000.0,
          currentAmount: 7500.0,
          targetDate: DateTime(2024, 12, 31),
          createdAt: DateTime(2024, 1, 1),
          status: GoalStatus.active,
          category: GoalCategory.emergency,
          color: Colors.green,
          icon: Icons.savings,
        ),
        Goal(
          id: '2',
          title: 'Vacation Fund',
          targetAmount: 5000.0,
          currentAmount: 3200.0,
          targetDate: DateTime(2024, 8, 15),
          createdAt: DateTime(2024, 2, 1),
          status: GoalStatus.active,
          category: GoalCategory.vacation,
          color: Colors.blue,
          icon: Icons.flight,
        ),
        Goal(
          id: '3',
          title: 'New Car',
          targetAmount: 25000.0,
          currentAmount: 12000.0,
          targetDate: DateTime(2025, 6, 30),
          createdAt: DateTime(2024, 3, 1),
          status: GoalStatus.active,
          category: GoalCategory.vehicle,
          color: Colors.purple,
          icon: Icons.directions_car,
        ),
        Goal(
          id: '4',
          title: 'Laptop Purchase',
          targetAmount: 1500.0,
          currentAmount: 1500.0,
          targetDate: DateTime(2024, 2, 15),
          createdAt: DateTime(2024, 1, 1),
          status: GoalStatus.completed,
          category: GoalCategory.education,
          color: Colors.orange,
          icon: Icons.laptop,
        ),
        Goal(
          id: '5',
          title: 'Gym Membership',
          targetAmount: 300.0,
          currentAmount: 300.0,
          targetDate: DateTime(2024, 1, 10),
          createdAt: DateTime(2023, 12, 1),
          status: GoalStatus.completed,
          category: GoalCategory.health,
          color: Colors.red,
          icon: Icons.fitness_center,
        ),
      ];
    });
  }

  void _addNewGoal(Goal goal) {
    setState(() {
      _goals.add(goal);
    });
  }

  List<Goal> get _activeGoals {
    var goals =
        _goals.where((goal) => goal.status == GoalStatus.active).toList();

    // Filter by category
    if (_selectedCategory != 'All') {
      goals =
          goals
              .where((goal) => goal.categoryDisplayName == _selectedCategory)
              .toList();
    }

    // Sort by deadline (nearest first)
    goals.sort((a, b) => a.targetDate.compareTo(b.targetDate));

    return goals;
  }

  List<Goal> get _completedGoals {
    var goals =
        _goals.where((goal) => goal.status == GoalStatus.completed).toList();

    // Filter by category
    if (_selectedCategory != 'All') {
      goals =
          goals
              .where((goal) => goal.categoryDisplayName == _selectedCategory)
              .toList();
    }

    // Sort by completion date (most recent first)
    goals.sort((a, b) => b.targetDate.compareTo(a.targetDate));

    return goals;
  }

  List<String> get _availableCategories {
    final categories =
        _goals.map((goal) => goal.categoryDisplayName).toSet().toList();
    categories.sort();
    return ['All', ...categories];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Financial Goals',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _showFilterDialog();
            },
            icon: const Icon(Icons.filter_list),
          ),
          IconButton(
            onPressed: () {
              _showAddGoalDialog();
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Goals Overview
            _buildGoalsOverview(),
            const SizedBox(height: 24),

            // Active Goals
            _buildSection(
              title: 'Active Goals',
              children:
                  _activeGoals.isEmpty
                      ? [
                        _buildEmptyState(
                          'No active goals yet',
                          'Create your first goal to get started!',
                        ),
                      ]
                      : _activeGoals
                          .map((goal) => _buildGoalCardFromModel(goal))
                          .toList(),
            ),
            const SizedBox(height: 24),

            // Completed Goals (Expandable)
            _buildExpandableSection(
              title: 'Completed Goals',
              isExpanded: _showCompletedGoals,
              onToggle: () {
                setState(() {
                  _showCompletedGoals = !_showCompletedGoals;
                });
              },
              children:
                  _completedGoals.isEmpty
                      ? [
                        _buildEmptyState(
                          'No completed goals yet',
                          'Complete your first goal to see it here!',
                        ),
                      ]
                      : _completedGoals
                          .map((goal) => _buildCompletedGoalCardFromModel(goal))
                          .toList(),
            ),
            const SizedBox(height: 24),

            // Savings Progress Chart
            _buildSavingsChart(),
            const SizedBox(height: 24),

            // Tips Section
            _buildTipsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalsOverview() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFD700), Color(0xFFFFE55C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Goals Overview',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Goals',
                      style: TextStyle(color: Colors.black87, fontSize: 14),
                    ),
                    Text(
                      '${_goals.length}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Completed',
                      style: TextStyle(color: Colors.black87, fontSize: 14),
                    ),
                    Text(
                      '${_completedGoals.length}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Active',
                      style: TextStyle(color: Colors.black87, fontSize: 14),
                    ),
                    Text(
                      '${_activeGoals.length}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Gamification Section
          _buildGamificationSection(),

          const SizedBox(height: 16),

          // Overall Progress
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value:
                  _goals.isEmpty
                      ? 0.0
                      : (_completedGoals.length / _goals.length),
              backgroundColor: Colors.black26,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.black),
              minHeight: 8,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            _goals.isEmpty
                ? 'No goals set yet'
                : '${((_completedGoals.length / _goals.length) * 100).toStringAsFixed(0)}% of total goals completed',
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge?.color,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...children.map(
          (child) =>
              Padding(padding: const EdgeInsets.only(bottom: 12), child: child),
        ),
      ],
    );
  }

  Widget _buildGoalCardFromModel(Goal goal) {
    return _buildGoalCard(
      title: goal.title,
      target: goal.targetAmount,
      current: goal.currentAmount,
      deadline: goal.targetDate,
      color: goal.color,
      icon: goal.icon,
    );
  }

  Widget _buildCompletedGoalCardFromModel(Goal goal) {
    return _buildCompletedGoalCard(
      title: goal.title,
      amount: goal.targetAmount,
      completedDate: goal.targetDate,
      color: goal.color,
      icon: goal.icon,
    );
  }

  Widget _buildGamificationSection() {
    final completedCount = _completedGoals.length;
    final streakDays = 5; // Mock streak data

    return Row(
      children: [
        // Streak Counter
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.local_fire_department,
                  color: Colors.orange,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$streakDays',
                      style: const TextStyle(
                        color: Colors.orange,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'Day Streak',
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),

        // Achievement Badges
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.purple.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.emoji_events, color: Colors.purple, size: 20),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$completedCount',
                      style: const TextStyle(
                        color: Colors.purple,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'Goals Done',
                      style: TextStyle(
                        color: Colors.purple,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMonthlySuggestion(double remaining, int daysLeft) {
    if (daysLeft <= 0) return const SizedBox.shrink();

    final monthsLeft = (daysLeft / 30).ceil();
    final monthlyAmount = (remaining / monthsLeft).ceil();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'Save \$${monthlyAmount}/month',
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildEmptyState(String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.flag_outlined,
              size: 64,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyLarge?.color,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            subtitle,
            style: TextStyle(
              color: Theme.of(context).textTheme.bodySmall?.color,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showAddGoalDialog(),
            icon: const Icon(Icons.add),
            label: const Text('Start Your First Goal Today!'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalCard({
    required String title,
    required double target,
    required double current,
    required DateTime deadline,
    required Color color,
    required IconData icon,
  }) {
    final progress = (current / target).clamp(0.0, 1.0);
    final remaining = target - current;
    final daysLeft = deadline.difference(DateTime.now()).inDays;
    final progressPercentage = (progress * 100).round();

    // Color-code progress
    Color progressColor;
    if (progressPercentage < 30) {
      progressColor = Colors.red;
    } else if (progressPercentage < 70) {
      progressColor = Colors.orange;
    } else {
      progressColor = Colors.green;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '\$${current.toStringAsFixed(0)} of \$${target.toStringAsFixed(0)}',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodySmall?.color,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Remaining: \$${remaining.toStringAsFixed(0)}',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodySmall?.color,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    _buildMonthlySuggestion(remaining, daysLeft),
                  ],
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: progressColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$progressPercentage%',
                      style: TextStyle(
                        color: progressColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${daysLeft}d left',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodySmall?.color,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Progress Bar with percentage label
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor:
                        Theme.of(
                          context,
                        ).textTheme.bodySmall?.color?.withOpacity(0.1) ??
                        Colors.grey.withOpacity(0.1),
                    valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                    minHeight: 8,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '$progressPercentage%',
                style: TextStyle(
                  color: progressColor,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Due: ${deadline.day}/${deadline.month}/${deadline.year}',
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                  fontSize: 14,
                ),
              ),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _showAddSavingsDialog(title, remaining),
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('Add Savings'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      textStyle: const TextStyle(fontSize: 12),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed:
                        () => _showEditGoalDialog(title, target, deadline),
                    icon: const Icon(Icons.edit, size: 18),
                    style: IconButton.styleFrom(
                      backgroundColor: Theme.of(
                        context,
                      ).primaryColor.withOpacity(0.1),
                      foregroundColor: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompletedGoalCard({
    required String title,
    required double amount,
    required DateTime completedDate,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.green.withOpacity(0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              Positioned(
                top: -2,
                right: -2,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 16),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        '✅ COMPLETED',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  '\$${amount.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Completed on ${completedDate.day}/${completedDate.month}/${completedDate.year}',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSavingsChart() {
    // Calculate dynamic max Y based on actual data
    final monthlyData = [1200, 1500, 1800, 1600, 2000, 2200];
    final maxY = monthlyData.reduce((a, b) => a > b ? a : b).toDouble() + 200;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Monthly Savings Progress',
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyLarge?.color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),

          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxY,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (group) => Theme.of(context).cardColor,
                    tooltipRoundedRadius: 8,
                    tooltipPadding: const EdgeInsets.all(8),
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
                      return BarTooltipItem(
                        '${months[group.x]}\n\$${rod.toY.toStringAsFixed(0)}',
                        TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const months = [
                          'Jan',
                          'Feb',
                          'Mar',
                          'Apr',
                          'May',
                          'Jun',
                        ];
                        if (value.toInt() >= 0 &&
                            value.toInt() < months.length) {
                          return Text(
                            months[value.toInt()],
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodySmall?.color,
                              fontSize: 10,
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '\$${value.toInt()}',
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodySmall?.color,
                            fontSize: 10,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups:
                    monthlyData.asMap().entries.map((entry) {
                      final index = entry.key;
                      final value = entry.value;

                      return BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(
                            toY: value.toDouble(),
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFFD700), Color(0xFF4CAF50)],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                            width: 24,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(6),
                              topRight: Radius.circular(6),
                            ),
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

  Widget _buildTipsSection() {
    final tips = [
      {
        'title': 'Set SMART Goals',
        'description': 'Specific, Measurable, Achievable, Relevant, Time-bound',
        'icon': Icons.flag,
        'color': Colors.blue,
      },
      {
        'title': 'Automate Savings',
        'description': 'Set up automatic transfers to reach goals faster',
        'icon': Icons.autorenew,
        'color': Colors.green,
      },
      {
        'title': 'Review Regularly',
        'description': 'Check and adjust your goals monthly',
        'icon': Icons.update,
        'color': Colors.orange,
      },
      {
        'title': 'Celebrate Milestones',
        'description': 'Reward yourself for small achievements',
        'icon': Icons.celebration,
        'color': Colors.purple,
      },
      {
        'title': '50/30/20 Rule',
        'description': 'Allocate 50% needs, 30% wants, 20% savings',
        'icon': Icons.pie_chart,
        'color': Colors.red,
      },
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb,
                color: Theme.of(context).primaryColor,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Savings Tips',
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          SizedBox(
            height: 120,
            child: PageView.builder(
              itemCount: tips.length,
              itemBuilder: (context, index) {
                final tip = tips[index];
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: (tip['color'] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: (tip['color'] as Color).withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: (tip['color'] as Color).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              tip['icon'] as IconData,
                              color: tip['color'] as Color,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              tip['title'] as String,
                              style: TextStyle(
                                color:
                                    Theme.of(
                                      context,
                                    ).textTheme.bodyLarge?.color,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        tip['description'] as String,
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                          fontSize: 14,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          // Page indicator
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                tips.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddGoalDialog() async {
    final result = await Navigator.push<Goal>(
      context,
      MaterialPageRoute(builder: (context) => const AddGoalScreen()),
    );

    if (result != null) {
      _addNewGoal(result);
    }
  }

  Widget _buildExpandableSection({
    required String title,
    required bool isExpanded,
    required VoidCallback onToggle,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onToggle,
          child: Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Icon(
                isExpanded ? Icons.expand_less : Icons.expand_more,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (isExpanded)
          ...children.map(
            (child) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: child,
            ),
          ),
      ],
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Filter Goals'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Filter by Category:'),
                const SizedBox(height: 16),
                ..._availableCategories.map(
                  (category) => RadioListTile<String>(
                    title: Text(category),
                    value: category,
                    groupValue: _selectedCategory,
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value!;
                      });
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
            ],
          ),
    );
  }

  void _showAddSavingsDialog(String goalTitle, double remaining) {
    final amountController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Add Savings to $goalTitle'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Remaining: \$${remaining.toStringAsFixed(0)}'),
                const SizedBox(height: 16),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Amount to add',
                    prefixText: '\$ ',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  final amount = double.tryParse(amountController.text);
                  if (amount != null && amount > 0) {
                    // TODO: Update goal with new savings
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Added \$${amount.toStringAsFixed(0)} to $goalTitle!',
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text('Add'),
              ),
            ],
          ),
    );
  }

  void _showEditGoalDialog(String goalTitle, double target, DateTime deadline) {
    final targetController = TextEditingController(
      text: target.toStringAsFixed(0),
    );
    DateTime selectedDate = deadline;

    showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setState) => AlertDialog(
                  title: Text('Edit $goalTitle'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: targetController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Target Amount',
                          prefixText: '\$ ',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      InkWell(
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(
                              const Duration(days: 3650),
                            ),
                          );
                          if (picked != null) {
                            setState(() {
                              selectedDate = picked;
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Theme.of(context).dividerColor,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_today),
                              const SizedBox(width: 12),
                              Text(
                                '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        final newTarget = double.tryParse(
                          targetController.text,
                        );
                        if (newTarget != null && newTarget > 0) {
                          // TODO: Update goal with new target and deadline
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Updated $goalTitle!'),
                              backgroundColor: Colors.blue,
                            ),
                          );
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('Save'),
                    ),
                  ],
                ),
          ),
    );
  }
}
