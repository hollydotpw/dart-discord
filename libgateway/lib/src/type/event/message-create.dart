import '../../constant/dispatch-event.dart';

class _Member {
  final List<int> roles;
  final DateTime? premiumSince;
  final bool pending;
  final String? nick;
  final bool mute;
  final DateTime? joinedAt;
  final int flags;
  final bool deaf;
  final DateTime? communicationDisabledUntil;
  final String? avatar;

  const _Member(
      {required this.roles,
      this.premiumSince,
      required this.pending,
      this.nick,
      required this.mute,
      this.joinedAt,
      required this.flags,
      required this.deaf,
      this.communicationDisabledUntil,
      this.avatar});
}

class _Mention {
  const _Mention();
}

class _MessageReference {
  final int messageId;
  final int guildId;
  final int channelId;

  const _MessageReference(
      {required this.messageId,
      required this.guildId,
      required this.channelId});

  factory _MessageReference.fromMap(Map<String, dynamic> object) =>
      _MessageReference(
          messageId: object['message_id'],
          guildId: object['guild_id'],
          channelId: object['channel_id']);
}

class _Author {
  final String username;
  final int publicFlags;
  final int id;
  final int discriminator;
  final Null avatarDecoratiom = null;
  final String? avatar;

  const _Author(
      {required this.username,
      required this.publicFlags,
      required this.id,
      required this.discriminator,
      this.avatar});

  factory _Author.fromMap(Map<String, dynamic> object) => _Author(
      username: object['username'],
      publicFlags: object['public_flags'],
      id: int.parse(object['id']),
      discriminator: int.parse(object['discriminator']),
      avatar: object['avatar']);
}

class MessageCreateEvent {
  static const DispatchEvent name = DispatchEvent.MessageCreate;

  final bool tts;
  final DateTime timestamp;
  final MessageCreateEvent? referencedMessage;
  final bool pinned;
  final int? nonce;
  final _MessageReference? messageReference;
  final int id;
  final int guildId;
  final int channelId;
  final String? content;
  final _Author author;

  const MessageCreateEvent(
      {required this.tts,
      required this.timestamp,
      required this.content,
      this.referencedMessage,
      required this.pinned,
      required this.nonce,
      this.messageReference,
      required this.id,
      required this.guildId,
      required this.channelId,
      required this.author});

  factory MessageCreateEvent.fromMap(Map<String, dynamic> object) => MessageCreateEvent(
        tts: object['tts'],
        content: object['content'],
        timestamp: DateTime.parse(object['timestamp']),
        referencedMessage: object['referenced_message'] == null
            ? null
            : MessageCreateEvent.fromMap(object['referenced_message']),
        pinned: object['pinned'],
        nonce: object['nonce'] == null
            ? null
            :  int.parse(object['nonce']),
        id: int.parse(object['id']),
        guildId: int.parse(object['guild_id']),
        channelId: int.parse(object['channel_id']),
        author: _Author.fromMap(object['author']));
}
