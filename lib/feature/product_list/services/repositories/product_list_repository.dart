import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:product_list_app/core/constants/api_key.dart';
import 'package:product_list_app/feature/product_list/services/models/product_details_model.dart';

class ProductListRepository {
  // fetch the list of product

  // fetch all item from the server
  Future<ProductResponse> fetchAllProductDetails(int limit, int skip) async {
    try {
      final uri = Uri.parse("${ApiKey.baseApiKey}?limit=$limit&skip=$skip");
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final decodedJson = jsonDecode(response.body);
        return ProductResponse.fromJson(decodedJson);
      } else {
        throw Exception("failed to load data $response ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("failed to load data $e");
    }
  }
}
