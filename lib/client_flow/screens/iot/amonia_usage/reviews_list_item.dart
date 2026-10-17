import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/iot/amonia_usage/iot_reviews_response_model.dart';

import '../../../../utils/app_images.dart';


class ReviewCardItem extends StatefulWidget {
  final CommentReview? review;

  const ReviewCardItem({super.key, required this.review});

  @override
  State<ReviewCardItem> createState() => _ReviewCardItemState();
}

class _ReviewCardItemState extends State<ReviewCardItem> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final review = widget.review;
    final DateTime? dateTime = review?.createdAt?.toLocal();

    final String formattedDate = dateTime != null
        ? DateFormat("d MMM").format(dateTime)
        : "";

    final String formattedTime = dateTime != null
        ? DateFormat("h.mm a").format(dateTime)
        : "";

    final String commentText = review?.comments ?? "";

    return  Container(
      margin: const EdgeInsets.symmetric(horizontal: 1 , vertical: 10) ,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 10,
          )
        ],
      ),
      child:  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Comment text
          Semantics(
              label: "Review list",
              value: "$commentText",
              child:
          Text(
            commentText,
            maxLines: isExpanded ? null : 3,
            overflow:
            isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ), ),

          /// Show more / Show less
          if (commentText.length > 100) // prevent button for small text
            GestureDetector(
              onTap: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child:
                Semantics(
                  label: "Review list",
                  value: "show more or less",
                  child:
                Text(
                  isExpanded ? "Show less" : "Show more...",
                  style: const TextStyle(
                    color: Colors.blue,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                ),
              ),
            ),


          const SizedBox(height: 8),

          /// Rating Row
          Row(
            children: [
            Semantics(
            label: "Review list",
    value: "${review?.rating.toString()}",
    child:
              Text(
          review?.rating.toString() ?? "1",
                style: const TextStyle(fontSize: 14),
              ),
            ),
              const SizedBox(width: 6),

              Row(
                children: List.generate(5, (index) {
                  return
                    Semantics(
                        label: "Review list",
                        value: "stars",
                        child:
                    Padding(
                    padding: const EdgeInsets.only(right: 2),
                    child: Opacity(
                      opacity: index < review!.rating! ? 1 : 0.3, // faded empty stars
                      child: Image.asset(
                        AppImages.stars,
                        height: 16,
                        width: 16,
                      ),
                    ),
                  ),
                    );
                }),
              ),
            ],
          ),

          const SizedBox(height: 8),

    Semantics(
    label: "Review list",
    value:  "${(review?.guestName?.trim().isNotEmpty ?? false)
        ? review!.guestName!.trim()
        : "Woloo User"}  | $formattedDate | $formattedTime",
    child:
          Text(
            "${(review?.guestName?.trim().isNotEmpty ?? false)
                ? review!.guestName!.trim()
                : "Woloo User"}  | $formattedDate | $formattedTime",
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
    ),
        ],
      ),
    );
  }
}

