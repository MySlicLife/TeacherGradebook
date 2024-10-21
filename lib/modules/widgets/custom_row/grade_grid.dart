import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teacher_gradebook/helpers/checkbox/checkbox_cubit.dart';
import 'package:teacher_gradebook/modules/dialog/assignment_dialog.dart';
import 'package:teacher_gradebook/modules/dialog/grade_dialog.dart';
import 'package:teacher_gradebook/storage/grade/grade_cubit.dart';
import 'package:teacher_gradebook/storage/student/student_cubit.dart';
import '../../../storage/assignment/assignment.dart';
import '../../../storage/assignment/assignment_cubit.dart';
import '../../../storage/course/course.dart';
import '../../../storage/grade/grade.dart';
import '../../../storage/school_year/year.dart';
import '../../../storage/student/student.dart';
import '../../../storage/teacher_repo.dart';
import '../../dialog/student_dialog.dart';

class GradeGrid extends StatefulWidget {
  final Year currentYear;
  final Course currentCourse;

  const GradeGrid({
    super.key,
    required this.currentCourse,
    required this.currentYear,
  });

  @override
  State<GradeGrid> createState() => _GradeGridState();
}

class _GradeGridState extends State<GradeGrid> {
  int currentStudentIndex = 0;
  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  void _loadStudents() {
    context
        .read<StudentCubit>()
        .loadStudents(widget.currentYear.id, widget.currentCourse.courseId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GradeCubit(TeacherRepo()),
      child: BlocBuilder<StudentCubit, StudentState>(
        builder: (context, studentState) {
          if (studentState is StudentsLoaded) {
            return _buildGradeGrid(studentState);
          } else if (studentState is StudentsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else {
            throw Exception("Unable to find state $studentState");
          }
        },
      ),
    );
  }

  Widget _buildGradeGrid(StudentsLoaded studentState) {
    return Expanded(
      child: SingleChildScrollView(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStudentColumn(studentState.students),
            _buildAssignmentColumn(),
            _buildAddAssignmentButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentColumn(List<Student> students) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 50),
        ...students.map((student) => _buildStudentTile(student)),
        _buildAddStudentButton(),
      ],
    );
  }

  Widget _buildStudentTile(Student student) {
    return GestureDetector(
      onTap: () => _showStudentDialog(student, true),
      child: Container(
        height: 50,
        width: 300,
        color: Colors.grey,
        alignment: Alignment.center,
        child: Text(student.studentName),
      ),
    );
  }

