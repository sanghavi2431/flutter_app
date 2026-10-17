import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../model/product_category_wrapper.dart';

class CategoryRepository {
  final String _baseUrl = "https://staging-store.woloo.in";

  Future<ProductCategoryWrapper> fetchCategories() async {
    final url = Uri.parse(
      "$_baseUrl/store/products?fields=*variants.calculated_price,variants.inventory_quantity,*categories,metadata&region_id=reg_01JPH693TAM20TXZEJNBJ5QBV4",
    );

    // Step 1: Fetch token from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    // Step 2: Prepare headers
    final headers = {
      'x-publishable-api-key':
          'pk_67ce4e90f35529f44006d2a95b330dbabbe576e43d3fd06021ca656ee00806cf',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    // Step 3: Make GET request
    final response = await http.get(url, headers: headers);

    // Step 4: Handle response
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      return ProductCategoryWrapper.fromJson(jsonData);
    } else {
      throw Exception("Failed to load categories (${response.statusCode})");
    }
  }
}
