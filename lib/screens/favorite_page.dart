import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/product_model.dart';
import 'detail_page.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List<ProductModel> _favoritProduct = [];
  bool _isLoading = true;
  static const String _favoriteKey = 'favoriteProducts';

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_favoriteKey) ?? '[]';
      final List<dynamic> rawList = json.decode(jsonString);

      if (mounted) {
        setState(() {
          _favoritProduct = rawList
              .map((jsonItem) => ProductModel.fromJson(jsonItem))
              .toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error loading favorites: $e");
      if (mounted) {
        setState(() {
          _isLoading = false;
          _favoritProduct = [];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _loadFavorites,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _favoritProduct.isEmpty
            ? const Center(
                child: Text(
                  'Anda belum menambahkan product ke keranjang.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: _favoritProduct.length,
                itemBuilder: (context, index) {
                  final product = _favoritProduct[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailPage(product: product),
                          ),
                        ).then((_) {
                          setState(() {
                            _isLoading = true;
                          });
                          _loadFavorites();
                        });
                      },
                      leading: SizedBox(
                        width: 60,
                        height: 60,
                        child: Image.network(
                          product.image,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.broken_image),
                        ),
                      ),
                      title: Text(
                        product.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Row(
                        children: [
                          const Icon(
                            Icons.attach_money,
                            color: Colors.brown,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            product.price,
                            style: TextStyle(color: Colors.brown),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
