
class OrderModel {
  final int id;
  final String transactionId;
  final String name;
  final String playerId;
  final String date;
  final double amount;
  final String status;
  final TopupProduct? topupProduct;
  final String? voucher;   // 🔥 Voucher nullable


  OrderModel({
    required this.id,
    required this.transactionId,
    required this.name,
    required this.playerId,
    required this.date,
    required this.amount,
    required this.status,
    this.topupProduct,
    this.voucher,

  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,
      transactionId: json['transaction_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      playerId: json['playerid']?.toString() ?? '',
      date: json['created_at']?.toString() ?? '',
      amount: double.tryParse(json['amount'].toString()) ?? 0.0,
      status: json['status']?.toString() ?? '',
      topupProduct: json['TopupProduct'] != null
          ? TopupProduct.fromJson(json['TopupProduct'])
          : null,
      voucher: json["Voucher"] != null ? json["Voucher"]["data"] : null,

    );
  }
}

class TopupProduct {
  final int id;
  final String name;
  final String? logo;

  TopupProduct({
    required this.id,
    required this.name,
    this.logo,
  });

  factory TopupProduct.fromJson(Map<String, dynamic> json) {
    return TopupProduct(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,
      name: json['name']?.toString() ?? '',
      logo: json['logo']?.toString(),
    );
  }
}
