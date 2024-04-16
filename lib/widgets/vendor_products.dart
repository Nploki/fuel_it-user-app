import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fuel_it/widgets/product_card.dart';

class vendor_products extends StatelessWidget {
  final String sellerId;
  final num dist;
  vendor_products({required this.sellerId, required this.dist});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('products')
            .where('sellerUid', isEqualTo: sellerId)
            .where('published', isEqualTo: true)
            .get(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final products = snapshot.data!.docs;
          return Column(
            children: List.generate(
              (products.length / 2).ceil(),
              (index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ProductCard(
                          product: products[index * 2], distance: dist),
                    ),
                    const SizedBox(width: 8.0),
                    if (index * 2 + 1 < products.length)
                      Expanded(
                        child: ProductCard(
                            product: products[index * 2 + 1], distance: dist),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
