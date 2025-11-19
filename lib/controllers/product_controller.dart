import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';

class ProductController extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<ProductModel> _productList = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<ProductModel> get productList => _productList;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchProductList() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _productList = await _apiService.fetchProduct();
    } catch (e) {
      _errorMessage = e.toString();
      _productList = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
