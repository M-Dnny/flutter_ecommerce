import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_ecommerce/models/product_model.dart';
import 'package:flutter_ecommerce/providers/product_prov/product_prov.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductCard extends ConsumerWidget {
  const ProductCard({super.key, required this.data});

  final ProductModel data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        ref.watch(productIdProv.notifier).state = data.id;
        ref.watch(productPriceProvider.notifier).state = data.price;
        context.pushNamed("detail");
      },
      borderRadius: BorderRadius.circular(15),
      child: SizedBox(
        width: 170,
        child: Column(
          children: [
            Stack(
              children: [
                Hero(
                  tag: data.images.first,
                  child: Container(
                    height: 190,
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      color: Theme.of(context).cardColor,
                      shadows: [
                        BoxShadow(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.3),
                          offset: const Offset(0, 2),
                          spreadRadius: 1,
                          blurRadius: 5,
                        ),
                      ],
                      shape: ContinuousRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: data.images.first,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                        child: SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                                strokeCap: StrokeCap.round)),
                      ),
                      errorListener: (value) {},
                      errorWidget: (context, url, error) => Center(
                        child: Text(
                          "Shopster",
                          style: GoogleFonts.tangerine(
                            textStyle:
                                Theme.of(context).textTheme.displayMedium,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              data.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              data.description,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .labelLarge!
                  .copyWith(color: Theme.of(context).hintColor),
            ),
            const SizedBox(height: 2),
            Text(
              "\$${data.price}",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).slideX();
  }
}
