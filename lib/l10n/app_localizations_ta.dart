// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Tamil (`ta`).
class AppLocalizationsTa extends AppLocalizations {
  AppLocalizationsTa([String locale = 'ta']) : super(locale);

  @override
  String get appName => 'VisaDuma';

  @override
  String get appTagline => 'இலங்கையின் சூப்பர் சேவை செயலி';

  @override
  String get selectLanguage => 'உங்கள் மொழியை தேர்ந்தெடுக்கவும்';

  @override
  String get selectLanguageSubtitle =>
      'உங்களுக்கு மிகவும் வசதியான மொழியை தேர்வு செய்யுங்கள்';

  @override
  String get continueButton => 'தொடரவும்';

  @override
  String get english => 'English';

  @override
  String get sinhala => 'සිංහල';

  @override
  String get tamil => 'தமிழ்';

  @override
  String get getStarted => 'தொடங்குங்கள்';

  @override
  String get login => 'உள்நுழைக';

  @override
  String get register => 'பதிவு செய்க';

  @override
  String get email => 'மின்னஞ்சல்';

  @override
  String get password => 'கடவுச்சொல்';

  @override
  String get confirmPassword => 'கடவுச்சொல்லை உறுதிப்படுத்தவும்';

  @override
  String get fullName => 'முழு பெயர்';

  @override
  String get phoneNumber => 'தொலைபேசி எண்';

  @override
  String get forgotPassword => 'கடவுச்சொல் மறந்துவிட்டதா?';

  @override
  String get dontHaveAccount => 'கணக்கு இல்லையா?';

  @override
  String get alreadyHaveAccount => 'ஏற்கனவே கணக்கு உள்ளதா?';

  @override
  String get home => 'முகப்பு';

  @override
  String get services => 'சேவைகள்';

  @override
  String get bookings => 'முன்பதிவுகள்';

  @override
  String get profile => 'சுயவிவரம்';

  @override
  String get notifications => 'அறிவிப்புகள்';

  @override
  String get chat => 'அரட்டை';

  @override
  String get rides => 'பயணங்கள்';

  @override
  String get shops => 'கடைகள்';

  @override
  String get vehicles => 'வாகனங்கள்';

  @override
  String get jobs => 'வேலைகள்';

  @override
  String get boarding => 'தங்குமிடம்';

  @override
  String get reviews => 'மதிப்புரைகள்';

  @override
  String get searchServices => 'சேவைகளை தேடுங்கள்…';

  @override
  String get searchShops => 'கடைகளை தேடுங்கள்…';

  @override
  String get allCategories => 'அனைத்து வகைகள்';

  @override
  String get nearbyProviders => 'அருகிலுள்ள சேவையாளர்கள்';

  @override
  String get topRated => 'உயர் மதிப்பீடு';

  @override
  String get bookNow => 'இப்போது முன்பதிவு செய்';

  @override
  String get viewAll => 'அனைத்தையும் பார்க்க';

  @override
  String get loading => 'ஏற்றுகிறது…';

  @override
  String get error => 'ஏதோ தவறாகிவிட்டது';

  @override
  String get retry => 'மீண்டும் முயற்சிக்கவும்';

  @override
  String get noInternetTitle => 'இணையம் இல்லை';

  @override
  String get noInternetBody =>
      'உங்கள் இணைப்பைச் சரிபார்த்து மீண்டும் முயற்சிக்கவும்.';

  @override
  String get emptyStateTitle => 'இன்னும் எதுவும் இல்லை';

  @override
  String get emptyStateBody => 'பின்னர் திரும்பி சரிபார்க்கவும்.';

  @override
  String get save => 'சேமிக்கவும்';

  @override
  String get cancel => 'ரத்துசெய்';

  @override
  String get delete => 'நீக்கு';

  @override
  String get edit => 'திருத்து';

  @override
  String get submit => 'சமர்ப்பிக்கவும்';

  @override
  String get confirm => 'உறுதிப்படுத்தவும்';

  @override
  String get yes => 'ஆம்';

  @override
  String get no => 'இல்லை';

  @override
  String get ok => 'சரி';

  @override
  String get close => 'மூடு';

  @override
  String get back => 'பின்செல்';

  @override
  String get logoutTitle => 'வெளியேறு';

  @override
  String get logoutBody => 'நிச்சயமாக வெளியேற விரும்புகிறீர்களா?';

  @override
  String get bookingSuccess => 'முன்பதிவு உறுதிப்படுத்தப்பட்டது!';

  @override
  String get bookingFailed =>
      'முன்பதிவு தோல்வியடைந்தது. மீண்டும் முயற்சிக்கவும்.';

  @override
  String get rating => 'மதிப்பீடு';

  @override
  String reviews_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count மதிப்புரைகள்',
      one: '1 மதிப்புரை',
    );
    return '$_temp0';
  }

  @override
  String get availableNow => 'இப்போது கிடைக்கிறது';

  @override
  String get unavailable => 'கிடைக்கவில்லை';

  @override
  String pricePerHour(String price) {
    return 'ரூ. $price/மணி';
  }

  @override
  String kmAway(String km) {
    return '$km கி.மீ தொலைவில்';
  }
}
