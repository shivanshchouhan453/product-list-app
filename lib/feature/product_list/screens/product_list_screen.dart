import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final screenWidth = MediaQuery.sizeOf(context).width;

    final productAsync = ref.watch(fetchAllProductDetails);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Row(
            children: [
              // circle
              CircleAvatar(radius: 22, backgroundColor: Colors.blue.shade500),
              SizedBox(width: 12),
              // greeting + name
              Column(
                crossAxisAlignment: .start,
                children: [
                  Text("GOOD MORNING", style: TextStyle(fontSize: 15)),
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
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(Icons.notifications, color: Colors.blue),
            ),
          ],
        ),
        body: Container(
          width: screenWidth,
          height: screenHeight,
          color: const Color.fromARGB(255, 237, 233, 233),
          padding: EdgeInsets.all(30),
          child: Column(
            children: [
              // show the banner
              SizedBox(
                width: screenWidth,
                height: screenHeight * 0.228,

                child: Stack(
                  children: [
                    Positioned(
                      child: Container(
                        width: screenWidth,
                        height: screenHeight * 0.2,

                        padding: EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            Spacer(),
                            Text(
                              "Hii, Shiv Baba",
                              style: TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                              ),
                            ),
                            Spacer(),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 1,
                      child: Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Container(
                          width: screenWidth * 0.8,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: .circular(30),
                          ),
                          child: TextField(
                            autocorrect: true,
                            controller: searchProductController,
                            decoration: InputDecoration(
                              label: Icon(Icons.search),
                              hintText: "Search for product",
                              hintStyle: TextStyle(color: Colors.black),
                              border: OutlineInputBorder(
                                borderRadius: .circular(30),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
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
              SizedBox(height: 50),
              Expanded(
                child: productAsync.when(
                  data: (productList) {
                    return ListView.builder(
                      itemCount: productList.limit,
                      itemBuilder: (context, index) {
                        final product = productList.products[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: .circular(20),
                            ),
                            padding: .all(20),
                            child: Column(
                              crossAxisAlignment: .start,
                              children: [
                                Container(
                                  height: 200,
                                  width: 200,
                                  child: Center(
                                    child: Image.network(product.images.first),
                                  ),
                                ),
                                Text(product.title),
                                Text(product.description),
                                Text(product.category),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  error: (e, s) => Text("Error :$e"),
                  loading: () => Center(child: CircularProgressIndicator()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
