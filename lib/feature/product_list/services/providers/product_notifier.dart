import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:product_list_app/feature/product_list/services/models/product_details_model.dart';
import 'package:product_list_app/feature/product_list/services/repositories/product_list_repository.dart';

class ProductNotifier extends AsyncNotifier<List<Product>> {
  final ProductListRepository _repository = ProductListRepository();

  final int limit = 20;

  int skip = 0;

  bool isLoadingMore = false;

  bool hasMore = true;

  List<Product> allProduct = [];

  List<Product> filteredProducts = [];

  String selectedCategory = "All";

  String searchQuery = "";

  List<String> get categories {
    return [
      "All",
      ...allProduct.map((product) => product.category).toSet().toList()..sort(),
    ];
  }

  @override
  Future<List<Product>> build() async {
    // initally it will fetch 20 item
    final response = await _repository.fetchAllProductDetails(limit, skip);

    skip += limit;

    hasMore = response.products.length < response.total;

    allProduct = response.products;

    return response.products;
  }

  // load more data
  Future<void> fetchMore() async {
    if (isLoadingMore || !hasMore) {
      return;
    }

    isLoadingMore = true;

    final response = await _repository.fetchAllProductDetails(limit, skip);

    final currentProduct = state.value ?? [];
    // keep old record and append new items
    state = AsyncData([...currentProduct, ...response.products]);

    allProduct.addAll(response.products);

    applyFilters();

    skip += limit;

    hasMore = state.value!.length < response.total;

    isLoadingMore = false;
  }

  // filter the product
  void applyFilters() {
    print("filtering...");
    List<Product> filteredProduct = allProduct;

    // fillter by category
    if (selectedCategory != "All") {
      filteredProduct = filteredProduct.where((product) {
        return product.category.toLowerCase() == selectedCategory.toLowerCase();
      }).toList();
    }

    // filter by query
    if (searchQuery.isNotEmpty) {
      filteredProduct = filteredProduct.where((product) {
        final query = searchQuery.toLowerCase();

        return product.title.toLowerCase().contains(query) ||
            (product.brand?.toLowerCase().contains(query) ?? false) ||
            product.category.toLowerCase().contains(query);
      }).toList();
    }

    print("filtered data : $filteredProduct");
    state = AsyncData(filteredProduct);
  }

  // change Category
  void changeCategory(String category) {
    selectedCategory = category;
    applyFilters();
  }

  // change Query
  void search(String query) {
    searchQuery = query;
    applyFilters();
  }
}
