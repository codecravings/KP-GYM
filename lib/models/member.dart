class Member {
  final int? id;
  final String name;
  final DateTime joiningDate;
  final int subscriptionDays;
  final double amount;
  final bool isMorningShift;

  Member({
    this.id,
    required this.name,
    required this.joiningDate,
    required this.subscriptionDays,
    required this.amount,
    required this.isMorningShift,
  });

  // Calculate expiry date
  DateTime get expiryDate {
    final expiry = joiningDate.add(Duration(days: subscriptionDays));
    return expiry;
  }

  // Calculate remaining days
  int get remainingDays {
    final expiryDate = joiningDate.add(Duration(days: subscriptionDays));
    final today = DateTime.now();
    
    // Normalize dates to compare only dates without time
    final expiryDateOnly = DateTime(expiryDate.year, expiryDate.month, expiryDate.day);
    final todayOnly = DateTime(today.year, today.month, today.day);
    
    final remaining = expiryDateOnly.difference(todayOnly).inDays;
    return remaining > 0 ? remaining : 0;
  }

  // Check if subscription is about to expire (1 day remaining)
  bool get isAboutToExpire => remainingDays <= 1 && remainingDays > 0;

  // Check if subscription has expired
  bool get isExpired => remainingDays <= 0;

  // Convert to Map for database operations
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'joiningDate': joiningDate.millisecondsSinceEpoch,
      'subscriptionDays': subscriptionDays,
      'amount': amount,
      'isMorningShift': isMorningShift ? 1 : 0,
    };
  }

  // Create Member from Map (from database)
  factory Member.fromMap(Map<String, dynamic> map) {
    return Member(
      id: map['id'],
      name: map['name'],
      joiningDate: DateTime.fromMillisecondsSinceEpoch(map['joiningDate']),
      subscriptionDays: map['subscriptionDays'],
      amount: map['amount'],
      isMorningShift: map['isMorningShift'] == 1,
    );
  }

  // Create a copy of Member with updated fields
  Member copyWith({
    int? id,
    String? name,
    DateTime? joiningDate,
    int? subscriptionDays,
    double? amount,
    bool? isMorningShift,
  }) {
    return Member(
      id: id ?? this.id,
      name: name ?? this.name,
      joiningDate: joiningDate ?? this.joiningDate,
      subscriptionDays: subscriptionDays ?? this.subscriptionDays,
      amount: amount ?? this.amount,
      isMorningShift: isMorningShift ?? this.isMorningShift,
    );
  }

  @override
  String toString() {
    return 'Member{id: $id, name: $name, joiningDate: $joiningDate, subscriptionDays: $subscriptionDays, amount: $amount, isMorningShift: $isMorningShift}';
  }
}
