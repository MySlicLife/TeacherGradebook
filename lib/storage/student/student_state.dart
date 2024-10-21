part of 'student_cubit.dart';

abstract class StudentState extends Equatable{
  const StudentState();
}

class StudentInitial extends StudentState {
      @override
  List<Object?> get props => [];
}
class StudentLoading extends StudentState {
      @override
  List<Object?> get props => [];
}

class StudentsLoading extends StudentState {
      @override
  List<Object?> get props => [];
}

class StudentLoaded extends StudentState {
  final Student student;
  final Year year;
  final Course course;
  
  const StudentLoaded({required this.student, required this.year, required this.course});

      @override
  List<Object?> get props => [student, year, course];
}

class StudentsLoaded extends StudentState {
  final List<Student> students;
  final Year year;
  final Course course;

  const StudentsLoaded({required this.students, required this.year, required this.course});

      @override
  List<Object?> get props => [students, year, course];
}

class StudentEditing extends StudentState {
  final Student student;

  const StudentEditing({required this.student});

      @override
  List<Object?> get props => [student];
}

class StudentError extends StudentState {
      @override
  List<Object?> get props => [];
}