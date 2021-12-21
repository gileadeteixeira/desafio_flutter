import 'package:desafio_flutter/services/services.dart';
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
  
  updateValue(dynamic newValue, String storageKey, List<dynamic> arrayMaster, Map<String, dynamic> element){
    setValue(newValue);
    arrayMaster.firstWhere((e) => 
      e["url"] == element["url"]
    )["initial_value"] = value;//atualiza o valor no array pai
    updateLocalStorage(storageKey, arrayMaster);//re-salva o array pai no localStorage
  }
  
}