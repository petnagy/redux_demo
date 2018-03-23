
import 'package:shared_preferences/shared_preferences.dart';

class Preferences {

  load() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt("counter");
  }

  save(int counter) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setInt("counter", counter);
  }

}