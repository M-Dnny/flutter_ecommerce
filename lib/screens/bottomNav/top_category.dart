import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_ecommerce/models/category_model.dart';
import 'package:flutter_ecommerce/providers/category_prov/category_prov.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class TopCategory extends ConsumerStatefulWidget {
  const TopCategory({super.key});

  @override
  ConsumerState createState() => _TopCategoryState();
}

class _TopCategoryState extends ConsumerState<TopCategory> {
  @override
  Widget build(BuildContext context) {
    final categoryList = ref.watch(getCategoryProvider);
    return categoryList.when(
      data: (data) {
        return GridView.builder(
          itemCount: data.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            childAspectRatio: 0.86,
            crossAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            return CategoryCard(data: data[index]);
          },
        );
      },
      error: (error, stackTrace) => Center(child: Text("Error: $error")),
      loading: () => const Center(
          child: CircularProgressIndicator(strokeCap: StrokeCap.round)),
    );
  }
}

class CategoryCard extends ConsumerWidget {
  const CategoryCard({super.key, required this.data});

  final CategoryModel data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MaterialButton(
        onPressed: () {},
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 2,
        color: Theme.of(context).cardColor,
        padding: const EdgeInsets.all(2),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 130,
                width: 150,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  clipBehavior: Clip.antiAlias,
                  child: CachedNetworkImage(
                    imageUrl: data.image,
                    fit: BoxFit.cover,
                    errorListener: (value) {},
                    placeholder: (context, url) => const Center(
                        child: SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                                strokeCap: StrokeCap.round))),
                    errorWidget: (context, url, error) => Center(
                      child: Text(
                        "Shopster",
                        style: GoogleFonts.tangerine(
                          textStyle: Theme.of(context).textTheme.displayMedium,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Text(
                data.name,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.bold),
                maxLines: 1,
                textAlign: TextAlign.center,
                overflow: TextOverflow.clip,
              ),
            ],
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 300.ms)
        .slideX(begin: 1, end: 0, duration: 500.ms);
  }
}
