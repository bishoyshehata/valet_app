import 'package:socket_io_client/socket_io_client.dart' as IO;

IO.Socket socket = IO.io(
  'https://valet.node.vps.kirellos.com',
  <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': false,
    'secure': true,
    'reconnection': false,
  },
);
class SocketService {
  void initSocket({
    required String saiesId,
    required Function(String phoneNumber) onPhoneReceived,
  }) {


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
  void closeSocket() {
    if (socket.connected) {
      socket.disconnect();
      socket.dispose(); // لو مدعومة في مكتبتك
      print('Socket disconnected');
    } else {
      print('Socket already disconnected');
    }
  }

}
