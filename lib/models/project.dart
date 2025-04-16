// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, prefer_const_constructors_in_immutables

class Project {
  String? id;
  String? name;
  String? projectName;
  String? controller;
  String? description;
  List<Module>? modules;
  String? createdAt;
  String? updatedAt;
  int? v;

  Project({
    this.id,
    this.projectName,
    this.controller,
    this.name,
    this.description,
    this.modules = const [],
    this.v,
    this.createdAt,
    this.updatedAt,
  });
}

class Module {
  String? moduleName;
  String? alternateName;
  String? lastValue;
  String? type;
  List<Pin>? pins;
  List<Rule>? rules;
  String? id;
  int? version;

  Module({
    this.moduleName,
    this.id,
    this.alternateName,
    this.lastValue,
    this.type,
    this.pins = const [],
    this.rules = const [],
    this.version,
  });
}

class Pin {
  String pinNumber;
  String id;
  String pinMode;
  String type;
  List<String>? additionalData;

  Pin({
    required this.pinNumber,
    required this.id,
    required this.pinMode,
    required this.type,
    this.additionalData,
  });
}

class Rule {
  final CustomAction action;
  final String triggerModuleId;
  final String condition;
  final String conditionValue;
  final String actionModuleId;
  final String id;

  Rule({
    required this.action,
    required this.triggerModuleId,
    required this.condition,
    required this.conditionValue,
    required this.actionModuleId,
    required this.id,
  });
}

class CustomAction {
  final String type;
  final String value;

  CustomAction({
    required this.type,
    required this.value,
  });
}
