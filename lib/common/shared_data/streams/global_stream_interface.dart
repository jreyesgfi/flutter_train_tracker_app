/// A generic interface for a shared stream.
abstract class SharedStream<T> {
  void update(T value);
  Stream<T> get stream;
}