
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar/isar.dart';
import 'package:teacher_gradebook/storage/student/student.dart';

import '../course/course.dart';
import '../school_year/year.dart';
import '../teacher_repo.dart';

part 'student_state.dart';

class StudentCubit extends Cubit<StudentState> {
  final TeacherRepo _teacherRepo;

  StudentCubit(this._teacherRepo) : super(StudentInitial());

  Future<void> loadStudent(Id isarStudentId, Id yearId, Id courseId) async {
    emit(StudentLoading());
    final Student? student = await _teacherRepo.getStudentByIsar(isarStudentId);
    final Year? studentYear = await _teacherRepo.getYear(yearId);
    final Course? studentCourse = await _teacherRepo.getCourse(courseId);

    if (student != null && studentYear != null && studentCourse != null) {
      
      emit(StudentLoaded(student: student, year: studentYear, course: studentCourse));
    } else {
      emit(StudentError());
    }
  }

  Future<void> loadStudents(Id yearId, Id courseId) async {
    emit(StudentsLoading());
    final List<Student> students = await _teacherRepo.getStudentsByCourse(courseId);
    final Year? studentYear = await _teacherRepo.getYear(yearId);
    final Course? studentCourse = await _teacherRepo.getCourse(courseId);
    if (studentYear != null && studentCourse != null) {
      emit(StudentsLoaded(students: students, year: studentYear, course: studentCourse));
    } else {
      emit(StudentError());
    }
  }

  Future<void> addStudent(String studentName, List<Id> courseIds, Id yearId, Id courseId, int? studentId, int? programId) async {
    await _teacherRepo.createStudent(studentName: studentName, courseIds: courseIds, studentId: studentId, programId: programId);

    loadStudents(yearId, courseId);
  }

  Future<void> editStudent(Id isarStudentId, String studentName, List<Id> courseIds, int? studentId, int? programId, Id yearId, Id courseId) async {
    await _teacherRepo.editStudent(isarStudentId: isarStudentId, courseIds: courseIds, studentName: studentName, studentId: studentId, programId: programId);
    loadStudents(yearId, courseId);
  }

  Future<void> deleteStudent(Id isarStudentId, Id yearId, Id courseId) async {
    await _teacherRepo.deleteStudent(studentId: isarStudentId);
    loadStudents(yearId, courseId);
  }
}
