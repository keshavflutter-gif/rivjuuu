import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_assets.dart';

class AboutHourModel extends Equatable {
  final String day;
  final String hours;

  const AboutHourModel({required this.day, required this.hours});

  @override
  List<Object?> get props => [day, hours];
}

class RestaurantDetailModel extends Equatable {
  final String name;
  final String logoText;
  final double rating;
  final int reviewCount;
  final String cuisine;
  final String openStatus;
  final String openTimeText;
  final String distance;
  final String address;
  final String description;
  final int couponCount;
  final int photosCount;
  final String heroImage;
  final List<AboutHourModel> aboutHours;
  final String aboutDescription;
  final String aboutTags;
  final String fullAddress;
  final String distanceFromYou;

  const RestaurantDetailModel({
    required this.name,
    required this.logoText,
    required this.rating,
    required this.reviewCount,
    required this.cuisine,
    required this.openStatus,
    required this.openTimeText,
    required this.distance,
    required this.address,
    required this.description,
    required this.couponCount,
    required this.photosCount,
    required this.heroImage,
    required this.aboutHours,
    required this.aboutDescription,
    required this.aboutTags,
    required this.fullAddress,
    required this.distanceFromYou,
  });

  factory RestaurantDetailModel.defaultTrattoria() {
    return const RestaurantDetailModel(
      name: 'Trattoria Nonna Rosa',
      logoText: 'NR',
      rating: 8.9,
      reviewCount: 214,
      cuisine: 'Italian',
      openStatus: 'Open',
      openTimeText: 'until 23:00',
      distance: '1.2 km',
      address: 'Fő utca 12',
      description: 'Hand-made pasta, a wood-fired oven and a quiet courtyard.',
      couponCount: 3,
      photosCount: 12,
      heroImage: AppAssets.interior,
      aboutHours: [
        AboutHourModel(day: 'Mon–Thu', hours: '12:00–22:00'),
        AboutHourModel(day: 'Fri–Sat', hours: '12:00–23:00'),
        AboutHourModel(day: 'Sunday', hours: '12:00–21:00'),
      ],
      aboutDescription:
          'Family-run Italian kitchen with fresh pasta made every morning, a wood-fired oven and a quiet courtyard for summer evenings.',
      aboutTags: 'Italian · Pasta · Pizza · Desserts',
      fullAddress: 'Fő utca 12, Hungary',
      distanceFromYou: '1.2 km from you',
    );
  }

  @override
  List<Object?> get props => [
        name,
        logoText,
        rating,
        reviewCount,
        cuisine,
        openStatus,
        openTimeText,
        distance,
        address,
        description,
        couponCount,
        photosCount,
        heroImage,
        aboutHours,
        aboutDescription,
        aboutTags,
        fullAddress,
        distanceFromYou,
      ];
}

class MenuItemModel extends Equatable {
  final String id;
  final String name;
  final String? description;
  final String price;
  final String? imageUrl;
  final String section;

  const MenuItemModel({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    this.imageUrl,
    required this.section,
  });

  @override
  List<Object?> get props => [id, name, description, price, imageUrl, section];
}

enum CouponStatusType { available, wait, expired, used }

class CouponModel extends Equatable {
  final String id;
  final String discountVal;
  final String discountSmall;
  final IconData? icon;
  final String type;
  final String title;
  final String requirement;
  final String statusText;
  final CouponStatusType statusType;
  final String? meta;
  final bool isDark;
  final bool isPast;

  const CouponModel({
    required this.id,
    required this.discountVal,
    required this.discountSmall,
    this.icon,
    required this.type,
    required this.title,
    required this.requirement,
    required this.statusText,
    required this.statusType,
    this.meta,
    this.isDark = false,
    this.isPast = false,
  });

  @override
  List<Object?> get props => [
        id,
        discountVal,
        discountSmall,
        icon,
        type,
        title,
        requirement,
        statusText,
        statusType,
        meta,
        isDark,
        isPast,
      ];
}

class LoyaltyRewardModel extends Equatable {
  final String id;
  final String title;
  final String pointsText;
  final String imageUrl;
  final bool isLocked;

  const LoyaltyRewardModel({
    required this.id,
    required this.title,
    required this.pointsText,
    required this.imageUrl,
    required this.isLocked,
  });

  @override
  List<Object?> get props => [id, title, pointsText, imageUrl, isLocked];
}

class LoyaltyActivityModel extends Equatable {
  final String title;
  final String date;
  final String deltaText;
  final bool isPositive;

  const LoyaltyActivityModel({
    required this.title,
    required this.date,
    required this.deltaText,
    required this.isPositive,
  });

  @override
  List<Object?> get props => [title, date, deltaText, isPositive];
}

enum GiveawayStatus { open, joined, won, ended }

class GiveawayModel extends Equatable {
  final String id;
  final String title;
  final String? prize;
  final String dateMeta;
  final String? joinedMeta;
  final String imageUrl;
  final GiveawayStatus status;
  final String? actionText;

  const GiveawayModel({
    required this.id,
    required this.title,
    this.prize,
    required this.dateMeta,
    this.joinedMeta,
    required this.imageUrl,
    required this.status,
    this.actionText,
  });

  GiveawayModel copyWith({GiveawayStatus? status, String? actionText}) {
    return GiveawayModel(
      id: id,
      title: title,
      prize: prize,
      dateMeta: dateMeta,
      joinedMeta: joinedMeta,
      imageUrl: imageUrl,
      status: status ?? this.status,
      actionText: actionText ?? this.actionText,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        prize,
        dateMeta,
        joinedMeta,
        imageUrl,
        status,
        actionText,
      ];
}

class ReviewModel extends Equatable {
  final String id;
  final String initials;
  final String name;
  final String date;
  final bool visitedWithCoupon;
  final double score;
  final String text;
  final List<String> images;
  final Color avatarBg;
  final Color avatarColor;

  const ReviewModel({
    required this.id,
    required this.initials,
    required this.name,
    required this.date,
    required this.visitedWithCoupon,
    required this.score,
    required this.text,
    this.images = const [],
    required this.avatarBg,
    required this.avatarColor,
  });

  @override
  List<Object?> get props => [
        id,
        initials,
        name,
        date,
        visitedWithCoupon,
        score,
        text,
        images,
        avatarBg,
        avatarColor,
      ];
}

