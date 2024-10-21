part of 'course_cubit.dart';

abstract class CourseState extends Equatable {
  const CourseState();
  
}

class CourseInitial extends CourseState {
    @override
  List<Object?> get props => [];
}

class CourseLoading extends CourseState {
    @override
  List<Object?> get props => [];
}

class CourseLoaded extends CourseState {
  final List<Course> courses;
  final Year year;
  const CourseLoaded({required this.courses, required this.year});

    @override
  List<Object?> get props => [courses, year];
}

class CourseEditing extends CourseState {
  final Course course;
  
  const CourseEditing({required this.course});

  @override
  List<Object?> get props => [course];
}

class CourseError extends CourseState {
  final String? message;

  const CourseError({required this.message});

  @override
  List<Object?> get props => [message];

}