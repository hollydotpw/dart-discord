
import '../constant/presence-status.dart';

class PresenceUpdate {
  final int? since;
  final String? activity;
  final PresenceStatus status;
  final bool? afk;

  const PresenceUpdate({ this.since, this.activity, required this.status, this.afk });
}