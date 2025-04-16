// ignore_for_file: avoid_function_literals_in_foreach_calls, avoid_print

import 'package:untitled7/models/project.dart';

Future insertProject({required Project model}) async {
  // Insert some records in a transaction
  model.modules!.forEach((element) {
    print(element.moduleName);
    element.pins!.forEach((element) {
      print(element.pinMode);
    });
  });
  print(model.name);

  //print(model.modules![0].pins);
  return;
}

Future updateProject({required Project model}) async {
  // Insert some records in a transaction
  print(model);
  return;
}

Future deleteProject({required Project model}) async {
  // Insert some records in a transaction

  print(model);
  return;
}
