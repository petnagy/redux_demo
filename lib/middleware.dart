import 'dart:async';
import 'package:redux_demo/main.dart';
import 'package:redux_demo/preferences.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

Stream<dynamic> saveToPreferences(
    Stream<dynamic> actions, EpicStore<AppState> store) {
  return new Observable(actions)
      .ofType(new TypeToken<IncrementCounterAction>())
      .asyncMap((action) {
    Preferences prefs = new Preferences();
    prefs.save(store.state.counter);
  });
}

Stream<dynamic> loadFromPreferences(
    Stream<dynamic> actions, EpicStore<AppState> store) {
  return new Observable(actions)
      .ofType(new TypeToken<IncrementCounterAction>())
      .asyncMap((action) {
    Preferences prefs = new Preferences();
    int counter = prefs.load();
    return new LoadedAction(counter);
  });
}
