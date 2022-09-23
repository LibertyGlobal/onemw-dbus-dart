import 'dart:async';

import 'dbus_client.dart';
import 'dbus_introspect.dart';
import 'dbus_method_response.dart';
import 'dbus_signal.dart';
import 'dbus_value.dart';

class ProxyStream<T> implements Stream<T> {
  final DBusRemoteObjectSignalStream _originalStream;
  final Stream<T> _mappedStream;

  ProxyStream({required DBusRemoteObjectSignalStream stream, required T Function(DBusSignal) mapFunction}):
  _originalStream = stream,
  _mappedStream = stream.asBroadcastStream().map(mapFunction);

  Future<void> listenSync() async {
    return _originalStream.listenSync();
  }

  @override
  Future<bool> any(bool Function(T element) test) {
    return _mappedStream.any(test);
  }

  @override
  Stream<T> asBroadcastStream({void Function(StreamSubscription<T> subscription)? onListen, void Function(StreamSubscription<T> subscription)? onCancel}) {
    return _mappedStream.asBroadcastStream(onListen: onListen, onCancel: onCancel);
  }

  @override
  Stream<E> asyncExpand<E>(Stream<E>? Function(T event) convert) {
    return _mappedStream.asyncExpand<E>(convert);
  }

  @override
  Stream<E> asyncMap<E>(FutureOr<E> Function(T event) convert) {
    return _mappedStream.asyncMap<E>(convert);
  }

  @override
  Stream<R> cast<R>() {
    return _mappedStream.cast<R>();
  }

  @override
  Future<bool> contains(Object? needle) {
    return _mappedStream.contains(needle);
  }

  @override
  Stream<T> distinct([bool Function(T previous, T next)? equals]) {
    return _mappedStream.distinct(equals);
  }

  @override
  Future<E> drain<E>([E? futureValue]) {
    return _mappedStream.drain(futureValue);
  }

  @override
  Future<T> elementAt(int index) {
    return _mappedStream.elementAt(index);
  }

  @override
  Future<bool> every(bool Function(T element) test) {
    return _mappedStream.every(test);
  }

  @override
  Stream<S> expand<S>(Iterable<S> Function(T element) convert) {
    return _mappedStream.expand(convert);
  }

  @override
  Future<T> get first => _mappedStream.first;

  @override
  Future<T> firstWhere(bool Function(T element) test, {T Function()? orElse}) {
    return _mappedStream.firstWhere(test, orElse: orElse);
  }

  @override
  Future<S> fold<S>(S initialValue, S Function(S previous, T element) combine) {
    return _mappedStream.fold(initialValue, combine);
  }

  @override
  Future forEach(void Function(T element) action) {
    return _mappedStream.forEach(action);
  }

  @override
  Stream<T> handleError(Function onError, {bool Function(dynamic error)? test}) {
    return _mappedStream.handleError(handleError, test: test);
  }

  @override
  bool get isBroadcast => _mappedStream.isBroadcast;

  @override
  Future<bool> get isEmpty => _mappedStream.isEmpty;

  @override
  Future<String> join([String separator = '']) {
    return _mappedStream.join(separator);
  }

  @override
  Future<T> get last => _mappedStream.last;

  @override
  Future<T> lastWhere(bool Function(T element) test, {T Function()? orElse}) {
    return _mappedStream.lastWhere(test, orElse: orElse);
  }

  @override
  Future<int> get length => _mappedStream.length;

