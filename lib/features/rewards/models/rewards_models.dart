import 'package:equatable/equatable.dart';

class RestaurantLoyaltyCardModel extends Equatable {
  final String id;
  final String name;
  final String logoText;
  final String activeAgo;
  final int points;
  final int targetPoints;
  final double progress;
  final String footerText;
  final bool isReady;
  final String imagePath;

  const RestaurantLoyaltyCardModel({
    required this.id,
    required this.name,
    required this.logoText,
    required this.activeAgo,
    required this.points,
    required this.targetPoints,
    required this.progress,
    required this.footerText,
    this.isReady = false,
    required this.imagePath,
  });

  RestaurantLoyaltyCardModel copyWith({
    String? id,
    String? name,
    String? logoText,
    String? activeAgo,
    int? points,
    int? targetPoints,
    double? progress,
    String? footerText,
    bool? isReady,
    String? imagePath,
  }) {
    return RestaurantLoyaltyCardModel(
      id: id ?? this.id,
      name: name ?? this.name,
      logoText: logoText ?? this.logoText,
      activeAgo: activeAgo ?? this.activeAgo,
      points: points ?? this.points,
      targetPoints: targetPoints ?? this.targetPoints,
      progress: progress ?? this.progress,
      footerText: footerText ?? this.footerText,
      isReady: isReady ?? this.isReady,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        logoText,
        activeAgo,
        points,
        targetPoints,
        progress,
        footerText,
        isReady,
        imagePath,
      ];
}

class LoyaltyRewardItemModel extends Equatable {
  final String id;
  final String title;
  final int points;
  final String subtitle;
  final String imagePath;
  final bool isLocked;

  const LoyaltyRewardItemModel({
    required this.id,
    required this.title,
    required this.points,
    required this.subtitle,
    required this.imagePath,
    required this.isLocked,
  });

  LoyaltyRewardItemModel copyWith({
    String? id,
    String? title,
    int? points,
    String? subtitle,
    String? imagePath,
    bool? isLocked,
  }) {
    return LoyaltyRewardItemModel(
      id: id ?? this.id,
      title: title ?? this.title,
      points: points ?? this.points,
      subtitle: subtitle ?? this.subtitle,
      imagePath: imagePath ?? this.imagePath,
      isLocked: isLocked ?? this.isLocked,
    );
  }

  @override
  List<Object?> get props => [id, title, points, subtitle, imagePath, isLocked];
}

class LoyaltyActivityItemModel extends Equatable {
  final String title;
  final String date;
  final String deltaText;
  final bool isPositive;

  const LoyaltyActivityItemModel({
    required this.title,
    required this.date,
    required this.deltaText,
    required this.isPositive,
  });

  @override
  List<Object?> get props => [title, date, deltaText, isPositive];
}

class LoyaltyDetailModel extends Equatable {
  final String id;
  final String restaurantName;
  final String logoText;
  final int points;
  final int maxPoints;
  final int pointsToNext;
  final String nextRewardTitle;
  final List<LoyaltyRewardItemModel> rewards;
  final List<LoyaltyActivityItemModel> activities;

  const LoyaltyDetailModel({
    required this.id,
    required this.restaurantName,
    required this.logoText,
    required this.points,
    required this.maxPoints,
    required this.pointsToNext,
    required this.nextRewardTitle,
    required this.rewards,
    required this.activities,
  });

  LoyaltyDetailModel copyWith({
    String? id,
    String? restaurantName,
    String? logoText,
    int? points,
    int? maxPoints,
    int? pointsToNext,
    String? nextRewardTitle,
    List<LoyaltyRewardItemModel>? rewards,
    List<LoyaltyActivityItemModel>? activities,
  }) {
    return LoyaltyDetailModel(
      id: id ?? this.id,
      restaurantName: restaurantName ?? this.restaurantName,
      logoText: logoText ?? this.logoText,
      points: points ?? this.points,
      maxPoints: maxPoints ?? this.maxPoints,
      pointsToNext: pointsToNext ?? this.pointsToNext,
      nextRewardTitle: nextRewardTitle ?? this.nextRewardTitle,
      rewards: rewards ?? this.rewards,
      activities: activities ?? this.activities,
    );
  }

  @override
  List<Object?> get props => [
        id,
        restaurantName,
        logoText,
        points,
        maxPoints,
        pointsToNext,
        nextRewardTitle,
        rewards,
        activities,
      ];
}

class RedeemedRewardSummary extends Equatable {
  final String restaurantName;
  final String rewardTitle;
  final int pointsUsed;
  final int pointsLeft;

  const RedeemedRewardSummary({
    required this.restaurantName,
    required this.rewardTitle,
    required this.pointsUsed,
    required this.pointsLeft,
  });

  @override
  List<Object?> get props => [
        restaurantName,
        rewardTitle,
        pointsUsed,
        pointsLeft,
      ];
}

