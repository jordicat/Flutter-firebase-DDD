import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_firebase_ddd_notes/domain/core/errors.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'failures.dart';

@immutable
abstract class ValueObject<T> {
  const ValueObject();
  Either<ValueFailure<T>, T> get value;

  /// Throws [UnxexpectedValueError] containing the [ValueFailure]
  T getOrCrash() {
    // id = identity -> same as writing (value) => value
    return value.fold((f) => throw UnexpectedValueError(f), id);
  }

  bool isValid() => value.isRight();

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    return o is ValueObject<T> && o.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'Value($value)';
}
