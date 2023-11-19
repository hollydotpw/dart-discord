import 'dart:io' show Platform;

import 'package:libgateway/libgateway.dart';
import 'package:libdiscord/libdiscord.dart';

String discordToken = Platform.environment['DISCORD_TOKEN']!;

void main() async {
  final gateway = Gateway(GatewayConfig(token: discordToken));
  final discord = Discord(discordToken);

  gateway.on<ReadyEvent>().listen((event) {
    print('🚀 Ready');

    // Update bot presence
    gateway.updatePresence(PresenceUpdate(
        status: PresenceStatus.Online, activity: '🛠️ Working hard'));
  });

  // Listen to all published messages
  gateway.on<MessageCreateEvent>().listen((messageEvent) async {
    final message =
        await discord.fetchMessage(messageEvent.channelId, messageEvent.id);

    print('${message['author']['username']}: ${message['content']}');
  });

  await gateway.connect();
}
