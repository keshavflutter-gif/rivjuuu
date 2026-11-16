import 'package:flutter_bloc/flutter_bloc.dart';
import 'signup_event.dart';
import 'signup_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc() : super(const SignUpState()) {
    on<SignUpNameChanged>(_onNameChanged);
    on<SignUpEmailChanged>(_onEmailChanged);
    on<SignUpPasswordChanged>(_onPasswordChanged);
    on<SignUpConfirmPasswordChanged>(_onConfirmPasswordChanged);
    on<SignUpPasswordVisibilityToggled>(_onPasswordVisibilityToggled);
    on<SignUpConfirmPasswordVisibilityToggled>(
        _onConfirmPasswordVisibilityToggled);
    on<SignUpTermsToggled>(_onTermsToggled);
    on<SignUpSubmitted>(_onSubmitted);
  }

  void _onNameChanged(SignUpNameChanged event, Emitter<SignUpState> emit) {
    emit(state.copyWith(name: event.name));
  }

  void _onEmailChanged(SignUpEmailChanged event, Emitter<SignUpState> emit) {
    emit(state.copyWith(email: event.email));
  }

  void _onPasswordChanged(
      SignUpPasswordChanged event, Emitter<SignUpState> emit) {
    emit(state.copyWith(password: event.password));
  }

  void _onConfirmPasswordChanged(
      SignUpConfirmPasswordChanged event, Emitter<SignUpState> emit) {
    emit(state.copyWith(confirmPassword: event.confirmPassword));
  }

  void _onPasswordVisibilityToggled(
      SignUpPasswordVisibilityToggled event, Emitter<SignUpState> emit) {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }

  void _onConfirmPasswordVisibilityToggled(
      SignUpConfirmPasswordVisibilityToggled event, Emitter<SignUpState> emit) {
    emit(state.copyWith(
        isConfirmPasswordVisible: !state.isConfirmPasswordVisible));
  }

  void _onTermsToggled(SignUpTermsToggled event, Emitter<SignUpState> emit) {
    emit(state.copyWith(agreedToTerms: !state.agreedToTerms));
  }

  void _onSubmitted(SignUpSubmitted event, Emitter<SignUpState> emit) {
    emit(state.copyWith(isSubmitting: true));
    emit(state.copyWith(isSubmitting: false, isSuccess: true));
  }
}

