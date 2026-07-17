import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:product_list_app/feature/product_list/screens/product_details_screen.dart';
import 'package:product_list_app/feature/product_list/services/models/product_details_model.dart';
import 'package:product_list_app/feature/product_list/services/providers/product_list_provider.dart';

class ProductListScreen extends ConsumerStatefulWidget {
  const ProductListScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProductListScreenState();
}

class _ProductListScreenState extends ConsumerState<ProductListScreen> {
  final TextEditingController searchProductController = TextEditingController(
    text: "Search the Product",
  );

  final ScrollController _scrollController = ScrollController();

  // sample data
  final List<String> _categories = [
    'All',
    'Electronics',
    'Clothing',
    'Home & Kitchen',
    'Books',
    'Beauty',
    'Sports',
    'Toys',
    'Automotive',
    'Groceries',
  ];
  String _selectedQuery = "All";

  @override
  void initState() {
    super.initState();
    print("loading more..");
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
                child: Icon(Icons.person),
              ),
              SizedBox(width: 12),
              // greeting + name
              Column(
                crossAxisAlignment: .start,
                children: [
                  Text("Hello Buddy,", style: TextStyle(fontSize: 15)),
                  Text(
                    "Shiv Baba!!",
                    style: TextStyle(
                      fontSize: 20,
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
        body: Container(
          width: screenWidth,
          height: screenHeight,
          color: const Color.fromARGB(255, 237, 233, 233),
          padding: EdgeInsets.only(left: 5, right: 5, top: 10),
          child: Column(
            children: [
              SizedBox(height: 5),
              // show the list of product
              Column(
                children: [
                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: .horizontal,
                      itemCount: _categories.length,

                      itemBuilder: (context, index) {
                        final category = _categories[index];
                        bool isSelected = category == _selectedQuery;
                        return Row(
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _selectedQuery = category;
                                });
                              },
                              child: Container(
                                // width: 100,
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
                  error: (e, s) => Center(child: Text("Error: $e")),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                ),
              ),
              // SizedBox(height: screenHeight * 0.01),
            ],
          ),
        ),
      ),
    );
  }
}

Widget productCard(Product product, BuildContext context) {
  return Card(
    elevation: 0,
    color: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24),
      side: BorderSide(color: Colors.grey.shade200),
    ),
    child: InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsScreen(product: product),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// IMAGE
          Stack(
            children: [
              Hero(
                tag: product.id,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                  child: AspectRatio(
                    aspectRatio: 2,
                    child: Image.network(
                      product.thumbnail,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),

              Positioned(
                left: 12,
                top: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    "-${product.discountPercentage.toStringAsFixed(0)}%",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),

              Positioned(
                right: 12,
                top: 12,
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.favorite_border, size: 20),
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.only(
              top: 16,
              left: 10,
              right: 10,
              bottom: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // const SizedBox(height: 5),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        product.brand ?? product.category,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.star,
                            size: 12,
                            color: Colors.orange,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            product.rating.toStringAsFixed(1),
                            style: TextStyle(fontSize: 12, fontWeight: .w600),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    product.category,
                    style: TextStyle(
                      color: Colors.blue.shade700,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    Text(
                      "\$${product.price}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(width: 8),

                    Text(
                      "\$${(product.price / (1 - product.discountPercentage / 100)).toStringAsFixed(2)}",
                      style: TextStyle(
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey.shade500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: product.stock > 10
                        ? Colors.green.shade100
                        : Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    product.stock > 10 ? "In Stock" : "Few Left",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: product.stock > 10
                          ? Colors.green.shade700
                          : Colors.orange.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
