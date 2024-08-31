import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/models/search_model.dart';
import 'package:flutter_ecommerce/utils/widgets/product_header.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final recentSearchProvider = StateProvider<List<SearchModel>>((ref) {
  return [];
});

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  searchSubmit(value) {
    final recentSearch = ref.read(recentSearchProvider);

    final id = recentSearch.length + 1;

    if (value != "") {
      ref.watch(recentSearchProvider.notifier).state = [
        ...recentSearch,
        SearchModel(id: id, title: value)
      ];
    }
    searchController.clear();
  }

  removeSearch(id) {
    final recentSearch = ref.read(recentSearchProvider);
    ref.watch(recentSearchProvider.notifier).state =
        recentSearch.where((element) => element.id != id).toList();
  }

  clearAll() {
    ref.watch(recentSearchProvider.notifier).state = [];
  }

  @override
  Widget build(BuildContext context) {
    final recentSearch = ref.watch(recentSearchProvider);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          appBar: AppBar(
            titleSpacing: 10,
            title: SearchAppBar(
              searchController: searchController,
              onSubmit: searchSubmit,
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 10),
                recentSearch.isEmpty
                    ? const SizedBox()
                    : ProductHeader(
                        title: "Last Search",
                        onPressed: clearAll,
                        buttonText: "Clear All"),
                const SizedBox(height: 10),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 5,
                    alignment: WrapAlignment.start,
                    children: recentSearch
                        .map(
                          (e) => LastSceneCard(
                            title: e.title,
                            onPressed: () {
                              removeSearch(e.id);
                            },
                          ),
                        )
                        .toList(),
                  ),
                )
              ],
            ),
          )),
    );
  }
}

class LastSceneCard extends StatelessWidget {
  const LastSceneCard(
      {super.key, required this.title, required this.onPressed});

  final String title;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(title),
      onDeleted: onPressed,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      side: BorderSide(
          color: Theme.of(context).hintColor.withOpacity(0.2), width: 1),
      labelStyle: Theme.of(context)
          .textTheme
          .titleSmall!
          .copyWith(color: Theme.of(context).hintColor),
      deleteIcon: const Icon(Icons.close),
      iconTheme: Theme.of(context)
          .iconTheme
          .copyWith(color: Theme.of(context).hintColor.withOpacity(0.5)),
    );
  }
}

class SearchAppBar extends ConsumerWidget {
  const SearchAppBar(
      {super.key, required this.searchController, required this.onSubmit});

  final TextEditingController searchController;
  final Function(String) onSubmit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width - 90,
      child: TextField(
        controller: searchController,
        textInputAction: TextInputAction.search,
        onSubmitted: onSubmit,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          hintText: "Search",
          enabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            borderSide:
                BorderSide(color: Theme.of(context).hintColor.withOpacity(0.5)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(15.0)),
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
          ),
          prefixIcon: const Icon(Icons.search),
        ),
      ),
    );
  }
}
