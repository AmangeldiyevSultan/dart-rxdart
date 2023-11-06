import 'dart:collection';

import 'package:rxdart/rxdart.dart';

void main() {
  //! Stream Classes
  combineLatestStream();
  concatStream();
  deferStream();
  forkJoinStream();
  fromCallableStream();
  mergeStream();
  raceStream();
  rangeStream();
  repeatStream();
  retryStream();
  retryWhenStream();
  sequenceEqualStream();
  switchLatestStream();
  timerStream();
  usingStream();
  zipStream();
}

void combineLatestStream() {
  //? This stream joins all the given streams into one
  //? single stream sequence by combining them when any
  //? of the source stream sequences send forth an item.
  //? this stream will emit items after all others streams
  //? that we want to combine have emitted at least one item.
  //? If any of the streams that we want to combine is empty then
  //? the resulting sequence completes instantly without emitting any items.

  //! so if at least one stream will be empty that result will beempty too
  CombineLatestStream.list<int>([
    // CombineLatestStream only emits a new list
    // when any of the source streams emits a new value,
    Stream.fromIterable([1]),
    Stream.fromIterable([2, 3]),
    Stream.fromIterable([4, 5, 6]),
  ]).listen((event) {
    print(event);
  });

  /// prints : [1, 2, 4], [1, 3, 4], [1, 3, 5], [1, 3, 6]
}

void concatStream() {
  //? This stream is used when we want to concatenates all
  //? stream sequences. ConcatStream concat the next stream
  //? sequence after the previous stream sequence is terminated
  //? successfully. In case where the streams is empty then
  //? it’s completes instantly without emitting any items.

  ConcatStream([
    Stream.fromIterable([1]),
    Stream.fromIterable([2, 3]),
    Stream.fromIterable([4, 5, 6]),
  ]).listen(print);

  /// cut each item in the list:
  /// prints : 1, 2, 3, 4, 5, 6

  //? ConcatEagerStream : This stream is similar
  //? with ConcatStream only the difference is that
  //? instead of subscribing to stream one by one,
  //? all the streams are immediately subscribed with correct time.
}

void deferStream() {
  //? [DeferStream] : This stream is used when we want
  //? to constructs a stream lazily when we subscribes
  //? to it. In some case we have to wait until the last
  //? minute to generate the stream that have latest data.
  //? it’s a single subscription stream but we can make it reusable.
  DeferStream(() => Stream.value([1, 2, 3])).listen(print);

  /// prints : [1, 2, 3]
}

void forkJoinStream() {
  //? [ForkJoinStream] : This stream is used
  //? when we only want sequence that contains
  //? only final emitted value of each stream.
  //? in the case where any of the inner streams
  //? have some error then we will lose the value
  //? of any other streams that already completed
  //? if we not catch that error correctly on the inner stream.

  ForkJoinStream.list<int>([
    Stream.fromIterable([1, 2, 3]),
    Stream.fromIterable([4, 5]),
    Stream.fromIterable([6]),
  ]).listen(print);

  /// prints : [3, 5, 6]
}

void fromCallableStream() {
  //? [FromCallableStream] : This stream is used when
  //? we want to return a stream that is based on the
  //? result of some function. the stream emits the value
  //? that’s returned from that function.

  FromCallableStream(() async {
    await Future<void>.delayed(const Duration(seconds: 3));
    return 'Value';
  }).listen(print);

  /// prints : Value (after 3 seconds)
}

void mergeStream() {
  //? [MergeStream] : This stream is used when
  //? we have to flattens the items that emitted
  //? by the given streams into a single sequence of
  //? stream. In this the items is emitted one after
  //? another from all the given streams.

  MergeStream([
    Stream.fromIterable([1, 2, 3]),
    Stream.fromIterable([4, 5]),
    Stream.fromIterable([6]),
  ]).listen(print);

  /// prints : 1, 4, 6, 2, 5, 3
}

void raceStream() {
  //? [RaceStream] : This stream returns a stream
  //? that emits all of it’s items before any other
  //? streams emits it’s items.

  RaceStream([
    TimerStream([1, 2, 3], Duration(seconds: 15)),
    TimerStream([4, 5], Duration(seconds: 10)),
    TimerStream([6, 7, 8, 9, 10], Duration(seconds: 5)),
  ]).listen(print);

  /// prints : [6, 7, 8, 9, 10] (after 5 seconds)
}

