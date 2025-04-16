// project.dart
class Projects {
  bool? success;
  String? msg;
  List<Project>? data;

  Projects({this.success, this.msg, this.data});

  factory Projects.fromJson(Map<String, dynamic> json) {
    return Projects(
      success: json['success'],
      msg: json['msg'],
      data: json['data'] != null
          ? (json['data'] as List).map((i) => Project.fromJson(i)).toList()
          : null,
    );
  }
}

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

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['_id'],
      name: json['name'],
      projectName: json['projectName'],
      controller: json['controller'],
      description: json['description'],
      modules: json['modules'] != null
          ? (json['modules'] as List).map((i) => Module.fromJson(i)).toList()
          : null,
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      v: json['__v'],
    );
  }
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

  factory Module.fromJson(Map<String, dynamic> json) {
    return Module(
      moduleName: json['moduleName'],
      id: json['_id'],
      alternateName: json['alternateName'],
      lastValue: json['lastValue'],
      type: json['type'],
      pins: json['pins'] != null
          ? (json['pins'] as List).map((i) => Pin.fromJson(i)).toList()
          : null,
      rules: json['rules'] != null
          ? (json['rules'] as List).map((i) => Rule.fromJson(i)).toList()
          : null,
      version: json['__v'],
    );
  }
}

class Pin {
  String? pinNumber;
  String? id;
  String? pinMode;
  String? type;
  List<String>? additionalData;

  Pin({
    this.pinNumber,
    this.id,
    this.pinMode,
    this.type,
    this.additionalData,
  });

  factory Pin.fromJson(Map<String, dynamic> json) {
    return Pin(
      pinNumber: json['pinNumber'],
      id: json['_id'],
      pinMode: json['pinMode'],
      type: json['type'],
      additionalData: json['additionalData'] != null
          ? List<String>.from(json['additionalData'])
          : null,
    );
  }
}

class Rule {
  CustomAction? action;
  String? triggerModuleId;
  String? condition;
  String? conditionValue;
  String? actionModuleId;
  String? id;

  Rule({
    this.action,
    this.triggerModuleId,
    this.condition,
    this.conditionValue,
    this.actionModuleId,
    this.id,
  });

  factory Rule.fromJson(Map<String, dynamic> json) {
    return Rule(
      action:
          json['action'] != null ? CustomAction.fromJson(json['action']) : null,
      triggerModuleId: json['triggerModuleId'],
      condition: json['condition'],
      conditionValue: json['conditionValue'],
      actionModuleId: json['actionModuleId'],
      id: json['_id'],
    );
  }
}

class CustomAction {
  String? type;
  String? value;

  CustomAction({this.type, this.value});

  factory CustomAction.fromJson(Map<String, dynamic> json) {
    return CustomAction(
      type: json['type'],
      value: json['value'],
    );
  }
}
