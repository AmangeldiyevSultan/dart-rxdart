import 'package:rxdart/rxdart.dart';

void main(List<String> arguments) {
  BehaviorSubject<int> behaviorSubject = BehaviorSubject<int>();

  //In BehaviorSubject the most recent item that we added to our
  //subject is dispatched to it’s new listeners. When we listen
  //to our new listener it will receive the latest stored item
  //from the subject and after that new event will be sent to
  //all other listeners. let’s see with example,

  behaviorSubject.add(1);
  behaviorSubject.add(2);

  // so we add to two items

  behaviorSubject.stream.listen((data) {
    // behavior print that latest item
    print("listener - 2 : $data");
  });

  // added new latest item
  behaviorSubject.add(3);

  behaviorSubject.stream.listen((data) {
    // behavior print that latest item and also notify previous listener
    print("listener - 3 : $data");

    /// listener - 2 : 2
    /// listener - 2 : 3
    /// listener - 3 : 3
  });

  behaviorSubject.close();
}
