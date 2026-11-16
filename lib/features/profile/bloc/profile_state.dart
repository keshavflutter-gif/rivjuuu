import 'package:equatable/equatable.dart';
import '../models/user_profile_model.dart';

class ProfileState extends Equatable {
  final UserProfileModel profile;
  final bool isSavedSuccess;

  const ProfileState({
    required this.profile,
    this.isSavedSuccess = false,
  });

  static const defaultProfile = UserProfileModel(
    name: 'Márk Szilágyi',
    email: 'mark.szilagyi@example.com',
    initials: 'MS',
    reviewCount: 6,
    favoriteRestaurantCount: 5,
    favoriteCouponCount: 3,
    friendsCount: 32,
    friendRequestsCount: 2,
  );

  ProfileState copyWith({
    UserProfileModel? profile,
    bool? isSavedSuccess,
  }) {
    return ProfileState(
      profile: profile ?? this.profile,
      isSavedSuccess: isSavedSuccess ?? this.isSavedSuccess,
    );
  }

  @override
  List<Object?> get props => [profile, isSavedSuccess];
}

