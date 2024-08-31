import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/providers/product_prov/product_prov.dart';
import 'package:flutter_ecommerce/utils/widgets/product_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SeeAllScreen extends ConsumerStatefulWidget {
  const SeeAllScreen({super.key, required this.title});

  final String title;

  @override
  ConsumerState createState() => _SeeAllScreenState();
}

class _SeeAllScreenState extends ConsumerState<SeeAllScreen> {
  @override
  Widget build(BuildContext context) {
    final products = ref.watch(getProductProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: products.when(
        data: (data) {
          return GridView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: data.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 15,
                mainAxisExtent: 275),
            itemBuilder: (context, index) {
              return ProductCard(data: data[index]);
            },
          );
        },
        error: (error, stackTrace) => Text(error.toString()),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
