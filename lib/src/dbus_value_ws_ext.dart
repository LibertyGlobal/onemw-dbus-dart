import 'dbus_value.dart';

extension DBusValueToJson on DBusValue {
  dynamic toJson() {
    if (this is DBusStruct) {
      return DBusStructToJson(this as DBusStruct).toJson();
    } else if (this is DBusArray) {
      return DBusArrayToJson(this as DBusArray).toJson();
    } else if (this is DBusDict) {
      return DBusDictToJson(this as DBusDict).toJson();
    }
    return toNative();
  }
}

extension DBusStructToJson on DBusStruct {
  dynamic toJson() {
    return children.map((value) => value.toJson()).toList();
  }
}

extension DBusArrayToJson on DBusArray {
  dynamic toJson() {
    return children.map((value) => value.toJson()).toList();
  }
}

// extension DBusByteToJson on DBusByte  {
//   dynamic toJson() => toNative();
// }
//
//
// extension DBusBooleanToJson on DBusBoolean {
//   dynamic toJson() => toNative();
// }
//
//
// extension DBusInt16ToJson on DBusInt16 {
//   dynamic toJson() => toNative();
// }
//
//
// extension DBusUint16ToJson on DBusUint16 {
//   dynamic toJson() => toNative();
// }
//
//
// extension DBusInt32ToJson on DBusInt32 {
//   dynamic toJson() => toNative();
// }
//
//
// extension DBusUint32ToJson on DBusUint32 {
//   dynamic toJson() => toNative();
// }
//
//
// extension DBusInt64ToJson on DBusInt64 {
//   dynamic toJson() => toNative();
// }
//
//
// extension DBusUint64ToJson on DBusUint64 {
//   dynamic toJson() => toNative();
// }
//
//
// extension DBusDoubleToJson on DBusDouble {
//   dynamic toJson() => toNative();
// }
//
//
// extension DBusStringToJson on DBusString {
//   dynamic toJson() => toNative();
// }
//
//
// extension DBusObjectToJson on DBusObjectPath {
//   dynamic toJson() => toNative();
// }
//
//
// extension DBusSignatureToJson on DBusSignature {
//   dynamic toJson() => toNative();
// }
//
//
// extension DBusVariantToJson on DBusVariant {
//   dynamic toJson() => toNative();
// }
//
//
// extension DBusMaybeToJson on DBusMaybe {
//   dynamic toJson() => toNative();
// }
//
extension DBusDictToJson on DBusDict {
  /*
    this will be consumed by dbus-native package on the other side;
    the expected encoding of DbusDict should be like:
    [["key":"value"],["key2":"value2"],...]
  */
  dynamic toJson() {
    return children.entries
        .map((entry) =>
            [entry.key.toJson(),entry.value.toJson()])
        .toList();
  }
}
//
