class User {
  final String id;
  final String email;
  final String name;
  final String? photoUrl;
  final DateTime createdAt;
  final double totalBalance;
  final double monthlyIncome;
  final double monthlyExpenses;

  User({
    required this.id,
    required this.email,
    required this.name,
    this.photoUrl,
    required this.createdAt,
    this.totalBalance = 0.0,
    this.monthlyIncome = 0.0,
    this.monthlyExpenses = 0.0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'photoUrl': photoUrl,
      'createdAt': createdAt.toIso8601String(),
      'totalBalance': totalBalance,
      'monthlyIncome': monthlyIncome,
      'monthlyExpenses': monthlyExpenses,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      email: map['email'],
      name: map['name'],
      photoUrl: map['photoUrl'],
      createdAt: DateTime.parse(map['createdAt']),
      totalBalance: (map['totalBalance'] as num?)?.toDouble() ?? 0.0,
      monthlyIncome: (map['monthlyIncome'] as num?)?.toDouble() ?? 0.0,
      monthlyExpenses: (map['monthlyExpenses'] as num?)?.toDouble() ?? 0.0,
    );
  }

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? photoUrl,
    DateTime? createdAt,
    double? totalBalance,
    double? monthlyIncome,
    double? monthlyExpenses,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
      totalBalance: totalBalance ?? this.totalBalance,
      monthlyIncome: monthlyIncome ?? this.monthlyIncome,
      monthlyExpenses: monthlyExpenses ?? this.monthlyExpenses,
    );
  }
}
