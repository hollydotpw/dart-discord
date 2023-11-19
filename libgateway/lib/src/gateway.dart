import 'dart:async';
import 'dart:io';
import 'dart:convert';

import './constant/gateway-endpoint.dart';
import './type/presence-update.dart';
import './constant/dispatch-event.dart';
import './constant/opcode.dart';
import './operation.dart';
import './operation/heartbeat.dart';
import './operation/identify.dart';
import './operation/presence-update.dart';
import './operation/resume.dart';

import './constant/dispatch-event-map.dart';

class GatewayConfig {
  final String token;
  final int intents;
  final bool debug;

  // 1536 = Intent.GuildMessages | Intent.GuildMessageReactions
  const GatewayConfig(
      {required this.token, this.intents = 1536, this.debug = false});
}

StreamTransformer<Map<String, dynamic>, T> _getTransformer<T>(Function fromMap) =>
    StreamTransformer<Map<String, dynamic>, T>.fromHandlers(
        handleData: (Map<String, dynamic> data, EventSink<T> sink) =>
            sink.add(fromMap(data)));

class Gateway {
  final GatewayConfig _config;
  WebSocket? _ws;
  Timer? _heartbeatTimer;
  String? _sessionId;
  int? _seq;
  StreamSubscription<dynamic>? _listenStreamSubscription;
  bool _ready = false;

  Map<DispatchEvent, StreamController<Map<String, dynamic>>> _streams = {};

  Gateway(this._config);

  Stream<T> on<T>() {
    final d = getDispatchEvent<T>();

    if (_streams.containsKey(d.name)) {
      return _getTransformer<T>(d.fromMap).bind(_streams[d.name]!.stream);
    }

    final streamController = StreamController<Map<String, dynamic>>.broadcast();
    _streams[d.name] = streamController;

    return _getTransformer<T>(d.fromMap).bind(streamController.stream);
  }

  void _send(Operation operation) => _sendMessage(operation.toMap());

  void updatePresence(PresenceUpdate presenceUpdate) {
    if (!_ready) {
      // TODO: create exceptions
      throw '[updatePresence] not ready';
    }

    _send(PresenceUpdateOperation(presenceUpdate));
  }

  void _handleDispatchEvent(
      DispatchEvent dispatchEvent, Map<String, dynamic> data) {
    switch (dispatchEvent) {
      case DispatchEvent.Ready:
        _ready = true;
        break;
      default:
        _print('[_handleDispatchEvent]: Unhadled event: $dispatchEvent $data');
    }

    _streams[dispatchEvent]?.sink.add(data);
  }

  void _print(Object object) {
    if (_config.debug) {
      print(object);
    }
  }

  void _handleOperations(Map<String, dynamic> data) {
    // _print('> $data');
    if (data.containsKey('s')) {
      _seq = data['s'];
    }

    switch (Opcode.map[data['op']]) {
      case Opcode.Hello:
        _send(
            IdentifyOperation(token: _config.token, intents: _config.intents));
        _send(HeartbeatOperation(_seq));
        _heartbeatTimer = Timer.periodic(
            Duration(milliseconds: data['d']['heartbeat_interval']), (timer) {
          _send(HeartbeatOperation(_seq));
        });
        break;
      case Opcode.InvalidSession:
        _print('[_handleOperations] InvalidSession: u retarted');
        break;
      case Opcode.Dispatch:
        _sessionId = data['d']['session_id'];

        _handleDispatchEvent(DispatchEvent.map[data['t']]!, data['d']);
        break;
      case Opcode.Reconnect:
        _send(ResumeOperation(_config.token, _sessionId!, _seq!));
        break;
      // TODO: check heartbeat ack, resume connection if the gateway does not respond
      case Opcode.HeartbeatAck:
        _print('[_handleOperations] HeartbeatAck: you know');
        break;

      default:
        throw 'shit';
    }
  }

  void _sendMessage(Map<String, dynamic> data) {
    // _print('< $data');
    return _ws!.add(json.encode(data));
  }

  Future<void> connect() async {
    _ws = await WebSocket.connect(GATEWAY_ENDPOINT);

    _listenStreamSubscription = _ws!.listen(
        (event) {
          if (event is! String) {
            _print('[connect] Invalid raw data received');
            return;
          }

          final message = json.decode(event);
          _handleOperations(message);
        },
        cancelOnError: true,
        onError: (e) {
          _print('[connect] onError');
        },
        onDone: () {
          _print('[connect] onDone');
        });
  }

  Future<void> close() async {
    _heartbeatTimer?.cancel();
    _listenStreamSubscription?.cancel();

    await _ws!.close();
    await _ws!.drain();
  }
}
