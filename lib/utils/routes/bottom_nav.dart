import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/providers/global.dart';
import 'package:flutter_ecommerce/screens/bottomNav/home.dart';
import 'package:flutter_ecommerce/screens/bottomNav/my_fav.dart';
import 'package:flutter_ecommerce/screens/bottomNav/my_order.dart';
import 'package:flutter_ecommerce/screens/bottomNav/profile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BottomNav extends ConsumerWidget {
  const BottomNav({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        selectedIndex: ref.watch(bottomNavIndexProvider),
        onDestinationSelected: (value) =>
            ref.watch(bottomNavIndexProvider.notifier).state = value,
        indicatorShape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        indicatorColor: Theme.of(context).colorScheme.primary,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded,
                color: Theme.of(context).colorScheme.onPrimary),
            label: "Home",
          ),
          NavigationDestination(
            icon: const Icon(Icons.local_shipping_outlined),
            selectedIcon: Icon(Icons.local_shipping_rounded,
                color: Theme.of(context).colorScheme.onPrimary),
            label: "My Orders",
          ),
          NavigationDestination(
            icon: const Icon(Icons.favorite_outline),
            selectedIcon: Icon(Icons.favorite_rounded,
                color: Theme.of(context).colorScheme.onPrimary),
            label: "My Wishlist",
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person_rounded,
                color: Theme.of(context).colorScheme.onPrimary),
            label: "Profile",
          ),
        ],
      ),
      body: [
        const HomeScreen(),
        const OrderScreen(),
        const FavoriteScreen(),
        const ProfileScreen(),
      ][ref.watch(bottomNavIndexProvider)],
    );
  }
}
