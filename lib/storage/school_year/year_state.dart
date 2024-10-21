part of 'year_cubit.dart';

abstract class YearState extends Equatable{
  const YearState();
}

class YearInitial extends YearState {
  @override
  List<Object?> get props => [];
}
class YearLoading extends YearState {
  @override
  List<Object?> get props => [];
}
class YearsLoading extends YearState {
    @override
  List<Object?> get props => [];
}

class YearLoaded extends YearState {
  final Year schoolYear;
   
   const YearLoaded({required this.schoolYear});

      @override
  List<Object?> get props => [schoolYear];
}

class YearsLoaded extends YearState {
final List<Year> schoolYears;

 const YearsLoaded({required this.schoolYears});

   @override
  List<Object?> get props => [schoolYears];

}

class YearChanged extends YearState {

  const YearChanged();

     @override
  List<Object?> get props => [];
}

class YearError extends YearState {
  final String? message;
  
  const YearError({required this.message});

       @override
  List<Object?> get props => [message];

}