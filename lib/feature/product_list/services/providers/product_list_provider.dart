import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:product_list_app/feature/product_list/services/models/product_details_model.dart';
import 'package:product_list_app/feature/product_list/services/repositories/product_list_repository.dart';

// repo provider
final productListRepository = Provider((ref) {
  return ProductListRepository();
});

// future provider
final fetchAllProductDetails = FutureProvider<ProductResponse>(
  (ref) => ref.read(productListRepository).fetchAllProductDetails(),
);
