// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, use_build_context_synchronously, avoid_print, prefer_const_constructors_in_immutables, avoid_single_cascade_in_expression_statements
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:untitled7/core/util/assets.dart';
import 'package:untitled7/models/project.dart';
import 'package:untitled7/view/features/project/add_project.dart';
import 'package:untitled7/view/features/project/view_project.dart';
import 'package:untitled7/view/features/style/app_colors.dart';
import 'package:untitled7/view/features/project1devices/modules.dart';
import 'package:untitled7/view/slider_test.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key, required this.token});

  final String token;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String token;
  Map<String?, dynamic>? jsonFile;
  List<Project>? projects;

  @override
  void initState() {
    super.initState();
    token = widget.token;
    getData();
  }

  Future<void> getData() async {
    try {
      var dio = Dio();
      var response = await dio.get(
        "http://192.168.43.183:5500/api/v1/project/all",
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
        print(response.data);
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> deleteProject(String id, String projectName) async {
    try {
      var dio = Dio();
      var response = await dio.delete(
        "http://192.168.43.183:5500/api/v1/project/delete/$id",
        options: Options(
          headers: {
            'Authorization': token,
          },
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
          projects!.removeWhere((project) => project.id == id);
        });
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: Text(
                'Success',
                style: TextStyle(color: Colors.red),
              ),
              content: Text(
                "Project $projectName removed",
                style: TextStyle(color: AppColors.primaryColor, fontSize: 13),
              ),
              actions: [
                TextButton(
                  child: Text(
                    'OK',
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text("Project not found"),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print(e.toString());
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text("Failed to delete project"),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  void _showEditDialog(Project project) {
    TextEditingController nameController =
        TextEditingController(text: project.projectName);
    TextEditingController descController =
        TextEditingController(text: project.description);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Project'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Project Name'),
              ),
              TextField(
                controller: descController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await _updateProjectDetails(
                    project.id!, nameController.text, descController.text);
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateProjectDetails(
      String projectId, String projectName, String description) async {
    try {
      var dio = Dio();
      final response = await dio.put(
        'http://192.168.43.183:5500/api/v1/project/update-project-details/$projectId',
        data: {
          'projectName': projectName,
          'description': description,
        },
        options: Options(
          headers: {
            'Authorization': token,
          },
        ),
      );
      if (response.statusCode == 200) {
        setState(() {
          projects!.firstWhere((project) => project.id == projectId)
            ..projectName = projectName
            ..description = description;
        });
        print('Project updated successfully');
      } else {
        print('Failed to update project');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.primaryColor,
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return AddProject(
                projects: projects,
                token: widget.token,
                refreshCallback: getData,
              );
            }));
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.white,
        body: RefreshIndicator(
          onRefresh: getData,
          child: Padding(
            padding: const EdgeInsets.only(left: 5, right: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadiusDirectional.only(
                      bottomEnd: Radius.circular(30),
                      bottomStart: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 75,
                                height: 75,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: AssetImage(
                                        'assets/images/WhatsApp Image 2024-07-09 at 09.51.00_c7ff616c.jpg'),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "IOT",
                                      style: TextStyle(
                                        fontSize: 21,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                    Text(
                                      "PLATFORM",
                                      style: TextStyle(
                                        fontSize: 21,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          // Image(
                          //   image: AssetImage(Assets.menuImage),
                          //   height: 35,
                          //   width: 35,
                          //   color: Colors.white,
                          // ),
                          IconButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return MyHomePage();
                                },
                              ));
                            },
                            icon: Icon(
                              Icons.play_arrow_rounded,
                              color: Colors.red,
                              size: 55,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20, top: 20, bottom: 20.0),
                  child: Text(
                    "Your projects",
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w700,
                      color: Color.fromARGB(255, 4, 70, 124),
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                    itemCount: (projects != null) ? projects!.length : 0,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                    ),
                    itemBuilder: (context, index) {
                      return itemDashBoard(
                        projects![index],
                        Assets.project1,
                        index,
                      );
                    },
                    shrinkWrap: true,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget itemDashBoard(Project project, String imageData, int index) => InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return ModuleListPage(
              token: token,
              project: projects![index],
            );
          }));
        },
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.secondaryColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 5),
                    color: Theme.of(context).primaryColor.withOpacity(.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 15, right: 15, top: 40),
                    height: 100,
                    width: 140,
                    decoration: BoxDecoration(
                      color: AppColors.secondaryColor,
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: AssetImage(imageData),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    project.projectName!.length > 15
                        ? '${project.projectName!.substring(0, 15)}...'
                        : project.projectName!,
                    style: TextStyle(
                      fontSize: 15,
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Positioned(
              top: 4,
              left: 8,
              child: IconButton(
                icon: Icon(
                  Icons.details,
                  color: Colors.red,
                  size: 25,
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ViewProject(token: token, project: project);
                  }));
                },
              ),
            ),
            Positioned(
              top: 4,
              right: 8,
              child: IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                  size: 25,
                ),
                onPressed: () {
                  deleteProject(project.id!, project.projectName!);
                },
              ),
            ),
            Positioned(
              top: 4,
              right: 50,
              child: IconButton(
                icon: Icon(
                  Icons.edit,
                  color: Colors.purple,
                  size: 25,
                ),
                onPressed: () {
                  _showEditDialog(project);
                },
              ),
            ),
          ],
        ),
      );
}
