import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/extensions/localization_extension.dart';
import '../../../core/routes/app_router.dart';
import '../../../core/storage/token_storage_service.dart';
import '../../../core/utils/localized_messages.dart';
import '../bloc/restaurant_signup_bloc.dart';
import '../bloc/restaurant_signup_event.dart';
import '../bloc/restaurant_signup_state.dart';
import '../models/restaurant_registration_data.dart';
import '../repository/restaurant_signup_repository.dart';
import '../widgets/step_progress_app_bar.dart';
import 'restaurant_step1_view.dart';
import 'restaurant_step2_view.dart';
import 'restaurant_step3_view.dart';
import 'restaurant_step4_view.dart';

class RestaurantSignupFlowPage extends StatefulWidget {
  final int initialStep;
  final RestaurantRegistrationData? initialData;
  final RestaurantSignupRepository? repository;

  const RestaurantSignupFlowPage({
    super.key,
    this.initialStep = 0,
    this.initialData,
    this.repository,
  });

  @override
  State<RestaurantSignupFlowPage> createState() =>
      _RestaurantSignupFlowPageState();
}

class _RestaurantSignupFlowPageState extends State<RestaurantSignupFlowPage> {
  late final PageController _pageController;
  late final RestaurantSignupBloc _bloc;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialStep);

    RestaurantSignupState? initialState;
    if (widget.initialData != null) {
      initialState = widget.initialData!.toBlocState(
        stepIndex: widget.initialStep,
      );
    } else if (widget.initialStep > 0) {
      initialState = RestaurantSignupState(currentStepIndex: widget.initialStep);
    }

    _bloc = RestaurantSignupBloc(
      initialState: initialState,
      repository: widget.repository,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _bloc.close();
    super.dispose();
  }

  void _handleBackNavigation(BuildContext context) {
    if (_bloc.state.currentStepIndex > 0) {
      _bloc.add(const PreviousStepRequested());
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Builder(
        builder: (ctx) {
          return PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) {
              if (didPop) return;
              _handleBackNavigation(ctx);
            },
            child: Scaffold(
              backgroundColor: AppColors.cream,
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(56),
                child: BlocBuilder<RestaurantSignupBloc, RestaurantSignupState>(
                  buildWhen: (prev, curr) =>
                      prev.currentStepIndex != curr.currentStepIndex,
                  builder: (context, state) {
                    return StepProgressAppBar(
                      step: state.currentStepIndex + 1,
                      onBack: () => _handleBackNavigation(ctx),
                    );
                  },
                ),
              ),
              body: SafeArea(
                child: MultiBlocListener(
                  listeners: [
                    BlocListener<RestaurantSignupBloc, RestaurantSignupState>(
                      listenWhen: (prev, curr) =>
                          prev.currentStepIndex != curr.currentStepIndex,
                      listener: (context, state) {
                        if (_pageController.hasClients &&
                            _pageController.page?.round() !=
                                state.currentStepIndex) {
                          _pageController.animateToPage(
                            state.currentStepIndex,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                    ),
                    BlocListener<RestaurantSignupBloc, RestaurantSignupState>(
                      listenWhen: (prev, curr) =>
                          prev.submissionStatus != curr.submissionStatus,
                      listener: (context, state) {
                        if (state.submissionStatus == SubmissionStatus.success) {
                          final data =
                              RestaurantRegistrationData.fromBlocState(state);
                          TokenStorageService.getInstance().then((storage) {
                            storage.saveRestaurantData(data);
                          });
                          Navigator.of(context).pushReplacementNamed(
                            AppRoutes.registrationPending,
                            arguments: data,
                          );
                        } else if (state.submissionStatus ==
                            SubmissionStatus.failure) {
                          final msg = state.errorMessage != null
                              ? LocalizedMessages.get(context, state.errorMessage)
                              : context.l10n.submissionFailed;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              duration: const Duration(seconds: 2),
                              content: Text(
                                msg,
                                style: GoogleFonts.poppins(color: Colors.white),
                              ),
                              backgroundColor: const Color(0xFFE03131),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: const [
                      RestaurantStep1View(),
                      RestaurantStep2View(),
                      RestaurantStep3View(),
                      RestaurantStep4View(),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

