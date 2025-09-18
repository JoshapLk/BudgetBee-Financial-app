import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum GoalStatus { active, completed, paused }

enum GoalCategory {
  emergency,
  vacation,
  education,
  home,
  vehicle,
  health,
  entertainment,
  investment,
  other,
}

class Goal {
  final String id;
  final String title;
  final String? description;
  final double targetAmount;
  final double currentAmount;
  final DateTime targetDate;
  final DateTime createdAt;
  final GoalStatus status;
  final GoalCategory category;
  final Color color;
  final IconData icon;

  Goal({
    required this.id,
    required this.title,
    this.description,
    required this.targetAmount,
    required this.currentAmount,
    required this.targetDate,
    required this.createdAt,
    required this.status,
    required this.category,
    required this.color,
    required this.icon,
  });

  // Copy with method for updating goals
  Goal copyWith({
    String? id,
    String? title,
    String? description,
    double? targetAmount,
    double? currentAmount,
    DateTime? targetDate,
    DateTime? createdAt,
    GoalStatus? status,
    GoalCategory? category,
    Color? color,
    IconData? icon,
  }) {
    return Goal(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      targetAmount: targetAmount ?? this.targetAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      targetDate: targetDate ?? this.targetDate,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      category: category ?? this.category,
      color: color ?? this.color,
      icon: icon ?? this.icon,
    );
  }

  // Getters for calculated values
  double get progressPercentage =>
      (currentAmount / targetAmount).clamp(0.0, 1.0);

  double get remainingAmount => targetAmount - currentAmount;

  int get daysRemaining => targetDate.difference(DateTime.now()).inDays;

  bool get isCompleted =>
      status == GoalStatus.completed || currentAmount >= targetAmount;

  bool get isOverdue => daysRemaining < 0 && !isCompleted;

  // Formatted strings
  String get formattedTargetAmount {
    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 0);
    return formatter.format(targetAmount);
  }

  String get formattedCurrentAmount {
    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 0);
    return formatter.format(currentAmount);
  }

  String get formattedRemainingAmount {
    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 0);
    return formatter.format(remainingAmount);
  }

  String get formattedTargetDate {
    return DateFormat('MMM dd, yyyy').format(targetDate);
  }

  String get formattedCreatedDate {
    return DateFormat('MMM dd, yyyy').format(createdAt);
  }

  String get categoryDisplayName {
    switch (category) {
      case GoalCategory.emergency:
        return 'Emergency Fund';
      case GoalCategory.vacation:
        return 'Vacation';
      case GoalCategory.education:
        return 'Education';
      case GoalCategory.home:
        return 'Home';
      case GoalCategory.vehicle:
        return 'Vehicle';
      case GoalCategory.health:
        return 'Health';
      case GoalCategory.entertainment:
        return 'Entertainment';
      case GoalCategory.investment:
        return 'Investment';
      case GoalCategory.other:
        return 'Other';
    }
  }

  String get statusDisplayName {
    switch (status) {
      case GoalStatus.active:
        return 'Active';
      case GoalStatus.completed:
        return 'Completed';
      case GoalStatus.paused:
        return 'Paused';
    }
  }

  // Static method to get default color and icon for category
  static Map<String, dynamic> getCategoryDefaults(GoalCategory category) {
    switch (category) {
      case GoalCategory.emergency:
        return {'color': const Color(0xFF4CAF50), 'icon': Icons.savings};
      case GoalCategory.vacation:
        return {'color': const Color(0xFF2196F3), 'icon': Icons.flight};
      case GoalCategory.education:
        return {'color': const Color(0xFF9C27B0), 'icon': Icons.school};
      case GoalCategory.home:
        return {'color': const Color(0xFFFF9800), 'icon': Icons.home};
      case GoalCategory.vehicle:
        return {'color': const Color(0xFF673AB7), 'icon': Icons.directions_car};
      case GoalCategory.health:
        return {
          'color': const Color(0xFFE91E63),
          'icon': Icons.health_and_safety,
        };
      case GoalCategory.entertainment:
        return {'color': const Color(0xFF00BCD4), 'icon': Icons.movie};
      case GoalCategory.investment:
        return {'color': const Color(0xFF795548), 'icon': Icons.trending_up};
      case GoalCategory.other:
        return {'color': const Color(0xFF607D8B), 'icon': Icons.category};
    }
  }
}
