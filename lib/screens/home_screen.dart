import 'package:flutter/material.dart';
import '../models/category.dart';
import '../models/product.dart';
import '../services/products_service.dart';
import '../widgets/product_card_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Category>> _categoriesFuture;
  List<Product> _allProducts = [];
  List<Product> _displayedProducts = [];
  int _selectedCategoryId = -1; // -1 for "All Products" as default
  String _searchQuery = '';
  Map<int, String> _categoryMap = {}; // Maps categoryId to categoryName

  @override
  void initState() {
    super.initState();
    _categoriesFuture = _loadCategories();
    _loadAllProducts();
  }

  Future<List<Category>> _loadCategories() async {
    final categories = await ProductApiService().fetchCategories();
    setState(() {
      // Store category names in a map to access by category ID
      _categoryMap = {
        for (var category in categories)
          category.categoryId: category.categoryName
      };
    });
    return categories;
  }

  void _loadAllProducts() async {
    final products = await ProductApiService().fetchAllProducts();
    setState(() {
      _allProducts = products;
      _filterProducts();
    });
  }

  void _filterProducts() {
    setState(() {
      _displayedProducts = _allProducts.where((product) {
        final matchesCategory = _selectedCategoryId == -1 ||
            product.categoryId == _selectedCategoryId;
        final matchesSearchQuery = product.productName
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            product.description
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            (_categoryMap[product.categoryId]
                    ?.toLowerCase()
                    .contains(_searchQuery.toLowerCase()) ??
                false);

        return matchesCategory && matchesSearchQuery;
      }).toList();
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _filterProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 15),
              child: Text(
                'BM-M Shop',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.teal,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText:
                      'Search products by name, description, or category...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                onChanged: _onSearchChanged,
              ),
            ),

            // Category Buttons with "All Products" as default
            FutureBuilder<List<Category>>(
              future: _categoriesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Error loading categories'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No categories available'));
                }

                final categories = [
                  Category(categoryId: -1, categoryName: "All Products"),
                  ...snapshot.data!
                ];

                return SizedBox(
                  height: 60,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: ChoiceChip(
                          label: Text(category.categoryName),
                          labelStyle: TextStyle(
                            color: _selectedCategoryId == category.categoryId
                                ? Colors.white
                                : Colors.black,
                          ),
                          selected: _selectedCategoryId == category.categoryId,
                          selectedColor: Colors.teal,
                          onSelected: (_) {
                            setState(() {
                              _selectedCategoryId = category.categoryId;
                              _filterProducts(); // Update displayed products based on category
                            });
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 12),

            // Products Grid
            Expanded(
              child: _displayedProducts.isEmpty
                  ? const Center(child: Text('No products available'))
                  : GridView.builder(
                      padding: const EdgeInsets.all(12.0),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 0.65,
                      ),
                      itemCount: _displayedProducts.length,
                      itemBuilder: (context, index) {
                        final product = _displayedProducts[index];
                        return ProductCard(product: product);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
