import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';

class RatingWidget extends StatefulWidget {
  double? ratingValue;
  double? starSize;
  double? starSpacing;
  final Function(double)? onValueChanged;

  RatingWidget({
    super.key,
    this.ratingValue,
    this.starSize,
    this.starSpacing,
    this.onValueChanged,
  });

  @override
  State<RatingWidget> createState() => _RatingWidgetState();
}

class _RatingWidgetState extends State<RatingWidget> {
  late double currentRating;

  @override
  void initState() {
    super.initState();
    currentRating = widget.ratingValue ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return RatingStars(
      value: currentRating,
      onValueChanged: widget.onValueChanged != null
          ? (v) {
        setState(() {
          currentRating = v;
        });
        widget.onValueChanged!(v);
      }
          : null, // disable interaction if no callback
      starBuilder: (index, color) {
        bool isStarOn = color == Colors.yellow;
        return Image.asset(
          isStarOn
              ? "assets/images/star_rating.png" // filled star
              : "assets/images/empty_star.png", // empty star
        );
      },
      starCount: 5,
      starSize: widget.starSize ?? 20,
      valueLabelColor: const Color(0xff9b9b9b),
      valueLabelTextStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.normal,
        fontSize: 12.0,
      ),
      maxValue: 5,
      starSpacing: widget.starSpacing ?? 4,
      maxValueVisibility: false,
      valueLabelVisibility: false,
      starOffColor: const Color(0xffe7e8ea),
      starColor: Colors.yellow,
    );
  }
}
