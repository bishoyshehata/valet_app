import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../../presentation/controllers/orders/order_bloc.dart';
import '../../../presentation/controllers/orders/order_events.dart';

class SocketService {
  void initSocket({
    required String saiesId,
    required Function(String phoneNumber) onPhoneReceived,
  }) {
    IO.Socket socket = IO.io(
      'https://valet.node.vps.kirellos.com',
      <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
        'secure': true,
        'reconnection': false,
      },
    );

    socket.connect();

    socket.onConnect((_) {
      print('✅ Connected');
      socket.emit('register', saiesId);
    });

    socket.on('receive-phone', (phone) {
      print('📞 Received phone number: $phone');
      onPhoneReceived(phone); // use callback
      socket.disconnect();
    });

    socket.onDisconnect((_) => print('❌ Disconnected'));
    socket.onError((error) => print('🔥 Error: $error'));
  }
}
