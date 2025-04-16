import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../core/util/strings.dart';
import '../core/web_socket/web_socket.dart';
import '../data/api_service.dart';
import '../models/projects_model.dart';

class SoketDemoPage extends StatefulWidget {
  const SoketDemoPage({super.key});

  @override
  _SoketDemoPageState createState() => _SoketDemoPageState();
}

class _SoketDemoPageState extends State<SoketDemoPage> {
  Map<String?, dynamic>? jsonFile;
  late WebSocketService webSocketService;
  late ApiService apiService;
  List<Project>? projects;

  Future<void> getData() async {
    try {
      var dio = Dio();
      var response = await dio.get(
        "https://graduation-api-zaj9.onrender.com/api/v1/project/all",
        options: Options(
          headers: {
            'Authorization': token,
          },
        ),
      );

      jsonFile = response.data;
      List<dynamic> allProjects = jsonFile!["data"];
      projects = <Project>[];

      for (var proj in allProjects) {
        List<Module> modules = [];
        if (proj["modules"] != null) {
          List<dynamic> jsonModules = proj["modules"];
          for (var m in jsonModules) {
            List<Pin> pins = [];
            if (m["pins"] != null) {
              List<dynamic> jsonPins = m["pins"];
              for (var p in jsonPins) {
                pins.add(Pin(
                  pinNumber: p["pinNumber"] ?? '',
                  id: p["_id"],
                  pinMode: p["pinMode"] ?? '',
                  type: p["type"] ?? '',
                ));
              }
            }
            List<Rule> rules = [];
            if (m["rules"] != null) {
              List<dynamic> jsonRules = m["rules"];
              for (var r in jsonRules) {
                print("Rule data: $r");

                CustomAction customAction = CustomAction(
                  type: r["action"]["type"] ?? '',
                  value: r["action"]["value"] ?? '',
                );

                rules.add(Rule(
                  action: customAction,
                  triggerModuleId: r["triggerModuleId"] ?? '',
                  condition: r["condition"] ?? '',
                  conditionValue: r["conditionValue"] ?? '',
                  actionModuleId: r["actionModuleId"] ?? '',
                  id: r["_id"] ?? '',
                ));
              }
            }

            modules.add(Module(
              moduleName: m["moduleName"] ?? '',
              alternateName: m["alternateName"] ?? '',
              type: m["type"] ?? '',
              id: m["_id"] ?? '',
              lastValue: m["lastValue"].toString(),
              pins: pins,
              rules: rules,
            ));
          }
        }
        projects!.add(Project(
          id: proj["_id"] ?? '',
          projectName: proj["projectName"] ?? '',
          controller: proj["controller"] ?? '',
          description: proj["description"] ?? '',
          name: proj["name"] ?? '',
          createdAt: proj["createdAt"] ?? '',
          updatedAt: proj["updatedAt"] ?? '',
          v: int.tryParse(proj["v"].toString()) ?? 0,
          modules: modules,
        ));
      }
      setState(() {
        log(response.data);
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    // Initialize the WebSocketService and ApiService
    webSocketService = WebSocketService();
    apiService = ApiService();
    getData();
  }

  Future<void> _fetchProjects() async {
    try {
      Projects projectList = await apiService.fetchProjects();
      setState(() {
        projects = projectList.data;
        print('Fetched projects: $projects'); // Debug statement
      });
    } catch (e) {
      // Handle error
      print('Error fetching projects: $e');
    }
  }

  void _connectData(String projectName, String user) async {
    try {
      await apiService.connectData(projectName, user);
      // Optionally show a success message
      log('Connected data for project: $projectName, user: $user'); // Debug statement
    } catch (e) {
      // Handle error
      print('Error connecting data: $e');
    }
  }

  void _handleModules(List<Module> modules) {
    for (var module in modules) {
      if (module.type == 'on-off') {
        setState(() {
          bool switchValue = module.lastValue ==
              'on'; // Determine initial switch value based on lastValue

          // UI to display the switch
          Switch(
            value: switchValue,
            onChanged: (newValue) {
              // Update the switch value in the UI
              setState(() {
                switchValue = newValue;
              });

              // Define the data to send via WebSocket
              Map<String, dynamic> data = {
                'modules': [
                  {'id': module.id, 'value': newValue ? 'on' : 'off'}
                ]
              };

              // Call the updateValues method in WebSocketService
              // webSocketService.updateValues(data);
            },
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Socket.IO Flutter Demo'),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: Drawer(
        child: projects == null
            ? Center(
                child:
                    CircularProgressIndicator()) // Loading indicator while fetching data
            : ListView.builder(
                itemCount: projects!.length,
                itemBuilder: (context, index) {
                  final project = projects![index];
                  return ListTile(
                    title: Text(project.projectName ?? 'No Name'),
                    onTap: () {
                      Navigator.pop(context);
                      _connectData(
                          project.projectName!,
                          project
                              .name!); // Replace 'fathy' with the actual user if needed
                      _handleModules(project.modules ?? []);
                    },
                  );
                },
              ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                // Connect to the socket server
                webSocketService.connect();
              },
              child: const Text('Connect to Socket Server'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Disconnect from the socket server
                webSocketService.disconnect();
              },
              child: const Text('Disconnect from Socket Server'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Define the data
                Map<String, dynamic> data = {
                  'projectID': '667e9de7a14090748f904c5e',
                  'modules': [
                    {'id': '667e9efda14090748f904d14', 'value': 'on'},
                    {'id': '667e9e99a14090748f904ca1', 'value': 'on'},
                    {'id': '667e9ebfa14090748f904cc8', 'value': 'on'},
                    {'id': '667e9e99a14090748f904ca3'}
                  ]
                };

                // Call the updateValues method
                // webSocketService.updateValues(data);
              },
              child: const Text('Send Update Values'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Define the data
                List<String> rooms = [
                  '668155129a05ad16d80a64fa',
                  '668155129a05ad16d80a64fc',
                  '668155129a05ad16d80a64ff',
                  '668155129a05ad16d80a6501',
                  '668258d7eaba795b12d0d3c1',
                  '66825b00eaba795b12d0d43c',
                ];
                webSocketService.joinRooms(rooms);
              },
              child: const Text('Join room'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Define the data
                Map<String, dynamic> message = {
                  "msg": {
                    "source": "MobileApp",
                    "roomId": "66825b00eaba795b12d0d43c",
                    "value": "off",
                    "status": true
                  },
                  "data": {"user": "fathy", "projectName": "oma 2"}
                };
                // Call the updateValues method
                webSocketService.sendMessage(message);
              },
              child: const Text('Send Message'),
            ),
            const SizedBox(height: 20),
            StreamBuilder<Map<String, dynamic>>(
              stream: webSocketService.messageStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final data = snapshot.data!;
                  final value = data['msg']['value'];

                  if (value == 'on' || value == 'off') {
                    return Switch(
                      value: value == 'on',
                      onChanged: (newValue) {
                        // Optionally, handle switch toggle
                      },
                    );
                  } else if (double.tryParse(value) != null) {
                    return Container(
                      padding: const EdgeInsets.all(16.0),
                      color: Colors.blue,
                      child: Text(
                        value,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 24),
                      ),
                    );
                  }
                }
                return Container(); // Return an empty container if no data
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    webSocketService.dispose();
    super.dispose();
  }
}
