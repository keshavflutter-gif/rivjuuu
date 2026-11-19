import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hu.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hu'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Rivjuuu'**
  String get appName;

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Rivjuuu'**
  String get appTitle;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get or;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navExplore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get navExplore;

  /// No description provided for @navRewards.
  ///
  /// In en, this message translates to:
  /// **'Rewards'**
  String get navRewards;

  /// No description provided for @navActivity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get navActivity;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @splashTagline.
  ///
  /// In en, this message translates to:
  /// **'Good Food\nMore Rewards'**
  String get splashTagline;

  /// No description provided for @chooseLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose language'**
  String get chooseLanguageTitle;

  /// No description provided for @chooseLanguageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select the language you\'d like to use in Rivjuuu.'**
  String get chooseLanguageSubtitle;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageHungarian.
  ///
  /// In en, this message translates to:
  /// **'Hungarian'**
  String get languageHungarian;

  /// No description provided for @createYourAccount.
  ///
  /// In en, this message translates to:
  /// **'Create your account'**
  String get createYourAccount;

  /// No description provided for @howWouldYouLikeToUse.
  ///
  /// In en, this message translates to:
  /// **'How would you like to use Rivjuuu?'**
  String get howWouldYouLikeToUse;

  /// No description provided for @customerRole.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get customerRole;

  /// No description provided for @customerRoleDescription.
  ///
  /// In en, this message translates to:
  /// **'Discover restaurants, redeem coupons and collect rewards.'**
  String get customerRoleDescription;

  /// No description provided for @restaurantRole.
  ///
  /// In en, this message translates to:
  /// **'Restaurant'**
  String get restaurantRole;

  /// No description provided for @restaurantRoleDescription.
  ///
  /// In en, this message translates to:
  /// **'Manage your restaurant, offers and customer rewards.'**
  String get restaurantRoleDescription;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Rivjuuu'**
  String get welcomeTitle;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Discover restaurants, offers and rewards around you.'**
  String get welcomeSubtitle;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get emailLabel;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'you@example.com'**
  String get emailHint;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get passwordHint;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @logIn.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get logIn;

  /// No description provided for @newToRivjuuu.
  ///
  /// In en, this message translates to:
  /// **'New to Rivjuuu? '**
  String get newToRivjuuu;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccount;

  /// No description provided for @createAccountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Join Rivjuuu and start exploring great restaurants.'**
  String get createAccountSubtitle;

  /// No description provided for @fullNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullNameLabel;

  /// No description provided for @fullNameHint.
  ///
  /// In en, this message translates to:
  /// **'John Doe'**
  String get fullNameHint;

  /// No description provided for @createPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Create a password'**
  String get createPasswordHint;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPasswordLabel;

  /// No description provided for @confirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Confirm your password'**
  String get confirmPasswordHint;

  /// No description provided for @iAgreeToThe.
  ///
  /// In en, this message translates to:
  /// **'I agree to the '**
  String get iAgreeToThe;

  /// No description provided for @termsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms and Conditions'**
  String get termsAndConditions;

  /// No description provided for @and.
  ///
  /// In en, this message translates to:
  /// **' and '**
  String get and;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccount;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address and we will send you a reset link.'**
  String get forgotPasswordSubtitle;

  /// No description provided for @sendResetLink.
  ///
  /// In en, this message translates to:
  /// **'Send reset link'**
  String get sendResetLink;

  /// No description provided for @backToLogIn.
  ///
  /// In en, this message translates to:
  /// **'Back to log in'**
  String get backToLogIn;

  /// No description provided for @checkEmailTitle.
  ///
  /// In en, this message translates to:
  /// **'Check your email'**
  String get checkEmailTitle;

  /// No description provided for @checkEmailSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We sent a password reset link to'**
  String get checkEmailSubtitle;

  /// No description provided for @openEmailApp.
  ///
  /// In en, this message translates to:
  /// **'Open email app'**
  String get openEmailApp;

  /// No description provided for @didNotReceiveEmail.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive the email? Click to resend'**
  String get didNotReceiveEmail;

  /// No description provided for @setNewPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Set new password'**
  String get setNewPasswordTitle;

  /// No description provided for @setNewPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your new password must be different from previous passwords.'**
  String get setNewPasswordSubtitle;

  /// No description provided for @newPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPasswordLabel;

  /// No description provided for @resetPasswordButton.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get resetPasswordButton;

  /// No description provided for @passwordUpdatedTitle.
  ///
  /// In en, this message translates to:
  /// **'Password updated'**
  String get passwordUpdatedTitle;

  /// No description provided for @passwordUpdatedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your password has been changed successfully.'**
  String get passwordUpdatedSubtitle;

  /// No description provided for @enableLocationTitle.
  ///
  /// In en, this message translates to:
  /// **'Discover restaurants\nnear you'**
  String get enableLocationTitle;

  /// No description provided for @enableLocationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Allow location access to find nearby restaurants and view them on the map.'**
  String get enableLocationSubtitle;

  /// No description provided for @allowLocationButton.
  ///
  /// In en, this message translates to:
  /// **'Allow location'**
  String get allowLocationButton;

  /// No description provided for @notNowButton.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get notNowButton;

  /// No description provided for @enableNotificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Stay updated'**
  String get enableNotificationsTitle;

  /// No description provided for @enableNotificationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Get updates about coupons, rewards, giveaways and important account activity.'**
  String get enableNotificationsSubtitle;

  /// No description provided for @allowNotificationsButton.
  ///
  /// In en, this message translates to:
  /// **'Enable notifications'**
  String get allowNotificationsButton;

  /// No description provided for @sendInstructionsButton.
  ///
  /// In en, this message translates to:
  /// **'Send instructions'**
  String get sendInstructionsButton;

  /// No description provided for @resendEmailButton.
  ///
  /// In en, this message translates to:
  /// **'Resend email'**
  String get resendEmailButton;

  /// No description provided for @resetInstructionsResent.
  ///
  /// In en, this message translates to:
  /// **'Reset instructions resent!'**
  String get resetInstructionsResent;

  /// No description provided for @createNewPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Create new password'**
  String get createNewPasswordTitle;

  /// No description provided for @createNewPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a new password for your account.'**
  String get createNewPasswordSubtitle;

  /// No description provided for @confirmNewPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm new password'**
  String get confirmNewPasswordLabel;

  /// No description provided for @legalLastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last updated November 2026'**
  String get legalLastUpdated;

  /// No description provided for @legalSection1Title.
  ///
  /// In en, this message translates to:
  /// **'Introduction'**
  String get legalSection1Title;

  /// No description provided for @legalSection1Content.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Rivjuuu. By accessing or using our services, you agree to be bound by these terms and our Privacy Policy. If you do not agree, please do not use our app.'**
  String get legalSection1Content;

  /// No description provided for @legalSection2Title.
  ///
  /// In en, this message translates to:
  /// **'Account Responsibilities'**
  String get legalSection2Title;

  /// No description provided for @legalSection2Content.
  ///
  /// In en, this message translates to:
  /// **'You are responsible for maintaining the confidentiality of your account credentials and for all activities that take place under your account.'**
  String get legalSection2Content;

  /// No description provided for @legalSection3Title.
  ///
  /// In en, this message translates to:
  /// **'Rewards & Offers'**
  String get legalSection3Title;

  /// No description provided for @legalSection3Content.
  ///
  /// In en, this message translates to:
  /// **'Rewards, coupons, and offers provided by participating restaurants are subject to availability and specific restaurant terms.'**
  String get legalSection3Content;

  /// No description provided for @logOutTitle.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logOutTitle;

  /// No description provided for @logOutConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out of Rivjuuu?'**
  String get logOutConfirmation;

  /// No description provided for @logOutButton.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logOutButton;

  /// No description provided for @stepProgress.
  ///
  /// In en, this message translates to:
  /// **'Step {step} of 4'**
  String stepProgress(int step);

  /// No description provided for @step1Title.
  ///
  /// In en, this message translates to:
  /// **'Account information'**
  String get step1Title;

  /// No description provided for @step1Subtitle.
  ///
  /// In en, this message translates to:
  /// **'You\'ll use these details to log in.'**
  String get step1Subtitle;

  /// No description provided for @ownerNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Owner or contact name'**
  String get ownerNameLabel;

  /// No description provided for @ownerNameHint.
  ///
  /// In en, this message translates to:
  /// **'Your full name'**
  String get ownerNameHint;

  /// No description provided for @step2Title.
  ///
  /// In en, this message translates to:
  /// **'Restaurant information'**
  String get step2Title;

  /// No description provided for @step2Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Tell us about your restaurant.'**
  String get step2Subtitle;

  /// No description provided for @restaurantNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Restaurant name'**
  String get restaurantNameLabel;

  /// No description provided for @restaurantNameHint.
  ///
  /// In en, this message translates to:
  /// **'Your restaurant name'**
  String get restaurantNameHint;

  /// No description provided for @restaurantCategoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Restaurant category'**
  String get restaurantCategoryLabel;

  /// No description provided for @selectCategoryHint.
  ///
  /// In en, this message translates to:
  /// **'Select category'**
  String get selectCategoryHint;

  /// No description provided for @addressLabel.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get addressLabel;

  /// No description provided for @addressHint.
  ///
  /// In en, this message translates to:
  /// **'Enter address'**
  String get addressHint;

  /// No description provided for @restaurantLocationLabel.
  ///
  /// In en, this message translates to:
  /// **'Restaurant location'**
  String get restaurantLocationLabel;

  /// No description provided for @setLocationOnMap.
  ///
  /// In en, this message translates to:
  /// **'Set location on map'**
  String get setLocationOnMap;

  /// No description provided for @step3Title.
  ///
  /// In en, this message translates to:
  /// **'Business information'**
  String get step3Title;

  /// No description provided for @step3Subtitle.
  ///
  /// In en, this message translates to:
  /// **'We use this to verify your restaurant before it goes live.'**
  String get step3Subtitle;

  /// No description provided for @businessDetailLabel.
  ///
  /// In en, this message translates to:
  /// **'Business detail'**
  String get businessDetailLabel;

  /// No description provided for @businessDetailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter business registration or tax details'**
  String get businessDetailHint;

  /// No description provided for @supportingDocumentLabel.
  ///
  /// In en, this message translates to:
  /// **'Supporting document'**
  String get supportingDocumentLabel;

  /// No description provided for @uploadFileButton.
  ///
  /// In en, this message translates to:
  /// **'Upload a file'**
  String get uploadFileButton;

  /// No description provided for @tapToChangeFile.
  ///
  /// In en, this message translates to:
  /// **'Tap to change file'**
  String get tapToChangeFile;

  /// No description provided for @acceptedFormatsHint.
  ///
  /// In en, this message translates to:
  /// **'Accepted: PDF, PNG, JPG up to 10MB'**
  String get acceptedFormatsHint;

  /// No description provided for @step4Title.
  ///
  /// In en, this message translates to:
  /// **'Review and submit'**
  String get step4Title;

  /// No description provided for @step4Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Check your details before sending your application.'**
  String get step4Subtitle;

  /// No description provided for @accountSection.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get accountSection;

  /// No description provided for @contactField.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contactField;

  /// No description provided for @emailField.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailField;

  /// No description provided for @restaurantSection.
  ///
  /// In en, this message translates to:
  /// **'Restaurant'**
  String get restaurantSection;

  /// No description provided for @nameField.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameField;

  /// No description provided for @categoryField.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get categoryField;

  /// No description provided for @addressField.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get addressField;

  /// No description provided for @businessInfoSection.
  ///
  /// In en, this message translates to:
  /// **'Business information'**
  String get businessInfoSection;

  /// No description provided for @documentField.
  ///
  /// In en, this message translates to:
  /// **'Document'**
  String get documentField;

  /// No description provided for @submitApplicationButton.
  ///
  /// In en, this message translates to:
  /// **'Submit application'**
  String get submitApplicationButton;

  /// No description provided for @applicationUnderReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Application under review'**
  String get applicationUnderReviewTitle;

  /// No description provided for @applicationUnderReviewSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your restaurant application has been submitted and is waiting for review.'**
  String get applicationUnderReviewSubtitle;

  /// No description provided for @statusLabel.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get statusLabel;

  /// No description provided for @pendingReview.
  ///
  /// In en, this message translates to:
  /// **'Pending review'**
  String get pendingReview;

  /// No description provided for @submittedLabel.
  ///
  /// In en, this message translates to:
  /// **'Submitted'**
  String get submittedLabel;

  /// No description provided for @viewSubmittedDetails.
  ///
  /// In en, this message translates to:
  /// **'View submitted details'**
  String get viewSubmittedDetails;

  /// No description provided for @contactSupport.
  ///
  /// In en, this message translates to:
  /// **'Contact support'**
  String get contactSupport;

  /// No description provided for @submittedDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Submitted details'**
  String get submittedDetailsTitle;

  /// No description provided for @ownerNameField.
  ///
  /// In en, this message translates to:
  /// **'Owner name'**
  String get ownerNameField;

  /// No description provided for @ownerEmailField.
  ///
  /// In en, this message translates to:
  /// **'Owner email'**
  String get ownerEmailField;

  /// No description provided for @restaurantNameField.
  ///
  /// In en, this message translates to:
  /// **'Restaurant name'**
  String get restaurantNameField;

  /// No description provided for @yourRestaurantIsApprovedTitle.
  ///
  /// In en, this message translates to:
  /// **'Your restaurant is approved'**
  String get yourRestaurantIsApprovedTitle;

  /// No description provided for @yourRestaurantIsApprovedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a plan to finish setup and start publishing coupons.'**
  String get yourRestaurantIsApprovedSubtitle;

  /// No description provided for @approvedStatus.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get approvedStatus;

  /// No description provided for @applicationNotApprovedTitle.
  ///
  /// In en, this message translates to:
  /// **'Application not approved'**
  String get applicationNotApprovedTitle;

  /// No description provided for @applicationNotApprovedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t approve your restaurant this time.'**
  String get applicationNotApprovedSubtitle;

  /// No description provided for @notApprovedStatus.
  ///
  /// In en, this message translates to:
  /// **'Not approved'**
  String get notApprovedStatus;

  /// No description provided for @messageFromReviewTeam.
  ///
  /// In en, this message translates to:
  /// **'Message from the review team'**
  String get messageFromReviewTeam;

  /// No description provided for @fullNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Full name is required'**
  String get fullNameRequired;

  /// No description provided for @fullNameInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid full name'**
  String get fullNameInvalid;

  /// No description provided for @ownerNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Owner or contact name is required'**
  String get ownerNameRequired;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email address is required'**
  String get emailRequired;

  /// No description provided for @emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get emailInvalid;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequired;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get passwordTooShort;

  /// No description provided for @passwordEmptyOrWhitespace.
  ///
  /// In en, this message translates to:
  /// **'Password cannot be empty or only whitespace'**
  String get passwordEmptyOrWhitespace;

  /// No description provided for @confirmPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get confirmPasswordRequired;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @termsRequired.
  ///
  /// In en, this message translates to:
  /// **'You must agree to the Terms and Conditions and Privacy Policy'**
  String get termsRequired;

  /// No description provided for @restaurantNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Restaurant name is required'**
  String get restaurantNameRequired;

  /// No description provided for @restaurantNameInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid restaurant name'**
  String get restaurantNameInvalid;

  /// No description provided for @categoryRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select a category'**
  String get categoryRequired;

  /// No description provided for @addressRequired.
  ///
  /// In en, this message translates to:
  /// **'Address is required'**
  String get addressRequired;

  /// No description provided for @businessDetailRequired.
  ///
  /// In en, this message translates to:
  /// **'Business detail is required'**
  String get businessDetailRequired;

  /// No description provided for @documentRequired.
  ///
  /// In en, this message translates to:
  /// **'Please upload a supporting document'**
  String get documentRequired;

  /// No description provided for @networkUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Network unavailable. Please check your internet connection.'**
  String get networkUnavailable;

  /// No description provided for @connectionTimeout.
  ///
  /// In en, this message translates to:
  /// **'Connection timed out. Please try again.'**
  String get connectionTimeout;

  /// No description provided for @serverError.
  ///
  /// In en, this message translates to:
  /// **'Server error occurred. Please try again later.'**
  String get serverError;

  /// No description provided for @genericError.
  ///
  /// In en, this message translates to:
  /// **'An error occurred. Please try again.'**
  String get genericError;

  /// No description provided for @registrationSuccess.
  ///
  /// In en, this message translates to:
  /// **'Customer account created successfully'**
  String get registrationSuccess;

  /// No description provided for @loginSuccess.
  ///
  /// In en, this message translates to:
  /// **'Login successful'**
  String get loginSuccess;

  /// No description provided for @invalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password'**
  String get invalidCredentials;

  /// No description provided for @logoutSuccess.
  ///
  /// In en, this message translates to:
  /// **'Logged out successfully'**
  String get logoutSuccess;

  /// No description provided for @submissionFailed.
  ///
  /// In en, this message translates to:
  /// **'Submission failed. Please try again.'**
  String get submissionFailed;

  /// No description provided for @emailAlreadyExists.
  ///
  /// In en, this message translates to:
  /// **'An account with this email already exists'**
  String get emailAlreadyExists;

  /// No description provided for @restaurantAppSubmittedPending.
  ///
  /// In en, this message translates to:
  /// **'Restaurant application submitted successfully and is pending approval'**
  String get restaurantAppSubmittedPending;

  /// No description provided for @invalidRequest.
  ///
  /// In en, this message translates to:
  /// **'Invalid request. Please check your details.'**
  String get invalidRequest;

  /// No description provided for @unauthorized.
  ///
  /// In en, this message translates to:
  /// **'Unauthorized. Please login again.'**
  String get unauthorized;

  /// No description provided for @accessDenied.
  ///
  /// In en, this message translates to:
  /// **'Access denied. You do not have permission.'**
  String get accessDenied;

  /// No description provided for @serviceNotFound.
  ///
  /// In en, this message translates to:
  /// **'Requested service not found.'**
  String get serviceNotFound;

  /// No description provided for @validationFailed.
  ///
  /// In en, this message translates to:
  /// **'Validation failed. Please check your input.'**
  String get validationFailed;

  /// No description provided for @sessionExpired.
  ///
  /// In en, this message translates to:
  /// **'Session expired. Please log in again.'**
  String get sessionExpired;

  /// No description provided for @profileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated'**
  String get profileUpdated;

  /// No description provided for @supportEmailInfo.
  ///
  /// In en, this message translates to:
  /// **'Support email: support@rivjuuu.com'**
  String get supportEmailInfo;

  /// No description provided for @locationPinned.
  ///
  /// In en, this message translates to:
  /// **'Location pinned: {label}'**
  String locationPinned(String label);

  /// No description provided for @fileUploaded.
  ///
  /// In en, this message translates to:
  /// **'Uploaded: {fileName}'**
  String fileUploaded(String fileName);

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @myActivitySection.
  ///
  /// In en, this message translates to:
  /// **'My activity'**
  String get myActivitySection;

  /// No description provided for @couponHistoryItem.
  ///
  /// In en, this message translates to:
  /// **'Coupon history'**
  String get couponHistoryItem;

  /// No description provided for @myRewardsItem.
  ///
  /// In en, this message translates to:
  /// **'My rewards'**
  String get myRewardsItem;

  /// No description provided for @myGiveawaysItem.
  ///
  /// In en, this message translates to:
  /// **'My giveaways'**
  String get myGiveawaysItem;

  /// No description provided for @myReviewsItem.
  ///
  /// In en, this message translates to:
  /// **'My reviews'**
  String get myReviewsItem;

  /// No description provided for @favoriteRestaurantsItem.
  ///
  /// In en, this message translates to:
  /// **'Favorite restaurants'**
  String get favoriteRestaurantsItem;

  /// No description provided for @favoriteCouponsItem.
  ///
  /// In en, this message translates to:
  /// **'Favorite coupons'**
  String get favoriteCouponsItem;

  /// No description provided for @socialSection.
  ///
  /// In en, this message translates to:
  /// **'Social'**
  String get socialSection;

  /// No description provided for @friendsItem.
  ///
  /// In en, this message translates to:
  /// **'Friends'**
  String get friendsItem;

  /// No description provided for @friendRequestsItem.
  ///
  /// In en, this message translates to:
  /// **'Friend requests'**
  String get friendRequestsItem;

  /// No description provided for @accountSectionProfile.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get accountSectionProfile;

  /// No description provided for @notificationsItem.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsItem;

  /// No description provided for @settingsItem.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsItem;

  /// No description provided for @editProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get editProfileTitle;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get changePassword;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @notificationPreferences.
  ///
  /// In en, this message translates to:
  /// **'Notification preferences'**
  String get notificationPreferences;

  /// No description provided for @couponRedemptions.
  ///
  /// In en, this message translates to:
  /// **'Coupon redemptions'**
  String get couponRedemptions;

  /// No description provided for @giveawayUpdates.
  ///
  /// In en, this message translates to:
  /// **'Giveaway updates'**
  String get giveawayUpdates;

  /// No description provided for @loyaltyRewards.
  ///
  /// In en, this message translates to:
  /// **'Loyalty rewards'**
  String get loyaltyRewards;

  /// No description provided for @subscriptionBilling.
  ///
  /// In en, this message translates to:
  /// **'Subscription & billing'**
  String get subscriptionBilling;

  /// No description provided for @supportAndLegal.
  ///
  /// In en, this message translates to:
  /// **'Support & legal'**
  String get supportAndLegal;

  /// No description provided for @helpAndContactSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & contact support'**
  String get helpAndContactSupport;

  /// No description provided for @changesApplyStraightAway.
  ///
  /// In en, this message translates to:
  /// **'Changes apply straight away.'**
  String get changesApplyStraightAway;

  /// No description provided for @currentPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get currentPasswordLabel;

  /// No description provided for @enterCurrentPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter current password'**
  String get enterCurrentPasswordHint;

  /// No description provided for @enterNewPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter new password (min. 8 characters)'**
  String get enterNewPasswordHint;

  /// No description provided for @confirmNewPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Re-enter new password'**
  String get confirmNewPasswordHint;

  /// No description provided for @updatePasswordButton.
  ///
  /// In en, this message translates to:
  /// **'Update password'**
  String get updatePasswordButton;

  /// No description provided for @passwordChangedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully!'**
  String get passwordChangedSuccess;

  /// No description provided for @fillAllPasswordFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all password fields.'**
  String get fillAllPasswordFields;

  /// No description provided for @restaurantLogoutConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out of your restaurant account?'**
  String get restaurantLogoutConfirmation;

  /// No description provided for @navDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get navDashboard;

  /// No description provided for @navCoupons.
  ///
  /// In en, this message translates to:
  /// **'Coupons'**
  String get navCoupons;

  /// No description provided for @navScan.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get navScan;

  /// No description provided for @growthPlan.
  ///
  /// In en, this message translates to:
  /// **'Growth plan'**
  String get growthPlan;

  /// No description provided for @growthPlanShort.
  ///
  /// In en, this message translates to:
  /// **'Growth'**
  String get growthPlanShort;

  /// No description provided for @restaurantProfile.
  ///
  /// In en, this message translates to:
  /// **'Restaurant profile'**
  String get restaurantProfile;

  /// No description provided for @menu.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menu;

  /// No description provided for @businessSection.
  ///
  /// In en, this message translates to:
  /// **'Business'**
  String get businessSection;

  /// No description provided for @subscription.
  ///
  /// In en, this message translates to:
  /// **'Subscription'**
  String get subscription;

  /// No description provided for @statistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// No description provided for @engagementSection.
  ///
  /// In en, this message translates to:
  /// **'Engagement'**
  String get engagementSection;

  /// No description provided for @loyalty.
  ///
  /// In en, this message translates to:
  /// **'Loyalty'**
  String get loyalty;

  /// No description provided for @giveaways.
  ///
  /// In en, this message translates to:
  /// **'Giveaways'**
  String get giveaways;

  /// No description provided for @oneActive.
  ///
  /// In en, this message translates to:
  /// **'1 active'**
  String get oneActive;

  /// No description provided for @privacySection.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacySection;

  /// No description provided for @profileAndActivity.
  ///
  /// In en, this message translates to:
  /// **'Profile & activity'**
  String get profileAndActivity;

  /// No description provided for @profileAndActivityDesc.
  ///
  /// In en, this message translates to:
  /// **'Choose who can see your profile, visits and activity.'**
  String get profileAndActivityDesc;

  /// No description provided for @latestVisit.
  ///
  /// In en, this message translates to:
  /// **'Latest visit'**
  String get latestVisit;

  /// No description provided for @latestVisitDesc.
  ///
  /// In en, this message translates to:
  /// **'Choose who can see the restaurant you visited last.'**
  String get latestVisitDesc;

  /// No description provided for @reviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get reviews;

  /// No description provided for @reviewsDesc.
  ///
  /// In en, this message translates to:
  /// **'Choose who can read your restaurant reviews.'**
  String get reviewsDesc;

  /// No description provided for @notificationsSection.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsSection;

  /// No description provided for @couponsAndOffers.
  ///
  /// In en, this message translates to:
  /// **'Coupons & offers'**
  String get couponsAndOffers;

  /// No description provided for @rewardsAndGiveaways.
  ///
  /// In en, this message translates to:
  /// **'Rewards & giveaways'**
  String get rewardsAndGiveaways;

  /// No description provided for @friendsAndReviews.
  ///
  /// In en, this message translates to:
  /// **'Friends & reviews'**
  String get friendsAndReviews;

  /// No description provided for @visibilityPrivate.
  ///
  /// In en, this message translates to:
  /// **'Private'**
  String get visibilityPrivate;

  /// No description provided for @visibilityPrivateSub.
  ///
  /// In en, this message translates to:
  /// **'Only you'**
  String get visibilityPrivateSub;

  /// No description provided for @visibilityFriends.
  ///
  /// In en, this message translates to:
  /// **'Friends only'**
  String get visibilityFriends;

  /// No description provided for @visibilityFriendsSub.
  ///
  /// In en, this message translates to:
  /// **'People you’ve accepted as friends'**
  String get visibilityFriendsSub;

  /// No description provided for @visibilityPublic.
  ///
  /// In en, this message translates to:
  /// **'Public'**
  String get visibilityPublic;

  /// No description provided for @visibilityPublicSub.
  ///
  /// In en, this message translates to:
  /// **'Anyone on Rivjuuu'**
  String get visibilityPublicSub;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @supportDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get supportDialogTitle;

  /// No description provided for @supportDialogContent.
  ///
  /// In en, this message translates to:
  /// **'Need help with your restaurant profile, coupons, or billing?\n\nReach our merchant team at support@rivjuuu.com or via live chat during business hours (9:00 - 18:00 CET).'**
  String get supportDialogContent;

  /// No description provided for @privacyPolicyDialogContent.
  ///
  /// In en, this message translates to:
  /// **'Rivjuuu protects your restaurant and customer data in accordance with GDPR and applicable EU privacy laws. We never sell your business or consumer data to third parties.'**
  String get privacyPolicyDialogContent;

  /// No description provided for @termsDialogContent.
  ///
  /// In en, this message translates to:
  /// **'By using Rivjuuu Restaurant Merchant portal, you agree to fulfill redeemed coupons, loyalty rewards, and giveaways in good faith. Standard merchant service terms apply.'**
  String get termsDialogContent;

  /// No description provided for @goodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get goodEvening;

  /// No description provided for @activeCoupons.
  ///
  /// In en, this message translates to:
  /// **'Active coupons'**
  String get activeCoupons;

  /// No description provided for @oneEndsThisWeek.
  ///
  /// In en, this message translates to:
  /// **'1 ends this week'**
  String get oneEndsThisWeek;

  /// No description provided for @pointsGiven.
  ///
  /// In en, this message translates to:
  /// **'Points given'**
  String get pointsGiven;

  /// No description provided for @thisWeek.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get thisWeek;

  /// No description provided for @giveawayEntries.
  ///
  /// In en, this message translates to:
  /// **'Giveaway entries'**
  String get giveawayEntries;

  /// No description provided for @drawOnDate.
  ///
  /// In en, this message translates to:
  /// **'Draw on 15 Oct'**
  String get drawOnDate;

  /// No description provided for @profileViews.
  ///
  /// In en, this message translates to:
  /// **'Profile views'**
  String get profileViews;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick actions'**
  String get quickActions;

  /// No description provided for @scanQr.
  ///
  /// In en, this message translates to:
  /// **'Scan QR'**
  String get scanQr;

  /// No description provided for @createCoupon.
  ///
  /// In en, this message translates to:
  /// **'Create coupon'**
  String get createCoupon;

  /// No description provided for @createGiveaway.
  ///
  /// In en, this message translates to:
  /// **'Create giveaway'**
  String get createGiveaway;

  /// No description provided for @recentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent activity'**
  String get recentActivity;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get seeAll;

  /// No description provided for @redemptionsToday.
  ///
  /// In en, this message translates to:
  /// **'Redemptions today'**
  String get redemptionsToday;

  /// No description provided for @redeemed.
  ///
  /// In en, this message translates to:
  /// **'Redeemed'**
  String get redeemed;

  /// No description provided for @reward.
  ///
  /// In en, this message translates to:
  /// **'Reward'**
  String get reward;

  /// No description provided for @manage.
  ///
  /// In en, this message translates to:
  /// **'Manage'**
  String get manage;

  /// No description provided for @planRenewsText.
  ///
  /// In en, this message translates to:
  /// **'Renews 14 Nov 2026 · 4 of 10 coupons used'**
  String get planRenewsText;

  /// No description provided for @earned.
  ///
  /// In en, this message translates to:
  /// **'Earned'**
  String get earned;

  /// No description provided for @rewards.
  ///
  /// In en, this message translates to:
  /// **'Rewards'**
  String get rewards;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @activeCouponsTab.
  ///
  /// In en, this message translates to:
  /// **'Active · 4'**
  String get activeCouponsTab;

  /// No description provided for @scheduledCouponsTab.
  ///
  /// In en, this message translates to:
  /// **'Scheduled · 1'**
  String get scheduledCouponsTab;

  /// No description provided for @expiredCouponsTab.
  ///
  /// In en, this message translates to:
  /// **'Expired / inactive'**
  String get expiredCouponsTab;

  /// No description provided for @tapAgainToExit.
  ///
  /// In en, this message translates to:
  /// **'Tap again to exit'**
  String get tapAgainToExit;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hu'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hu':
      return AppLocalizationsHu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