void rangeStream() {
  //?[RangeStream] : This stream class basically used when
  //? we want to returns a resulting stream that emits a
  //? sequence of integers within a particular range that we added.

  RangeStream(1, 5).listen((i) => print(i));

  /// prints : 1, 2, 3, 4, 5
}

void repeatStream() {
  //? [RepeatStream] : This stream creates a stream that
  //? will recreate it self and re- listen to the source stream
  //? for the specified number of times until the stream terminates
  //? successfully. In case if we forget to specify the count then
  //? it repeats indefinitely.

  RepeatStream(
          (int value) =>
              Stream.value(value).concatWith([Stream<int>.error(Error)]),
          //count
          2)
      .listen(print);

  /// prints : 0, Error, 1, Error
}

void retryStream() {
  //? [RetryStream] : This stream is similar with [RepeatStream]
  //? only the difference is that if the retry count is not
  //? specified, it retries indefinitely and if the retry count is
  //? met, but the stream has not terminated successfully then all
  //? of the errors that caused the failure will be emitted at the end.

  RetryStream(
    () => Stream.value(1).concatWith([Stream<int>.error(Error())]),
    2,
  ).listen(
    print,
    onError: (Object e, StackTrace s) => print(e),
  );

  /// prints : 1, 1, 1, Error, Error, Error
}

void retryWhenStream() {
  //? [RetryWhenStream] : This stream is somehow similar with the
  //? [RetryStream] the difference is it will take two stream
  //? as an argument (streamFactory and retryWhenFactory).
  //? if the retryWhenFactory throws an error or returns a stream
  //? that emits an error then the original error will be emitted
  //? and then the error from retryWhenFactory will be emitted if
  //? it is not same as the original error.

  var isError = false;
  RetryWhenStream<String>(
    () => Stream.periodic(const Duration(seconds: 1), (i) => i).map((i) {
      return (i == 4)
          ? throw 'Stop'
          : (i == 3 && !isError)
              ? throw 'restart'
              : isError
                  ? 'restart: $i'
                  : '$i';
    }),
    (e, s) {
      isError = true;
      if (e == 'restart') {
        // ignore: void_checks
        return Stream.value('restarting!!!');
      } else {
        return Stream.error(e, s);
      }
    },
  ).listen(print, onError: print);

  /// prints
  /*
  flutter: 0
  flutter: 1
  flutter: 2
  flutter: restart: 0
  flutter: restart: 1
  flutter: restart: 2
  flutter: restart: 3
  flutter: Stop
  */
}

void sequenceEqualStream() {
  //? [SequenceEqualStream] : This stream is used
  //? to check that whether the two streams emit
  //? the same sequence of items or not.

  SequenceEqualStream(
    Stream.fromIterable([1, 2, 3, 4, 5]),
    Stream.fromIterable([1, 2, 3, 4, 5]),
  ).listen(print);

  /// prints : true
}

void switchLatestStream() {
  //? [SwitchLatestStream] : This stream is used
  //? when we only want the single streams items
  //? that emitted most recently from the multiple streams.

  SwitchLatestStream<String>(
    Stream.fromIterable(<Stream<String>>[
      Rx.timer('1', Duration(seconds: 2)),
      Rx.timer('2', Duration(seconds: 3)),
      Stream.value('3'),
    ]),
  ).listen(print);

  /// prints : 3
  /// (because first & second stream not emits data fr 2-3 seconds
  /// and third stream emits before that time)
}

void timerStream() {
  //? [TimerStream] : This stream is useful when we
  //? want to emits an item after a some specific amount of time.

  TimerStream(1, Duration(seconds: 5)).listen((i) => print(i));

  /// prints : 1 (after 5 seconds)
}

void usingStream() {
  //? [UsingStream] : This stream is used to create
  //? a way so we can instruct an stream to create a
  //? resource for us that exists only during the lifetime
  //? of the stream and is disposed when the stream terminates.

  UsingStream<int, Queue<int>>(
    () => Queue.of([1, 2, 3, 4, 5]),
    (r) => Stream.fromIterable(r),
    (r) => r.clear(),
  ).listen(print);

  /// prints : 1, 2, 3, 4, 5
}

void zipStream() {
  //? [ZipStream] : This stream is used to merge all
  //? the specified streams into a one single stream sequence
  //? using the zipper function whenever all of the stream
  //? sequences have produced an element at a corresponding index.

  ZipStream(
    [
      Stream.fromIterable([1, 2]),
      Stream.fromIterable([3, 4]),
      Stream.fromIterable([5, 6]),
    ],
    (values) => values.join(),
  ).listen(print);

  /// prints : 135, 246
}
