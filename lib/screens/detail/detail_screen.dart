import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_ecommerce/models/product_model.dart';
import 'package:flutter_ecommerce/providers/product_prov/product_prov.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DetailScreen extends ConsumerStatefulWidget {
  const DetailScreen({super.key});

  @override
  ConsumerState createState() => _DetailScreenState();
}

class _DetailScreenState extends ConsumerState<DetailScreen> {
  final quantityProvider = StateProvider<String>((ref) => "1");
  final selectedColorProvider = StateProvider<int>((ref) => 0);

  @override
  Widget build(BuildContext context) {
    final productInfo = ref.watch(getProductInfoProvider);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.outlineVariant,
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.shopping_bag_outlined),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            const SizedBox(width: 20),
            Text("\$${ref.watch(productPriceProvider)}",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontWeight: FontWeight.bold)),
            const Spacer(),
            FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.shopping_bag_outlined),
                label: const Text("Add to cart")),
            const SizedBox(width: 20)
          ],
        ),
      ),
      body: productInfo.when(
          data: (data) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  ImageSlider(data: data),
                  Container(
                    width: MediaQuery.sizeOf(context).width,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(35),
                        topRight: Radius.circular(35),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TitleReview(title: data.title),
                            QuantityCounter(quantityProvider: quantityProvider),
                          ],
                        ),
                        const SizedBox(height: 20),
                        ColorWidget(
                            selectedColorProvider: selectedColorProvider),
                        const SizedBox(height: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Description",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              data.description,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(fontWeight: FontWeight.w400),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn();
          },
          error: (error, stackTrace) => Center(child: Text(error.toString())),
          loading: () => const Center(
              child: CircularProgressIndicator(strokeCap: StrokeCap.round))),
    );
  }
}

class ColorWidget extends ConsumerWidget {
  const ColorWidget({super.key, required this.selectedColorProvider});

  final StateProvider<int> selectedColorProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Color",
            style: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        SizedBox(
          height: 30,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: List.generate(
              7,
              (index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: GestureDetector(
                    onTap: () {
                      ref.read(selectedColorProvider.notifier).state = index;
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.primaries[index],
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: index == ref.watch(selectedColorProvider)
                          ? Icon(Icons.check_rounded,
                              color: Theme.of(context).cardColor, size: 20)
                          : null,
                    ),
                  ),
                );
              },
            ),
          ),
        )
      ],
    );
  }
}

class QuantityCounter extends ConsumerWidget {
  const QuantityCounter({super.key, required this.quantityProvider});

  final StateProvider<String> quantityProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quantity = ref.watch(quantityProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 35,
          width: 100,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 2),
                child: IconButton(
                  onPressed: () {
                    if (quantity != "1") {
                      ref.read(quantityProvider.notifier).state =
                          (int.parse(quantity) - 1).toString();
                    }
                  },
                  style: ButtonStyle(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    backgroundColor: WidgetStatePropertyAll(
                        Theme.of(context).scaffoldBackgroundColor),
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minHeight: 28,
                    minWidth: 28,
                  ),
                  iconSize: 20,
                  icon: const Icon(Icons.remove),
                ),
              ),
              Text(
                quantity,
                style: Theme.of(context)
                    .textTheme
                    .labelMedium!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 2),
                child: IconButton(
                  onPressed: () {
                    ref.read(quantityProvider.notifier).state =
                        (int.parse(quantity) + 1).toString();
                  },
                  style: ButtonStyle(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      backgroundColor: WidgetStatePropertyAll(
                          Theme.of(context).scaffoldBackgroundColor)),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minHeight: 28,
                    minWidth: 28,
                  ),
                  iconSize: 20,
                  icon: const Icon(Icons.add),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 5),
        Text(
          "Available in Stock",
          style: Theme.of(context)
              .textTheme
              .labelSmall!
              .copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class TitleReview extends StatelessWidget {
  const TitleReview({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.6,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 15,
                width: 15,
                decoration: const ShapeDecoration(
                    color: Colors.amber,
                    shape: StarBorder(
                        side: BorderSide(color: Colors.transparent),
                        points: 5,
                        pointRounding: 0.2)),
              ),
              const SizedBox(width: 5),
              Text.rich(
                TextSpan(children: [
                  TextSpan(
                    text: "4.9",
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: " (120 reviews)",
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.5),
                        ),
                  ),
                ]),
              )
            ],
          )
        ],
      ),
    );
  }
}

class ImageSlider extends ConsumerStatefulWidget {
  const ImageSlider({super.key, required this.data});

  final ProductModel data;

  @override
  ConsumerState createState() => _ImageSliderState();
}

class _ImageSliderState extends ConsumerState<ImageSlider> {
  PageController pageController = PageController();

  final selectIndexProvider = StateProvider<int>((ref) => 0);

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  wishToggle(data) async {
    final dt = {
      "id": data.id,
      "title": data.title,
      "price": data.price,
      "description": data.description,
      "images": data.images,
      "is_fav": true,
    };

    final box = Hive.box("wishlist");

    if (box.containsKey(data.id)) {
      box.delete(data.id);
    } else {
      box.put(data.id, dt);
    }
    log("box ${box.get(data.id)}");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight: MediaQuery.sizeOf(context).height * 0.4),
            child: Row(
              children: [
                SizedBox(
                  width: 60,
                  height: MediaQuery.sizeOf(context).height * 0.4,
                  child: Center(
                    child: ListView.builder(
                      itemCount: widget.data.images.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            pageController.animateToPage(
                              index,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 100),
                            curve: Curves.easeIn,
                            height: 60,
                            margin: const EdgeInsets.only(bottom: 10),
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              color: Colors.white54,
                              borderRadius: BorderRadius.circular(10),
                              border: ref.watch(selectIndexProvider) != index
                                  ? null
                                  : Border.all(
                                      color: Theme.of(context).primaryColor,
                                      width: 2,
                                      strokeAlign:
                                          BorderSide.strokeAlignOutside,
                                    ),
                              boxShadow: index == ref.watch(selectIndexProvider)
                                  ? [
                                      BoxShadow(
                                        color: Theme.of(context)
                                            .primaryColor
                                            .withOpacity(0.5),
                                        spreadRadius: 1,
                                        blurRadius: 3,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: CachedNetworkImage(
                              imageUrl: widget.data.images[index],
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(
                                  child: SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                    strokeCap: StrokeCap.round),
                              )),
                              errorWidget: (context, url, error) => const Icon(
                                  Icons.error_outline_rounded,
                                  color: Colors.red),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Stack(
                    children: [
                      PageView.builder(
                        controller: pageController,
                        itemCount: widget.data.images.length,
                        onPageChanged: (value) {
                          ref.watch(selectIndexProvider.notifier).state = value;
                        },
                        scrollDirection: Axis.horizontal,
                        pageSnapping: true,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Hero(
                              tag: widget.data.images[index],
                              child: Container(
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                    color: Colors.white54,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Theme.of(context)
                                            .primaryColor
                                            .withOpacity(0.5),
                                        spreadRadius: 1,
                                        blurRadius: 3,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]),
                                child: CachedNetworkImage(
                                  imageUrl: widget.data.images[index],
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(
                                        strokeCap: StrokeCap.round),
                                  ),
                                  errorWidget: (context, url, error) => Center(
                                    child: Text(
                                      "Shopster",
                                      style: GoogleFonts.tangerine(
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .displayMedium,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: IconButton(
                            onPressed: () {
                              wishToggle(widget.data);
                            },
                            icon: const Icon(Icons.favorite_outline_rounded)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
