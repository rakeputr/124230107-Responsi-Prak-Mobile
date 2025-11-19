import 'package:flutter/material.dart';
import 'package:latihan_responsi_anime/models/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class DetailPage extends StatefulWidget {
  final ProductModel product;

  DetailPage({super.key, required this.product});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool _isFavorite = false;
  static const String _favoriteKey = 'favoriteProducts';

  @override
  void initState() {
    super.initState();
    _checkFavoriteStatus();
  }

  Future<void> _checkFavoriteStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_favoriteKey) ?? '[]';
    final List<dynamic> favoriteListJson = json.decode(jsonString);

    if (mounted) {
      setState(() {
        _isFavorite = favoriteListJson.any(
          (item) => item['id'] == widget.product.id,
        );
      });
    }
  }

  Future<void> _toggleFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_favoriteKey) ?? '[]';
    List<dynamic> favoriteListJson = json.decode(jsonString);

    if (_isFavorite) {
      favoriteListJson.removeWhere((item) => item['id'] == widget.product.id);
    } else {
      favoriteListJson.add(widget.product.toJson());
    }

    await prefs.setString(_favoriteKey, json.encode(favoriteListJson));

    if (mounted) {
      setState(() {
        _isFavorite = !_isFavorite;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isFavorite
                ? 'Ditambahkan ke Keranjang!'
                : 'Dihapus dari Keranjang!',
          ),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.title),
        backgroundColor: Colors.brown[200],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              widget.product.image,
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(
                        Icons.attach_money,
                        color: Colors.brown,
                        size: 24,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        widget.product.price,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 150),
                      const Icon(Icons.star, color: Colors.amber, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        'Rate: ${widget.product.rate}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _toggleFavorite(),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: _isFavorite
                          ? Colors.brown[200]
                          : Colors.brown, // Background color of the button
                      foregroundColor: _isFavorite
                          ? Colors.black
                          : Colors.white,
                    ),
                    child: _isFavorite
                        ? Text('Hapus dari Keranjang')
                        : Text('Masukkan ke Keranjang'),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Description:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Divider(),
                  Text(
                    widget.product.description,
                    textAlign: TextAlign.justify,
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
