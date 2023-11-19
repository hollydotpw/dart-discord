import '../operation.dart';
import '../constant/opcode.dart';

class HeartbeatOperation extends Operation {
  final int? _lastSequence;

  const HeartbeatOperation(this._lastSequence) : super(Opcode.Heartbeat);

  @override
  int? data() => _lastSequence;
}
