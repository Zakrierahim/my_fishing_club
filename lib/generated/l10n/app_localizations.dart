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
