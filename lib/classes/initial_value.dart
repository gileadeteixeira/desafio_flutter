import 'package:mobx/mobx.dart';
part 'initial_value.g.dart';

class InitialValue = _InitialValue with _$InitialValue;

abstract class _InitialValue with Store {
  @observable
  dynamic value;

  _InitialValue({required this.value});

  @action
  setValue(dynamic newValue) {
    value = newValue;
  }
}