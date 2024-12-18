import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../models/product.dart';

class ProductTile extends StatelessWidget {
  final Product product;

  ProductTile({required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Fixed size container for image
        SizedBox(
          width: MediaQuery.of(context).size.width / 2.5, // 50% of the screen width
          height: MediaQuery.of(context).size.height / 6, // Fixed height for the image
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl : product.imageUrl,
              fit: BoxFit.fill, // Ensures the image fits the container
            ),
          ),
        ),
        SizedBox(height: 8), // Add some space between image and text
        // Wrap Text widgets inside a Flexible widget
        Flexible(
          child: Text(
            product.name,
            style: TextStyle(fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis, // Handle overflow if text is too long
          ),
        ),
        Flexible(
          child: Text(
            '\$${product.price}',
            style: TextStyle(color: Colors.green),
            overflow: TextOverflow.ellipsis, // Handle overflow if text is too long
          ),
        ),
      ],
    );
  }
}
