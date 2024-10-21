
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar/isar.dart';

import '../assignment/assignment.dart';
import '../student/student.dart';
import '../teacher_repo.dart';
import 'grade.dart';

part 'grade_state.dart';

class GradeCubit extends Cubit<GradeState> {
  final TeacherRepo _teacherRepo;

  GradeCubit(this._teacherRepo) : super(GradeInitial());

  Future<void> loadGrade(Id gradeId, Id assignmentId, Id isarStudentId) async {
    emit(GradeLoading());
    try {
      final Grade grade = await _teacherRepo.getGrade(gradeId);
      final Assignment? currentAssignment = await _teacherRepo.getAssignment(assignmentId);
      final Student? currentStudent = await _teacherRepo.getStudentByIsar(isarStudentId);
      
      if (currentStudent != null && currentAssignment != null) {
        emit(GradeLoaded(assignment: currentAssignment, grade: grade, student: currentStudent));
      } else {
        emit(GradeError(message: "Cannot find student or assignment"));
      }
    } catch (e) {
      emit(GradeError(message: e.toString()));
    }
  }

  Future<void> loadGrades({Id? isarStudentId, Id? assignmentId}) async {
    emit(GradesLoading());
    try {
      if (isarStudentId != null && assignmentId == null) {
        final List<Grade> grades = await _teacherRepo.getGradesByStudent(isarStudentId);
        final Student? currentStudent = await _teacherRepo.getStudentByIsar(isarStudentId);
        emit(GradesLoaded(grades: grades, student: currentStudent));
      } else if (assignmentId != null && isarStudentId == null) {
        final List<Grade> grades = await _teacherRepo.getGradesByAssignment(assignmentId);
        final Assignment? currentAssignment = await _teacherRepo.getAssignment(assignmentId);
        
        emit(GradesLoaded(grades: grades, assignment: currentAssignment));
      } else {
        emit(GradeError(message: "Cannot find student ID or assignment ID"));
      }
    } catch (e) {
      emit(GradeError(message: e.toString()));
    }
  }

  Future<void> addGrade(double pointsEarned, double pointsPossible, Id isarStudentId, Id assignmentId, bool isCompleted, bool isLate, bool isMissing) async {
    await _teacherRepo.addGrade(pointsEarned: pointsEarned, pointsPossible: pointsPossible, isarStudentId: isarStudentId, assignmentId: assignmentId, isCompleted: isCompleted, isLate: isLate, isMissing: isMissing);
    loadGrades(isarStudentId: isarStudentId);
  }

  Future<void> editGrade(Id gradeId, double pointsEarned, double pointsPossible, Id isarStudentId, bool? isCompleted, bool? isLate, bool? isMissing) async {
    await _teacherRepo.editGrade(gradeId: gradeId, pointsEarned: pointsEarned, pointsPossible: pointsPossible);
    loadGrades(isarStudentId: isarStudentId);
  }

  Future<void> deleteGrade(Id gradeId, Id isarStudentId) async {
    await _teacherRepo.deleteGrade(gradeId: gradeId);
    loadGrades(isarStudentId: isarStudentId);
  }
}
