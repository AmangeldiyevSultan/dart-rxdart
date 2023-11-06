import 'package:dart_rxdart_streams/dart_rxdart_streams.dart'
    as dart_rxdart_streams;
import 'package:rxdart/rxdart.dart';

void main(List<String> arguments) {
  BehaviorSubject<int> behaviorSubject = BehaviorSubject<int>();

  behaviorSubject.add(1);
  behaviorSubject.add(2);

  behaviorSubject.stream.listen((data) {
    print("listener - 2 : $data");

    /// listener - 2 prints : 2, 3
  });

  behaviorSubject.add(3);

  behaviorSubject.stream.listen((data) {
    print("listener - 3 : $data");

    /// listener - 3 prints : only 3
  });

  behaviorSubject.close();
}
