import '../../constant/dispatch-event.dart';

class _User {
  final bool verified;
  final String username;
  final bool mfaEnabled;
  final int id;
  final int flags;
  final String? email;
  final int discriminator;
  final bool bot;
  final String? avatar;

  const _User(
      {required this.verified,
      required this.username,
      required this.mfaEnabled,
      required this.id,
      required this.flags,
      this.email,
      required this.discriminator,
      required this.bot,
      this.avatar});

  factory _User.fromMap(Map<String, dynamic> object) => _User(
      verified: object['verified'],
      username: object['username'],
      mfaEnabled: object['mfa_enabled'],
      id: int.parse(object['id']),
      flags: object['flags'],
      discriminator: int.parse(object['discriminator']),
      avatar: object['avatar'],
      email: object['email'],
      bot: object['bot']);
}

class _Guild {
  final bool unavailable;
  final int id;

  const _Guild({required this.unavailable, required this.id});

  factory _Guild.fromMap(Map<String, dynamic> object) =>
      _Guild(unavailable: object['unavailable'], id: int.parse(object['id']));
}

class _Application {
  final int id;
  final int flags;

  const _Application({required this.id, required this.flags});

  factory _Application.fromMap(Map<String, dynamic> object) =>
      _Application(id: int.parse(object['id']), flags: object['flags']);
}

class ReadyEvent {
  static const DispatchEvent name = DispatchEvent.Ready;

  final Null userSettings = null;
  final int v;
  final _User user;
  final List<int> shard;
  final String sessionType;
  final String sessionId;
  final String resumeGatewayUrl;
  final List<Null> relationships = const [];
  final List<Null> privateChannels = const [];
  final List<Null> presences = const [];
  final List<_Guild> guilds;
  final List<Null> guildJoinRequests = const [];
  final List<String> geoOrderedRtcRegions;
  final _Application application;
  final List<String> trace;

  const ReadyEvent(
      {required this.v,
      required this.user,
      required this.shard,
      required this.sessionType,
      required this.sessionId,
      required this.resumeGatewayUrl,
      required this.guilds,
      required this.geoOrderedRtcRegions,
      required this.application,
      required this.trace});

  factory ReadyEvent.fromMap(Map<String, dynamic> object) => ReadyEvent(
      v: object['v'],
      user: _User.fromMap(object['user']),
      shard: object['shard'].cast<int>(),
      sessionType: object['session_type'],
      sessionId: object['session_id'],
      resumeGatewayUrl: object['resume_gateway_url'],
      guilds: object['guilds']
          .map<_Guild>((guild) => _Guild.fromMap(guild))
          .toList(),
      geoOrderedRtcRegions: object['geo_ordered_rtc_regions'].cast<String>(),
      application: _Application.fromMap(object['application']),
      trace: object['_trace'].cast<String>());
}
