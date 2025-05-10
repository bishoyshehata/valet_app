import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:valet_app/valete/data/datasource/socket/socket_event.dart';

import '../../models/socket/user_socket_model.dart';

class SocketManager {
  static final SocketManager _instance = SocketManager._internal();
  factory SocketManager() => _instance;
  static SocketManager get to => _instance;
  SocketManager._internal();

  IO.Socket? socket;
  final List<Map<String, dynamic>> streamStudentsList = [];
  bool isConnected = false;

  static String get _baseUrl => 'https://node-iti.vps.kirellos.com';

  Future<void> initSocket(UserSocketModel model) async {
    print('🔥 sessionId: ${model.sessionId}');
    print('🧾 sending query: ${{
      'userId': model.id,
      'name': model.name,
      'role': model.type.toLowerCase(),
      'session_id': model.sessionId,
    }}');

    socket = IO.io(
      _baseUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .setQuery({
        'userId': model.id,
        'name': model.name,
        'role': model.type.toLowerCase(),
        'session_id': model.sessionId,
      })
          .build(),
    );

    print('🔥 Preparing to init socket with sessionId: ${model.sessionId}');

    socket!.onConnect((_) {
      isConnected = true;
      _registerEvents(model);

      if (model.type == 'Instructor') {
        createChannel(model.sessionId, model.id);
      }

      print("✅ Connected as ${model.type} (${model.name})");
    });

    socket!.onConnectError((error) => print("❌ Connection error: $error"));
    socket!.onReconnectError((error) => print("❌ Reconnection error: $error"));
    socket!.onDisconnect((_) {
      print("🔌 Disconnected from server");
      isConnected = false;
    });
  }

  void _registerEvents(UserSocketModel model) {
    socket?.on(SocketEvents.channelCreated, (data) {
      print("📢 Channel created: $data");
    });

    socket?.on(SocketEvents.studentJoined, (data) {
      print("👥 Student joined: ${data['studentId']}");
      streamStudentsList.add({
        'studentId': data['studentId'],
        'studentName': data['studentName'],
      });
    });

    socket?.on(SocketEvents.studentsListUpdated, (data) {
      streamStudentsList
        ..clear()
        ..addAll(List<Map<String, dynamic>>.from(data));
      print("📄 Updated students list received: $streamStudentsList");
    });
  }

  Future<void> disposeSocket() async {
    print('🧨 Disposing socket...');
    if (socket != null) {
      socket!.disconnect();
      socket!.clearListeners();
      socket!.destroy(); // optional based on your lib version
      socket = null;
    }
  }

  void createChannel(int sessionId, int instructorId) {
    if (isConnected) {
      socket!.emit(SocketEvents.createChannel, {
        'sessionId': sessionId,
        'instructorId': instructorId,
      });
    }
  }

  void joinChannel(int sessionId) {
    if (isConnected) {
      final channelId = 'channel_$sessionId';
      socket!.emit(SocketEvents.joinChannel, {'channelId': channelId});
      print("🟢 Student joined channel: $channelId");
    } else {
      print("❌ Cannot join channel. Socket not connected.");
    }
  }

  void emit(String event, Map<String, dynamic> data) {
    if (socket != null && socket!.connected) {
      socket!.emit(event, data);
    } else {
      print("❌ Socket not connected. Cannot emit $event.");
    }
  }

  Future<void> reconnectSocket(UserSocketModel model) async {
    await disposeSocket();
    await Future.delayed(Duration(milliseconds: 500));
    await initSocket(model);
    await ChannelManager.to.createChannel(model.sessionId, model.id);
  }
}

class ChannelManager {
  static final ChannelManager _instance = ChannelManager._internal();
  factory ChannelManager() => _instance;
  static ChannelManager get to => _instance;
  ChannelManager._internal();

  final List<Map<String, dynamic>> streamStudentsList = [];

  Future<void> createChannel(int sessionId, int instructorId) async {
    if (SocketManager.to.isConnected) {
      SocketManager.to.socket!.emit(SocketEvents.createChannel, {
        'sessionId': sessionId,
        'instructorId': instructorId,
      });
    }
  }

  void joinChannel(int sessionId) {
    if (SocketManager.to.isConnected) {
      final channelId = 'channel_$sessionId';
      SocketManager.to.socket!.emit(SocketEvents.joinChannel, {'channelId': channelId});
      print("🟢 Student joined channel: $channelId");
    } else {
      print("❌ Cannot join channel. Socket not connected.");
    }
  }

  void registerChannelEvents(UserSocketModel model) {
    print("🔌 Registered channel events for sessionId=${model.sessionId}");

    SocketManager.to.socket?.on(SocketEvents.channelCreated, (data) {
      print("📢 Channel created: $data");
    });

    SocketManager.to.socket?.on(SocketEvents.studentJoined, (data) {
      print("👥 Student joined: ${data['studentId']}");
      streamStudentsList.add({
        'studentId': data['studentId'],
        'studentName': data['studentName'],
      });
    });

    SocketManager.to.socket?.on(SocketEvents.studentsListUpdated, (data) {
      streamStudentsList
        ..clear()
        ..addAll(List<Map<String, dynamic>>.from(data));
      print("📄 Updated students list received");
    });
  }
}
