import './constant/opcode.dart';

abstract class Operation {
  final Opcode code;

  const Operation(this.code);

  dynamic data();

  Map<String, dynamic> toMap() => {
        'op': this.code.value,
        'd': data(),
      };
}
