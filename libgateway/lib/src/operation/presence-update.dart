import '../type/presence-update.dart';

import '../operation.dart';
import '../constant/opcode.dart';

class PresenceUpdateOperation extends Operation {
  final PresenceUpdate _presenceUpdate;

  const PresenceUpdateOperation(this._presenceUpdate)
      : super(Opcode.PresenceUpdate);

  @override
  Map<String, dynamic> data() => {
        'since': _presenceUpdate.since,
        'activities': [
          {'name': _presenceUpdate.activity, 'type': 0}
        ],
        'status': _presenceUpdate.toString(),
        'afk': _presenceUpdate.afk
      };
}