  void _showStudentDialog(Student? student, bool isEditing) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return BlocProvider.value(
          value: context.read<StudentCubit>(),
          child: StudentDialog(
            currentCourse: widget.currentCourse,
            currentYear: widget.currentYear,
            currentStudent: student,
            isEditing: isEditing,
          ),
        );
      },
    );
  }

  Widget _buildAddStudentButton() {
    return GestureDetector(
      child: Container(
        height: 50,
        width: 300,
        color: Colors.green,
        child: const Icon(Icons.add),
      ),
      onTap: () => _showStudentDialog(null, false),
    );
  }

  Widget _buildAssignmentColumn() {
    return BlocBuilder<AssignmentCubit, AssignmentState>(
      builder: (context, assignmentState) {
        if (assignmentState is AssignmentsLoaded) {
          return _buildAssignments(assignmentState.assignments);
        } else if (assignmentState is AssignmentsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return const Text('No assignments available.');
        }
      },
    );
  }

  Widget _buildAssignments(List<Assignment> assignments) {
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          children: [
            _buildAssignmentRow(assignments),
            _buildGradesColumn(assignments),
          ],
        ),
      ),
    );
  }

  Widget _buildAssignmentRow(List<Assignment> assignments) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        for (var assignment in assignments) _buildAssignmentTile(assignment),
      ],
    );
  }

  Widget _buildAssignmentTile(Assignment assignment) {
    return GestureDetector(
      onTap: () => _showAssignmentDialog(assignment, true),
      child: Container(
        height: 50,
        width: 150,
        color: Colors.red,
        child: Center(
            child: Column(
          children: [
            Text(assignment.assignmentName), // Assignment Name
            Text("(${assignment.getFormattedMaximumPoints()})")
          ],
        )),
      ),
    );
  }

  void _showAssignmentDialog(Assignment? assignment, bool isEditing) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return BlocProvider(
          create: (context) => CheckboxCubit<Course>(),
          child: AssignmentDialog(
            courseList: widget.currentYear.courses.toList(),
            currentCourse: widget.currentCourse,
            currentYear: widget.currentYear,
            assignmentCubit: context.read<AssignmentCubit>(),
            isEditing: isEditing,
            existingAssignment: assignment,
          ),
        );
      },
    );
  }

  Widget _buildAddAssignmentButton() {
    return GestureDetector(
      child: Container(
        height: 50,
        width: 50,
        color: Colors.purple,
        child: const Icon(Icons.add),
      ),
      onTap: () => _showAssignmentDialog(null, false),
    );
  }

  Widget _buildGradesColumn(List<Assignment> assignments) {
    final students =
        (context.read<StudentCubit>().state as StudentsLoaded).students;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: List.generate(students.length, (index) {
        var student = students[index];
        return _buildGradesRow(student, assignments, index);
      }),
    );
  }

  Widget _buildGradesRow(
    Student student,
    List<Assignment> assignments,
    int studentIndex,
  ) {
    return BlocBuilder<GradeCubit, GradeState>(
      builder: (context, gradeState) {
        if (gradeState is GradesLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (gradeState is GradeInitial ||
            (gradeState is GradesLoaded &&
                gradeState.student!.id != student.id)) {
          // No update needed for grades
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: assignments.map((assignment) {
              Grade? studentGrade = _matchStudentGradeToAssignment(
                  student.grades.toList(), assignment);
              return _buildGradeTile(
                  studentGrade, assignment, studentIndex, context);
            }).toList(),
          );
        } else if (gradeState is GradesLoaded &&
            gradeState.student?.id == student.id) {
          // Update the student's grades directly
          for (var assignment in assignments) {
            Grade? newGrade =
                _matchStudentGradeToAssignment(gradeState.grades, assignment);
            if (newGrade != null) {
              // Update the existing grade if it matches
              int index = student.grades.toList().indexWhere((grade) =>
                  grade.assignment.value!.id == newGrade.assignment.value?.id);
              if (index != -1) {
                Grade existingGrade =
                    student.grades.toList()[index]; // Get the existing grade
                existingGrade.pointsEarned =
                    newGrade.pointsEarned; // Update the points earned
              } else {
                student.grades.add(newGrade); // Add new grade if not found
              }
            }
          }
          // Use the updated student grades for rendering
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: assignments.map((assignment) {
              Grade? studentGrade =
                  _matchStudentGradeToAssignment(gradeState.grades, assignment);
              return _buildGradeTile(
                  studentGrade, assignment, studentIndex, context);
            }).toList(),
          );
        }
        // Handle any other states or fallback UI

        return Text("An error occurred $gradeState");
      },
    );
  }

  Grade? _matchStudentGradeToAssignment(
    List<Grade> studentGrades,
    Assignment assignment,
  ) {
    return studentGrades.firstWhere(
      (grade) => grade.assignment.value!.id == assignment.id,
      orElse: () => Grade(pointsEarned: null, pointsPossible: null),
    );
  }

  Widget _buildGradeTile(Grade? studentGrade, Assignment assignment,
      int studentIndex, BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Handle grade box tap
        _showGradeDialog(
          studentGrade,
          studentGrade.pointsEarned == null ? true : false,
          assignment,
          studentIndex,
          context,
        );
      },
      child: Container(
        height: 50,
        width: 150,
        alignment: Alignment.center,
        color: Colors.blue[100],
        child: Container(
          color: Colors.blue[200],
          height: 40,
          width: 40,
          child: Center(
            child: Text(studentGrade!.getFormattedPointsEarned().toString()),
          ),
        ),
      ),
    );
  }

  void _showGradeDialog(Grade? grade, bool isEditing, Assignment assignment,
      int studentIndex, BuildContext context) {
    final studentCubitState = context.read<StudentCubit>().state;

    if (studentCubitState is StudentsLoaded) {
      showDialog(
        context: context,
        builder: (dialogContext) {
          return BlocProvider.value(
            value: context.read<GradeCubit>(),
            child: GradeDialog(
              assignment: assignment,
              studentList: studentCubitState.students,
              initialIndex: studentIndex,
              currentCourse: widget.currentCourse,
            ),
          );
        },
      );
    }
  }
}
