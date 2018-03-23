import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux_demo/preferences.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:redux_persist/redux_persist.dart';
import 'package:redux_persist_flutter/redux_persist_flutter.dart';
import 'package:redux_logging/redux_logging.dart';
import 'package:redux_demo/middleware.dart';

void main() {
  runApp(new MyApp());
}

final allEpics = combineEpics<AppState>([
  saveToPreferences,
  loadFromPreferences
]);

// Redux
class AppState {
  final int counter;

  AppState({this.counter = 0});

  AppState copyWith({int counter}) {
    return new AppState(counter: counter ?? this.counter);
  }
}

class IncrementCounterAction {}

class LoadAction{}

class LoadedAction{
  int counter;

  LoadedAction(this.counter);
}

AppState reducer(AppState state, Object action) {
  if (action is IncrementCounterAction) {
    print("Reduser increment");
    return state.copyWith(counter: state.counter + 1);
  } else if (action is LoadedAction) {
    print("Reducer loaded action");
    return state.copyWith(counter: action.counter);
  }

  return state;
}

// App
class MyApp extends StatelessWidget {
  Store<AppState> store;

  MyApp() {

    store = new Store<AppState>(
      reducer,
      initialState: new AppState(),
      middleware: [
        new EpicMiddleware(allEpics),
        new LoggingMiddleware(formatter: LoggingMiddleware.multiLineFormatter)
      ],
    );

    store.dispatch(new LoadAction());
  }

  @override
  Widget build(BuildContext context) {
    // PersistorGate waits for state to be loaded before rendering
    return new StoreProvider(
        store: store,
        child: new MaterialApp(
            title: 'Redux Persist Demo',
            home: new MyHomePage()),
    );
  }
}

// Counter example
class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Redux Persist demo"),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              'You have pushed the button this many times:',
            ),
            new StoreConnector<AppState, String>(
              converter: (store) => store.state.counter.toString(),
              builder: (context, count) => new Text(
                '$count',
                style: Theme.of(context).textTheme.display1,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: new StoreConnector<AppState, VoidCallback>(
        converter: (store) {
          // Return a `VoidCallback`, which is a fancy name for a function
          // with no parameters. It only dispatches an Increment action.
          return () => store.dispatch(new IncrementCounterAction());
        },
        builder: (context, callback) => new FloatingActionButton(
          onPressed: callback,
          tooltip: 'Increment',
          child: new Icon(Icons.add),
        ),
      ),
    );
  }
}