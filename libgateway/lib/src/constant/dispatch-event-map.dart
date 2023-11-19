import './dispatch-event.dart';

import '../type/event/ready.dart';
import '../type/event/message-create.dart';

class _DispatchEvent<T> {
  final Function
      fromMap; // TODO: tear-off constructor type broken T Function(Map<String, dynamic> object)
  final DispatchEvent name;

  const _DispatchEvent(this.fromMap, this.name);
}

_DispatchEvent<T> getDispatchEvent<T>() {
  switch (T) {
    case ReadyEvent:
      return _DispatchEvent<T>(ReadyEvent.fromMap, ReadyEvent.name);
    case MessageCreateEvent:
      return _DispatchEvent<T>(
          MessageCreateEvent.fromMap, MessageCreateEvent.name);
    default:
      throw '[getDispatchEvent] unmapped event';
  }
}
