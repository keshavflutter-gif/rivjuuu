import 'package:flutter/material.dart';
import 'coupon_qr_view.dart';

class CouponQrPage extends StatelessWidget {
  final String? restaurant;
  final String? discount;
  final String? title;
  final bool openRedemptionSuccess;

  const CouponQrPage({
    super.key,
    this.restaurant,
    this.discount,
    this.title,
    this.openRedemptionSuccess = false,
  });

  @override
  Widget build(BuildContext context) {
    return CouponQrView(
      restaurant: restaurant ?? 'Trattoria Nonna Rosa',
      discount: discount ?? '20% OFF',
      title: title ?? '20% off your whole bill',
      openRedemptionSuccess: openRedemptionSuccess,
    );
  }
}
