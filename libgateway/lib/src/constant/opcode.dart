// i think that is better to declare an enum and a map

enum Opcode {
  Dispatch(0),
  Heartbeat(1),
  Identify(2),
  PresenceUpdate(3),
  Resume(6),
  Reconnect(7),
  InvalidSession(9),
  Hello(10),
  HeartbeatAck(11);

  const Opcode(this.value);
  final int value;

  static Map<int, Opcode> get map => Opcode.values
      .asMap()
      .map((key, value) => MapEntry(value.value, value));
}