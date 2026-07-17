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

  @override
  Future<List<Product>> build() async {
    // initally it will fetch 20 item
    final response = await _repository.fetchAllProductDetails(limit, skip);

    skip += limit;

    hasMore = response.products.length < response.total;

    return response.products;
  }

  // load more data\
  Future<void> fetchMore() async {
    if (isLoadingMore || !hasMore) {
      return;
    }

    isLoadingMore = true;

    final response = await _repository.fetchAllProductDetails(limit, skip);

    final currentProduct = state.value ?? [];
    // keep old record and append new items
    state = AsyncData([...currentProduct, ...response.products]);

    skip += limit;

    hasMore = state.value!.length < response.total;

    isLoadingMore = false;
  }
}
