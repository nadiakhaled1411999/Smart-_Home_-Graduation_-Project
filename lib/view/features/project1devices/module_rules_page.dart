// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_constructors_in_immutables, unnecessary_brace_in_string_interps
import 'package:flutter/material.dart';
import '../../../models/project.dart'; // استيراد نموذج القاعدة

class ModuleRulesPage extends StatelessWidget {
  final List<Module> modules;
  final String moduleName;

  ModuleRulesPage({required this.modules, required this.moduleName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rules for $moduleName'), // تعديل عنوان الصفحة
        backgroundColor: Colors.purple,
      ),
      body: modules.isEmpty
          ? Center(
              child: Text(
                'No modules available.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: modules.length,
              itemBuilder: (context, index) {
                final module = modules[index];
                return Padding(
                  padding: const EdgeInsets.only(top: 100, right: 10, left: 10),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    color: Color(0xffff2cDf),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Module Name: ${module.moduleName}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 8),
                          if (module.rules != null && module.rules!.isNotEmpty)
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: module.rules!.length,
                              itemBuilder: (context, ruleIndex) {
                                final rule = module.rules![ruleIndex];
                                print(
                                    'Rule: $rule'); // طباعة القاعدة للتحقق من البيانات
                                print(
                                    'Action Type: ${rule.action?.type}, Action Value: ${rule.action?.value}'); // طباعة قيم النوع والقيمة للتحقق
                                return Card(
                                  elevation: 1,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  color: Colors.purpleAccent,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Rule ${ruleIndex + 1}',
                                          style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'Action Type: ${rule.action?.type ?? 'No Type'}',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                        Text(
                                          'Action Value: ${rule.action?.value ?? 'No Value'}',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                        Text(
                                          'Trigger Module ID: ${rule.triggerModuleId ?? 'No Trigger Module ID'}',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                        Text(
                                          'Condition: ${rule.condition ?? 'No Condition'}',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                        Text(
                                          'Condition Value: ${rule.conditionValue ?? 'No Condition Value'}',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                        Text(
                                          'Action Module ID: ${rule.actionModuleId ?? 'No Action Module ID'}',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          if (module.rules == null || module.rules!.isEmpty)
                            Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text(
                                'No rules available for this module.',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.purple,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
