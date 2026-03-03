// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Sinhala Sinhalese (`si`).
class AppLocalizationsSi extends AppLocalizations {
  AppLocalizationsSi([String locale = 'si']) : super(locale);

  @override
  String get appName => 'VisaDuma';

  @override
  String get appTagline => 'ශ්‍රී ලංකාවේ සුපිරි සේවා යෙදුම';

  @override
  String get selectLanguage => 'ඔබගේ භාෂාව තෝරන්න';

  @override
  String get selectLanguageSubtitle => 'ඔබට වඩාත් සුවිධායක භාෂාව තෝරාගන්න';

  @override
  String get continueButton => 'ඉදිරියට';

  @override
  String get english => 'English';

  @override
  String get sinhala => 'සිංහල';

  @override
  String get tamil => 'தமிழ்';

  @override
  String get getStarted => 'ආරම්භ කරන්න';

  @override
  String get login => 'පිවිසෙන්න';

  @override
  String get register => 'ලියාපදිංචි වන්න';

  @override
  String get email => 'විද්‍යුත් තැපෑල';

  @override
  String get password => 'මුරපදය';

  @override
  String get confirmPassword => 'මුරපදය තහවුරු කරන්න';

  @override
  String get fullName => 'සම්පූර්ණ නම';

  @override
  String get phoneNumber => 'දුරකථන අංකය';

  @override
  String get forgotPassword => 'මුරපදය අමතකද?';

  @override
  String get dontHaveAccount => 'ගිණුමක් නොමැතිද?';

  @override
  String get alreadyHaveAccount => 'දැනටමත් ගිණුමක් තිබේද?';

  @override
  String get home => 'මුල් පිටුව';

  @override
  String get services => 'සේවාවන්';

  @override
  String get bookings => 'වෙන් කිරීම්';

  @override
  String get profile => 'පැතිකඩ';

  @override
  String get notifications => 'දැනුම්දීම්';

  @override
  String get chat => 'කතාබස';

  @override
  String get rides => 'ගමනාගමන';

  @override
  String get shops => 'වෙළඳසැල්';

  @override
  String get vehicles => 'වාහන';

  @override
  String get jobs => 'රැකිරියා';

  @override
  String get boarding => 'නේවාසිකාගාර';

  @override
  String get reviews => 'සමාලෝචන';

  @override
  String get searchServices => 'සේවාවන් සොයන්න…';

  @override
  String get searchShops => 'වෙළඳසැල් සොයන්න…';

  @override
  String get allCategories => 'සියලු වර්ග';

  @override
  String get nearbyProviders => 'ආසන්නතම සපයන්නන්';

  @override
  String get topRated => 'ඉහළ ශ්‍රේණිගත';

  @override
  String get bookNow => 'දැන් වෙන් කරන්න';

  @override
  String get viewAll => 'සියල්ල බලන්න';

  @override
  String get loading => 'පූරණය වෙමින්…';

  @override
  String get error => 'කිසියම් දෝෂයක් ඇත';

  @override
  String get retry => 'නැවත උත්සාහ කරන්න';

  @override
  String get noInternetTitle => 'අන්තර්ජාල සම්බන්ධතාවය නැත';

  @override
  String get noInternetBody => 'ඔබගේ සම්බන්ධතාව පරීක්ෂා කර නැවත උත්සාහ කරන්න.';

  @override
  String get emptyStateTitle => 'තවමත් කිසිවක් නැත';

  @override
  String get emptyStateBody => 'පසුව නැවත පරීක්ෂා කරන්න.';

  @override
  String get save => 'සුරකින්න';

  @override
  String get cancel => 'අවලංගු කරන්න';

  @override
  String get delete => 'මකන්න';

  @override
  String get edit => 'සංස්කරණය';

  @override
  String get submit => 'ඉදිරිපත් කරන්න';

  @override
  String get confirm => 'තහවුරු කරන්න';

  @override
  String get yes => 'ඔව්';

  @override
  String get no => 'නැත';

  @override
  String get ok => 'හරි';

  @override
  String get close => 'වසන්න';

  @override
  String get back => 'ආපසු';

  @override
  String get logoutTitle => 'ඉවත් වන්න';

  @override
  String get logoutBody => 'ඔබට සැබවින්ම ඉවත් වීමට අවශ්‍යද?';

  @override
  String get bookingSuccess => 'වෙන්කිරීම සාර්ථකයි!';

  @override
  String get bookingFailed => 'වෙන්කිරීම අසාර්ථකයි. නැවත උත්සාහ කරන්න.';

  @override
  String get rating => 'ශ්‍රේණිය';

  @override
  String reviews_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'සමාලෝචන $count',
      one: 'සමාලෝචනය 1',
    );
    return '$_temp0';
  }

  @override
  String get availableNow => 'දැන් ලබාගත හැකිය';

  @override
  String get unavailable => 'නොතිබේ';

  @override
  String pricePerHour(String price) {
    return 'රු. $price/පැ';
  }

  @override
  String kmAway(String km) {
    return '$km km දුරින්';
  }
}
