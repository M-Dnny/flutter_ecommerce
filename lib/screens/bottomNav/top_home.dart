import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_ecommerce/models/product_model.dart';
import 'package:flutter_ecommerce/providers/product_prov/product_prov.dart';
import 'package:flutter_ecommerce/utils/contants.dart';
import 'package:flutter_ecommerce/utils/widgets/product_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../utils/widgets/product_header.dart';

class TopHomeScreen extends ConsumerStatefulWidget {
  const TopHomeScreen({super.key});

  @override
  ConsumerState createState() => _TopHomeScreenState();
}

class _TopHomeScreenState extends ConsumerState<TopHomeScreen> {
  @override
  Widget build(BuildContext context) {
    final arrivalList = ref.watch(getArrivalProvider);
    final trendingList = ref.watch(getTrendingProvider);

    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        children: [
          const SizedBox(height: 20),
          const BannerCards(),
          const SizedBox(height: 15),
          ProductHeader(
              title: "New Arrivals 🔥",
              buttonText: "See All",
              onPressed: () {
                context
                    .pushNamed("see_all", extra: {"title": "New Arrivals 🔥"});
              }),
          const SizedBox(height: 10),
          ArrivalList(products: arrivalList),
          ProductHeader(
              title: "Trending 🔥",
              buttonText: "See All",
              onPressed: () {
                context.pushNamed("see_all", extra: {"title": "Trending 🔥"});
              }),
          const SizedBox(height: 10),
          TrendingList(products: trendingList),
        ],
      ),
    );
  }
}

class TrendingList extends StatelessWidget {
  const TrendingList({super.key, required this.products});

  final AsyncValue<List<ProductModel>> products;

  @override
  Widget build(BuildContext context) {
    return products.when(
      data: (data) {
        return GridView.builder(
          shrinkWrap: true,
          itemCount: data.length,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            mainAxisExtent: 275,
            crossAxisSpacing: 15,
          ),
          itemBuilder: (context, index) {
            return ProductCard(data: data[index]);
          },
        );
      },
      error: (error, stackTrace) {
        return Text("Error: $error");
      },
      loading: () => const Center(
        child: CircularProgressIndicator(strokeCap: StrokeCap.round),
      ),
    );
  }
}

class ArrivalList extends StatelessWidget {
  const ArrivalList({super.key, required this.products});

  final AsyncValue<List<ProductModel>> products;

  @override
  Widget build(BuildContext context) {
    return products.when(
      data: (data) {
        return GridView.builder(
          shrinkWrap: true,
          itemCount: data.length,
          physics: const NeverScrollableScrollPhysics(),
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
      error: (error, stackTrace) {
        return Text("Error: $error");
      },
      loading: () => const Center(
        child: CircularProgressIndicator(strokeCap: StrokeCap.round),
      ),
    );
  }
}

class BannerCards extends ConsumerWidget {
  const BannerCards({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 180),
      child: CarouselView(
        itemSnapping: true,
        shape:
            ContinuousRectangleBorder(borderRadius: BorderRadius.circular(80)),
        itemExtent: MediaQuery.sizeOf(context).width,
        elevation: 3,
        padding: const EdgeInsets.only(left: 15),
        children: List<Widget>.generate(3, (int index) {
          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: CachedNetworkImageProvider(
                  cards[index]["url"],
                ),
              ),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black26, Colors.black26],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
              child: Text(
                cards[index]["title"],
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          );
        }),
      ),
    ).animate().fadeIn().slideX();
  }
}
