import 'package:flutter/material.dart';
import 'review_detail_view.dart';

class ReviewDetailPage extends StatelessWidget {
  final Map<String, dynamic>? reviewData;

  const ReviewDetailPage({super.key, this.reviewData});

  @override
  Widget build(BuildContext context) {
    return ReviewDetailView(reviewData: reviewData);
  }
}
