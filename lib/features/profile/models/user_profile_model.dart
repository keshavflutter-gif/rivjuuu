import 'package:equatable/equatable.dart';

class UserProfileModel extends Equatable {
  final String name;
  final String email;
  final String initials;
  final int reviewCount;
  final int favoriteRestaurantCount;
  final int favoriteCouponCount;
  final int friendsCount;
  final int friendRequestsCount;

  const UserProfileModel({
    required this.name,
    required this.email,
    required this.initials,
    this.reviewCount = 6,
    this.favoriteRestaurantCount = 5,
    this.favoriteCouponCount = 3,
    this.friendsCount = 32,
    this.friendRequestsCount = 2,
  });

  UserProfileModel copyWith({
    String? name,
    String? email,
    String? initials,
    int? reviewCount,
    int? favoriteRestaurantCount,
    int? favoriteCouponCount,
    int? friendsCount,
    int? friendRequestsCount,
  }) {
    return UserProfileModel(
      name: name ?? this.name,
      email: email ?? this.email,
      initials: initials ?? this.initials,
      reviewCount: reviewCount ?? this.reviewCount,
      favoriteRestaurantCount:
          favoriteRestaurantCount ?? this.favoriteRestaurantCount,
      favoriteCouponCount: favoriteCouponCount ?? this.favoriteCouponCount,
      friendsCount: friendsCount ?? this.friendsCount,
      friendRequestsCount: friendRequestsCount ?? this.friendRequestsCount,
    );
  }

  @override
  List<Object?> get props => [
        name,
        email,
        initials,
        reviewCount,
        favoriteRestaurantCount,
        favoriteCouponCount,
        friendsCount,
        friendRequestsCount,
      ];
}

