import 'package:rxdart/rxdart.dart';

//? In PublishSubject all the items that we added
//? to our subject is dispatched to it’s listeners.
//? this is most easiest subject among other subjects
//? provided by rxdart. for this, the sequence of
//? listener matters for adding and listening to
//? the items of PublishSubject

void main() {
  PublishSubject<int> publishSubject = PublishSubject<int>();

  //* [PublishSubject] added all items to our [Subject]
  //* or in other way [StreamController]
  publishSubject.stream.listen((data) {
    print("listener - 1 : $data");
  });

  //* we adding 2 items
  publishSubject.add(1);
  publishSubject.add(2);

  //* also adding 2 items below but
  publishSubject.stream.listen((data) {
    print("listener - 2 : $data");
  });

  publishSubject.add(3);
  publishSubject.add(4);

  publishSubject.close();
  //* so listener 1 dispatch all items
  //* listener 2 also dispatched all which added later [2 and 3]
  /// listener - 1 : 1
  /// listener - 2 : 3
  /// listener - 1 : 2
  /// listener - 2 : 4
  /// listener - 1 : 3
  /// listener - 1 : 4
}
