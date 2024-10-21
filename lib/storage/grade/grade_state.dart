part of 'grade_cubit.dart';

abstract class GradeState extends Equatable {
  const GradeState();
}

class GradeInitial extends GradeState {
  @override
  List<Object?> get props => [];
}

class GradeLoading extends GradeState {
  @override
  List<Object?> get props => [];
}

class GradesLoading extends GradeState {
  @override
  List<Object?> get props => [];
}

class GradeLoaded extends GradeState {
  final Grade grade;
  final Assignment assignment;
  final Student student;

  const GradeLoaded(
      {required this.assignment, required this.grade, required this.student});

  @override
  List<Object?> get props => [assignment, grade, student];
}

class GradesLoaded extends GradeState {
  final List<Grade> grades;
  final Assignment? assignment;
  final Student? student;

  const GradesLoaded({this.assignment, required this.grades, this.student});

  @override
  List<Object?> get props => [assignment, grades, student];
}

class GradeModified extends GradeState {
  const GradeModified();

  @override
  List<Object?> get props => [];
}

class GradeError extends GradeState {
  final String? message;

  const GradeError({required this.message});
  @override
  List<Object?> get props => [message];
}
