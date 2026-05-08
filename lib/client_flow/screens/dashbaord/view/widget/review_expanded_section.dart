import 'package:flutter/material.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/view/widget/review_ilist_tem.dart';

import '../../../../../host/get_hosts_all_revies.dart';

class ReviewsExpandableSection extends StatefulWidget {
  final List<ReviewAllHost> reviews; // Replace with your review model

  const ReviewsExpandableSection({super.key, required this.reviews});

  @override
  State<ReviewsExpandableSection> createState() => _ReviewsExpandableSectionState();
}

class _ReviewsExpandableSectionState extends State<ReviewsExpandableSection> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "View Reviews",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                  width: 20,
                  child: RotatedBox(
                    quarterTurns: _isExpanded ? 1 : 3,
                    child: const Icon(
                      Icons.arrow_back_ios,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Expandable list area
        if (widget.reviews.isEmpty)
          const Text(
            "No Reviews",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          )
        else
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 300),
          crossFadeState: _isExpanded
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          firstChild: SizedBox(
            height: 300, // approx height for 3 reviews, scroll for more
            child: ListView.builder(
              itemCount: widget.reviews.length,
              itemBuilder: (context, index) {
                return ReviewItem(reviewText: widget.reviews[index]);
              },
            ),
          ),
          secondChild: const SizedBox.shrink(),
        ),
      ],
    );
  }
}
