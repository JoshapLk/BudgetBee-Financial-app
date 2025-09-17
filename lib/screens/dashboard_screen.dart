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
              const SizedBox(height: 24),

              // Recent Transactions
              _buildRecentTransactions(),
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
          backgroundColor: Theme.of(context).primaryColor,
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
              Text(
                'Welcome back!',
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                  fontSize: 14,
                ),
              ),
              Text(
                currentUser.name,
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
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
          icon: Icon(
            Icons.settings,
            color: Theme.of(context).textTheme.bodyLarge?.color,
            size: 24,
          ),
        ),
      ],
    );
  }

  Widget _buildTotalBalanceCard() {
    // Calculate savings rate
    final savingsRate =
        currentUser.monthlyIncome > 0
            ? ((currentUser.monthlyIncome - currentUser.monthlyExpenses) /
                currentUser.monthlyIncome *
                100)
            : 0.0;

    // Mock previous month balance for comparison
    final previousMonthBalance =
        currentUser.totalBalance - 500.0; // Simulate growth
    final balanceChange = currentUser.totalBalance - previousMonthBalance;
    final balanceChangePercent =
        previousMonthBalance > 0
            ? (balanceChange / previousMonthBalance * 100)
            : 0.0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Balance',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              // Monthly comparison indicator
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color:
                      balanceChange >= 0
                          ? Colors.green.withOpacity(0.2)
                          : Colors.red.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      balanceChange >= 0
                          ? Icons.trending_up
                          : Icons.trending_down,
                      color:
                          balanceChange >= 0
                              ? Colors.green.shade700
                              : Colors.red.shade700,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${balanceChangePercent.abs().toStringAsFixed(1)}%',
                      style: TextStyle(
                        color:
                            balanceChange >= 0
                                ? Colors.green.shade700
                                : Colors.red.shade700,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
          const SizedBox(height: 12),

          // Savings rate indicator
          Row(
            children: [
              Icon(
                Icons.savings,
                color: Colors.black.withOpacity(0.7),
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                'Savings Rate: ${savingsRate.toStringAsFixed(1)}%',
                style: TextStyle(
                  color: Colors.black.withOpacity(0.7),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Text(
                '\$${(currentUser.monthlyIncome - currentUser.monthlyExpenses).toStringAsFixed(0)}/month',
                style: TextStyle(
                  color: Colors.black.withOpacity(0.7),
                  fontSize: 12,
                ),
              ),
            ],
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
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              color: Theme.of(context).textTheme.bodySmall?.color,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '\$${amount.toStringAsFixed(0)}',
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyLarge?.color,
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
            Text(
              'Category Breakdown',
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge?.color,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            GestureDetector(
              onTap: () {
                // TODO: Navigate to detailed breakdown
              },
              child: Text(
                'View All',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
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
              pieTouchData: PieTouchData(
                enabled: true,
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  if (event is FlTapUpEvent &&
                      pieTouchResponse?.touchedSection != null) {
                    final touchedSection = pieTouchResponse!.touchedSection!;
                    final categoryIndex = touchedSection.touchedSectionIndex;
                    _showCategoryDetails(categoryIndex);
                  }
                },
              ),
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
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Text(
                    '\$${category['amount']}',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodySmall?.color,
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
        Text(
          'Monthly Trends',
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge?.color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),

        // Legend for the dual lines
        Row(
          children: [
            _buildTrendLegendItem('Income', Colors.green, Icons.trending_up),
            const SizedBox(width: 24),
            _buildTrendLegendItem('Expenses', Colors.red, Icons.trending_down),
          ],
        ),
        const SizedBox(height: 16),

        SizedBox(
          height: 200,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: 1000,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: Theme.of(context).dividerColor.withOpacity(0.3),
                    strokeWidth: 1,
                  );
                },
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
                    reservedSize: 30,
                    interval: 1,
                    getTitlesWidget: (double value, TitleMeta meta) {
                      const style = TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      );
                      Widget text;
                      switch (value.toInt()) {
                        case 0:
                          text = const Text('Jan', style: style);
                          break;
                        case 1:
                          text = const Text('Feb', style: style);
                          break;
                        case 2:
                          text = const Text('Mar', style: style);
                          break;
                        case 3:
                          text = const Text('Apr', style: style);
                          break;
                        case 4:
                          text = const Text('May', style: style);
                          break;
                        case 5:
                          text = const Text('Jun', style: style);
                          break;
                        default:
                          text = const Text('', style: style);
                          break;
                      }
                      return SideTitleWidget(
                        axisSide: meta.axisSide,
                        child: text,
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1000,
                    getTitlesWidget: (double value, TitleMeta meta) {
                      return Text(
                        '\$${(value / 1000).toStringAsFixed(0)}k',
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                          fontSize: 10,
                        ),
                      );
                    },
                    reservedSize: 42,
                  ),
                ),
              ),
              borderData: FlBorderData(
                show: true,
                border: Border.all(
                  color: Theme.of(context).dividerColor.withOpacity(0.3),
                  width: 1,
                ),
              ),
              lineBarsData: [
                // Income line (green)
                LineChartBarData(
                  spots: const [
                    FlSpot(0, 4800),
                    FlSpot(1, 5200),
                    FlSpot(2, 5000),
                    FlSpot(3, 4800),
                    FlSpot(4, 5200),
                    FlSpot(5, 5000),
                  ],
                  isCurved: true,
                  color: Colors.green,
                  barWidth: 3,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) {
                      return FlDotCirclePainter(
                        radius: 4,
                        color: Colors.green,
                        strokeWidth: 2,
                        strokeColor: Colors.white,
                      );
                    },
                  ),
                  belowBarData: BarAreaData(show: false),
                ),
                // Expenses line (red)
                LineChartBarData(
                  spots: const [
                    FlSpot(0, 2200),
                    FlSpot(1, 2400),
                    FlSpot(2, 2600),
                    FlSpot(3, 2300),
                    FlSpot(4, 2500),
                    FlSpot(5, 2500),
                  ],
                  isCurved: true,
                  color: Colors.red,
                  barWidth: 3,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) {
                      return FlDotCirclePainter(
                        radius: 4,
                        color: Colors.red,
                        strokeWidth: 2,
                        strokeColor: Colors.white,
                      );
                    },
                  ),
                  belowBarData: BarAreaData(show: false),
                ),
              ],
              lineTouchData: LineTouchData(
                enabled: true,
                touchTooltipData: LineTouchTooltipData(
                  getTooltipColor: (touchedSpot) => Theme.of(context).cardColor,
                  tooltipRoundedRadius: 8,
                  tooltipPadding: const EdgeInsets.all(8),
                  getTooltipItems: (touchedSpots) {
                    return touchedSpots.map((touchedSpot) {
                      final isIncome = touchedSpot.barIndex == 0;
                      final color = isIncome ? Colors.green : Colors.red;
                      final label = isIncome ? 'Income' : 'Expenses';

                      return LineTooltipItem(
                        '$label: \$${touchedSpot.y.toStringAsFixed(0)}',
                        TextStyle(
                          color: color,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      );
                    }).toList();
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTrendLegendItem(String label, Color color, IconData icon) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge?.color,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildRecentTransactions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Transactions',
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge?.color,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/transactions');
              },
              child: Text(
                'View All',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Show recent transactions or empty state
        if (recentTransactions.isEmpty)
          _buildEmptyTransactionsState()
        else
          SizedBox(
            height: 300, // Fixed height for ListView
            child: ListView.builder(
              itemCount:
                  recentTransactions.length > 5 ? 5 : recentTransactions.length,
              itemBuilder: (context, index) {
                final tx = recentTransactions[index];
                return _buildTransactionTile(tx);
              },
            ),
          ),
      ],
    );
  }

  Widget _buildTransactionTile(Transaction tx) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Transaction type icon
          CircleAvatar(
            radius: 20,
            backgroundColor:
                tx.type == TransactionType.expense
                    ? Colors.red.withOpacity(0.1)
                    : Colors.green.withOpacity(0.1),
            child: Icon(
              tx.type == TransactionType.expense
                  ? Icons.arrow_downward
                  : Icons.arrow_upward,
              color:
                  tx.type == TransactionType.expense
                      ? Colors.red
                      : Colors.green,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),

          // Transaction details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tx.title,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '${tx.date.day}/${tx.date.month}/${tx.date.year} • ${tx.category.name}',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          // Amount
          Text(
            '${tx.type == TransactionType.expense ? '-' : '+'}\$${tx.amount.toStringAsFixed(2)}',
            style: TextStyle(
              color:
                  tx.type == TransactionType.expense
                      ? Colors.red
                      : Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  void _showCategoryDetails(int categoryIndex) {
    final categories = [
      {'category': 'Food', 'amount': 1200.0, 'color': Colors.orange},
      {'category': 'Transport', 'amount': 500.0, 'color': Colors.green},
      {'category': 'Entertainment', 'amount': 400.0, 'color': Colors.blue},
      {'category': 'Utilities', 'amount': 300.0, 'color': Colors.purple},
      {'category': 'Other', 'amount': 100.0, 'color': Colors.grey},
    ];

    if (categoryIndex >= 0 && categoryIndex < categories.length) {
      final category = categories[categoryIndex];
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('${category['category']} Details'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Amount: \$${category['amount']}'),
                const SizedBox(height: 8),
                Text('Category: ${category['category']}'),
                const SizedBox(height: 8),
                Text(
                  'This shows detailed breakdown for ${category['category']} category. '
                  'In a real app, this would navigate to a detailed expenses page.',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // TODO: Navigate to detailed category breakdown page
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Navigating to ${category['category']} details...',
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: category['color'] as Color,
                  foregroundColor: Colors.white,
                ),
                child: const Text('View Details'),
              ),
            ],
          );
        },
      );
    }
  }

  Widget _buildEmptyTransactionsState() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(
            Icons.account_balance_wallet_outlined,
            size: 64,
            color: Theme.of(
              context,
            ).textTheme.bodySmall?.color?.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No transactions yet',
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyLarge?.color,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start by adding your first expense or income!',
            style: TextStyle(
              color: Theme.of(context).textTheme.bodySmall?.color,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/add-transaction');
            },
            icon: const Icon(Icons.add),
            label: const Text('Add Transaction'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
