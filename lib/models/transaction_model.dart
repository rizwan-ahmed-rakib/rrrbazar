class UserTransaction {
  final int id;
  final int userId;
  final double amount;
  final String number;
  final String status;
  final String purpose;
  final String transactionId;
  final String createdAt;

  UserTransaction({
    required this.id,
    required this.userId,
    required this.amount,
    required this.number,
    required this.status,
    required this.purpose,
    required this.transactionId,
    required this.createdAt,
  });

  factory UserTransaction.fromJson(Map<String, dynamic> json) {
    return UserTransaction(
      id: json['id'],
      userId: json['user_id'],
      amount: double.tryParse(json['amount'].toString()) ?? 0.0,
      number: json['number'] ?? '',
      status: json['status'] ?? '',
      purpose: json['purpose'] ?? '',
      transactionId: json['transaction_id'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }
}
