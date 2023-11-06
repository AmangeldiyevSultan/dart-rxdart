import 'package:rxdart/rxdart.dart';

//? In ReplaySubject all the items we added
//? to our subject is dispatched to it’s listeners
//? doesn’t matter the sequence when we add first
//? or listen first to that items of ReplaySubject,
//? unlike PublishSubject and BehaviorSubject.
void main() {
  ReplaySubject<int> replaySubject = ReplaySubject<int>();
  //? Also we can specify max size of our subject
  ReplaySubject<int> replaySubjectWithMaxSize = ReplaySubject<int>(maxSize: 1);

  //! so [ReplaySubject] add items to all listeners no matter
  //! listener above or below then added item
  replaySubject.stream.listen((data) {
    print("listener - 1 : $data");
  });

  replaySubject.add(1);
  replaySubject.add(2);
  replaySubject.add(3);

  replaySubject.stream.listen((data) {
    print("listener - 2 : $data");
  });

  replaySubject.add(4);

  replaySubject.close();

  /// listener - 1 : 1
  /// listener - 2 : 1
  /// listener - 2 : 2
  /// listener - 2 : 3
  /// listener - 2 : 4
  /// listener - 1 : 2
  /// listener - 1 : 3
  /// listener - 1 : 4

  replaySubjectWithMaxSize.add(1);
  replaySubjectWithMaxSize.add(2);
  replaySubjectWithMaxSize.add(3);

  replaySubjectWithMaxSize.stream.listen((data) {
    print("listener with max size - 1 : $data");

    /// listener with max size  - 1 prints : only 3
    /// so it mean just last added item
  });

  replaySubject.close();
}
