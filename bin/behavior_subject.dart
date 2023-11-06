import 'package:rxdart/rxdart.dart';

//? In BehaviorSubject the most recent item that we added to our
//? subject is dispatched to it’s new listeners. When we listen
//? to our new listener it will receive the latest stored item
//? from the subject and after that new event will be sent to
//? all other listeners.
void main() {
  //* [seedValue] becomes the current value and is emitted immediately.
  BehaviorSubject<int> behaviorSubject = BehaviorSubject<int>.seeded(1);

  behaviorSubject.stream.listen((data) {
    print('listener - 1: $data');
  });

  behaviorSubject.add(0);
  behaviorSubject.add(2);

  //* so we add to two items

  behaviorSubject.stream.listen((data) {
    //* behavior print that latest item
    print("listener - 2 : $data");
  });

  //* added new latest item
  behaviorSubject.add(3);

  behaviorSubject.stream.listen((data) {
    //! behavior print that latest item and also notify previous listener
    print("listener - 3 : $data");

    /// output
    /// listener - 1: 1
    /// listener - 1: 0
    /// listener - 2 : 2
    /// listener - 2 : 3
    /// listener - 3 : 3
    /// listener - 1: 2
    /// listener - 1: 3
  });

  behaviorSubject.close();
}
