import '../operation.dart';
import '../constant/opcode.dart';

class IdentifyOperation extends Operation {
  final String token;
  final int intents;

  const IdentifyOperation({ required this.token, required this.intents }) : super(Opcode.Identify);

  @override
  Map<String, dynamic> data() => {
        'token': token,
        'properties': {'os': 'linux', 'browser': 'disco', 'device': 'disco'},
        'intents': intents,
        'shard': [0, 1],
        'compress': false,
        'large_threshold': 250
      };
}