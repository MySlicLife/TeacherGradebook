// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grade.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetGradeCollection on Isar {
  IsarCollection<Grade> get grades => this.collection();
}

const GradeSchema = CollectionSchema(
  name: r'Grade',
  id: -5717027466259005798,
  properties: {
    r'isComplete': PropertySchema(
      id: 0,
      name: r'isComplete',
      type: IsarType.bool,
    ),
    r'isLate': PropertySchema(
      id: 1,
      name: r'isLate',
      type: IsarType.bool,
    ),
    r'isMissing': PropertySchema(
      id: 2,
      name: r'isMissing',
      type: IsarType.bool,
    ),
    r'pointsEarned': PropertySchema(
      id: 3,
      name: r'pointsEarned',
      type: IsarType.double,
    ),
    r'pointsPossible': PropertySchema(
      id: 4,
      name: r'pointsPossible',
      type: IsarType.double,
    ),
    r'weight': PropertySchema(
      id: 5,
      name: r'weight',
      type: IsarType.long,
    )
  },
  estimateSize: _gradeEstimateSize,
  serialize: _gradeSerialize,
  deserialize: _gradeDeserialize,
  deserializeProp: _gradeDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'assignment': LinkSchema(
      id: -942596409955632905,
      name: r'assignment',
      target: r'Assignment',
      single: true,
    ),
    r'student': LinkSchema(
      id: 6655192037350000626,
      name: r'student',
      target: r'Student',
      single: true,
    )
  },
  embeddedSchemas: {},
  getId: _gradeGetId,
  getLinks: _gradeGetLinks,
  attach: _gradeAttach,
  version: '3.1.0+1',
);

int _gradeEstimateSize(
  Grade object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _gradeSerialize(
  Grade object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.isComplete);
  writer.writeBool(offsets[1], object.isLate);
  writer.writeBool(offsets[2], object.isMissing);
  writer.writeDouble(offsets[3], object.pointsEarned);
  writer.writeDouble(offsets[4], object.pointsPossible);
  writer.writeLong(offsets[5], object.weight);
}

Grade _gradeDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Grade(
    isComplete: reader.readBoolOrNull(offsets[0]),
    isLate: reader.readBoolOrNull(offsets[1]),
    isMissing: reader.readBoolOrNull(offsets[2]),
    pointsEarned: reader.readDoubleOrNull(offsets[3]),
    pointsPossible: reader.readDoubleOrNull(offsets[4]),
    weight: reader.readLongOrNull(offsets[5]),
  );
  object.id = id;
  return object;
}

P _gradeDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBoolOrNull(offset)) as P;
    case 1:
      return (reader.readBoolOrNull(offset)) as P;
    case 2:
      return (reader.readBoolOrNull(offset)) as P;
    case 3:
      return (reader.readDoubleOrNull(offset)) as P;
    case 4:
      return (reader.readDoubleOrNull(offset)) as P;
    case 5:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _gradeGetId(Grade object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _gradeGetLinks(Grade object) {
  return [object.assignment, object.student];
}

void _gradeAttach(IsarCollection<dynamic> col, Id id, Grade object) {
  object.id = id;
  object.assignment
      .attach(col, col.isar.collection<Assignment>(), r'assignment', id);
  object.student.attach(col, col.isar.collection<Student>(), r'student', id);
}

extension GradeQueryWhereSort on QueryBuilder<Grade, Grade, QWhere> {
  QueryBuilder<Grade, Grade, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension GradeQueryWhere on QueryBuilder<Grade, Grade, QWhereClause> {
  QueryBuilder<Grade, Grade, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<Grade, Grade, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Grade, Grade, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Grade, Grade, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension GradeQueryFilter on QueryBuilder<Grade, Grade, QFilterCondition> {
  QueryBuilder<Grade, Grade, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> isCompleteIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'isComplete',
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> isCompleteIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'isComplete',
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> isCompleteEqualTo(
      bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isComplete',
        value: value,
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> isLateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'isLate',
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> isLateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'isLate',
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> isLateEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isLate',
        value: value,
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> isMissingIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'isMissing',
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> isMissingIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'isMissing',
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> isMissingEqualTo(
      bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isMissing',
        value: value,
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> pointsEarnedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'pointsEarned',
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> pointsEarnedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'pointsEarned',
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> pointsEarnedEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pointsEarned',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> pointsEarnedGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'pointsEarned',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> pointsEarnedLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'pointsEarned',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> pointsEarnedBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'pointsEarned',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> pointsPossibleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'pointsPossible',
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> pointsPossibleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'pointsPossible',
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> pointsPossibleEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pointsPossible',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> pointsPossibleGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'pointsPossible',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> pointsPossibleLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'pointsPossible',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> pointsPossibleBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'pointsPossible',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> weightIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'weight',
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> weightIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'weight',
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> weightEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'weight',
        value: value,
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> weightGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'weight',
        value: value,
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> weightLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'weight',
        value: value,
      ));
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> weightBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'weight',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension GradeQueryObject on QueryBuilder<Grade, Grade, QFilterCondition> {}

extension GradeQueryLinks on QueryBuilder<Grade, Grade, QFilterCondition> {
  QueryBuilder<Grade, Grade, QAfterFilterCondition> assignment(
      FilterQuery<Assignment> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'assignment');
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> assignmentIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'assignment', 0, true, 0, true);
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> student(
      FilterQuery<Student> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'student');
    });
  }

  QueryBuilder<Grade, Grade, QAfterFilterCondition> studentIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'student', 0, true, 0, true);
    });
  }
}

