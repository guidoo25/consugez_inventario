import 'dart:convert';

ProductResponse productResponseFromJson(String str) =>
    ProductResponse.fromJson(json.decode(str));

String productResponseToJson(ProductResponse data) =>
    json.encode(data.toJson());

class ProductResponse {
  ProductResponse({
    required this.producto,
  });

  List<Product> producto;

  factory ProductResponse.fromJson(Map<String, dynamic> json) =>
      ProductResponse(
        producto: List<Product>.from(
            json["producto"].map((x) => Product.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "producto": List<dynamic>.from(producto.map((x) => x.toJson())),
      };
}

class Product {
  String? name;
  int? id;
  String? category;
  int? inCart;
  int? stock;
  int? minStock;
  String? stockStatus;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        name: json["name"],
        category: json["category"],
        id: json["id"],
        stock: json["stock"],
        minStock: json["min_stock"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "category": category,
        "id": id,
        "stock": stock,
        "min_stock": minStock,
      };

  Product({
    this.name,
    this.category,
    this.id,
    this.inCart,
    this.stock,
    this.minStock,
  });

  Product copyWith({
    String? name,
    String? category,
    int? id,
    bool? inCart,
    int? stock,
    int? minStock,
  }) {
    return Product(
      name: name ?? this.name,
      category: category ?? this.category,
      stock: stock ?? this.stock,
      minStock: minStock ?? this.minStock,
    );
  }
}
