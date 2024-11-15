

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar/isar.dart';

import '../teacher_repo.dart';
import 'year.dart';

part 'year_state.dart';

class YearCubit extends Cubit<YearState> {
  final TeacherRepo _teacherRepo;

  YearCubit(this._teacherRepo) : super(YearInitial());

  Future<void> loadYears() async {
    
    emit(YearsLoading());
    final years = _teacherRepo.loadAllYears();
    List<Year> yearList = await years;
    emit(YearsLoaded(schoolYears: yearList));
  }

  Future<void> loadYear(Id yearId) async {
    emit(YearLoading());
    final year = await _teacherRepo.getYear(yearId);

    if (year != null) {
      emit(YearLoaded(schoolYear: year));
    } else {
      emit(YearError(message: "Cannot find year"));
    }
  }

  Future<void> addYear(String yearName, int yearColorId, DateTime startDate, DateTime endDate, String schoolName, String location) async {
    await _teacherRepo.createYear(name: yearName, yearColorId: yearColorId, startDate: startDate, endDate: endDate, schoolName: schoolName, location: location);
    emit(YearChanged());
    loadYears();
  }

  Future<void> deleteYear(Id yearId) async {
    await _teacherRepo.deleteYear(id: yearId);
    emit(YearChanged());
    loadYears();
  }

  Future<void> editYear(Id yearId, String? yearName, int? yearColorId, DateTime? startDate, DateTime? endDate, String? schoolName, String? location) async {
    await _teacherRepo.editYear(id: yearId, name: yearName, yearColorId: yearColorId, startDate: startDate, endDate: endDate, schoolName: schoolName, location: location);
    emit(YearChanged());
    loadYears();
  }
}
