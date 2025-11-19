import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class ApiService {
  static const String _baseUrl = 'https://fakestoreapi.com/products';

  Future<List<ProductModel>> fetchProduct() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List product = data;

        return product.map((item) => ProductModel.fromJson(item)).toList();
      } else {
        throw Exception(
          'Gagal memuat data anime. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan saat koneksi API: $e');
    }
  }
}
