

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar/isar.dart';
import 'package:teacher_gradebook/storage/assignment/assignment.dart';

import '../course/course.dart';
import '../grade/grade.dart';
import '../school_year/year.dart';
import '../teacher_repo.dart';

part 'assignment_state.dart';

class AssignmentCubit extends Cubit<AssignmentState> {
  final TeacherRepo _teacherRepo;

  AssignmentCubit(this._teacherRepo) : super(AssignmentInitial());

  Future<void> loadAssignments(Id courseId, Id yearId) async {
    emit(AssignmentsLoading());
    try {
      final List<Assignment> assignments = await _teacherRepo.loadAllAssignmentsByCourse(courseId);
      final Course? currentCourse = await _teacherRepo.getCourse(courseId);
      final Year? currentYear = await _teacherRepo.getYear(yearId);

      if (currentCourse != null && currentYear != null) {
        emit(AssignmentsLoaded(assignments: assignments, course: currentCourse, year: currentYear));
      } else {
        emit(AssignmentError(message: "Cannot find course or year"));
      }
    } catch (e) {
      emit(AssignmentError(message: e.toString()));
    }
  }

  Future<void> addAssignment(String assignmentName, List<Course> courses, double maximumPoints, Id courseId, Id yearId) async {
    await _teacherRepo.createAssignment(assignmentName: assignmentName, courses: courses, maximumPoints: maximumPoints);
    loadAssignments(courseId, yearId);
  }

  Future<void> deleteAssignment(Id assignmentId, Id courseId, Id yearId) async {
    await _teacherRepo.deleteAssignment(id: assignmentId);
    loadAssignments(courseId, yearId);
  }

  Future<void> editAssignment(Id assignmentId, String assignmentName, List<Course> courses, double maximumPoints, Id courseId, Id yearId) async {
    await _teacherRepo.editAssignment(assignmentId: assignmentId, courses: courses, maximumPoints: maximumPoints, assignmentName: assignmentName);
    loadAssignments(courseId, yearId);
  }

  void updateAssignmentBasedOnGrades(List<Grade> grades, Id courseId, Id yearId) {
    loadAssignments(courseId, yearId);
  }
}
