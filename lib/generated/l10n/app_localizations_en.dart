// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'My Fishing App';

  @override
  String get welcomeBack => 'Welcome Back';

  @override
  String get welcomeSubtitle => 'Your next fishing adventure starts here.';

  @override
  String get login => 'Login';

  @override
  String get home => 'Home';

  @override
  String get explore => 'Explore';

  @override
  String get notification => 'Notification';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get bahasaMelayu => 'Bahasa Melayu';

  @override
  String get english => 'English';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get showPassword => 'Show password';

  @override
  String get hidePassword => 'Hide password';

  @override
  String get newUser => 'New?';

  @override
  String get register => 'Register';

  @override
  String get createAccount => 'Create account';

  @override
  String get createAccountSubtitle =>
      'Register to start your next fishing adventure.';

  @override
  String get name => 'Name';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get fishingHook => 'Fishing hook';

  @override
  String get splashScene => 'Angler fighting a jumping fish at night';

  @override
  String get homeHeaderScene => 'Angler and a jumping fish';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get continueWithFacebook => 'Continue with Facebook';

  @override
  String get continueWithTikTok => 'Continue with TikTok';

  @override
  String get continueWithWhatsApp => 'Continue with WhatsApp';

  @override
  String get linkedAccounts => 'Linked Accounts';

  @override
  String get connected => 'Connected';

  @override
  String get notConnected => 'Not connected';

  @override
  String get linkAccount => 'Link Account';

  @override
  String get unlinkAccount => 'Unlink Account';

  @override
  String get authenticationFailed => 'Authentication failed';

  @override
  String get authenticationCancelled => 'Authentication cancelled';

  @override
  String get verificationCode => 'Verification code';

  @override
  String get resendCode => 'Resend code';

  @override
  String get confirmUnlink => 'Confirm unlinking';

  @override
  String confirmUnlinkMessage(String provider) {
    return 'Unlink $provider? You will not be able to sign in with it.';
  }

  @override
  String get configurationRequired => 'Configuration required';

  @override
  String get unlinkLastMethod => 'Keep at least one sign-in method linked.';

  @override
  String get cancel => 'Cancel';

  @override
  String get phoneNumber => 'Phone number';

  @override
  String get whatsappVerificationTitle => 'Verify WhatsApp';

  @override
  String get whatsappVerificationSubtitle =>
      'Enter your phone number. A code is sent only after WhatsApp verification is configured.';

  @override
  String get verify => 'Verify';

  @override
  String get goodMorning => 'Good morning';

  @override
  String get goodAfternoon => 'Good afternoon';

  @override
  String get goodEvening => 'Good evening';

  @override
  String get homePrompt => 'Your next trip starts here.';

  @override
  String get logACatch => 'Log a catch';

  @override
  String get spots => 'Spots';

  @override
  String get spotsSubtitle => 'Browse places to fish';

  @override
  String get trips => 'Trips';

  @override
  String get tripsSubtitle => 'Plan your next outing';

  @override
  String get recentActivity => 'Recent activity';

  @override
  String get noCatchesYet => 'No catches yet.';

  @override
  String get membershipSection => 'Membership';

  @override
  String get noMembershipYet => 'No membership yet.';

  @override
  String get myFishingPass => 'My Fishing Pass';

  @override
  String get passCardSubtitle =>
      'Open your pond pass when you have a membership.';

  @override
  String get explorePonds => 'Explore Ponds';

  @override
  String get myMemberships => 'My Memberships';

  @override
  String get myTrips => 'My Trips';

  @override
  String get quickActions => 'Quick actions';

  @override
  String get searchPonds => 'Search ponds';

  @override
  String get fishSpecies => 'Fish species';

  @override
  String get pondType => 'Pond type';

  @override
  String get noPondsYet => 'No ponds to show yet.';

  @override
  String get noMatchingPonds => 'No ponds match your search.';

  @override
  String get noFiltersYet => 'Filters appear when ponds are available.';

  @override
  String get clearFilters => 'Clear filters';

  @override
  String get pondDetails => 'Pond details';

  @override
  String get speciesLabel => 'Species';

  @override
  String get noMembershipAtPond => 'No membership at this pond.';

  @override
  String get membershipsEmptyBody =>
      'When you join a pond, it will appear here. Each pond has its own membership.';

  @override
  String get membershipDetails => 'Membership details';

  @override
  String get demoPreview => 'Demo preview';

  @override
  String get notVerifiedMembership => 'This is not a verified membership.';

  @override
  String get demoData => 'Demo data';

  @override
  String get demoDataHint =>
      'Shows a local preview of publicly listed venues. This is not live data.';

  @override
  String get demoPond => 'Demo pond';

  @override
  String get previewData => 'Preview data';

  @override
  String get notConfirmed => 'Not confirmed';

  @override
  String get saltwater => 'Saltwater';

  @override
  String get freshwater => 'Freshwater';

  @override
  String get mixedWater => 'Saltwater and freshwater';

  @override
  String get unknownWater => 'Unknown';

  @override
  String get waterType => 'Water type';

  @override
  String get openInGoogleMaps => 'Open in Google Maps';

  @override
  String get searchInGoogleMaps => 'Search in Google Maps';

  @override
  String get coordinatesLabel => 'Coordinates';

  @override
  String get imageUnavailable => 'Image unavailable';

  @override
  String get price => 'Price';

  @override
  String get openingHours => 'Opening hours';

  @override
  String get samplePrice => 'Sample price';

  @override
  String get sampleOpeningHours => 'Sample opening hours';

  @override
  String get facilities => 'Facilities';

  @override
  String get areaLabel => 'Area';

  @override
  String get verifiedMembership => 'Verified membership';

  @override
  String get passEmptyTitle => 'No fishing pass yet';

  @override
  String get passEmptyBody =>
      'A pass appears here after you have a membership at a pond.';

  @override
  String get qrUnavailable => 'No QR code is shown in this version.';

  @override
  String get demoPassBody => 'This preview is not a membership credential.';

  @override
  String get demoPreviewBadge => 'DEMO PREVIEW';

  @override
  String get demoQrCode => 'Demo QR code';

  @override
  String get demoBarcode => 'Demo barcode';

  @override
  String get memberId => 'Member ID';

  @override
  String get demoPassOnly => 'Demo pass only. Not valid for entry or check-in.';

  @override
  String get membershipNotVerified => 'Membership is not verified.';

  @override
  String get checkInUnavailable => 'Check-in is not available.';

  @override
  String get profile => 'Profile';

  @override
  String get editProfile => 'Edit profile';

  @override
  String get nameNotSet => 'Name not set';

  @override
  String get unavailable => 'Unavailable';

  @override
  String get displayName => 'Display name';

  @override
  String get savedOnDeviceOnly => 'Saved on this device only.';

  @override
  String get save => 'Save';

  @override
  String get preferences => 'Preferences';

  @override
  String get about => 'About';

  @override
  String versionLabel(String version) {
    return 'Version $version';
  }

  @override
  String get noNotificationsYet => 'No notifications yet';

  @override
  String get noNotificationsBody =>
      'When something needs your attention, it will show up here.';

  @override
  String get screenNotReady =>
      'This screen is not ready yet. Nothing is saved.';

  @override
  String get viewMap => 'View map';

  @override
  String get navigate => 'Navigate';

  @override
  String get chooseNavigation => 'Choose a maps app';

  @override
  String get navigationSuggested => 'Suggested';

  @override
  String get googleMaps => 'Google Maps';

  @override
  String get waze => 'Waze';

  @override
  String get appleMaps => 'Apple Maps';

  @override
  String get navigationSearchNote =>
      'This searches by the pond name and address. It is not a verified pin.';

  @override
  String get mapsLaunchFailed => 'Couldn\'t open maps.';

  @override
  String get mapsOpenedInBrowser =>
      'Opened a map page in the browser. Navigation did not start in an app.';

  @override
  String get favorites => 'Favorites';

  @override
  String get noFavoritesYet => 'No favorite ponds yet.';

  @override
  String get favoritePond => 'Add to favorites';

  @override
  String get unfavoritePond => 'Remove from favorites';

  @override
  String get pondUnavailable => 'This pond is not in the current list.';

  @override
  String get sortByName => 'Name (A–Z)';

  @override
  String get catchLog => 'Catch log';

  @override
  String get addCatch => 'Add catch';

  @override
  String get editCatch => 'Edit catch';

  @override
  String get catchDetails => 'Catch details';

  @override
  String get speciesRequired => 'Enter a species name.';

  @override
  String get catchDate => 'Catch date';

  @override
  String get catchTime => 'Catch time';

  @override
  String get weightKg => 'Weight (kg, optional)';

  @override
  String get lengthCm => 'Length (cm, optional)';

  @override
  String get notesOptional => 'Notes (optional)';

  @override
  String get associatedPond => 'Pond (optional)';

  @override
  String get noPondSelected => 'No pond';

  @override
  String get invalidNumber => 'Enter a number that is zero or greater.';

  @override
  String get addPhoto => 'Add photo';

  @override
  String get removePhoto => 'Remove photo';

  @override
  String get photoSelected => 'A photo is attached.';

  @override
  String get photoUnavailable => 'The photo could not be saved.';

  @override
  String get couldNotSave => 'Couldn\'t save. Nothing was changed.';

  @override
  String get delete => 'Delete';

  @override
  String get deleteConfirmTitle => 'Delete this record?';

  @override
  String get deleteConfirmBody => 'This removes it from this device.';

  @override
  String get planATrip => 'Plan a trip';

  @override
  String get editTrip => 'Edit trip';

  @override
  String get tripDetails => 'Trip details';

  @override
  String get tripTitleLabel => 'Trip title';

  @override
  String get tripTitleRequired => 'Enter a trip title.';

  @override
  String get startDate => 'Start date';

  @override
  String get endDate => 'End date (optional)';

  @override
  String get clearEndDate => 'Clear end date';

  @override
  String get endBeforeStart => 'The end date is before the start date.';

  @override
  String get tripStatusPlanned => 'Planned';

  @override
  String get tripStatusCompleted => 'Completed';

  @override
  String get tripStatusCancelled => 'Cancelled';

  @override
  String get markCompleted => 'Mark completed';

  @override
  String get cancelTrip => 'Cancel trip';

  @override
  String get reopenTrip => 'Mark as planned';

  @override
  String get notAReservation => 'This does not reserve or book the pond.';

  @override
  String get noTripsYet => 'No trips yet.';

  @override
  String get selectPond => 'Pond';

  @override
  String get noPondsForTrip => 'No ponds are available to select.';

  @override
  String get loadingRecords => 'Loading saved records…';

  @override
  String get recordsLoadFailed => 'Saved records could not be loaded.';

  @override
  String get recordMissing => 'This record is no longer on this device.';

  @override
  String get fishingSession => 'Fishing session';

  @override
  String get fishingHistory => 'Fishing history';

  @override
  String get startSession => 'Start session';

  @override
  String get resumeSession => 'Resume session';

  @override
  String get sessionActive => 'Active';

  @override
  String get sessionCompleted => 'Completed';

  @override
  String get sessionInProgress => 'A session is already in progress.';

  @override
  String get sessionStartedAt => 'Started';

  @override
  String get sessionEndedAt => 'Ended';

  @override
  String get sessionElapsed => 'Elapsed';

  @override
  String sessionDurationHours(int hours, int minutes) {
    return '$hours h $minutes min';
  }

  @override
  String sessionDurationMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String sessionCatchCount(int count) {
    return 'Catches: $count';
  }

  @override
  String get endSession => 'End session';

  @override
  String get endSessionConfirmTitle => 'End this session?';

  @override
  String get endSessionConfirmBody =>
      'The end time is recorded. New catches cannot be added from this session.';

  @override
  String get sessionTitleLabel => 'Session title (optional)';

  @override
  String get noSessionsYet => 'No fishing sessions yet.';

  @override
  String get sessionNotABooking =>
      'Saved on this device. This is not a booking.';

  @override
  String get addCatchToSession => 'Add catch';

  @override
  String get sessionPond => 'Pond';

  @override
  String get noPondOnSession => 'No pond selected';

  @override
  String get markLinkedTripCompleted => 'Mark linked trip completed';

  @override
  String get linkedTripMissing =>
      'The linked trip is no longer on this device.';

  @override
  String get sessionSummary => 'Session summary';

  @override
  String get activeSessionSection => 'Active session';

  @override
  String get completedSessionsSection => 'Completed';

  @override
  String get sessionCatchLinked => 'This catch is part of the fishing session.';

  @override
  String get sessionEndMissing => 'End time was not recorded.';
}
