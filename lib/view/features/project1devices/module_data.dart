// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors, avoid_function_literals_in_foreach_calls, prefer_const_constructors_in_immutables, avoid_print
import 'package:flutter/material.dart';
import 'package:untitled7/models/project.dart';
import 'package:untitled7/view/features/project1devices/modules.dart';
import 'package:untitled7/view/features/project1devices/project1_devices.dart';

class ModuleDetailPage extends StatelessWidget {
  final Module module;
  final String token;
  final Project project;

  ModuleDetailPage({
    required this.module,
    required this.token,
    required this.project,
  });

  @override
  Widget build(BuildContext context) {
    List<Pin> pins = module.pins ?? [];

    return Scaffold(
      body:  SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.purple, Colors.pink]),
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(50),
                  bottomLeft: Radius.circular(50),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 50),
                  Container(
                    padding: EdgeInsets.only(left: 25),
                    alignment: Alignment.bottomLeft,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 30),
                    title: Text(
                      'Module Details',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(color: Colors.white),
                    ),
                    subtitle: module.moduleName != null && module.moduleName!.isNotEmpty
                        ? Text(
                      module.moduleName!,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: Colors.white54),
                    )
                        : null,
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 50,left: 20,right: 20),
              child: IntrinsicHeight(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (module.moduleName != null && module.moduleName!.isNotEmpty)
                          Text(
                            "moduleName: ${module.moduleName}",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),SizedBox(height: 5,),
                        if (module.alternateName != null && module.alternateName!.isNotEmpty)
                          Text(
                            "alternateName: ${module.alternateName}",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),SizedBox(height: 5,),
                        if (module.type != null && module.type!.isNotEmpty)
                          Text(
                            "type: ${module.type}",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),SizedBox(height: 5,),
                        ...pins.map((pin) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (pin.pinNumber != null && pin.pinNumber!.isNotEmpty)
                              Text(
                                "Pin Number: ${pin.pinNumber}",
                                style: TextStyle(color: Colors.white, fontSize: 18),
                              ),SizedBox(height: 5,),
                            if (pin.pinMode != null && pin.pinMode!.isNotEmpty)
                              Text(
                                "Pin Mode: ${pin.pinMode}",
                                style: TextStyle(color: Colors.white, fontSize: 18),
                              ),SizedBox(height: 5,),
                            if (pin.type != null && pin.type!.isNotEmpty)
                              Text(
                                "Type: ${pin.type}",
                                style: TextStyle(color: Colors.white, fontSize: 18),
                              ),
                          ],
                        )).toList(),
                      ],
                    ),
                  ),
                ),
              ),
            ),SizedBox(height: 50,),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical:30),
              child: InkWell(
                onTap: () {
                  Navigator.pop(context, MaterialPageRoute(builder: (context) {
                    return ModuleListPage(project: project, token: token);
                  }));
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 60,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(colors: [Colors.purple, Colors.pink]),
                  ),
                  child: Text(
                    "RETURN",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}