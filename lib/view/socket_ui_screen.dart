import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:untitled7/core/web_socket/web_socket.dart';

class SocketUiScreen extends StatelessWidget {
  const SocketUiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SwitchExample(),
          ],
        ),
      ),
    );
  }
}

class SwitchExample extends StatefulWidget {
  const SwitchExample({super.key});

  @override
  State<SwitchExample> createState() => _SwitchExampleState();
}

class _SwitchExampleState extends State<SwitchExample> {
  bool light1 = true;

  final MaterialStateProperty<Icon?> thumbIcon =
      MaterialStateProperty.resolveWith<Icon?>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return const Icon(Icons.check_rounded);
      }
      return const Icon(Icons.close);
    },
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SwitchContainer(
          initialLightState: light1,
          onChanged: (bool value) {
            setState(() {
              light1 = value;
            });
          },
          moduleId: "module1",
          name: "Module 1",
          userName: "User1",
          projectName: "Project1",
        ),
      ],
    );
  }
}

class SwitchContainer extends StatefulWidget {
  final bool initialLightState;
  final ValueChanged<bool> onChanged;
  final String moduleId;
  final String name;
  final String userName;
  final String projectName;

  const SwitchContainer({
    required this.initialLightState,
    required this.onChanged,
    required this.moduleId,
    required this.name,
    required this.userName,
    required this.projectName,
    Key? key,
  }) : super(key: key);

  @override
  _SwitchContainerState createState() => _SwitchContainerState();
}

class _SwitchContainerState extends State<SwitchContainer> {
  late bool light1;
  final WebSocketService webSocketService = WebSocketService();
  late StreamSubscription<Map<String, dynamic>> _subscription;
  bool _isSendingMessage = false;

  @override
  void initState() {
    super.initState();
    light1 = widget.initialLightState;
    webSocketService.connect();

    _subscription = webSocketService.messageStream.listen((data) {
      final msg = data['msg'];
      if (msg['roomId'] == widget.moduleId) {
        setState(() {
          light1 = msg['value'] == 'on';
        });
      }
    });

    // webSocketService.joinRooms(widget.moduleId);
  }

  @override
  void dispose() {
    _subscription.cancel();
    // webSocketService.leaveRooms(widget.moduleId);
    super.dispose();
  }

