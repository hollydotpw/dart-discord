enum PresenceStatus {
	Idle('idle'),
	Online('online'),
	Offline('offline'),
	Dnd('dnd');

  const PresenceStatus(this._value);
  final String _value;
  
  @override
  String toString() => _value;

  static Map<String, PresenceStatus> get map => PresenceStatus.values
      .asMap()
      .map((key, value) => MapEntry(value.toString(), value));
}