  @override
  StreamSubscription<T> listen(void Function(T event)? onData, {Function? onError, void Function()? onDone, bool? cancelOnError}) {
    return _mappedStream.listen(onData, onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }

  @override
  Stream<S> map<S>(S Function(T event) convert) {
    return _mappedStream.map(convert);
  }

  @override
  Future pipe(StreamConsumer<T> streamConsumer) {
    return _mappedStream.pipe(streamConsumer);
  }

  @override
  Future<T> reduce(T Function(T previous, T element) combine) {
    return _mappedStream.reduce(combine);
  }

  @override
  Future<T> get single => _mappedStream.single;

  @override
  Future<T> singleWhere(bool Function(T element) test, {T Function()? orElse}) {
    return _mappedStream.singleWhere(test, orElse: orElse);
  }

  @override
  Stream<T> skip(int count) {
    return _mappedStream.skip(count);
  }

  @override
  Stream<T> skipWhile(bool Function(T element) test) {
    return _mappedStream.skipWhile(test);
  }

  @override
  Stream<T> take(int count) {
    return _mappedStream.take(count);
  }

  @override
  Stream<T> takeWhile(bool Function(T element) test) {
    return _mappedStream.takeWhile(test);
  }

  @override
  Stream<T> timeout(Duration timeLimit, {void Function(EventSink<T> sink)? onTimeout}) {
    return _mappedStream.timeout(timeLimit, onTimeout: onTimeout);
  }

  @override
  Future<List<T>> toList() {
    return _mappedStream.toList();
  }

  @override
  Future<Set<T>> toSet() {
    return _mappedStream.toSet();
  }

  @override
  Stream<S> transform<S>(StreamTransformer<T, S> streamTransformer) {
    return _mappedStream.transform(streamTransformer);
  }

  @override
  Stream<T> where(bool Function(T event) test) {
    return _mappedStream.where(test);
  }
}

/// A stream of signals from a remote object.
class DBusRemoteObjectSignalStream extends DBusSignalStream {
  /// Creates a stream of signals [interface].[name] from [object].
  ///
  /// If [signature] is provided this causes the stream to throw a
  /// [DBusSignalSignatureException] if a signal is received that does not
  /// match the provided signature.
  DBusRemoteObjectSignalStream(
      {required DBusRemoteObject object,
      required String interface,
      required String name,
      DBusSignature? signature,
      bool ignoreSender = false})
      : super(object.client,
            sender: ignoreSender ? null : object.name,
            path: object.path,
            interface: interface,
            name: name,
            signature: signature);
}

/// Signal received when properties are changed.
class DBusPropertiesChangedSignal extends DBusSignal {
  /// The interface the properties are on.
  String get propertiesInterface => (values[0] as DBusString).value;

  /// Properties that have changed and their new values.
  Map<String, DBusValue> get changedProperties =>
      (values[1] as DBusDict).mapStringVariant();

  /// Properties that have changed but require their values to be requested.
  List<String> get invalidatedProperties =>
      (values[2] as DBusArray).mapString().toList();

  DBusPropertiesChangedSignal(DBusSignal signal)
      : super(
            sender: signal.sender,
            path: signal.path,
            interface: signal.interface,
            name: signal.name,
            values: signal.values);
}

/// Exception thrown when a D-Bus property returns a value that don't match the expected signature.
class DBusPropertySignatureException implements Exception {
  /// The name of the property.
  final String propertyName;

  /// The value that was returned.
  final DBusValue value;

  DBusPropertySignatureException(this.propertyName, this.value);

  @override
  String toString() {
    return '$propertyName returned invalid value: $value';
  }
}

/// An object to simplify access to a D-Bus object.
class DBusRemoteObject {
  /// The client this object is accessed from.
  final DBusClient client;

  /// The name of the client providing this object.
  final String name;

  /// The path to the object.
  final DBusObjectPath path;

  /// Stream of signals when the remote object indicates a property has changed.
  late final Stream<DBusPropertiesChangedSignal> propertiesChanged;

  /// Creates an object that access accesses a remote D-Bus object using bus [name] with [path].
  DBusRemoteObject(this.client, {required this.name, required this.path}) {
    var rawPropertiesChanged = DBusRemoteObjectSignalStream(
        object: this,
        interface: 'org.freedesktop.DBus.Properties',
        name: 'PropertiesChanged');
    propertiesChanged = rawPropertiesChanged.map((signal) {
      if (signal.signature == DBusSignature('sa{sv}as')) {
        return DBusPropertiesChangedSignal(signal);
      } else {
        throw 'org.freedesktop.DBus.Properties.PropertiesChanged contains invalid values ${signal.values}';
      }
    });
  }

  /// Gets the introspection data for this object.
  ///
  /// Throws [DBusServiceUnknownException] if there is the requested service is not available.
  /// Throws [DBusUnknownObjectException] if this object is not available.
  /// Throws [DBusUnknownInterfaceException] if introspection is not supported by this object.
  Future<DBusIntrospectNode> introspect() async {
    var result = await client.callMethod(
        destination: name,
        path: path,
        interface: 'org.freedesktop.DBus.Introspectable',
        name: 'Introspect',
        replySignature: DBusSignature('s'));
    var xml = (result.returnValues[0] as DBusString).value;
    return parseDBusIntrospectXml(xml);
  }

