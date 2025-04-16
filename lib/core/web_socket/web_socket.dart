import 'dart:async';
import 'dart:collection';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class WebSocketService {
  static final WebSocketService _instance = WebSocketService._internal();
  late IO.Socket socket;
  late Dio dio;
  final _messageController = StreamController<Map<String, dynamic>>.broadcast();
  final Queue<Map<String, dynamic>> _messageQueue =
      Queue<Map<String, dynamic>>();
  bool _isProcessing = false;

  ValueNotifier<bool> isConnected = ValueNotifier(false);

  Stream<Map<String, dynamic>> get messageStream => _messageController.stream;

  factory WebSocketService() {
    return _instance;
  }

  WebSocketService._internal() {
    dio = Dio();

    socket = IO.io('http://192.168.43.183:5500/', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.on('roomMessagess', (data) async {
      log('Message from server: $data');
      // _messageQueue.add(data);
      // _processQueue();
      _handleRoomMessages(data);
    });
  }

  void connect() {
    socket.connect();
    socket.on('connect', (_) {
      log('Connected to server');
      isConnected.value = true;
    });

    socket.on('disconnect', (_) {
      log('Disconnected from server');
      isConnected.value = false;
    });
  }

  void disconnect() {
    socket.disconnect();
    socket.on('disconnect', (_) {
      log('Disconnected from server');
      isConnected.value = false;
    });
  }

  void sendMessage(Map<String, dynamic> message) {
    try {
      log(message.toString());
      socket.emit('messageToRoom', message);
    } catch (e) {
      log('Error sending message: $e');
    }
  }

  void joinRooms(dynamic message) {
    log(message.toString());
    socket.emit('joinMobileRooms', message.toString());
    log('joinMobileRooms: $message');
  }

  void leaveRooms(dynamic message) {
    socket.emit('leaveMobileRooms', message.toString());
    log('leaveMobileRooms: $message');
  }

  Future<void> _processQueue() async {
    if (_isProcessing || _messageQueue.isEmpty) return;
    _isProcessing = true;

    while (_messageQueue.isNotEmpty) {
      final data = _messageQueue.removeFirst();
      await _handleRoomMessages(data);
    }

    _isProcessing = false;
  }

  Future<void> _handleRoomMessages(Map<String, dynamic> data) async {
    try {
      final msg = data['msg'];
      final userData = data['data'];

      if (msg == null || userData == null) {
        log('Invalid data received');
        return;
      }

      final value = msg['value'].toString(); // Ensure value is a string
      final number = value.split(' ')[0];
      final isNumber = double.tryParse(number) != null;
      final startsWithNumber = RegExp(r'^[0-9]').hasMatch(value);

      if ((isNumber && startsWithNumber) || value == 'on' || value == 'off') {
        try {
          final response = await dio.get(
            'http://192.168.43.183:5500/api/v1/rule/projectRules',
            queryParameters: {
              'user': userData['user'],
              'projectName': userData['projectName'],
            },
          );

          final rules = response.data['data'];
          if (rules.isEmpty) {
            log('No rules found');
          } else {
            for (final rule in rules) {
              if (rule['triggerModuleId'] == msg['roomId']) {
                bool conditionMet = false;

                if (value == 'on' || value == 'off') {
                  if (rule['conditionValue'] == 'on' ||
                      rule['conditionValue'] == 'off') {
                    conditionMet = value == rule['conditionValue'];
                  }
                } else {
                  final messageValue = double.tryParse(value.split(' ')[0]);
                  final ruleConditionValue =
                      double.tryParse(rule['conditionValue']);

                  if (messageValue != null && ruleConditionValue != null) {
                    switch (rule['condition']) {
                      case '<':
                        conditionMet = messageValue < ruleConditionValue;
                        break;
                      case '<=':
                        conditionMet = messageValue <= ruleConditionValue;
                        break;
                      case '>':
                        conditionMet = messageValue > ruleConditionValue;
                        break;
                      case '>=':
                        conditionMet = messageValue >= ruleConditionValue;
                        break;
                      case '==':
                        conditionMet = messageValue == ruleConditionValue;
                        break;
                      case '!=':
                        conditionMet = messageValue != ruleConditionValue;
                        break;
                    }
                  }
                }

                if (conditionMet) {
                  log(
                    'Condition met for rule: ${rule['_id']}, emitting to room: ${rule['actionModuleId']} with value ${rule['action']['value']}',
                  );

                  final actionData = {
                    'msg': {
                      'source': 'MobileApp',
                      'roomId': rule['actionModuleId'],
                      'value': rule['action']['value'],
                      'status': true,
                    },
                    'data': userData,
                  };

                  log(actionData.toString());

                  socket.emit('messageToRoom', actionData);
                } else {
                  log('Condition not met');
                }
              }
            }
          }
        } catch (e) {
          log('Error fetching rules: $e');
        }
      } else {
        log('Value is not a number or does not start with a number');
      }
    } catch (e) {
      log('Error handling room messages: $e');
    }

    _messageController.add(data);
  }

  void updateValues(Map<String, dynamic> message) {
    log(message.toString());
    socket.emit('updateValues', message);
    log('updating values: $message');
  }

  void dispose() {
    socket.dispose();
    _messageController.close();
  }
}
