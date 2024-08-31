import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoarding extends ConsumerStatefulWidget {
  const OnBoarding({super.key});

  @override
  ConsumerState createState() => _OnBoardingState();
}

class _OnBoardingState extends ConsumerState<OnBoarding> {
  PageController pageController = PageController();

  @override
  void initState() {
    super.initState();
    firstTimeFun();
  }

  firstTimeFun() async {
    final box = await Hive.openBox("firstTime");
    final firstTime = box.get("firstTime");
    if (firstTime == null) {
      box.put("firstTime", false);
    }
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  final pages = [
    {
      "id": 1,
      "title": "Various Collections Of The Latest Products",
      "description":
          "Explore the newest trends and must-have items all in one place.",
      "image": "https://rb.gy/gqpz57",
    },
    {
      "id": 2,
      "title": "Complete Collection Of Colors and Sizes",
      "description": "Find every color and size to suit your preferences.",
      "image": "https://rb.gy/z6kf27",
    },
    {
      "id": 3,
      "title": "Find The Most Suitable Outfit For You",
      "description":
          "Easily find outfits that match your style and fit perfectly.",
      "image": "https://rb.gy/ohu0dh",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 650,
              child: PageView.builder(
                itemCount: pages.length,
                controller: pageController,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 20,
                    ),
                    child: Column(
                      children: [
                        ImageContainer(image: pages[index]["image"].toString()),
                        const SizedBox(height: 30),
                        Text(
                          pages[index]["title"].toString(),
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 15),
                        Text(
                          pages[index]["description"].toString(),
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                children: [
                  SmoothPageIndicator(
                    controller: pageController, // PageController
                    count: pages.length,
                    effect: WormEffect(
                      dotHeight: 8,
                      dotWidth: 8,
                      activeDotColor:
                          Theme.of(context).colorScheme.onPrimaryFixedVariant,
                    ), // your preferred effect
                    onDotClicked: (index) {
                      pageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.fastEaseInToSlowEaseOut,
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      context.push("/register");
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 55),
                      backgroundColor:
                          Theme.of(context).colorScheme.onPrimaryFixedVariant,
                      foregroundColor: Colors.white,
                      textStyle: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    child: const Text("Create Account"),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                      onPressed: () {
                        context.push("/login");
                      },
                      style: TextButton.styleFrom(
                        foregroundColor:
                            Theme.of(context).colorScheme.secondary,
                        textStyle:
                            Theme.of(context).textTheme.bodySmall!.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      child: const Text("Already Have An Account"))
                ],
              ),
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    ));
  }
}

class ImageContainer extends StatelessWidget {
  const ImageContainer({super.key, required this.image});

  final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 450,
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
          shadows: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              offset: const Offset(0, 5),
              blurRadius: 8,
            ),
          ],
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(130),
          )),
      child: CachedNetworkImage(
        imageUrl: image,
        fit: BoxFit.cover,
        placeholder: (context, url) => const Center(
          child: CircularProgressIndicator(strokeCap: StrokeCap.round),
        ),
        errorWidget: (context, url, error) => const Icon(
          Icons.broken_image,
          size: 80,
        ),
      ),
    );
  }
}
