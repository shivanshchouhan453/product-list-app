import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:product_list_app/feature/product_list/services/models/product_details_model.dart';
import 'package:product_list_app/feature/product_list/services/providers/product_notifier.dart';
import 'package:product_list_app/feature/product_list/services/repositories/product_list_repository.dart';

// repo provider
final productListRepository = Provider((ref) {
  return ProductListRepository();
});

// future provider
final fetchAllProductDetails =
    FutureProvider.family<ProductResponse, ({int limit, int skip})>(
      (ref, arg) => ref
          .read(productListRepository)
          .fetchAllProductDetails(arg.limit, arg.skip),
    );

// product provider
final productProvider = AsyncNotifierProvider<ProductNotifier, List<Product>>(
  ProductNotifier.new,
);
