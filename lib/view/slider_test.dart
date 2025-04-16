import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:untitled7/core/web_socket/web_socket.dart';
import '../core/util/strings.dart';
import 'socket_ui_screen.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String baseUrl = 'http://192.168.43.183:5500/api/v1';
  final Dio _dio = Dio();

  List<Map<String, dynamic>> projects = [];
  Map<String, dynamic>? selectedProject;
  WebSocketService webSocketService = WebSocketService();
  List<String> currentJoinedRooms = [];
  Map<String, String> moduleValues = {}; // Store current module values

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> fetchProjects({bool preserveSelection = false}) async {
    try {
      final response = await _dio.get('$baseUrl/project/all',
          options: Options(
            headers: {
              'Authorization': token,
            },
          ));
      if (response.statusCode == 200) {
        log('Response data: ${response.data}');
        final data = response.data['data'];
        setState(() {
          projects = List<Map<String, dynamic>>.from(data);
          if (!preserveSelection) {
            selectedProject = null;
            currentJoinedRooms = [];
            moduleValues = {};
          }
        });
        log('Projects: $projects');
      } else {
        log('Error: ${response.statusCode}');
      }
    } catch (e) {
      log('Exception: $e');
      setState(() {
        projects = [];
        selectedProject = null; // Clear the selected project on error
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProjects();
  }

  void _joinProjectRooms(Map<String, dynamic> project) {
    _updateAndLeaveCurrentRooms();

    List<String> newRooms = project['modules']
        .map<String>((module) => module['_id'] as String)
        .toList();

    webSocketService.joinRooms(newRooms);

    setState(() {
      currentJoinedRooms = newRooms;
      selectedProject = project;
    });
  }

  void _updateAndLeaveCurrentRooms() {
    if (currentJoinedRooms.isNotEmpty) {
      List<Map<String, dynamic>> moduleUpdates = [];
      for (String roomId in currentJoinedRooms) {
        if (moduleValues.containsKey(roomId)) {
          moduleUpdates.add({'id': roomId, 'value': moduleValues[roomId]});
        }
      }

      if (moduleUpdates.isNotEmpty) {
        final updateMessage = {
          'projectID': selectedProject?['_id'],
          'modules': moduleUpdates
        };
        log('Sending update message: $updateMessage');
        webSocketService.updateValues(updateMessage);
      }

      webSocketService.leaveRooms(currentJoinedRooms);
      setState(() {
        currentJoinedRooms = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back_outlined),
          color: Colors.white,
        ),
        title: const Text(
          'Live Control',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF407BFF),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ValueListenableBuilder<bool>(
              valueListenable: webSocketService.isConnected,
              builder: (context, isConnected, child) {
                return IconButton(
                  onPressed: () {
                    if (isConnected) {
                      webSocketService.disconnect();
                    } else {
                      webSocketService.connect();
                    }
                  },
                  icon: Icon(
                    isConnected ? Icons.wifi : Icons.wifi_off_rounded,
                    size: 30,
                    color: isConnected ? Colors.green : Colors.red,
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 209, 227, 255),
                  Color.fromARGB(255, 120, 176, 255)
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // Main content
          RefreshIndicator(
            onRefresh: () => fetchProjects(preserveSelection: false),
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 80,
                      child: projects.isEmpty
                          ? Center(
                              child: Text(
                                'No projects to show',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 18,
                                ),
                              ),
                            )
                          : ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: projects.length,
                              itemBuilder: (context, index) {
                                bool isSelected =
                                    selectedProject == projects[index];
                                return GestureDetector(
                                  onTap: () {
                                    _joinProjectRooms(projects[index]);
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 400),
                                    width: 120,
                                    margin: const EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? const Color(0xFF407BFF)
                                          : Colors.grey.shade500,
                                      borderRadius: BorderRadius.circular(10.0),
                                      boxShadow: [
                                        if (isSelected)
                                          BoxShadow(
                                            color: Colors.grey.shade600,
                                            offset: Offset(0, 4),
                                            blurRadius: 8.0,
                                          ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        child: Text(
                                          projects[index]['projectName'],
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                    if (selectedProject != null)
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: selectedProject!['modules'].length,
                        itemBuilder: (context, index) {
                          var module = selectedProject!['modules'][index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: ModuleWidget(
                              module: module,
                              project: selectedProject,
                              onUpdateValue: (id, value) {
                                setState(() {
                                  moduleValues[id] = value;
                                });
                              },
                            ),
                          );
                        },
                      )
                    else
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 250.0),
                        child: Text(
                          'Please, select a project',
                          style: TextStyle(
                            color: Color.fromARGB(255, 129, 129, 129),
                            fontSize: 18,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class ModuleWidget extends StatelessWidget {
  final Map<String, dynamic> module;
  final Map<String, dynamic>? project;
  final Function(String, String) onUpdateValue;

  WebSocketService webSocketService = WebSocketService();

  ModuleWidget(
      {required this.module,
      required this.project,
      required this.onUpdateValue});

  @override
  Widget build(BuildContext context) {
    switch (module['type']) {
      case 'output_number':
        return NumberValueContainer(
          name: module['alternateName'] ?? module['moduleName'],
          moduleId: module['_id'],
          onUpdateValue: onUpdateValue,
        );
      case 'input_number':
        return SliderInput(
          projectName: project!['projectName'],
          userName: project!['name'],
          moduleId: module['_id'],
          name: module['alternateName'] ?? module['moduleName'],
          value: module['lastValue']?.toString(), // Handle null value
          onUpdateValue: onUpdateValue,
        );
      case 'output_text':
        return TextValueContainer(
          name: module['moduleName'],
          moduleId: module['_id'],
          onUpdateValue: onUpdateValue,
        );
      case 'on-off':
        return SwitchContainer(
          userName: project!['name'],
          projectName: project!['projectName'],
          initialLightState: module['lastValue'] == 'on',
          onChanged: (bool value) {
            webSocketService.sendMessage({
              "msg": {
                "source": "MobileApp",
                "roomId": module['_id'],
                "value": value == true ? "on" : "off",
                "status": true
              },
              "data": {
                "user": project!['name'],
                "projectName": project!['projectName'],
              }
            });
            onUpdateValue(module['_id'], value ? "on" : "off");
          },
          moduleId: module['_id'],
          name: module['alternateName'] ?? module['moduleName'],
        );
      case 'on-off (input)':
        return TextValueContainer(
          initialValue: module['lastValue'] ?? '...',
          name: module['moduleName'],
          moduleId: module['_id'],
          onUpdateValue: onUpdateValue,
        );
      default:
        return DefaultModuleWidget(module: module);
    }
  }
}

class DefaultModuleWidget extends StatelessWidget {
  final Map<String, dynamic> module;

  DefaultModuleWidget({required this.module});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(module['moduleName']),
        subtitle: Text("Type: Unknown, (Nadia's fault!!! 🐥)"),
      ),
    );
  }
}
