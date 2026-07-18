import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:product_list_app/core/widgets/product_card_widget.dart';
import 'package:product_list_app/feature/product_list/services/providers/product_list_provider.dart';

class ProductListScreen extends ConsumerStatefulWidget {
  const ProductListScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProductListScreenState();
}

class _ProductListScreenState extends ConsumerState<ProductListScreen> {
  final TextEditingController searchProductController = TextEditingController();

  final ScrollController _scrollController = ScrollController();

  String _selectedQuery = "All";

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      // when it will reach it to bottom the fetch again more product and append it
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        ref.read(productProvider.notifier).fetchMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final screenWidth = MediaQuery.sizeOf(context).width;

    final productAsync = ref.watch(productProvider);
    final notifier = ref.read(productProvider.notifier);
    final categories = notifier.categories;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Row(
            children: [
              // circle
              CircleAvatar(
                radius: 22,
                backgroundColor: const Color.fromARGB(255, 210, 224, 235),
                child: Icon(Icons.person, size: 35),
              ),
              SizedBox(width: 12),
              // greeting + name
              Column(
                crossAxisAlignment: .start,
                children: [
                  // Text("Hello Buddy,", style: TextStyle(fontSize: 15)),
                  Text(
                    "Hello User!",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: .w600,
                      color: const Color.fromARGB(255, 13, 79, 193),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: Icon(
                Icons.notifications,
                color: const Color.fromARGB(255, 114, 127, 138),
              ),
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await notifier.refreshProduct();
          },
          child: Container(
            width: screenWidth,
            height: screenHeight,
            color: const Color.fromARGB(255, 237, 233, 233),
            padding: EdgeInsets.only(left: 5, right: 5, top: 10),
            child: Column(
              children: [
                SizedBox(height: 5),

                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Container(
                    // width: screenWidth * 0.8,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: .circular(30),
                    ),
                    child: TextField(
                      autocorrect: true,
                      controller: searchProductController,
                      decoration: InputDecoration(
                        hintText: "Search for product",
                        hintStyle: const TextStyle(color: Colors.black54),
                        border: OutlineInputBorder(borderRadius: .circular(30)),
                      ),
                      onChanged: (value) {
                        notifier.search(value);
                      },
                    ),
                  ),
                ),
                SizedBox(height: 10),
                // show the list of product
                Column(
                  children: [
                    SizedBox(
                      height: 40,
                      child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: .horizontal,
                        itemCount: categories.length,

                        itemBuilder: (context, index) {
                          final category = categories[index];
                          bool isSelected = category == _selectedQuery;
                          return Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    _selectedQuery = category;
                                  });
                                  ref
                                      .read(productProvider.notifier)
                                      .changeCategory(category);
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: .circular(20),
                                    color: isSelected
                                        ? Colors.blue
                                        : Colors.white,
                                  ),
                                  child: Center(
                                    child: Text(
                                      category,
                                      style: TextStyle(
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Expanded(
                  child: productAsync.when(
                    data: (productList) {
                      return GridView.builder(
                        // Added padding to the entire list so it breathes nicely against the screen edges
                        padding: const EdgeInsets.symmetric(
                          horizontal: 3,
                          vertical: 5,
                        ),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.64,
                        ),
                        controller: _scrollController,
                        itemCount: productList.length,
                        itemBuilder: (context, index) {
                          final product = productList[index];

                          return productCard(product, context);
                        },
                      );
                    },
                    error: (e, s) => Center(
                      child: Column(
                        children: [
                          Spacer(),
                          Text("Error: $e"),
                          ElevatedButton(
                            onPressed: () async {
                              try {
                                await notifier.refreshProduct();
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Products refreshed successfully.",
                                      ),
                                    ),
                                  );
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Error : $e")),
                                  );
                                }
                              }
                            },
                            child: Text("Retry !"),
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                  ),
                ),
                // SizedBox(height: screenHeight * 0.01),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
