import 'package:socket_io_client/socket_io_client.dart' as IO;

void initSocket(String saiesId) {
  IO.Socket socket = IO.io('http://<node-server-ip>:3000', <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': false,
  });

  socket.connect();

  socket.onConnect((_) {
    print('Connected to Node.js');
    socket.emit('register', saiesId);
  });

  socket.on('receive-phone', (phone) {
    print('Received phone number: $phone');
    socket.disconnect(); // يقفل بعد الاستلام
  });

  socket.onDisconnect((_) => print('Disconnected'));
}