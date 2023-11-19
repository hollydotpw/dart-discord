import '../operation.dart';
import '../constant/opcode.dart';

class ResumeOperation extends Operation {
  final String _token;
  final String _sessionId;
  final int _seq;

  const ResumeOperation(this._token, this._sessionId, this._seq)
      : super(Opcode.Resume);

  @override
  Map<String, dynamic> data() =>
      {'token': _token, 'session_id': _sessionId, 'seq': _seq};
}
