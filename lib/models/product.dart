class Product {
  final int productId;
  final String productName;
  final String? imgFile; // This should match the backend's field name
  final int categoryId;
  final double price;
  final int stockQuantity;
  final String description;

  Product({
    required this.productId,
    required this.productName,
    this.imgFile,
    required this.categoryId,
    required this.price,
    required this.stockQuantity,
    required this.description,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productId: json['product_id'],
      productName: json['product_name'],
      imgFile: json['img_file'], 
      categoryId: json['category_id'],
      price: double.parse(json['price'].toString()),
      stockQuantity: json['stock_quantity'],
      description: json['description'],
    );
  }
}