  void _handleSwitchChange(bool value) {
    if (_isSendingMessage) return;

    setState(() {
      _isSendingMessage = true;
    });

    final message = {
      "msg": {
        "source": "MobileApp",
        "roomId": widget.moduleId,
        "value": value ? "on" : "off",
        "status": true
      },
      "data": {
        "user": widget.userName,
        "projectName": widget.projectName,
      }
    };
    log('Sending message: $message');
    webSocketService.sendMessage(message);
    setState(() {
      light1 = value;
    });
    widget.onChanged(value);

    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _isSendingMessage = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 90),
      child: Container(
        height: 160,
        width: 200,
        padding: EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(bottom: 6),
              child: Text(
                'OFF',
                style: TextStyle(
                  fontSize: 20,
                  color: Color.fromARGB(255, 119, 119, 119),
                ),
              ),
            ),
            Transform.rotate(
              angle: 3.14 / 2,
              child: Switch(
                value: light1,
                onChanged: _handleSwitchChange,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                activeTrackColor: Colors.green,
                inactiveTrackColor: Colors.red,
                activeColor: Colors.white,
                inactiveThumbColor: Colors.white,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                'ON',
                style: TextStyle(
                  fontSize: 20,
                  color: Color.fromARGB(255, 119, 119, 119),
                ),
              ),
            ),
            Text(
              widget.name,
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TextValueContainer extends StatefulWidget {
  final String name;
  final String moduleId;
  final String? initialValue;
  final Function(String, String) onUpdateValue;

  const TextValueContainer({
    required this.name,
    required this.moduleId,
    this.initialValue,
    required this.onUpdateValue,
    Key? key,
  }) : super(key: key);

  @override
  _TextValueContainerState createState() => _TextValueContainerState();
}

class _TextValueContainerState extends State<TextValueContainer> {
  final WebSocketService webSocketService = WebSocketService();
  late StreamSubscription<Map<String, dynamic>> _subscription;
  late String value;

  @override
  void initState() {
    super.initState();
    value = widget.initialValue ?? '...';
    webSocketService.connect();

    _subscription = webSocketService.messageStream.listen((data) {
      if (data['msg']['roomId'] == widget.moduleId) {
        setState(() {
          value = data['msg']['value'];
        });
        widget.onUpdateValue(widget.moduleId, value); // Update the value
      }
    });

    // webSocketService.joinRooms(widget.moduleId);
  }

  @override
  void dispose() {
    _subscription.cancel();
    // webSocketService.leaveRooms(widget.moduleId);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  widget.name,
                  style: TextStyle(fontSize: 18, color: Colors.black),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NumberValueContainer extends StatefulWidget {
  final String name;
  final String moduleId;
  final Function(String, String) onUpdateValue;

  const NumberValueContainer({
    required this.name,
    required this.moduleId,
    required this.onUpdateValue,
    Key? key,
  }) : super(key: key);

  @override
  _NumberValueContainerState createState() => _NumberValueContainerState();
}

class _NumberValueContainerState extends State<NumberValueContainer> {
  final WebSocketService webSocketService = WebSocketService();
  late StreamSubscription<Map<String, dynamic>> _subscription;
  String value = '0';

  @override
  void initState() {
    super.initState();
    webSocketService.connect();

    _subscription = webSocketService.messageStream.listen((data) {
      if (data['msg']['roomId'] == widget.moduleId) {
        setState(() {
          value = data['msg']['value'];
        });
        widget.onUpdateValue(widget.moduleId, value); // Update the value
      }
    });

    // webSocketService.joinRooms(widget.moduleId);
  }

  @override
  void dispose() {
    _subscription.cancel();
    // webSocketService.leaveRooms(widget.moduleId);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Container(
        height: 150,
        width: 200,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 36,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  widget.name,
                  style: TextStyle(fontSize: 18, color: Colors.black),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SliderInput extends StatefulWidget {
  final String projectName;
  final String userName;
  final String moduleId;
  final String name;
  final String? value; // Make this nullable
  final Function(String, String) onUpdateValue;

  const SliderInput({
    required this.projectName,
    required this.userName,
    required this.moduleId,
    required this.name,
    this.value, // Make this nullable
    required this.onUpdateValue,
    Key? key,
  }) : super(key: key);

  @override
  _SliderInputState createState() => _SliderInputState();
}

class _SliderInputState extends State<SliderInput> {
  double? _currentSliderValue;
  final WebSocketService webSocketService = WebSocketService();
  late StreamSubscription<Map<String, dynamic>> _subscription;

  @override
  void initState() {
    super.initState();
    _currentSliderValue =
        double.tryParse(widget.value ?? '0') ?? 0.0; // Handle null value
    webSocketService.connect();

    _subscription = webSocketService.messageStream.listen((data) {
      final msg = data['msg'];

      if (msg['roomId'] == widget.moduleId && (msg['source'] != 'MobileApp')) {
        setState(() {
          _currentSliderValue = double.tryParse(msg['value']) ?? 0.0;
        });
        widget.onUpdateValue(widget.moduleId, msg['value']);
      }
    });

    // webSocketService.joinRooms(widget.moduleId);
  }

  @override
  void dispose() {
    _subscription.cancel();
    // webSocketService.leaveRooms(widget.moduleId);
    super.dispose();
  }

  void _onSliderChanged(double value) {
    setState(() {
      _currentSliderValue = value;
    });
  }

  void _onSliderChangeEnd(double value) {
    webSocketService.sendMessage({
      "msg": {
        "source": "MobileApp",
        "roomId": widget.moduleId,
        "value": value.round().toString(),
        "status": true
      },
      "data": {
        "user": widget.userName,
        "projectName": widget.projectName,
      }
    });

    widget.onUpdateValue(widget.moduleId, value.round().toString());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Container(
        height: 150,
        width: 180,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.name,
                style: TextStyle(
                  fontSize: 26,
                )),
            Slider(
              activeColor: Color(0xFF125BFA),
              value: _currentSliderValue!,
              min: 0,
              max: 1023,
              divisions: 1023,
              label: _currentSliderValue!.round().toString(),
              onChanged: _onSliderChanged,
              onChangeEnd: _onSliderChangeEnd,
            ),
            Text(
              _currentSliderValue.toString(),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
