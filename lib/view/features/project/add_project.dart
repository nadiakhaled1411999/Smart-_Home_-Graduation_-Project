// ignore
// _for_file: prefer_const_constructors, sized_box_for_whitespace, prefer
// ignore_for_file: prefer_const_constructors, prefer_generic_function_type_aliases, use_key_in_widget_constructors

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../models/project.dart';
import '../style/app_colors.dart';
import 'add_module.dart';

typedef void DataRefreshCallback();

class AddProject extends StatefulWidget {
  List<Project>? projects;
  final String token;
  final DataRefreshCallback refreshCallback;

  AddProject(
      {required this.projects,
      required this.token,
      required this.refreshCallback});

  @override
  State<AddProject> createState() => _AddProjectState();
}

class _AddProjectState extends State<AddProject> {
  List<TextEditingController> controllers = [
    TextEditingController(), // Name
    TextEditingController(), // ProjectName
    TextEditingController(), // Description
    TextEditingController(), // Controller
  ];

  List<Module> modules = [];

  Future<void> _createProject(
    String name,
    String projectName,
    String description,
    String controller,
    List<Module> modules,
  ) async {
    try {
      var dio = Dio();
      final modulesJson = modules.map((module) {
        return {
          'moduleName': module.moduleName,
          'alternateName': module.alternateName,
          'type': module.type,
          'lastValue': module.lastValue,
          'pins': module.pins
              ?.map((pin) => {
                    'pinMode': pin.pinMode,
                    'pinNumber': pin.pinNumber,
                  })
              .toList(),
        };
      }).toList();

      final response = await dio.post(
        'http://192.168.43.183:5500/api/v1/project/create',
        data: {
          'name': name,
          'projectName': projectName,
          'description': description,
          'controller': controller,
          'modules': modulesJson,
        },
        options: Options(
          headers: {
            'Authorization': widget.token,
          },
        ),
      );
      if (response.statusCode == 201) {
        print('Project created successfully');
        widget.refreshCallback(); // Call the refresh callback to update data
        Navigator.pop(context); // Navigate back to home screen
      } else {
        print('Failed to create project');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      size: 28,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Add Project',
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Column(
                children: [
                  TextField(
                    controller: controllers[0],
                    decoration: InputDecoration(
                      labelText: 'Name',
                      hintText: 'Type name Here',
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: controllers[1],
                    decoration: InputDecoration(
                      labelText: 'ProjectName',
                      hintText: 'Type Project Name Here',
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: controllers[2],
                    decoration: InputDecoration(
                      labelText: 'Description',
                      hintText: 'Type Description Here',
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: controllers[3],
                    decoration: InputDecoration(
                      labelText: 'Controller',
                      hintText: 'Type controller Here',
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Modules:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: modules.length,
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Module Name: ${modules[index].moduleName}'),
                          Text(
                              'Alternate Name: ${modules[index].alternateName}'),
                          Text('Type: ${modules[index].type}'),
                          Text('Last Value: ${modules[index].lastValue}'),
                          Text(
                              'Pins: ${modules[index].pins?.map((pin) => 'Mode: ${pin.pinMode}, Number: ${pin.pinNumber},').join(', ')}'),
                          Divider(),
                        ],
                      );
                    },
                  ),
                  SizedBox(height: 5),
                  ElevatedButton(
                    onPressed: () async {
                      final newModule = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddModule(
                            project: null,
                            module: null,
                            token: widget.token,
                          ),
                        ),
                      );
                      if (newModule != null) {
                        setState(() {
                          modules.add(newModule);
                        });
                      }
                    },
                    child: Text('Add Module'),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (controllers[0].text.isEmpty ||
                          controllers[1].text.isEmpty ||
                          controllers[2].text.isEmpty) {
                        print('Message: Forms are empty');
                      } else {
                        _createProject(
                          controllers[0].text,
                          controllers[1].text,
                          controllers[2].text,
                          controllers[3].text,
                          modules, // Pass the modules list
                        );
                      }
                    },
                    child: Text('Add Project'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
