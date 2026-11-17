import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/api/api_exception.dart';
import '../../../../core/constants/app_messages.dart';
import '../../../../core/storage/token_storage_service.dart';
import '../../../../core/utils/validators.dart';
import '../../../../data/models/auth/login_request.dart';
import '../../../../data/models/auth/login_response.dart';
import '../../../../data/repositories/auth/login_repository.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  static LoginRepository? defaultRepository;
  final LoginRepository _repository;
  final TokenStorageService? tokenStorageService;

  LoginBloc({
    LoginRepository? repository,
    this.tokenStorageService,
  })  : _repository = repository ?? defaultRepository ?? LoginRepositoryImpl(),
        super(const LoginInitial()) {
    on<LoginEmailChanged>(_onEmailChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginPasswordVisibilityToggled>(_onVisibilityToggled);
    on<LoginSubmitted>(_onSubmitted);
    on<LoginSessionChecked>(_onSessionChecked);
    on<LogoutRequested>(_onLogoutRequested);
  }

  void _onEmailChanged(LoginEmailChanged event, Emitter<LoginState> emit) {
    emit(LoginInitial(
      email: event.email,
      password: state.password,
      obscurePassword: state.obscurePassword,
      fieldErrors: state.fieldErrors != null
          ? (Map<String, String>.from(state.fieldErrors!)..remove('email'))
          : null,
    ));
  }

  void _onPasswordChanged(LoginPasswordChanged event, Emitter<LoginState> emit) {
    emit(LoginInitial(
      email: state.email,
      password: event.password,
      obscurePassword: state.obscurePassword,
      fieldErrors: state.fieldErrors != null
          ? (Map<String, String>.from(state.fieldErrors!)..remove('password'))
          : null,
    ));
  }

  void _onVisibilityToggled(
    LoginPasswordVisibilityToggled event,
    Emitter<LoginState> emit,
  ) {
    final nextObscure = !state.obscurePassword;
    if (state is LoginLoading) {
      emit(LoginLoading(
        email: state.email,
        password: state.password,
        obscurePassword: nextObscure,
        fieldErrors: state.fieldErrors,
      ));
    } else if (state is LoginFailure) {
      final s = state as LoginFailure;
      emit(LoginFailure(
        message: s.message,
        statusCode: s.statusCode,
        email: state.email,
        password: state.password,
        obscurePassword: nextObscure,
        fieldErrors: state.fieldErrors,
      ));
    } else {
      emit(LoginInitial(
        email: state.email,
        password: state.password,
        obscurePassword: nextObscure,
        fieldErrors: state.fieldErrors,
      ));
    }
  }

  Future<void> _onSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    // Prevent duplicate simultaneous submissions
    if (state is LoginLoading) return;

    final email = (event.email ?? state.email).trim();
    final password = event.password ?? state.password;

    final emailError = Validators.validateEmail(email);
    final passwordError = Validators.validateLoginPassword(password);

    if (emailError != null || passwordError != null) {
      final fieldErrors = <String, String>{};
      if (emailError != null) fieldErrors['email'] = emailError;
      if (passwordError != null) fieldErrors['password'] = passwordError;

      emit(LoginFailure(
        message: emailError ?? passwordError ?? 'Please check your inputs',
        email: email,
        password: password,
        obscurePassword: state.obscurePassword,
        fieldErrors: fieldErrors,
      ));
      return;
    }

    emit(LoginLoading(
      email: email,
      password: password,
      obscurePassword: state.obscurePassword,
    ));

    try {
      final response = await _repository.login(
        LoginRequest(email: email, password: password),
      );

      // Verify success == 1 and non-empty access token
      if (response.success == 1 &&
          response.accessToken != null &&
          response.accessToken!.isNotEmpty) {
        final user = response.user;
        final role = (response.role ?? user?.role ?? '').toUpperCase();

        // Check if role is CUSTOMER or RESTAURANT
        if (role != 'CUSTOMER' && role != 'RESTAURANT') {
          emit(LoginFailure(
            message: AppMessages.unsupportedRole,
            email: email,
            password: password,
            obscurePassword: state.obscurePassword,
          ));
          return;
        }

        // Save session in SharedPreferences
        final storage =
            tokenStorageService ?? await TokenStorageService.getInstance();
        final profile = user?.customerProfile;
        final displayName = profile?.displayName ??
            '${user?.firstName ?? ''} ${user?.lastName ?? ''}'.trim();

        final saved = await storage.saveLoginSession(
          accessToken: response.accessToken!,
          refreshToken: response.refreshToken ?? '',
          userId: user?.id ?? '',
          email: user?.email ?? email,
          firstName: user?.firstName,
          lastName: user?.lastName,
          phone: user?.phone,
          role: role,
          status: user?.status ?? 'ACTIVE',
          customerProfileId: profile?.id,
          displayName: displayName.isNotEmpty ? displayName : null,
          avatarUrl: profile?.avatarUrl,
          bio: profile?.bio,
        );

        if (!saved) {
          emit(LoginFailure(
            message: 'Failed to securely store authentication session.',
            email: email,
            password: password,
            obscurePassword: state.obscurePassword,
          ));
          return;
        }

        emit(LoginSuccess(
          response: response,
          email: email,
          password: password,
          obscurePassword: state.obscurePassword,
        ));
      } else {
        emit(LoginFailure(
          message: response.message.isNotEmpty
              ? response.message
              : AppMessages.invalidCredentials,
          email: email,
          password: password,
          obscurePassword: state.obscurePassword,
        ));
      }
    } on ApiException catch (e) {
      emit(LoginFailure(
        message: e.message,
        statusCode: e.statusCode,
        email: email,
        password: password,
        obscurePassword: state.obscurePassword,
        fieldErrors: e.fieldErrors,
      ));
    } catch (e) {
      emit(LoginFailure(
        message: e.toString(),
        email: email,
        password: password,
        obscurePassword: state.obscurePassword,
      ));
    }
  }

  Future<void> _onSessionChecked(
    LoginSessionChecked event,
    Emitter<LoginState> emit,
  ) async {
    final storage =
        tokenStorageService ?? await TokenStorageService.getInstance();
    final loggedIn = await storage.isLoggedIn();
    if (loggedIn) {
      final userData = await storage.getUserData();
      final role = (userData['role'] ?? '').toUpperCase();
      if (role == 'CUSTOMER') {
        emit(LoginSuccess(
          response: LoginResponse(
            success: 1,
            message: AppMessages.loginSuccess,
            accessToken: await storage.getAccessToken(),
            refreshToken: await storage.getRefreshToken(),
            role: role,
            user: LoginUser(
              id: userData['userId'] ?? '',
              email: userData['email'] ?? '',
              firstName: userData['firstName'],
              lastName: userData['lastName'],
              phone: userData['phone'],
              role: role,
              status: userData['status'],
              customerProfile: CustomerProfile(
                id: userData['customerProfileId'] ?? '',
                displayName: userData['displayName'],
                avatarUrl: userData['avatarUrl'],
                bio: userData['bio'],
              ),
            ),
          ),
        ));
        return;
      }
    }
    emit(const LoginInitial());
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<LoginState> emit,
  ) async {
    final storage =
        tokenStorageService ?? await TokenStorageService.getInstance();
    await storage.clearSession();
    emit(const LoginInitial());
  }
}
