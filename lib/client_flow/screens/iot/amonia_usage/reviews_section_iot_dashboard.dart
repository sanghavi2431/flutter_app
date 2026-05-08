import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/iot/amonia_usage/reviews_list_item.dart';

import '../../../../b2b_store/product_details.dart';
import '../../../../utils/app_color.dart';
import '../../../../utils/app_images.dart';
import 'iot_reviews_response_model.dart';

class ReviewList extends StatelessWidget {
  final List<CommentReview>? review;

  const ReviewList({super.key, required this.review
   });

  @override
  Widget build(BuildContext context) {
    final reviews = review ?? [];

    return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      /// Header
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Semantics(
              label: "Reviews list",
              value: "reviews the header",
              child:
           Text(
            "Reviews",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          ),
          if (reviews.isNotEmpty)
            GestureDetector(
              onTap: () => _showAllReviews(context , reviews),
              child:
              Semantics(
                label: "Reviews list",
                value: "reviews view all",
                child:
              Text(
                "View All",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ),
        ],
      ),

      const SizedBox(height: 12),

      /// If Empty
      if (reviews.isEmpty)
    Semantics(
    label: "Reviews list",
    value: "No reviews Added",
    child:
         Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text(
              "No reviews added",
              style: TextStyle(fontSize: 14),
            ),
          ),
        ),
    )
      else
        Column(
          children: reviews
              .take(2) // show only 2
              .map((e) => ReviewCardItem(review: e))
              .toList(),
        ),
    ],
  );
}


}

void _showAllReviews(BuildContext context ,  List<CommentReview> reviews) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return Column(
            children: [
              /// 40px drag line space
              const SizedBox(height: 12),

              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2), // Shadow color
                    spreadRadius: 1, // How wide the shadow should spread
                    blurRadius: 10, // The blur effect of the shadow
                    offset: const Offset(0, 0), // No offset for shadow on all sides
                  ),
                ], color: AppColors.white, borderRadius: BorderRadius.circular(20)),
              ),

              const SizedBox(height: 16),

              const Text(
                "Reviews",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              /// Divider
              const Divider(height: 1),

              const SizedBox(height: 10),

              /// List
              Expanded(
                child: reviews.isEmpty
                    ? const Center(
                  child: Text(
                    "No records found",
                    style: TextStyle(fontSize: 14),
                  ),
                )
                    : ListView.builder(
                  controller: scrollController,
                  itemCount: reviews.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding:
                      const EdgeInsets.symmetric(
                          horizontal: 16),
                      child: ReviewCardItem(
                        review: reviews[index],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      );
    },
  );
}
