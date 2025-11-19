import 'package:flutter/material.dart';
import 'package:latihan_responsi_anime/controllers/product_controller.dart';
import 'package:latihan_responsi_anime/widgets/product_card.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductController>(context, listen: false).fetchProductList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductController>(
      builder: (context, controller, child) {
        return Scaffold(body: _buildBody(controller));
      },
    );
  }

  Widget _buildBody(ProductController controller) {
    if (controller.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.errorMessage != null) {
      return Center(
        child: Text('Gagal memuat data: ${controller.errorMessage}'),
      );
    }

    if (controller.productList.isEmpty) {
      return const Center(child: Text('Tidak ada data anime ditemukan.'));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: controller.productList.length,
      itemBuilder: (context, index) {
        return ProductCard(product: controller.productList[index]);
      },
    );
  }
}