  /// Gets a property on this object.
  ///
  /// If [signature] is provided this causes this method to throw a
  /// [DBusPropertySignatureException] if a property is returned that does not
  /// match the provided signature.
  ///
  /// Throws [DBusServiceUnknownException] if there is the requested service is not available.
  /// Throws [DBusUnknownObjectException] if this object is not available.
  /// Throws [DBusUnknownInterfaceException] if properties are not supported by this object.
  /// Throws [DBusUnknownPropertyException] if the property doesn't exist.
  /// Throws [DBusPropertyWriteOnlyException] if the property can't be read.
  Future<DBusValue> getProperty(String interface, String name,
      {DBusSignature? signature}) async {
    var result = await client.callMethod(
        destination: this.name,
        path: path,
        interface: 'org.freedesktop.DBus.Properties',
        name: 'Get',
        values: [DBusString(interface), DBusString(name)],
        replySignature: DBusSignature('v'));
    var value = (result.returnValues[0] as DBusVariant).value;
    if (signature != null && value.signature != signature) {
      throw DBusPropertySignatureException('$interface.$name', value);
    }
    return value;
  }

  /// Gets the values of all the properties on this object.
  ///
  /// Throws [DBusServiceUnknownException] if there is the requested service is not available.
  /// Throws [DBusUnknownObjectException] if this object is not available.
  /// Throws [DBusUnknownInterfaceException] if properties are not supported by this object.
  Future<Map<String, DBusValue>> getAllProperties(String interface) async {
    var result = await client.callMethod(
        destination: name,
        path: path,
        interface: 'org.freedesktop.DBus.Properties',
        name: 'GetAll',
        values: [DBusString(interface)],
        replySignature: DBusSignature('a{sv}'));
    return (result.returnValues[0] as DBusDict).mapStringVariant();
  }

  /// Sets a property on this object.
  ///
  /// Throws [DBusServiceUnknownException] if there is the requested service is not available.
  /// Throws [DBusUnknownObjectException] if this object is not available.
  /// Throws [DBusUnknownInterfaceException] if properties are not supported by this object.
  /// Throws [DBusUnknownPropertyException] if the property doesn't exist.
  /// Throws [DBusPropertyReadOnlyException] if the property can't be written.
  Future<void> setProperty(
      String interface, String name, DBusValue value) async {
    await client.callMethod(
        destination: this.name,
        path: path,
        interface: 'org.freedesktop.DBus.Properties',
        name: 'Set',
        values: [DBusString(interface), DBusString(name), DBusVariant(value)],
        replySignature: DBusSignature(''));
  }

  /// Invokes a method on this object.
  /// Throws [DBusMethodResponseException] if the remote side returns an error.
  ///
  /// If [replySignature] is provided this causes this method to throw a
  /// [DBusReplySignatureException] if the result is successful but the returned
  /// values do not match the provided signature.
  ///
  /// Throws [DBusServiceUnknownException] if there is the requested service is not available.
  /// Throws [DBusUnknownObjectException] if this object is not available.
  /// Throws [DBusUnknownInterfaceException] if [interface] is not provided by this object.
  /// Throws [DBusUnknownMethodException] if the method with [name] is not available.
  /// Throws [DBusInvalidArgsException] if [args] aren't correct.
  Future<DBusMethodSuccessResponse> callMethod(
      String? interface, String name, Iterable<DBusValue> values,
      {DBusSignature? replySignature,
      bool noReplyExpected = false,
      bool noAutoStart = false,
      bool allowInteractiveAuthorization = false}) async {
    return client.callMethod(
        destination: this.name,
        path: path,
        interface: interface,
        name: name,
        values: values,
        replySignature: replySignature,
        noReplyExpected: noReplyExpected,
        noAutoStart: noAutoStart,
        allowInteractiveAuthorization: allowInteractiveAuthorization);
  }

  @override
  String toString() {
    return "DBusRemoteObject(name: '$name', path: '${path.value}')";
  }
}
