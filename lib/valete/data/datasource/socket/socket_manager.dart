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
    Function(String error)? onError,  // اضفت callback اختياري للتعامل مع الخطأ
  }) {
    socket.connect();

    socket.onConnect((_) {
      print('✅ Connected');
      socket.emit('register', saiesId);
    });

    socket.on('receive-phone', (phone) {
      print('📞 Received phone number: $phone');
      onPhoneReceived(phone); // use callback
      closeSocket();
    });

    socket.onDisconnect((_) => print('❌ Disconnected'));

    socket.onError((error) {
      print('🔥 Error: $error');
      if (onError != null) {
        onError(error.toString());
      }
    });
  }

  void closeSocket() {
    if (socket.connected) {
      socket.disconnect();
      socket.dispose();
    } else {
      print('Socket already disconnected');
    }
  }
}
