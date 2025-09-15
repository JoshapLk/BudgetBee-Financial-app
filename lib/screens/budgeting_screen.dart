import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class BudgetingScreen extends StatefulWidget {
  const BudgetingScreen({super.key});

  @override
  State<BudgetingScreen> createState() => _BudgetingScreenState();
}

class _BudgetingScreenState extends State<BudgetingScreen> {
  final List<BudgetCategory> budgetCategories = [
    BudgetCategory(
      name: 'Food & Dining',
      budget: 800.0,
      spent: 650.0,
      icon: '🍽️',
      color: Colors.orange,
    ),
    BudgetCategory(
      name: 'Transportation',
      budget: 300.0,
      spent: 245.0,
      icon: '🚗',
      color: Colors.blue,
    ),
    BudgetCategory(
      name: 'Entertainment',
      budget: 200.0,
      spent: 180.0,
      icon: '🎬',
      color: Colors.purple,
    ),
    BudgetCategory(
      name: 'Utilities',
      budget: 150.0,
      spent: 120.0,
      icon: '⚡',
      color: Colors.green,
    ),
    BudgetCategory(
      name: 'Shopping',
      budget: 400.0,
      spent: 320.0,
      icon: '🛍️',
      color: Colors.pink,
    ),
    BudgetCategory(
      name: 'Healthcare',
      budget: 100.0,
      spent: 75.0,
      icon: '🏥',
      color: Colors.red,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final totalBudget = budgetCategories.fold(
      0.0,
      (sum, cat) => sum + cat.budget,
    );
    final totalSpent = budgetCategories.fold(
      0.0,
      (sum, cat) => sum + cat.spent,
    );
    final remaining = totalBudget - totalSpent;

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        title: const Text(
          'Budgeting',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              _showCreateBudgetDialog();
            },
            icon: const Icon(Icons.add, color: Colors.white),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Budget Overview Card
            _buildBudgetOverviewCard(totalBudget, totalSpent, remaining),
            const SizedBox(height: 24),

            // Budget Progress Chart
            _buildBudgetChart(),
            const SizedBox(height: 24),

            // Budget Categories
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Budget Categories',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // TODO: Navigate to detailed budget view
                  },
                  child: const Text(
                    'Manage',
                    style: TextStyle(color: Color(0xFFFFD700), fontSize: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Category List
            ...budgetCategories.map((category) => _buildCategoryCard(category)),
          ],
        ),
      ),
    );
  }

  Widget _buildBudgetOverviewCard(
    double totalBudget,
    double totalSpent,
    double remaining,
  ) {
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
            'Monthly Budget Overview',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w600,
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
                      'Total Budget',
                      style: TextStyle(color: Colors.black87, fontSize: 14),
                    ),
                    Text(
                      '\$${totalBudget.toStringAsFixed(0)}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
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
                      'Spent',
                      style: TextStyle(color: Colors.black87, fontSize: 14),
                    ),
                    Text(
                      '\$${totalSpent.toStringAsFixed(0)}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: totalSpent / totalBudget,
              backgroundColor: Colors.black26,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.black),
              minHeight: 8,
            ),
          ),

          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Remaining: \$${remaining.toStringAsFixed(0)}',
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${((totalSpent / totalBudget) * 100).toStringAsFixed(1)}% used',
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetChart() {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Budget vs Spending',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 1000,
                barTouchData: BarTouchData(enabled: false),
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
                        const categories = [
                          'Food',
                          'Transport',
                          'Entertainment',
                          'Utilities',
                          'Shopping',
                          'Health',
                        ];
                        if (value.toInt() >= 0 &&
                            value.toInt() < categories.length) {
                          return Text(
                            categories[value.toInt()],
                            style: const TextStyle(
                              color: Colors.white70,
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
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 10,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups:
                    budgetCategories.asMap().entries.map((entry) {
                      final index = entry.key;
                      final category = entry.value;
                      return BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(
                            toY: category.budget,
                            color: category.color.withOpacity(0.3),
                            width: 16,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(4),
                              topRight: Radius.circular(4),
                            ),
                          ),
                          BarChartRodData(
                            toY: category.spent,
                            color: category.color,
                            width: 16,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(4),
                              topRight: Radius.circular(4),
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

  Widget _buildCategoryCard(BudgetCategory category) {
    final percentage = (category.spent / category.budget * 100).clamp(0, 100);
    final isOverBudget = category.spent > category.budget;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: category.color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    category.icon,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '\$${category.spent.toStringAsFixed(0)} of \$${category.budget.toStringAsFixed(0)}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              Text(
                '${percentage.toStringAsFixed(0)}%',
                style: TextStyle(
                  color: isOverBudget ? Colors.red : Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (percentage / 100).clamp(0, 1),
              backgroundColor: Colors.white.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(
                isOverBudget ? Colors.red : category.color,
              ),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  void _showCreateBudgetDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color(0xFF2A2A2A),
            title: const Text(
              'Create New Budget',
              style: TextStyle(color: Colors.white),
            ),
            content: const Text(
              'Budget creation feature coming soon!',
              style: TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'OK',
                  style: TextStyle(color: Color(0xFFFFD700)),
                ),
              ),
            ],
          ),
    );
  }
}

class BudgetCategory {
  final String name;
  final double budget;
  final double spent;
  final String icon;
  final Color color;

  BudgetCategory({
    required this.name,
    required this.budget,
    required this.spent,
    required this.icon,
    required this.color,
  });
}
