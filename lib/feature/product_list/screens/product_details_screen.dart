import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:product_list_app/core/widgets/custom_rating_start_widget.dart';
import 'package:product_list_app/feature/product_list/services/models/product_details_model.dart';
import 'package:intl/intl.dart';

class ProductDetailsScreen extends ConsumerStatefulWidget {
  final Product product;
  const ProductDetailsScreen({super.key, required this.product});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends ConsumerState<ProductDetailsScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  @override
  Widget build(BuildContext context) {
    final productDetails = widget.product;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Stack(
              children: [
                Positioned(
                  child: Column(
                    children: [
                      Container(
                        height: MediaQuery.sizeOf(context).height * 0.5,
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: productDetails.images.length,
                          scrollDirection: .horizontal,
                          onPageChanged: (index) {
                            setState(() {
                              _currentPage = index;
                            });
                          },
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                SizedBox(
                                  width: MediaQuery.sizeOf(context).width,
                                  child: Image.network(
                                    productDetails.images[index],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          productDetails.images.length,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: _currentPage == index
                                ? 10
                                : 7, // Makes the active dot slightly larger
                            height: _currentPage == index ? 10 : 7,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              // Blue for active dot (Flipkart style), grey for inactive dots
                              color: _currentPage == index
                                  ? Colors.blue
                                  : Colors.grey.shade400,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: .only(
                            topLeft: .circular(50),
                            topRight: .circular(50),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 20.0,
                            right: 20,
                            top: 20,
                          ),
                          child: Column(
                            crossAxisAlignment: .start,
                            children: [
                              Row(
                                mainAxisAlignment: .spaceBetween,
                                children: [
                                  commanTagButton(productDetails.category),

                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 5,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Text(
                                      "-${productDetails.discountPercentage.toStringAsFixed(0)}%",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 5),
                              // Content
                              Text(
                                productDetails.title,
                                style: TextStyle(
                                  fontSize: 21,
                                  fontWeight: .w700,
                                ),
                              ),

                              SizedBox(height: 5),

                              Row(
                                children: [
                                  Text(
                                    "by",
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontWeight: .w700,
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    productDetails.brand ?? '',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: .w600,
                                      color: Colors.deepPurple,
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 2),

                              Row(
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.star, color: Colors.amber),
                                      SizedBox(width: 3),
                                      Text(productDetails.rating.toString()),
                                      SizedBox(width: 5),
                                      Text(
                                        "(${productDetails.reviews.length.toString()} reviews)",
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 8),
                                  Container(
                                    height: 20,
                                    width: 1,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(width: 8),
                                  Container(
                                    padding: .only(
                                      left: 10,
                                      right: 10,
                                      top: 5,
                                      bottom: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                        255,
                                        146,
                                        243,
                                        151,
                                      ),
                                      borderRadius: .circular(10),
                                    ),
                                    child: Text(
                                      productDetails.availabilityStatus,
                                      style: TextStyle(
                                        fontWeight: .w600,
                                        color: const Color.fromARGB(
                                          255,
                                          51,
                                          93,
                                          53,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 5),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "\$${productDetails.price}",
                                        style: TextStyle(
                                          fontSize: 29,
                                          fontWeight: .w500,
                                          color: Colors.blue,
                                        ),
                                      ),
                                      SizedBox(width: 15),
                                      Text(
                                        "\$${productDetails.discountPercentage}",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: .w600,
                                          color: Colors.grey.shade600,
                                          decoration:
                                              TextDecoration.lineThrough,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    width: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: .circular(10),
                                    ),
                                    padding: .only(
                                      left: 12,
                                      right: 12,
                                      top: 7,
                                      bottom: 7,
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Buy",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Container(
                                padding: .all(5),
                                decoration: BoxDecoration(
                                  border: .all(color: Colors.grey.shade400),
                                  borderRadius: .circular(10),
                                ),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      // radius: 10,
                                      backgroundColor: const Color.fromARGB(
                                        255,
                                        218,
                                        210,
                                        242,
                                      ),
                                      child: Icon(Icons.local_shipping),
                                    ),
                                    SizedBox(width: 5),
                                    Column(
                                      crossAxisAlignment: .start,
                                      children: [
                                        Text("Shipping"),
                                        Text(
                                          productDetails.shippingInformation,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                padding: .all(5),
                                decoration: BoxDecoration(
                                  border: .all(color: Colors.grey.shade400),
                                  borderRadius: .circular(10),
                                ),
                                child: Row(
                                  children: [
                                    CircleAvatar(child: Icon(Icons.policy)),
                                    SizedBox(width: 5),
                                    Column(
                                      crossAxisAlignment: .start,
                                      children: [
                                        Text("Return Policy"),
                                        Text(productDetails.returnPolicy),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                padding: .all(5),
                                decoration: BoxDecoration(
                                  border: .all(color: Colors.grey.shade400),
                                  borderRadius: .circular(10),
                                ),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      child: Icon(Icons.group_rounded),
                                    ),
                                    SizedBox(width: 5),
                                    Column(
                                      crossAxisAlignment: .start,
                                      children: [
                                        Text("Warranty"),
                                        Text(
                                          productDetails.warrantyInformation,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),

                              SizedBox(height: 12),

                              // description
                              Text(
                                "Description",
                                style: TextStyle(
                                  fontWeight: .w700,
                                  fontSize: 19,
                                  color: Colors.grey.shade700,
                                ),
                              ),

                              SizedBox(height: 2),
                              Text(productDetails.description),
                              SizedBox(height: 12),

                              //specification

                              // Tag
                              Text(
                                "Tags",
                                style: TextStyle(
                                  fontWeight: .w700,
                                  fontSize: 19,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              SizedBox(height: 6),
                              Container(
                                height: 40,
                                child: ListView.builder(
                                  physics: BouncingScrollPhysics(),
                                  scrollDirection: .horizontal,
                                  itemCount: productDetails.tags.length,
                                  itemBuilder: (context, index) {
                                    final tag = productDetails.tags[index];

                                    return Row(
                                      children: [
                                        commanTagButton(tag),
                                        SizedBox(width: 10),
                                      ],
                                    );
                                  },
                                ),
                              ),

                              SizedBox(height: 12),

                              Container(
                                height: 300,
                                width: MediaQuery.sizeOf(context).width,
                                decoration: BoxDecoration(
                                  borderRadius: .circular(10),
                                  border: .all(color: Colors.grey.shade300),
                                ),
                                padding: .all(10),
                                child: Column(
                                  crossAxisAlignment: .start,
                                  children: [
                                    Text(
                                      "Reviews (${productDetails.reviews.length})",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    Divider(),
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount:
                                            productDetails.reviews.length,
                                        itemBuilder: ((context, index) {
                                          final review =
                                              productDetails.reviews[index];

                                          return Padding(
                                            padding: const EdgeInsets.only(
                                              bottom: 8.0,
                                            ),
                                            child: Container(
                                              width: MediaQuery.sizeOf(
                                                context,
                                              ).width,
                                              decoration: BoxDecoration(
                                                borderRadius: .circular(10),
                                                border: .all(
                                                  color: Colors.grey.shade300,
                                                ),
                                              ),
                                              padding: .all(10),
                                              child: Column(
                                                mainAxisAlignment: .start,
                                                crossAxisAlignment: .start,
                                                children: [
                                                  Row(
                                                    crossAxisAlignment: .start,
                                                    mainAxisAlignment:
                                                        .spaceBetween,
                                                    children: [
                                                      Column(
                                                        children: [
                                                          Row(
                                                            crossAxisAlignment:
                                                                .start,
                                                            children: [
                                                              CircleAvatar(
                                                                radius: 20,
                                                                child: Icon(
                                                                  Icons.people,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Column(
                                                                crossAxisAlignment:
                                                                    .start,
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        .spaceBetween,
                                                                    children: [
                                                                      Text(
                                                                        review
                                                                            .reviewerName,
                                                                      ),
                                                                    ],
                                                                  ),

                                                                  CustomStarRating(
                                                                    rating: review
                                                                        .rating
                                                                        .toDouble(),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      Text(
                                                        DateFormat(
                                                          'dd/MM/yyyy',
                                                        ).format(review.date),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 3),
                                                  Text(review.comment),
                                                ],
                                              ),
                                            ),
                                          );
                                        }),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                              // Text(productDetails.returnPolicy),
                              // Text(productDetails.shippingInformation),
                              // Text(productDetails.sku),
                              // Text(productDetails.thumbnail),
                              // Text(productDetails.warrantyInformation),
                              // // Text(productDetails.dimensions.height.toString()),
                              // Text(productDetails.discountPercentage.toString()),
                              // Text(productDetails.id.toString()),
                              // Text(productDetails.meta.qrCode),
                              // Text(productDetails.minimumOrderQuantity.toString()),
                              // Text(productDetails.tags.first),
                              // Text(productDetails.rating.toString()),
                              // Text(productDetails.stock.toString()),
                              // Text(productDetails.reviews.first.reviewerName),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Positioned(
                  top: 5,
                  left: 5,
                  right: 5,
                  child: Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      BackButton(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.favorite_border, size: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget commanTagButton(String tagText) {
  return Container(
    padding: .only(left: 10, right: 10, top: 6, bottom: 6),
    decoration: BoxDecoration(
      borderRadius: .circular(20),
      color: const Color.fromARGB(255, 225, 211, 250),
    ),
    child: Center(
      child: Text(
        tagText,
        style: TextStyle(
          fontSize: 15,
          fontWeight: .w600,
          color: Colors.deepPurple,
        ),
      ),
    ),
  );
}