extension GradeQuerySortBy on QueryBuilder<Grade, Grade, QSortBy> {
  QueryBuilder<Grade, Grade, QAfterSortBy> sortByIsComplete() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isComplete', Sort.asc);
    });
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> sortByIsCompleteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isComplete', Sort.desc);
    });
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> sortByIsLate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isLate', Sort.asc);
    });
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> sortByIsLateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isLate', Sort.desc);
    });
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> sortByIsMissing() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isMissing', Sort.asc);
    });
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> sortByIsMissingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isMissing', Sort.desc);
    });
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> sortByPointsEarned() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pointsEarned', Sort.asc);
    });
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> sortByPointsEarnedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pointsEarned', Sort.desc);
    });
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> sortByPointsPossible() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pointsPossible', Sort.asc);
    });
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> sortByPointsPossibleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pointsPossible', Sort.desc);
    });
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> sortByWeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weight', Sort.asc);
    });
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> sortByWeightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weight', Sort.desc);
    });
  }
}

extension GradeQuerySortThenBy on QueryBuilder<Grade, Grade, QSortThenBy> {
  QueryBuilder<Grade, Grade, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> thenByIsComplete() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isComplete', Sort.asc);
    });
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> thenByIsCompleteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isComplete', Sort.desc);
    });
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> thenByIsLate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isLate', Sort.asc);
    });
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> thenByIsLateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isLate', Sort.desc);
    });
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> thenByIsMissing() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isMissing', Sort.asc);
    });
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> thenByIsMissingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isMissing', Sort.desc);
    });
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> thenByPointsEarned() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pointsEarned', Sort.asc);
    });
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> thenByPointsEarnedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pointsEarned', Sort.desc);
    });
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> thenByPointsPossible() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pointsPossible', Sort.asc);
    });
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> thenByPointsPossibleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pointsPossible', Sort.desc);
    });
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> thenByWeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weight', Sort.asc);
    });
  }

  QueryBuilder<Grade, Grade, QAfterSortBy> thenByWeightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weight', Sort.desc);
    });
  }
}

extension GradeQueryWhereDistinct on QueryBuilder<Grade, Grade, QDistinct> {
  QueryBuilder<Grade, Grade, QDistinct> distinctByIsComplete() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isComplete');
    });
  }

  QueryBuilder<Grade, Grade, QDistinct> distinctByIsLate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isLate');
    });
  }

  QueryBuilder<Grade, Grade, QDistinct> distinctByIsMissing() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isMissing');
    });
  }

  QueryBuilder<Grade, Grade, QDistinct> distinctByPointsEarned() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pointsEarned');
    });
  }

  QueryBuilder<Grade, Grade, QDistinct> distinctByPointsPossible() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pointsPossible');
    });
  }

  QueryBuilder<Grade, Grade, QDistinct> distinctByWeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'weight');
    });
  }
}

extension GradeQueryProperty on QueryBuilder<Grade, Grade, QQueryProperty> {
  QueryBuilder<Grade, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Grade, bool?, QQueryOperations> isCompleteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isComplete');
    });
  }

  QueryBuilder<Grade, bool?, QQueryOperations> isLateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isLate');
    });
  }

  QueryBuilder<Grade, bool?, QQueryOperations> isMissingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isMissing');
    });
  }

  QueryBuilder<Grade, double?, QQueryOperations> pointsEarnedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pointsEarned');
    });
  }

  QueryBuilder<Grade, double?, QQueryOperations> pointsPossibleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pointsPossible');
    });
  }

  QueryBuilder<Grade, int?, QQueryOperations> weightProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'weight');
    });
  }
}
