import 'package:flutter/material.dart';

class AppConstants {
  static const String env = 'prod';
  static const String iconsFolder = 'assets/icons/';
  static const String imagesFolder = 'assets/images/';
  static const String dateFormat = 'yyyy-MM-dd'; //dd/MM/yyyy';
  static final themeColorShade1 = Color.fromARGB(255, 253, 82, 106);
  static final themeColorShade2 = Color.fromARGB(255, 251, 102, 104);
  static final themeColorShade3 = Color.fromARGB(255, 249, 112, 103);
  static bool myItemsLoaded = false;
  static bool brandsLoaded = false;
  static const primaryColor = Color.fromARGB(255, 253, 82, 106);
  static const String privacyPolicyUrl =
      "https://www.zervee.com/privacy-policy/";
  static const String termsOfServiceUrl =
      "https://www.zervee.com/terms-of-service/";
  static var fileFormats = {
    'doc': 'docIcon.png',
    'docx': 'docxIcon.png',
    'pdf': 'pdfIcon.png',
    'xls': 'xlsIcon.png',
    'xlsx': 'xlsxIcon.png',
  };

  static const devAuthServiceUrl =
      'https://pfop3m6c4e.execute-api.ap-southeast-1.amazonaws.com/dev';
  static const devAdminServiceUrl =
      'https://2dyto52v4a.execute-api.ap-southeast-1.amazonaws.com/dev';
  static const devCustServiceUrl =
      'https://w1ssxykqe8.execute-api.ap-southeast-1.amazonaws.com/dev';

  static const prodAuthServiceUrl =
      'https://jid9nlxaof.execute-api.ap-southeast-1.amazonaws.com/prod';
  static const prodAdminServiceUrl =
      'https://aez0wqdr1e.execute-api.ap-southeast-1.amazonaws.com/prod';
  static const prodCustServiceUrl =
      'https://gqec0mhbl2.execute-api.ap-southeast-1.amazonaws.com/prod';

  static var passwordPolicy =
      new RegExp("(?=.{8,})" + // "" followed by 9+ symbols
          "(?=.*[a-z])" + // --- ' ' --- at least 1 lower
          "(?=.*[A-Z])" + // --- ' ' --- at least 1 upper
          "(?=.*[0-9])" + // --- ' ' --- at least 1 digit
          "(?=.*\\p{Punct})" + // --- ' ' --- at least 1 symbol
          ".*");
  static var pwdPolicies = [
    "(?=.{8,})", // "" followed by 9+ symbols
    "(?=.*[a-z])", // --- ' ' --- at least 1 lower
    "(?=.*[A-Z])", // --- ' ' --- at least 1 upper
    "(?=.*[0-9])", // --- ' ' --- at least 1 digit
    '''[!@#\$%^&*()\\-_]''', // --- ' ' --- at least 1 symbol
    ".*"
  ];

  static final MaterialColor primaryMaterialColor =
      MaterialColor(Color.fromARGB(255, 253, 82, 106).value, {
    50: Color.fromARGB(255, 249, 112, 103),
    100: Color.fromARGB(255, 250, 107, 104),
    200: Color.fromARGB(255, 251, 102, 106),
    300: Color.fromARGB(255, 252, 90, 106),
    400: Color.fromARGB(255, 253, 82, 106),
    500: Color.fromARGB(255, 253, 82, 106),
    600: Color.fromARGB(255, 253, 82, 106),
    700: Color.fromARGB(255, 253, 82, 106),
    800: Color.fromARGB(255, 253, 82, 106),
    900: Color.fromARGB(255, 255, 70, 106),
  });

  final cardColors = [
    Colors.amber,
    Colors.black,
    Colors.redAccent,
    Colors.blueAccent,
    Colors.greenAccent,
    Colors.yellowAccent,
    Colors.cyanAccent,
    Colors.accents,
  ];

  static String get authServiceUrl {
    if (env == 'prod') return prodAuthServiceUrl;
    return devAuthServiceUrl;
  }

  static String get adminServiceUrl {
    if (env == 'prod') return prodAdminServiceUrl;
    return devAdminServiceUrl;
  }

  static String get custServiceUrl {
    if (env == 'prod') return prodCustServiceUrl;
    return devCustServiceUrl;
  }
}

class BrandCategories {
  static List<String> categories = [
    'Industry',
    'Accounting',
    'Airlines/Aviation',
    'Alternative Dispute Resolution',
    'Alternative Medicine',
    'Animation',
    'Apparel/Fashion',
    'Architecture/Planning',
    'Arts/Crafts',
    'Automotive',
    'Aviation/Aerospace',
    'Banking/Mortgage',
    'Biotechnology/Greentech',
    'Broadcast Media',
    'Building Materials',
    'Business Supplies/Equipment',
    'Capital Markets/Hedge Fund/Private Equity',
    'Chemicals',
  ];
}
