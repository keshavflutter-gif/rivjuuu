import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/storage/token_storage_service.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final TokenStorageService? tokenStorageService;

  ProfileBloc({this.tokenStorageService})
      : super(const ProfileState(profile: ProfileState.defaultProfile)) {
    on<ProfileLoaded>(_onLoaded);
    on<ProfileNameUpdated>(_onNameUpdated);
  }

  Future<void> _onLoaded(ProfileLoaded event, Emitter<ProfileState> emit) async {
    try {
      final storage =
          tokenStorageService ?? await TokenStorageService.getInstance();
      final userData = await storage.getUserData();

      final storedEmail = userData['email'];
      final storedDisplayName = userData['displayName'];
      final storedFirstName = userData['firstName'];
      final storedLastName = userData['lastName'];

      String resolvedName = state.profile.name;
      if (storedDisplayName != null && storedDisplayName.trim().isNotEmpty) {
        resolvedName = storedDisplayName.trim();
      } else {
        final combined = [storedFirstName, storedLastName]
            .where((s) => s != null && s.trim().isNotEmpty)
            .join(' ')
            .trim();
        if (combined.isNotEmpty) {
          resolvedName = combined;
        }
      }

      String resolvedEmail = state.profile.email;
      if (storedEmail != null && storedEmail.trim().isNotEmpty) {
        resolvedEmail = storedEmail.trim();
      }

      // Generate initials from resolvedName
      String initials = state.profile.initials;
      final parts = resolvedName.trim().split(RegExp(r'\s+'));
      if (parts.isNotEmpty && parts[0].isNotEmpty) {
        if (parts.length > 1 && parts[1].isNotEmpty) {
          initials = '${parts[0][0]}${parts[1][0]}'.toUpperCase();
        } else if (parts[0].length >= 2) {
          initials = parts[0].substring(0, 2).toUpperCase();
        } else {
          initials = parts[0][0].toUpperCase();
        }
      }

      final updatedProfile = state.profile.copyWith(
        name: resolvedName,
        email: resolvedEmail,
        initials: initials,
      );

      emit(state.copyWith(profile: updatedProfile, isSavedSuccess: false));
    } catch (_) {
      emit(state.copyWith(isSavedSuccess: false));
    }
  }

  Future<void> _onNameUpdated(
    ProfileNameUpdated event,
    Emitter<ProfileState> emit,
  ) async {
    final newName = event.newName.trim();
    final names = newName.split(RegExp(r'\s+'));
    String initials = 'MS';
    if (names.isNotEmpty && names[0].isNotEmpty) {
      if (names.length > 1 && names[1].isNotEmpty) {
        initials = '${names[0][0]}${names[1][0]}'.toUpperCase();
      } else if (names[0].length >= 2) {
        initials = names[0].substring(0, 2).toUpperCase();
      } else {
        initials = names[0][0].toUpperCase();
      }
    }

    final updated = state.profile.copyWith(
      name: newName,
      initials: initials,
    );
    emit(state.copyWith(profile: updated, isSavedSuccess: true));

    try {
      final storage =
          tokenStorageService ?? await TokenStorageService.getInstance();
      await storage.updateDisplayName(newName);
    } catch (_) {}
  }
}
