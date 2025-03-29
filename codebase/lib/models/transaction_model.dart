class Transaction {
  final int? id;
  final String title;
  final double amount;
  final String date;
  final String type; // "income" or "expense"
  final String description;
  final String category;

  Transaction({
    this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.type,
    required this.description,
    required this.category,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date,
      'type': type,
      'description': description,
      'category': category,
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      title: map['title'],
      amount: map['amount'],
      date: map['date'],
      type: map['type'],
      description: map['description'],
      category: map['category'],
    );
  }
}
