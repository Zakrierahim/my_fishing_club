import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ms.dart';

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

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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
    Locale('ms'),
  ];

  /// Application name shown in the interface
  ///
  /// In en, this message translates to:
  /// **'My Fishing App'**
  String get appName;

  /// Login screen heading
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// Login screen subtitle
  ///
  /// In en, this message translates to:
  /// **'Your next fishing adventure starts here.'**
  String get welcomeSubtitle;

  /// Login action
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// Home tab label
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Explore tab label
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get explore;

  /// Notification tab label
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get notification;

  /// Settings tab label
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Language settings section title
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Native name of the Malay language option
  ///
  /// In en, this message translates to:
  /// **'Bahasa Melayu'**
  String get bahasaMelayu;

  /// Native name of the English language option
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// Email field hint
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Password field hint
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Tooltip for revealing a password
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get showPassword;

  /// Tooltip for hiding a password
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get hidePassword;

  /// Prompt shown before the register link
  ///
  /// In en, this message translates to:
  /// **'New?'**
  String get newUser;

  /// Link to the create-account screen
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// Create-account heading and button
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccount;

  /// Create-account screen subtitle
  ///
  /// In en, this message translates to:
  /// **'Register to start your next fishing adventure.'**
  String get createAccountSubtitle;

  /// Name field hint
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// Prompt shown before the link back to login
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// Screen-reader label for the fishing hook mark
  ///
  /// In en, this message translates to:
  /// **'Fishing hook'**
  String get fishingHook;

  /// Screen-reader label for the splash and login artwork
  ///
  /// In en, this message translates to:
  /// **'Angler fighting a jumping fish at night'**
  String get splashScene;

  /// Screen-reader label for the home header artwork
  ///
  /// In en, this message translates to:
  /// **'Angler and a jumping fish'**
  String get homeHeaderScene;

  /// Google sign-in button
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// Facebook sign-in button
  ///
  /// In en, this message translates to:
  /// **'Continue with Facebook'**
  String get continueWithFacebook;

  /// TikTok sign-in button
  ///
  /// In en, this message translates to:
  /// **'Continue with TikTok'**
  String get continueWithTikTok;

  /// WhatsApp phone verification button
  ///
  /// In en, this message translates to:
  /// **'Continue with WhatsApp'**
  String get continueWithWhatsApp;

  /// Settings section for provider links
  ///
  /// In en, this message translates to:
  /// **'Linked Accounts'**
  String get linkedAccounts;

  /// Provider link confirmed by the authentication service
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get connected;

  /// Provider is not linked
  ///
  /// In en, this message translates to:
  /// **'Not connected'**
  String get notConnected;

  /// Action that asks the service to link a provider
  ///
  /// In en, this message translates to:
  /// **'Link Account'**
  String get linkAccount;

  /// Action that asks the service to remove a provider link
  ///
  /// In en, this message translates to:
  /// **'Unlink Account'**
  String get unlinkAccount;

  /// Shown when sign-in or linking fails
  ///
  /// In en, this message translates to:
  /// **'Authentication failed'**
  String get authenticationFailed;

  /// Shown when the user cancels provider sign-in
  ///
  /// In en, this message translates to:
  /// **'Authentication cancelled'**
  String get authenticationCancelled;

  /// Hint for a one-time verification code
  ///
  /// In en, this message translates to:
  /// **'Verification code'**
  String get verificationCode;

  /// Asks the verification service to send another code
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get resendCode;

  /// Title of the unlink confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Confirm unlinking'**
  String get confirmUnlink;

  /// Body of the unlink confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Unlink {provider}? You will not be able to sign in with it.'**
  String confirmUnlinkMessage(String provider);

  /// Shown when provider credentials or the session backend are missing
  ///
  /// In en, this message translates to:
  /// **'Configuration required'**
  String get configurationRequired;

  /// Shown when unlinking would remove the only sign-in method
  ///
  /// In en, this message translates to:
  /// **'Keep at least one sign-in method linked.'**
  String get unlinkLastMethod;

  /// Dismisses a confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Hint for the WhatsApp phone number field
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneNumber;

  /// Heading on the WhatsApp verification screen
  ///
  /// In en, this message translates to:
  /// **'Verify WhatsApp'**
  String get whatsappVerificationTitle;

  /// Explains that WhatsApp codes are not sent by the app itself
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number. A code is sent only after WhatsApp verification is configured.'**
  String get whatsappVerificationSubtitle;

  /// Submits a verification code to the authentication service
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// Home greeting before noon
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get goodMorning;

  /// Home greeting from noon until evening
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get goodAfternoon;

  /// Home greeting in the evening
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get goodEvening;

  /// Line under the home greeting
  ///
  /// In en, this message translates to:
  /// **'Your next trip starts here.'**
  String get homePrompt;

  /// Primary home action
  ///
  /// In en, this message translates to:
  /// **'Log a catch'**
  String get logACatch;

  /// Shortcut to fishing places
  ///
  /// In en, this message translates to:
  /// **'Spots'**
  String get spots;

  /// Subtitle on the spots shortcut
  ///
  /// In en, this message translates to:
  /// **'Browse places to fish'**
  String get spotsSubtitle;

  /// Shortcut for planned fishing trips
  ///
  /// In en, this message translates to:
  /// **'Trips'**
  String get trips;

  /// Subtitle on the trips shortcut
  ///
  /// In en, this message translates to:
  /// **'Plan your next outing'**
  String get tripsSubtitle;

  /// Home section for the latest catches
  ///
  /// In en, this message translates to:
  /// **'Recent activity'**
  String get recentActivity;

  /// Empty state when the angler has not logged a catch
  ///
  /// In en, this message translates to:
  /// **'No catches yet.'**
  String get noCatchesYet;

  /// No description provided for @membershipSection.
  ///
  /// In en, this message translates to:
  /// **'Membership'**
  String get membershipSection;

  /// No description provided for @noMembershipYet.
  ///
  /// In en, this message translates to:
  /// **'No membership yet.'**
  String get noMembershipYet;

  /// No description provided for @myFishingPass.
  ///
  /// In en, this message translates to:
  /// **'My Fishing Pass'**
  String get myFishingPass;

  /// No description provided for @passCardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Open your pond pass when you have a membership.'**
  String get passCardSubtitle;

  /// No description provided for @explorePonds.
  ///
  /// In en, this message translates to:
  /// **'Explore Ponds'**
  String get explorePonds;

  /// No description provided for @myMemberships.
  ///
  /// In en, this message translates to:
  /// **'My Memberships'**
  String get myMemberships;

  /// No description provided for @myTrips.
  ///
  /// In en, this message translates to:
  /// **'My Trips'**
  String get myTrips;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick actions'**
  String get quickActions;

  /// No description provided for @searchPonds.
  ///
  /// In en, this message translates to:
  /// **'Search ponds'**
  String get searchPonds;

  /// No description provided for @fishSpecies.
  ///
  /// In en, this message translates to:
  /// **'Fish species'**
  String get fishSpecies;

  /// No description provided for @pondType.
  ///
  /// In en, this message translates to:
  /// **'Pond type'**
  String get pondType;

  /// No description provided for @noPondsYet.
  ///
  /// In en, this message translates to:
  /// **'No ponds to show yet.'**
  String get noPondsYet;

  /// No description provided for @noMatchingPonds.
  ///
  /// In en, this message translates to:
  /// **'No ponds match your search.'**
  String get noMatchingPonds;

  /// No description provided for @noFiltersYet.
  ///
  /// In en, this message translates to:
  /// **'Filters appear when ponds are available.'**
  String get noFiltersYet;

  /// No description provided for @clearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear filters'**
  String get clearFilters;

  /// No description provided for @pondDetails.
  ///
  /// In en, this message translates to:
  /// **'Pond details'**
  String get pondDetails;

  /// No description provided for @speciesLabel.
  ///
  /// In en, this message translates to:
  /// **'Species'**
  String get speciesLabel;

  /// No description provided for @noMembershipAtPond.
  ///
  /// In en, this message translates to:
  /// **'No membership at this pond.'**
  String get noMembershipAtPond;

  /// No description provided for @membershipsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'When you join a pond, it will appear here. Each pond has its own membership.'**
  String get membershipsEmptyBody;

  /// No description provided for @membershipDetails.
  ///
  /// In en, this message translates to:
  /// **'Membership details'**
  String get membershipDetails;

  /// No description provided for @demoPreview.
  ///
  /// In en, this message translates to:
  /// **'Demo preview'**
  String get demoPreview;

  /// No description provided for @notVerifiedMembership.
  ///
  /// In en, this message translates to:
  /// **'This is not a verified membership.'**
  String get notVerifiedMembership;

  /// No description provided for @demoData.
  ///
  /// In en, this message translates to:
  /// **'Demo data'**
  String get demoData;

  /// No description provided for @demoDataHint.
  ///
  /// In en, this message translates to:
  /// **'Shows a local preview of publicly listed venues. This is not live data.'**
  String get demoDataHint;

  /// No description provided for @demoPond.
  ///
  /// In en, this message translates to:
  /// **'Demo pond'**
  String get demoPond;

  /// No description provided for @previewData.
  ///
  /// In en, this message translates to:
  /// **'Preview data'**
  String get previewData;

  /// No description provided for @notConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Not confirmed'**
  String get notConfirmed;

  /// No description provided for @saltwater.
  ///
  /// In en, this message translates to:
  /// **'Saltwater'**
  String get saltwater;

  /// No description provided for @freshwater.
  ///
  /// In en, this message translates to:
  /// **'Freshwater'**
  String get freshwater;

  /// No description provided for @mixedWater.
  ///
  /// In en, this message translates to:
  /// **'Saltwater and freshwater'**
  String get mixedWater;

  /// No description provided for @unknownWater.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknownWater;

  /// No description provided for @waterType.
  ///
  /// In en, this message translates to:
  /// **'Water type'**
  String get waterType;

  /// No description provided for @openInGoogleMaps.
  ///
  /// In en, this message translates to:
  /// **'Open in Google Maps'**
  String get openInGoogleMaps;

  /// No description provided for @searchInGoogleMaps.
  ///
  /// In en, this message translates to:
  /// **'Search in Google Maps'**
  String get searchInGoogleMaps;

  /// No description provided for @coordinatesLabel.
  ///
  /// In en, this message translates to:
  /// **'Coordinates'**
  String get coordinatesLabel;

  /// No description provided for @imageUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Image unavailable'**
  String get imageUnavailable;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @openingHours.
  ///
  /// In en, this message translates to:
  /// **'Opening hours'**
  String get openingHours;

  /// No description provided for @samplePrice.
  ///
  /// In en, this message translates to:
  /// **'Sample price'**
  String get samplePrice;

  /// No description provided for @sampleOpeningHours.
  ///
  /// In en, this message translates to:
  /// **'Sample opening hours'**
  String get sampleOpeningHours;

  /// No description provided for @facilities.
  ///
  /// In en, this message translates to:
  /// **'Facilities'**
  String get facilities;

  /// No description provided for @areaLabel.
  ///
  /// In en, this message translates to:
  /// **'Area'**
  String get areaLabel;

  /// No description provided for @verifiedMembership.
  ///
  /// In en, this message translates to:
  /// **'Verified membership'**
  String get verifiedMembership;

  /// No description provided for @passEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No fishing pass yet'**
  String get passEmptyTitle;

  /// No description provided for @passEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'A pass appears here after you have a membership at a pond.'**
  String get passEmptyBody;

  /// No description provided for @qrUnavailable.
  ///
  /// In en, this message translates to:
  /// **'No QR code is shown in this version.'**
  String get qrUnavailable;

  /// No description provided for @demoPassBody.
  ///
  /// In en, this message translates to:
  /// **'This preview is not a membership credential.'**
  String get demoPassBody;

  /// No description provided for @demoPreviewBadge.
  ///
  /// In en, this message translates to:
  /// **'DEMO PREVIEW'**
  String get demoPreviewBadge;

  /// No description provided for @demoQrCode.
  ///
  /// In en, this message translates to:
  /// **'Demo QR code'**
  String get demoQrCode;

  /// No description provided for @demoBarcode.
  ///
  /// In en, this message translates to:
  /// **'Demo barcode'**
  String get demoBarcode;

  /// No description provided for @memberId.
  ///
  /// In en, this message translates to:
  /// **'Member ID'**
  String get memberId;

  /// No description provided for @demoPassOnly.
  ///
  /// In en, this message translates to:
  /// **'Demo pass only. Not valid for entry or check-in.'**
  String get demoPassOnly;

  /// No description provided for @membershipNotVerified.
  ///
  /// In en, this message translates to:
  /// **'Membership is not verified.'**
  String get membershipNotVerified;

  /// No description provided for @checkInUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Check-in is not available.'**
  String get checkInUnavailable;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get editProfile;

  /// No description provided for @nameNotSet.
  ///
  /// In en, this message translates to:
  /// **'Name not set'**
  String get nameNotSet;

  /// No description provided for @unavailable.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get unavailable;

  /// No description provided for @displayName.
  ///
  /// In en, this message translates to:
  /// **'Display name'**
  String get displayName;

  /// No description provided for @savedOnDeviceOnly.
  ///
  /// In en, this message translates to:
  /// **'Saved on this device only.'**
  String get savedOnDeviceOnly;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @versionLabel.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String versionLabel(String version);

  /// No description provided for @noNotificationsYet.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get noNotificationsYet;

  /// No description provided for @noNotificationsBody.
  ///
  /// In en, this message translates to:
  /// **'When something needs your attention, it will show up here.'**
  String get noNotificationsBody;

  /// No description provided for @screenNotReady.
  ///
  /// In en, this message translates to:
  /// **'This screen is not ready yet. Nothing is saved.'**
  String get screenNotReady;

  /// No description provided for @viewMap.
  ///
  /// In en, this message translates to:
  /// **'View map'**
  String get viewMap;

  /// No description provided for @navigate.
  ///
  /// In en, this message translates to:
  /// **'Navigate'**
  String get navigate;

  /// No description provided for @chooseNavigation.
  ///
  /// In en, this message translates to:
  /// **'Choose a maps app'**
  String get chooseNavigation;

  /// No description provided for @navigationSuggested.
  ///
  /// In en, this message translates to:
  /// **'Suggested'**
  String get navigationSuggested;

  /// No description provided for @googleMaps.
  ///
  /// In en, this message translates to:
  /// **'Google Maps'**
  String get googleMaps;

  /// No description provided for @waze.
  ///
  /// In en, this message translates to:
  /// **'Waze'**
  String get waze;

  /// No description provided for @appleMaps.
  ///
  /// In en, this message translates to:
  /// **'Apple Maps'**
  String get appleMaps;

  /// No description provided for @navigationSearchNote.
  ///
  /// In en, this message translates to:
  /// **'This searches by the pond name and address. It is not a verified pin.'**
  String get navigationSearchNote;

  /// No description provided for @mapsLaunchFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open maps.'**
  String get mapsLaunchFailed;

  /// No description provided for @mapsOpenedInBrowser.
  ///
  /// In en, this message translates to:
  /// **'Opened a map page in the browser. Navigation did not start in an app.'**
  String get mapsOpenedInBrowser;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @noFavoritesYet.
  ///
  /// In en, this message translates to:
  /// **'No favorite ponds yet.'**
  String get noFavoritesYet;

  /// No description provided for @favoritePond.
  ///
  /// In en, this message translates to:
  /// **'Add to favorites'**
  String get favoritePond;

  /// No description provided for @unfavoritePond.
  ///
  /// In en, this message translates to:
  /// **'Remove from favorites'**
  String get unfavoritePond;

  /// No description provided for @pondUnavailable.
  ///
  /// In en, this message translates to:
  /// **'This pond is not in the current list.'**
  String get pondUnavailable;

  /// No description provided for @sortByName.
  ///
  /// In en, this message translates to:
  /// **'Name (A–Z)'**
  String get sortByName;

  /// No description provided for @catchLog.
  ///
  /// In en, this message translates to:
  /// **'Catch log'**
  String get catchLog;

  /// No description provided for @addCatch.
  ///
  /// In en, this message translates to:
  /// **'Add catch'**
  String get addCatch;

  /// No description provided for @editCatch.
  ///
  /// In en, this message translates to:
  /// **'Edit catch'**
  String get editCatch;

  /// No description provided for @catchDetails.
  ///
  /// In en, this message translates to:
  /// **'Catch details'**
  String get catchDetails;

  /// No description provided for @speciesRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a species name.'**
  String get speciesRequired;

  /// No description provided for @catchDate.
  ///
  /// In en, this message translates to:
  /// **'Catch date'**
  String get catchDate;

  /// No description provided for @catchTime.
  ///
  /// In en, this message translates to:
  /// **'Catch time'**
  String get catchTime;

  /// No description provided for @weightKg.
  ///
  /// In en, this message translates to:
  /// **'Weight (kg, optional)'**
  String get weightKg;

  /// No description provided for @lengthCm.
  ///
  /// In en, this message translates to:
  /// **'Length (cm, optional)'**
  String get lengthCm;

  /// No description provided for @notesOptional.
  ///
  /// In en, this message translates to:
  /// **'Notes (optional)'**
  String get notesOptional;

  /// No description provided for @associatedPond.
  ///
  /// In en, this message translates to:
  /// **'Pond (optional)'**
  String get associatedPond;

  /// No description provided for @noPondSelected.
  ///
  /// In en, this message translates to:
  /// **'No pond'**
  String get noPondSelected;

  /// No description provided for @invalidNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter a number that is zero or greater.'**
  String get invalidNumber;

  /// No description provided for @addPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add photo'**
  String get addPhoto;

  /// No description provided for @removePhoto.
  ///
  /// In en, this message translates to:
  /// **'Remove photo'**
  String get removePhoto;

  /// No description provided for @photoSelected.
  ///
  /// In en, this message translates to:
  /// **'A photo is attached.'**
  String get photoSelected;

  /// No description provided for @photoUnavailable.
  ///
  /// In en, this message translates to:
  /// **'The photo could not be saved.'**
  String get photoUnavailable;

  /// No description provided for @couldNotSave.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save. Nothing was changed.'**
  String get couldNotSave;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @deleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this record?'**
  String get deleteConfirmTitle;

  /// No description provided for @deleteConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'This removes it from this device.'**
  String get deleteConfirmBody;

  /// No description provided for @planATrip.
  ///
  /// In en, this message translates to:
  /// **'Plan a trip'**
  String get planATrip;

  /// No description provided for @editTrip.
  ///
  /// In en, this message translates to:
  /// **'Edit trip'**
  String get editTrip;

  /// No description provided for @tripDetails.
  ///
  /// In en, this message translates to:
  /// **'Trip details'**
  String get tripDetails;

  /// No description provided for @tripTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Trip title'**
  String get tripTitleLabel;

  /// No description provided for @tripTitleRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a trip title.'**
  String get tripTitleRequired;

  /// No description provided for @startDate.
  ///
  /// In en, this message translates to:
  /// **'Start date'**
  String get startDate;

  /// No description provided for @endDate.
  ///
  /// In en, this message translates to:
  /// **'End date (optional)'**
  String get endDate;

  /// No description provided for @clearEndDate.
  ///
  /// In en, this message translates to:
  /// **'Clear end date'**
  String get clearEndDate;

  /// No description provided for @endBeforeStart.
  ///
  /// In en, this message translates to:
  /// **'The end date is before the start date.'**
  String get endBeforeStart;

  /// No description provided for @tripStatusPlanned.
  ///
  /// In en, this message translates to:
  /// **'Planned'**
  String get tripStatusPlanned;

  /// No description provided for @tripStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get tripStatusCompleted;

  /// No description provided for @tripStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get tripStatusCancelled;

  /// No description provided for @markCompleted.
  ///
  /// In en, this message translates to:
  /// **'Mark completed'**
  String get markCompleted;

  /// No description provided for @cancelTrip.
  ///
  /// In en, this message translates to:
  /// **'Cancel trip'**
  String get cancelTrip;

  /// No description provided for @reopenTrip.
  ///
  /// In en, this message translates to:
  /// **'Mark as planned'**
  String get reopenTrip;

  /// No description provided for @notAReservation.
  ///
  /// In en, this message translates to:
  /// **'This does not reserve or book the pond.'**
  String get notAReservation;

  /// No description provided for @noTripsYet.
  ///
  /// In en, this message translates to:
  /// **'No trips yet.'**
  String get noTripsYet;

  /// No description provided for @selectPond.
  ///
  /// In en, this message translates to:
  /// **'Pond'**
  String get selectPond;

  /// No description provided for @noPondsForTrip.
  ///
  /// In en, this message translates to:
  /// **'No ponds are available to select.'**
  String get noPondsForTrip;

  /// No description provided for @loadingRecords.
  ///
  /// In en, this message translates to:
  /// **'Loading saved records…'**
  String get loadingRecords;

  /// No description provided for @recordsLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Saved records could not be loaded.'**
  String get recordsLoadFailed;

  /// No description provided for @recordMissing.
  ///
  /// In en, this message translates to:
  /// **'This record is no longer on this device.'**
  String get recordMissing;

  /// No description provided for @fishingSession.
  ///
  /// In en, this message translates to:
  /// **'Fishing session'**
  String get fishingSession;

  /// No description provided for @fishingHistory.
  ///
  /// In en, this message translates to:
  /// **'Fishing history'**
  String get fishingHistory;

  /// No description provided for @startSession.
  ///
  /// In en, this message translates to:
  /// **'Start session'**
  String get startSession;

  /// No description provided for @resumeSession.
  ///
  /// In en, this message translates to:
  /// **'Resume session'**
  String get resumeSession;

  /// No description provided for @sessionActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get sessionActive;

  /// No description provided for @sessionCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get sessionCompleted;

  /// No description provided for @sessionInProgress.
  ///
  /// In en, this message translates to:
  /// **'A session is already in progress.'**
  String get sessionInProgress;

  /// No description provided for @sessionStartedAt.
  ///
  /// In en, this message translates to:
  /// **'Started'**
  String get sessionStartedAt;

  /// No description provided for @sessionEndedAt.
  ///
  /// In en, this message translates to:
  /// **'Ended'**
  String get sessionEndedAt;

  /// No description provided for @sessionElapsed.
  ///
  /// In en, this message translates to:
  /// **'Elapsed'**
  String get sessionElapsed;

  /// No description provided for @sessionDurationHours.
  ///
  /// In en, this message translates to:
  /// **'{hours} h {minutes} min'**
  String sessionDurationHours(int hours, int minutes);

  /// No description provided for @sessionDurationMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String sessionDurationMinutes(int minutes);

  /// No description provided for @sessionCatchCount.
  ///
  /// In en, this message translates to:
  /// **'Catches: {count}'**
  String sessionCatchCount(int count);

  /// No description provided for @endSession.
  ///
  /// In en, this message translates to:
  /// **'End session'**
  String get endSession;

  /// No description provided for @endSessionConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'End this session?'**
  String get endSessionConfirmTitle;

  /// No description provided for @endSessionConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'The end time is recorded. New catches cannot be added from this session.'**
  String get endSessionConfirmBody;

  /// No description provided for @sessionTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Session title (optional)'**
  String get sessionTitleLabel;

  /// No description provided for @noSessionsYet.
  ///
  /// In en, this message translates to:
  /// **'No fishing sessions yet.'**
  String get noSessionsYet;

  /// No description provided for @sessionNotABooking.
  ///
  /// In en, this message translates to:
  /// **'Saved on this device. This is not a booking.'**
  String get sessionNotABooking;

  /// No description provided for @addCatchToSession.
  ///
  /// In en, this message translates to:
  /// **'Add catch'**
  String get addCatchToSession;

  /// No description provided for @sessionPond.
  ///
  /// In en, this message translates to:
  /// **'Pond'**
  String get sessionPond;

  /// No description provided for @noPondOnSession.
  ///
  /// In en, this message translates to:
  /// **'No pond selected'**
  String get noPondOnSession;

  /// No description provided for @markLinkedTripCompleted.
  ///
  /// In en, this message translates to:
  /// **'Mark linked trip completed'**
  String get markLinkedTripCompleted;

  /// No description provided for @linkedTripMissing.
  ///
  /// In en, this message translates to:
  /// **'The linked trip is no longer on this device.'**
  String get linkedTripMissing;

  /// No description provided for @sessionSummary.
  ///
  /// In en, this message translates to:
  /// **'Session summary'**
  String get sessionSummary;

  /// No description provided for @activeSessionSection.
  ///
  /// In en, this message translates to:
  /// **'Active session'**
  String get activeSessionSection;

  /// No description provided for @completedSessionsSection.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completedSessionsSection;

  /// No description provided for @sessionCatchLinked.
  ///
  /// In en, this message translates to:
  /// **'This catch is part of the fishing session.'**
  String get sessionCatchLinked;

  /// No description provided for @sessionEndMissing.
  ///
  /// In en, this message translates to:
  /// **'End time was not recorded.'**
  String get sessionEndMissing;
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
      <String>['en', 'ms'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ms':
      return AppLocalizationsMs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
