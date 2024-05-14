import '../../presentation/blocs/add_to_cart/add_to_cart_bloc.dart';

class CartModel {
  final int? id;
  final String product;
  final String description;
  final double amount;


  factory CartModel.fromMap(Map<String, dynamic> json) => CartModel(
    id: json["id"],
    product: json["product"],
    description: json["description"],
    amount: json["amount"],
  );

  CartModel({this.id, required this.product, required this.description, required this.amount});

  Map<String, dynamic> toMap() => {
    "id": id,
    "product": product,
    "description": description,
    "amount": amount,
  };
}

class CartItemModel extends CartModel {
  int quantity;
  bool isSelected;
  double totalPrice = 0.0;
  OfferState? offerState;

  CartItemModel({
    required int id,
    required String product,
    required String description,
    double? amount,
    String? createdAt,
    required this.quantity,
    required this.isSelected,
    double? totalPrice,
    this.offerState,
  }) : super(
    id: id,
    product: product,
    description: description,
    amount: amount ?? 0.0,
  );

  factory CartItemModel.fromMap(Map<String, dynamic> data) {
    return CartItemModel(
      id: data['id'],
      product: data['product'],
      description: data['description'],
      amount: data['amount'],
      quantity: data['quantity'],
      isSelected: data['isSelected'] == 1,
      totalPrice:  data['totalPrice'],
      offerState: null,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map['quantity'] = quantity;
    map['isSelected'] = isSelected;
    return map;
  }
}

class OrderItem {
  final String productName;
  final String description;
  final int quantity;
  final double priceWithTax;

  OrderItem({
    required this.productName,
    required this.description,
    required this.quantity,
    required this.priceWithTax,
  });
}
