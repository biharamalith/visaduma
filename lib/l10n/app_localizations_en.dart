// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'VisaDuma';

  @override
  String get appTagline => 'Sri Lanka\'s Super Service App';

  @override
  String get selectLanguage => 'Select Your Language';

  @override
  String get selectLanguageSubtitle =>
      'Choose the language you are most comfortable with';

  @override
  String get continueButton => 'Continue';

  @override
  String get english => 'English';

  @override
  String get sinhala => 'සිංහල';

  @override
  String get tamil => 'தமிழ்';

  @override
  String get getStarted => 'Get Started';

  @override
  String get login => 'Log In';

  @override
  String get register => 'Register';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get fullName => 'Full Name';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get home => 'Home';

  @override
  String get services => 'Services';

  @override
  String get bookings => 'Bookings';

  @override
  String get profile => 'Profile';

  @override
  String get notifications => 'Notifications';

  @override
  String get chat => 'Chat';

  @override
  String get rides => 'Rides';

  @override
  String get shops => 'Shops';

  @override
  String get vehicles => 'Vehicles';

  @override
  String get jobs => 'Jobs';

  @override
  String get boarding => 'Boarding';

  @override
  String get reviews => 'Reviews';

  @override
  String get searchServices => 'Search services…';

  @override
  String get searchShops => 'Search shops…';

  @override
  String get allCategories => 'All Categories';

  @override
  String get nearbyProviders => 'Nearby Providers';

  @override
  String get topRated => 'Top Rated';

  @override
  String get bookNow => 'Book Now';

  @override
  String get viewAll => 'View All';

  @override
  String get loading => 'Loading…';

  @override
  String get error => 'Something went wrong';

  @override
  String get retry => 'Retry';

  @override
  String get noInternetTitle => 'No Internet';

  @override
  String get noInternetBody => 'Please check your connection and try again.';

  @override
  String get emptyStateTitle => 'Nothing here yet';

  @override
  String get emptyStateBody => 'Check back later for updates.';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get submit => 'Submit';

  @override
  String get confirm => 'Confirm';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get ok => 'OK';

  @override
  String get close => 'Close';

  @override
  String get back => 'Back';

  @override
  String get logoutTitle => 'Log Out';

  @override
  String get logoutBody => 'Are you sure you want to log out?';

  @override
  String get bookingSuccess => 'Booking confirmed!';

  @override
  String get bookingFailed => 'Booking failed. Please try again.';

  @override
  String get rating => 'Rating';

  @override
  String reviews_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reviews',
      one: '1 review',
    );
    return '$_temp0';
  }

  @override
  String get availableNow => 'Available Now';

  @override
  String get unavailable => 'Unavailable';

  @override
  String pricePerHour(String price) {
    return 'Rs. $price/hr';
  }

  @override
  String kmAway(String km) {
    return '$km km away';
  }
}
