import 'dart:developer';

import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/providers/global.dart';
import 'package:flutter_ecommerce/screens/bottomNav/search_screen.dart';
import 'package:flutter_ecommerce/screens/bottomNav/top_category.dart';
import 'package:flutter_ecommerce/screens/bottomNav/top_home.dart';
import 'package:flutter_ecommerce/services/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState createState() => _HomeScreenState();
}

const imgUrl = "https://shorturl.at/y1dbT";

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    getProfile();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getProfile() {
    try {
      Auth.getProfile().then((value) {
        if (value.data != null && value.statusCode == 200) {
          ref.read(userNameProvider.notifier).state = value.data["name"];
        }
      }).catchError((e) {
        log("Error ${e.toString()}");
      });
    } on Exception catch (e) {
      log("Error ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverOverlapAbsorber(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                        context),
                    sliver: const HomeAppBar(),
                  ),
                ];
              },
              body: const TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: TopHomeScreen(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: TopCategory(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HomeAppBar extends ConsumerWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverAppBar(
      leadingWidth: 40,
      pinned: true,
      floating: true,
      forceMaterialTransparency: true,
      leading: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(100),
        child: const CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(imgUrl)),
      ),
      titleSpacing: 10,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Hi, ${ref.watch(userNameProvider)}",
            style: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 2),
          Text(
            "Let's go shopping",
            style: Theme.of(context)
                .textTheme
                .labelSmall!
                .copyWith(color: Theme.of(context).hintColor),
          ),
        ],
      ),
      actions: [
        OpenContainer(
          transitionType: ContainerTransitionType.fadeThrough,
          closedElevation: 0,
          closedShape: const CircleBorder(),
          transitionDuration: const Duration(milliseconds: 900),
          closedColor: Theme.of(context).scaffoldBackgroundColor,
          middleColor: Theme.of(context).scaffoldBackgroundColor,
          openBuilder: (context, action) => const SearchScreen(),
          closedBuilder: (context, action) => const Padding(
            padding: EdgeInsets.all(5.0),
            child: Icon(Icons.search_rounded),
          ),
        ),
        IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none_rounded))
      ],
      bottom: TabBar(
        dividerHeight: 0,
        unselectedLabelColor: Colors.grey,
        labelStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).tabBarTheme.labelColor),
        unselectedLabelStyle: Theme.of(context).textTheme.titleSmall,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: const EdgeInsets.symmetric(horizontal: 40),
        tabs: const [
          Tab(text: "Home"),
          Tab(text: "Category"),
        ],
      ),
    );
  }
}
