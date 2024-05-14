class CartModel {
  final int? id;
  final String product;
  final String description;
  final int amount;


  factory CartModel.fromMap(Map<String, dynamic> json) => CartModel(
    id: json["id"],
    product: json["product"],
    description: json["description"],
    amount: json["amount"],
  );

  CartModel({required this.id, required this.product, required this.description, required this.amount});

  Map<String, dynamic> toMap() => {
    "id": id,
    "product": product,
    "description": description,
    "amount": amount,
  };
}