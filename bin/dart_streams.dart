//! Subjects its like StreamController in Streams
import 'dart:async';

void main() async {
  var controller = StreamController<String>();

  //? method listen its like a trap for items to take from conveyor of items
  //? [StreamSubscription] to control stream behavior
  //? like that
  //* subscription.onData((data) {
  //*   print(data);
  //* });

  StreamSubscription subscription =
      controller.stream.listen((item) => print(item));

  controller.add("Item1");
  controller.add("Item2");
  controller.add("Item3");

  await Future.delayed(Duration(milliseconds: 500));

  subscription.cancel;
}

// Example
class Model {
  int _counter = 0;
  final StreamController<int> _streamController = StreamController<int>();
  //  Also we can write [StreamController<int>.broadcast();] to listen multiple listeners
  // like:
  //   _controller.stream.listen((data) {
  //   print('Listener 1 received data: $data');
  // });
  // _controller.stream.listen((data) {
  //   print('Listener 2 received data: $data');
  // });
  Stream<int> get counterUpdates => _streamController.stream;

  void incrementCounter() {
    _counter++;
    _streamController.add(_counter);
    // Also we can write like _streamController.sink.add(_counter);
    // but in new version of Dart we can write just add
  }
}
// For Example in InitState
// @override
// void initState() {
//   streamSubscription = MyApp.model.counterUpdates.listen((newVal) => setState(() {
//         _counter = newVal;
//       }));
//   super.initState();
// }

// And use it in state via StreamBuilder
