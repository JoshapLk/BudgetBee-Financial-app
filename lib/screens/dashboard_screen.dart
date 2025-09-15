import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/transaction.dart';
import '../models/user.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Mock data - in a real app, this would come from a database or API
  final User currentUser = User(
    id: '1',
    email: 'sophia.carter@email.com',
    name: 'Sophia Carter',
    photoUrl: null,
    createdAt: DateTime.now(),
    totalBalance: 12345.67,
    monthlyIncome: 5000.0,
    monthlyExpenses: 2500.0,
  );

  final List<Transaction> recentTransactions = [
    Transaction(
      id: '1',
      title: 'Groceries',
      amount: 120.0,
      type: TransactionType.expense,
      category: Category.food,
      date: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Transaction(
      id: '2',
      title: 'Uber Ride',
      amount: 15.50,
      type: TransactionType.expense,
      category: Category.transport,
      date: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Transaction(
      id: '3',
      title: 'Movie Tickets',
      amount: 25.0,
      type: TransactionType.expense,
      category: Category.entertainment,
      date: DateTime.now().subtract(const Duration(days: 3)),
    ),
    Transaction(
      id: '4',
      title: 'Salary',
      amount: 5000.0,
      type: TransactionType.income,
      category: Category.salary,
      date: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with profile and settings
              _buildHeader(),
              const SizedBox(height: 24),

              // Total Balance Card
              _buildTotalBalanceCard(),
              const SizedBox(height: 20),

              // Income and Expenses Cards
              _buildIncomeExpenseCards(),
              const SizedBox(height: 24),

              // Category Breakdown
              _buildCategoryBreakdown(),
              const SizedBox(height: 24),

              // Monthly Trends
              _buildMonthlyTrends(),
              const SizedBox(height: 100), // Space for bottom navigation
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        // Profile Picture
        CircleAvatar(
          radius: 25,
          backgroundColor: const Color(0xFFFFD700),
          child: Text(
            currentUser.name.split(' ').map((e) => e[0]).join(),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 16),

        // Welcome Text
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome back!',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              Text(
                currentUser.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        // Settings Icon
        IconButton(
          onPressed: () {
            Navigator.pushNamed(context, '/settings');
          },
          icon: const Icon(Icons.settings, color: Colors.white, size: 24),
        ),
      ],
    );
  }

  Widget _buildTotalBalanceCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFFFD700),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Total Balance',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '\$${currentUser.totalBalance.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIncomeExpenseCards() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Icons.trending_up,
            iconColor: Colors.green,
            title: 'Income',
            amount: currentUser.monthlyIncome,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            icon: Icons.trending_down,
            iconColor: Colors.red,
            title: 'Expenses',
            amount: currentUser.monthlyExpenses,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required double amount,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            '\$${amount.toStringAsFixed(0)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBreakdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Category Breakdown',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            GestureDetector(
              onTap: () {
                // TODO: Navigate to detailed breakdown
              },
              child: const Text(
                'View All',
                style: TextStyle(
                  color: Color(0xFFFFD700),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Pie Chart
        SizedBox(
          height: 200,
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 40,
              sections: _getPieChartSections(),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Legend
        _buildCategoryLegend(),
      ],
    );
  }

  List<PieChartSectionData> _getPieChartSections() {
    final categories = [
      {'category': 'Food', 'amount': 1200.0, 'color': Colors.orange},
      {'category': 'Transport', 'amount': 500.0, 'color': Colors.green},
      {'category': 'Entertainment', 'amount': 400.0, 'color': Colors.blue},
      {'category': 'Utilities', 'amount': 300.0, 'color': Colors.purple},
      {'category': 'Other', 'amount': 100.0, 'color': Colors.grey},
    ];

    double total = categories.fold(
      0.0,
      (sum, item) => sum + (item['amount'] as double),
    );

    return categories.map((item) {
      final amount = item['amount'] as double;
      final percentage = (amount / total * 100).round();
      return PieChartSectionData(
        color: item['color'] as Color,
        value: amount,
        title: '$percentage%',
        radius: 80,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  Widget _buildCategoryLegend() {
    final categories = [
      {'name': 'Food', 'amount': 1200.0, 'color': Colors.orange},
      {'name': 'Transport', 'amount': 500.0, 'color': Colors.green},
      {'name': 'Entertainment', 'amount': 400.0, 'color': Colors.blue},
      {'name': 'Utilities', 'amount': 300.0, 'color': Colors.purple},
      {'name': 'Other', 'amount': 100.0, 'color': Colors.grey},
    ];

    return Column(
      children:
          categories.map((category) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: category['color'] as Color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      category['name'] as String,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                  Text(
                    '\$${category['amount']}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
    );
  }

  Widget _buildMonthlyTrends() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Monthly Trends',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),

        SizedBox(
          height: 200,
          child: LineChart(
            LineChartData(
              gridData: const FlGridData(show: false),
              titlesData: const FlTitlesData(show: false),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: [
                    const FlSpot(0, 8000),
                    const FlSpot(1, 8500),
                    const FlSpot(2, 9200),
                    const FlSpot(3, 8800),
                    const FlSpot(4, 10500),
                    const FlSpot(5, 12345),
                  ],
                  isCurved: true,
                  color: const Color(0xFFFFD700),
                  barWidth: 3,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    color: const Color(0xFFFFD700).withOpacity(0.1),
                  ),
                ),
              ],
              lineTouchData: LineTouchData(
                enabled: true,
                touchTooltipData: LineTouchTooltipData(
                  getTooltipColor: (touchedSpot) => const Color(0xFF2A2A2A),
                  tooltipRoundedRadius: 8,
                  tooltipPadding: const EdgeInsets.all(8),
                ),
              ),
            ),
          ),
        ),

        // Month labels
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('Jan', style: TextStyle(color: Colors.white70, fontSize: 12)),
            Text('Feb', style: TextStyle(color: Colors.white70, fontSize: 12)),
            Text('Mar', style: TextStyle(color: Colors.white70, fontSize: 12)),
            Text('Apr', style: TextStyle(color: Colors.white70, fontSize: 12)),
            Text('May', style: TextStyle(color: Colors.white70, fontSize: 12)),
            Text('Jun', style: TextStyle(color: Colors.white70, fontSize: 12)),
          ],
        ),
      ],
    );
  }
}
