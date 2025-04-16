// ignore_for_file: prefer_const_constructors, no_logic_in_create_state, unnecessary_this, use_key_in_widget_constructors
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:untitled7/core/widgets/default_button.dart';
import 'package:untitled7/core/widgets/my_textfield.dart';
import 'package:untitled7/models/project.dart';
import 'package:untitled7/view/features/style/app_colors.dart';

class AddPin extends StatefulWidget {
  final Module? module;
  final Project? project;
  final void Function(Module) onUpdateModule;

  const AddPin({Key? key, this.module, this.project, required this.onUpdateModule});

  @override
  State<AddPin> createState() => _AddPinState();
}

class _AddPinState extends State<AddPin> {
  final List<TextEditingController> controllers = [
    TextEditingController(),
    TextEditingController(),
  ];

  // قائمة بأرقام البنات
  List<String> pinNumbers = [
    "--",
    "D0",
    "D1",
    "D2 PWM",
    "D3",
    "D4",
    "D5 PWM",
    "D6 PWM",
    "D7",
    "D8 PWM",
    "A0",
  ];

  String? selectedPinNumber;

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
                'Add Pin',
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 50),
              Column(
                children: [
                  MyTextField(
                    controller: controllers[0],
                    title: 'pinMode',
                    hint: 'Type pinMode Here',
                  ),
                  SizedBox(height: 30),
                  DropdownButtonHideUnderline(
                    child: DropdownButton2(
                      isExpanded: true,
                      hint: Text(
                        'Select pinNumber',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                      items: pinNumbers
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
                      value: selectedPinNumber,
                      onChanged: (value) {
                        setState(() {
                          selectedPinNumber = value as String?;
                          controllers[1].text = selectedPinNumber ?? '';
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
                ],
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DefaultButton(
                    onTap: () {
                      if (controllers[0].text.isEmpty || controllers[1].text.isEmpty) {
                        print('message : forms empty');
                      } else {
                        if (widget.module == null) {
                          print('Module is null');
                          return;
                        }
                        Pin pin = Pin(
                          pinMode: controllers[0].text,
                          pinNumber: controllers[1].text,
                          type: "  ", // قيمة افتراضية للتأكد من أن الحقل ليس فارغًا
                          id: '    ',
                        );

                        // Ensure pins is a modifiable list
                        widget.module!.pins = List.from(widget.module!.pins ?? []);
                        widget.module!.pins!.add(pin);

                        widget.onUpdateModule(widget.module!);

                        Navigator.pop(context);
                      }
                    },
                    text: 'Add Pin',
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
