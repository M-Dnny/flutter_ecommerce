import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/screens/bottomNav/order_history_tab.dart';
import 'package:flutter_ecommerce/screens/bottomNav/order_tab.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderScreen extends ConsumerStatefulWidget {
  const OrderScreen({super.key});

  @override
  ConsumerState createState() => _OrderScreenState();
}

class _OrderScreenState extends ConsumerState<OrderScreen> {
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
                    sliver: const OrderAppBar(),
                  ),
                ];
              },
              body: const TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: OrderTab(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: OrderHistoryTab(),
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

class OrderAppBar extends ConsumerWidget {
  const OrderAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverAppBar(
      pinned: true,
      floating: true,
      forceMaterialTransparency: true,
      title: const Text("My Orders"),
      titleTextStyle: Theme.of(context)
          .textTheme
          .titleSmall!
          .copyWith(fontWeight: FontWeight.bold),
      centerTitle: true,
      actions: [
        IconButton(
            onPressed: () {}, icon: const Icon(Icons.shopping_bag_outlined))
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
          Tab(text: "My Order"),
          Tab(text: "History"),
        ],
      ),
    );
  }
}
