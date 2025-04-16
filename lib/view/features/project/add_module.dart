// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, no_logic_in_create_state, unnecessary_this, prefer_const_constructors_in_immutables, prefer_conditional_assignment

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, no_logic_in_create_state, unnecessary_this, prefer_const_constructors_in_immutables
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:untitled7/view/features/project/add_pin.dart';

import '../../../core/widgets/default_button.dart';
import '../../../core/widgets/my_textfield.dart';
import '../../../models/project.dart';
import '../style/app_colors.dart';

class AddModule extends StatefulWidget {
  final Project? project;
  Module? module;
  final String? token;

  AddModule({super.key, this.project, this.module, this.token});

  @override
  State<AddModule> createState() => _AddModuleState();
}

class _AddModuleState extends State<AddModule> {
  final List<TextEditingController> controllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  // List of module names
  List<String> moduleNames = [
    'on-off',
    'PIR Motion sensor (Digital/Analog)',
    'Servro motor',
    'Temperature Sensor',
    'Smoke sensor MQ2 (Digital/Analog)',
    'Ultrasonic Sensor Module',
  ];

  // Selected module name
  String? selectedModuleName;

  @override
  void initState() {
    super.initState();
    if (widget.module != null) {
      controllers[0].text = widget.module?.moduleName ?? '';
      controllers[1].text = widget.module?.alternateName ?? '';
      controllers[2].text = widget.module?.type ?? '';
      selectedModuleName = widget.module?.moduleName; // Initialize selected module name
    }
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void updateModuleWithPin(Module module) {
    setState(() {
      widget.module = module;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          top: 40,
          left: 20,
          right: 20,
          bottom: 40,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context); // Navigate back on tap
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
                'Add Module',
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Column(
                children: [
                  DropdownButtonHideUnderline(
                    child: DropdownButton2(
                      isExpanded: true,
                      hint: Text(
                        'Select module name',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                      items: moduleNames
                          .map((item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          item,
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ))
                          .toList(),
                      value: selectedModuleName,
                      onChanged: (value) {
                        setState(() {
                          selectedModuleName = value as String?;
                          controllers[0].text = selectedModuleName ?? '';
                        });
                      },
                      buttonStyleData: ButtonStyleData(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.grey,
                          ),
                          color: Colors.white,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        height: 50,
                      ),
                      dropdownStyleData: DropdownStyleData(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                        ),
                        maxHeight: 200,
                        width: MediaQuery.of(context).size.width - 40,
                      ),
                      menuItemStyleData: MenuItemStyleData(
                        height: 40,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  MyTextField(
                    controller: controllers[1],
                    title: 'alternateName',
                    hint: 'Type alternateName here',
                  ),
                  SizedBox(height: 10),
                  MyTextField(
                    controller: controllers[2],
                    title: 'Type',
                    hint: 'Type type here',
                  ),
                  SizedBox(height: 10),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DefaultButton(
                    onTap: () {
                      if (controllers.every((controller) => controller.text.isNotEmpty)) {
                        if (widget.module == null) {
                          widget.module = Module(
                            moduleName: controllers[0].text,
                            alternateName: controllers[1].text,
                            type: controllers[2].text,
                          );
                        }
                        Navigator.pop(context, widget.module);
                      } else {
                        print('message: forms are empty');
                      }
                    },
                    text: 'Add Module',
                  ),
                ],
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  if (controllers.every((controller) => controller.text.isNotEmpty)) {
                    if (widget.module == null) {
                      widget.module = Module(
                        moduleName: controllers[0].text,
                        alternateName: controllers[1].text,
                        type: controllers[2].text,
                      );
                    }
                    if (widget.module != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return AddPin(
                            module: widget.module!,
                            onUpdateModule: updateModuleWithPin,
                          );
                        }),
                      );
                    }
                  } else {
                    print('message: forms are empty');
                  }
                },
                child: Text("Add Pin"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
