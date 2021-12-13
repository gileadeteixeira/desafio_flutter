// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'initial_value.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$InitialValue on _InitialValue, Store {
  final _$valueAtom = Atom(name: '_InitialValue.value');

  @override
  dynamic get value {
    _$valueAtom.reportRead();
    return super.value;
  }

  @override
  set value(dynamic value) {
    _$valueAtom.reportWrite(value, super.value, () {
      super.value = value;
    });
  }

  final _$_InitialValueActionController =
      ActionController(name: '_InitialValue');

  @override
  dynamic setValue(dynamic newValue) {
    final _$actionInfo = _$_InitialValueActionController.startAction(
        name: '_InitialValue.setValue');
    try {
      return super.setValue(newValue);
    } finally {
      _$_InitialValueActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
value: ${value}
    ''';
  }
}
