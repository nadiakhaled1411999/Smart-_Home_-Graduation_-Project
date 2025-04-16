import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled7/core/cubit/project_state.dart';
import '../../models/project.dart';
import '../util/strings.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import your authentication models

class ProjectCubit extends Cubit<ProjectState> {
  Map<String?, dynamic>? jsonFile;
  List<Project>? projects;
  SharedPreferences? prefs;
  static ProjectCubit get(context) => BlocProvider.of(context);

  ProjectCubit() : super(ProjectInitial());

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
      print(response.data);
    } catch (e) {
      print(e.toString());
    }
  }
}
