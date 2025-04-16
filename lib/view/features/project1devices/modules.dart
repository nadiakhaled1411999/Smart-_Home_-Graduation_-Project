// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:untitled7/models/project.dart';

import 'module_data.dart';
import 'module_rules_page.dart'; // استيراد صفحة عرض القواعد للوحدة

class ModuleListPage extends StatelessWidget {
  final Project project;
  final String token;

  ModuleListPage({required this.project, required this.token});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modules for ${project.projectName}'),
        backgroundColor: Colors.purple, // تعديل لون الخلفية
      ),
      body: Container(
        color: Colors.purple.shade50, // تعيين خلفية بنفسجية فاتحة
        child: ListView.builder(
          itemCount: project.modules?.length ?? 0,
          itemBuilder: (context, index) {
            final module = project.modules![index];
            return Card(
              margin: EdgeInsets.all(10),
              child: ListTile(
                title: Text(module.moduleName ?? 'Unnamed Module',style: TextStyle(fontWeight: FontWeight.bold),),
                subtitle: Text(module.alternateName ?? 'No Alternate Name'),
                trailing: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ModuleRulesPage(
                          modules: [module], // تمرير الوحدة الحالية فقط
                          moduleName: module.moduleName ?? '',
                        ),
                      ),
                    );
                  },
                  child: Text("Rules",style: TextStyle(color: Colors.purple,fontSize: 15),),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ModuleDetailPage(
                        module: module,
                        token: token,
                        project: project,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
