import 'package:flutter/material.dart';
import '../models/transaction.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  final List<Transaction> transactions = [
    Transaction(
      id: '1',
      title: 'Groceries',
      amount: 120.0,
      type: TransactionType.expense,
      category: Category.food,
      date: DateTime.now().subtract(const Duration(days: 1)),
      description: 'Weekly grocery shopping',
    ),
    Transaction(
      id: '2',
      title: 'Uber Ride',
      amount: 15.50,
      type: TransactionType.expense,
      category: Category.transport,
      date: DateTime.now().subtract(const Duration(days: 2)),
      description: 'Ride to downtown',
    ),
    Transaction(
      id: '3',
      title: 'Movie Tickets',
      amount: 25.0,
      type: TransactionType.expense,
      category: Category.entertainment,
      date: DateTime.now().subtract(const Duration(days: 3)),
      description: 'Weekend movie night',
    ),
    Transaction(
      id: '4',
      title: 'Salary',
      amount: 5000.0,
      type: TransactionType.income,
      category: Category.salary,
      date: DateTime.now().subtract(const Duration(days: 5)),
    ),
    Transaction(
      id: '5',
      title: 'Electricity Bill',
      amount: 85.0,
      type: TransactionType.expense,
      category: Category.utilities,
      date: DateTime.now().subtract(const Duration(days: 7)),
    ),
    Transaction(
      id: '6',
      title: 'Freelance Project',
      amount: 800.0,
      type: TransactionType.income,
      category: Category.freelance,
      date: DateTime.now().subtract(const Duration(days: 10)),
      description: 'Website development project',
    ),
    Transaction(
      id: '7',
      title: 'Coffee Shop',
      amount: 8.50,
      type: TransactionType.expense,
      category: Category.food,
      date: DateTime.now().subtract(const Duration(days: 12)),
    ),
    Transaction(
      id: '8',
      title: 'Gas Station',
      amount: 45.0,
      type: TransactionType.expense,
      category: Category.transport,
      date: DateTime.now().subtract(const Duration(days: 15)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        title: const Text(
          'Transactions',
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
              // TODO: Implement filter functionality
            },
            icon: const Icon(Icons.filter_list, color: Colors.white),
          ),
        ],
      ),
      body: Column(
        children: [
          // Summary Cards
          _buildSummaryCards(),

          // Transactions List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                return _buildTransactionCard(transaction);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add-transaction');
        },
        backgroundColor: const Color(0xFFFFD700),
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }

  Widget _buildSummaryCards() {
    final totalIncome = transactions
        .where((t) => t.type == TransactionType.income)
        .fold(0.0, (sum, t) => sum + t.amount);

    final totalExpenses = transactions
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (sum, t) => sum + t.amount);

    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _buildSummaryCard(
              title: 'Total Income',
              amount: totalIncome,
              color: Colors.green,
              icon: Icons.trending_up,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildSummaryCard(
              title: 'Total Expenses',
              amount: totalExpenses,
              color: Colors.red,
              icon: Icons.trending_down,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required double amount,
    required Color color,
    required IconData icon,
  }) {
    return Container(
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
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionCard(Transaction transaction) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Category Icon
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color:
                  transaction.type == TransactionType.income
                      ? Colors.green.withOpacity(0.2)
                      : Colors.red.withOpacity(0.2),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Center(
              child: Text(
                transaction.categoryIcon,
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Transaction Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  transaction.categoryDisplayName,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
                if (transaction.description != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    transaction.description!,
                    style: const TextStyle(color: Colors.white60, fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),

          // Amount and Date
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                transaction.formattedAmount,
                style: TextStyle(
                  color:
                      transaction.type == TransactionType.income
                          ? Colors.green
                          : Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                transaction.formattedDate,
                style: const TextStyle(color: Colors.white60, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
