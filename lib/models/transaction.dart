import 'package:intl/intl.dart';

enum TransactionType { income, expense }

enum Category {
  food,
  transport,
  entertainment,
  utilities,
  shopping,
  healthcare,
  education,
  other,
  salary,
  freelance,
  investment,
  gift,
}

class Transaction {
  final String id;
  final String title;
  final double amount;
  final TransactionType type;
  final Category category;
  final DateTime date;
  final String? description;
  final String? location;

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
    this.description,
    this.location,
  });

  String get formattedAmount {
    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    return formatter.format(amount);
  }

  String get formattedDate {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  String get categoryDisplayName {
    switch (category) {
      case Category.food:
        return 'Food';
      case Category.transport:
        return 'Transport';
      case Category.entertainment:
        return 'Entertainment';
      case Category.utilities:
        return 'Utilities';
      case Category.shopping:
        return 'Shopping';
      case Category.healthcare:
        return 'Healthcare';
      case Category.education:
        return 'Education';
      case Category.other:
        return 'Other';
      case Category.salary:
        return 'Salary';
      case Category.freelance:
        return 'Freelance';
      case Category.investment:
        return 'Investment';
      case Category.gift:
        return 'Gift';
    }
  }

  String get categoryIcon {
    switch (category) {
      case Category.food:
        return '🍽️';
      case Category.transport:
        return '🚗';
      case Category.entertainment:
        return '🎬';
      case Category.utilities:
        return '⚡';
      case Category.shopping:
        return '🛍️';
      case Category.healthcare:
        return '🏥';
      case Category.education:
        return '📚';
      case Category.other:
        return '📝';
      case Category.salary:
        return '💰';
      case Category.freelance:
        return '💼';
      case Category.investment:
        return '📈';
      case Category.gift:
        return '🎁';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'type': type.toString(),
      'category': category.toString(),
      'date': date.toIso8601String(),
      'description': description,
      'location': location,
    };
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      title: json['title'],
      amount: (json['amount'] as num).toDouble(),
      type: TransactionType.values.firstWhere(
        (e) => e.toString() == json['type'],
      ),
      category: Category.values.firstWhere(
        (e) => e.toString() == json['category'],
      ),
      date: DateTime.parse(json['date']),
      description: json['description'],
      location: json['location'],
    );
  }
}
