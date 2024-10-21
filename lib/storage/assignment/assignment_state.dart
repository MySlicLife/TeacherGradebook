part of 'assignment_cubit.dart';

abstract class AssignmentState extends Equatable {
  const AssignmentState();
}

class AssignmentInitial extends AssignmentState {
  @override
  List<Object?> get props => [];
}

class AssignmentLoading extends AssignmentState {
    @override
  List<Object?> get props => [];
}

class AssignmentsLoading extends AssignmentState {
    @override
  List<Object?> get props => [];
}

class AssignmentLoaded extends AssignmentState {
  final Assignment assignment;
  final Course course;
  final Year year;

  const AssignmentLoaded({required this.assignment, required this.course, required this.year});

    @override
  List<Object?> get props => [assignment, course, year];
}

class AssignmentsLoaded extends AssignmentState {
  final List<Assignment> assignments;
  final Course course;
  final Year year;

  const AssignmentsLoaded({required this.assignments, required this.course, required this.year});

    @override
  List<Object?> get props => [assignments, course, year];
}

class AssignmentEditing extends AssignmentState {
  final Assignment assignment;

  const AssignmentEditing({required this.assignment});

    @override
  List<Object?> get props => [assignment];
}

class AssignmentError extends AssignmentState {
  final String? message;

  const AssignmentError({required this.message});

    @override
  List<Object?> get props => [message];
}