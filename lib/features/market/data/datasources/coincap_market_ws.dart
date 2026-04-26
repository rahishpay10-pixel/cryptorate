import 'dart:async';
import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

class CoinCapMarketWs {
  WebSocketChannel? _channel;
  StreamSubscription? _subscription;
  StreamController<Map<String, double>>? _controller;
  Timer? _reconnectTimer;
  int _reconnectAttempt = 0;
  bool _closed = false;

  Stream<Map<String, double>> watchPrices({required List<String> assetIds}) {
    _controller ??= StreamController<Map<String, double>>.broadcast(
      onListen: () => _connect(assetIds),
      onCancel: () {},
    );
    if (_channel == null && !_closed) {
      _connect(assetIds);
    }
    return _controller!.stream;
  }

  Future<void> dispose() async {
    _closed = true;
    _reconnectTimer?.cancel();
    await _subscription?.cancel();
    await _controller?.close();
    await _channel?.sink.close();
    _subscription = null;
    _controller = null;
    _channel = null;
  }

  void _connect(List<String> assetIds) {
    if (_closed) return;
    _reconnectTimer?.cancel();
    _reconnectAttempt = 0;
    _subscription?.cancel();
    _channel?.sink.close();
    _channel = null;

    final assets = assetIds
        .where((e) => e.trim().isNotEmpty)
        .toList(growable: false);
    final uri = Uri.parse(
      'wss://ws.coincap.io/prices?assets=${assets.join(',')}',
    );

    _channel = WebSocketChannel.connect(uri);
    _subscription = _channel!.stream.listen(
      (event) {
        if (_closed) return;
        final update = _parse(event);
        if (update.isNotEmpty) {
          _controller?.add(update);
        }
      },
      onError: (_) => _scheduleReconnect(assetIds),
      onDone: () => _scheduleReconnect(assetIds),
      cancelOnError: true,
    );
  }

  Map<String, double> _parse(dynamic event) {
    try {
      final raw = event is String ? event : utf8.decode(event as List<int>);
      final decoded = jsonDecode(raw);
      if (decoded is! Map) return const {};
      final out = <String, double>{};
      for (final entry in decoded.entries) {
        final key = entry.key?.toString();
        if (key == null || key.isEmpty) continue;
        final val = double.tryParse(entry.value.toString());
        if (val == null) continue;
        out[key] = val;
      }
      return out;
    } catch (_) {
      return const {};
    }
  }

  void _scheduleReconnect(List<String> assetIds) {
    if (_closed) return;
    _subscription?.cancel();
    _subscription = null;
    _channel?.sink.close();
    _channel = null;
    _reconnectTimer?.cancel();
    _reconnectAttempt += 1;
    final delaySeconds = (1 << (_reconnectAttempt - 1)).clamp(1, 10);
    _reconnectTimer = Timer(
      Duration(seconds: delaySeconds),
      () => _connect(assetIds),
    );
  }
}
