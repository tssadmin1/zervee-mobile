import '../models/user_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserInfoProvider {
  static var userInfo = UserInfo();

///Fetch the user information from Shared Preferences
///and initialise the object, which can be used later on in the application
  Future<void> fetchAndSetUserInfo() async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(UserInfo.sharedPrefKey)) {
      print("found user info key in shared preferences");
      print('Fetching user details...');
      var pref = prefs.getString(UserInfo.sharedPrefKey);
      print('Fetched user details...:::: $pref');
      //Map<String, dynamic> res = json.decode(pref);
      userInfo = userInfoFromJson(pref);
      print('parsed user information...');
      print('${userInfo.email}');
      print('${userInfo.name}');
      //userInfo = UserInfo.fromJson(res);
    } else {
      print('UserInfo not found in shared preferences');
    }
  }

}
