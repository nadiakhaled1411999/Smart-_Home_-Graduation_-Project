abstract class ProjectState {}

class ProjectInitial extends ProjectState {}

class ProjectLoading extends ProjectState {}

class StopLoading extends ProjectState {}

class ProjectLoaded extends ProjectState {}

class ProjectError extends ProjectState {
  final String message;
  ProjectError(this.message);
}

class ChangeRole extends ProjectState {}
