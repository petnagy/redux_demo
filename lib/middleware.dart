import 'dart:async';
import 'package:redux_demo/main.dart';
import 'package:redux_demo/preferences.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

//Stream<dynamic> saveToPreferences(
//    Stream<dynamic> actions, EpicStore<AppState> store) {
//  return actions
//      .where((action) => action is IncrementCounterAction)
//      .asyncMap((action) {
//    print("Middleware saveToPreference");
//    Preferences prefs = new Preferences();
//    prefs.save(store.state.counter);
//  });
//}
//
//Stream<dynamic> loadFromPreferences(
//    Stream<dynamic> actions, EpicStore<AppState> store) {
//  return actions
//      .where((action) => action is LoadAction)
//      .asyncMap((action) {
//    print("Middleware loadFromPreference");
//    Preferences prefs = new Preferences();
//    int counter = prefs.load();
//    return new LoadedAction(counter);
//  });
//}

Stream<dynamic> saveToPreferences(
    Stream<dynamic> actions, EpicStore<AppState> store) {
  return new Observable(actions)
      .doOnData((dynamic) => print(dynamic))
      .ofType(new TypeToken<IncrementCounterAction>())
      .asyncMap((action) {
    print("Middleware saveToPreference");
    Preferences prefs = new Preferences();
    prefs.save(store.state.counter);
  });
}

Stream<dynamic> loadFromPreferences(
    Stream<dynamic> actions, EpicStore<AppState> store) {
  return new Observable(actions)
      .doOnData((dynamic) => print(dynamic))
      .ofType(new TypeToken<LoadAction>())
      .asyncMap((action) {
    print("Middleware loadFromPreference");
    Preferences prefs = new Preferences();
    int counter = prefs.load();
    return new LoadedAction(counter);
  });
}
