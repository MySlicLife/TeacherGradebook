// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assignment.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAssignmentCollection on Isar {
  IsarCollection<Assignment> get assignments => this.collection();
}

const AssignmentSchema = CollectionSchema(
  name: r'Assignment',
  id: 6342734841231534375,
  properties: {
    r'assignmentName': PropertySchema(
      id: 0,
      name: r'assignmentName',
      type: IsarType.string,
    ),
    r'maximumPoints': PropertySchema(
      id: 1,
      name: r'maximumPoints',
      type: IsarType.double,
    )
  },
  estimateSize: _assignmentEstimateSize,
  serialize: _assignmentSerialize,
  deserialize: _assignmentDeserialize,
  deserializeProp: _assignmentDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'grades': LinkSchema(
      id: -2247745099362504530,
      name: r'grades',
      target: r'Grade',
      single: false,
      linkName: r'assignment',
    ),
    r'courses': LinkSchema(
      id: 6952910082921581418,
      name: r'courses',
      target: r'Course',
      single: false,
    )
  },
  embeddedSchemas: {},
  getId: _assignmentGetId,
  getLinks: _assignmentGetLinks,
  attach: _assignmentAttach,
  version: '3.1.0+1',
);

int _assignmentEstimateSize(
  Assignment object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.assignmentName.length * 3;
  return bytesCount;
}

void _assignmentSerialize(
  Assignment object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.assignmentName);
  writer.writeDouble(offsets[1], object.maximumPoints);
}

Assignment _assignmentDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Assignment(
    assignmentName: reader.readString(offsets[0]),
    maximumPoints: reader.readDouble(offsets[1]),
  );
  object.id = id;
  return object;
}

P _assignmentDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _assignmentGetId(Assignment object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _assignmentGetLinks(Assignment object) {
  return [object.grades, object.courses];
}

void _assignmentAttach(IsarCollection<dynamic> col, Id id, Assignment object) {
  object.id = id;
  object.grades.attach(col, col.isar.collection<Grade>(), r'grades', id);
  object.courses.attach(col, col.isar.collection<Course>(), r'courses', id);
}

extension AssignmentQueryWhereSort
    on QueryBuilder<Assignment, Assignment, QWhere> {
  QueryBuilder<Assignment, Assignment, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AssignmentQueryWhere
    on QueryBuilder<Assignment, Assignment, QWhereClause> {
  QueryBuilder<Assignment, Assignment, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Assignment, Assignment, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterWhereClause> idBetween(
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

extension AssignmentQueryFilter
    on QueryBuilder<Assignment, Assignment, QFilterCondition> {
  QueryBuilder<Assignment, Assignment, QAfterFilterCondition>
      assignmentNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'assignmentName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition>
      assignmentNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'assignmentName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition>
      assignmentNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'assignmentName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition>
      assignmentNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'assignmentName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition>
      assignmentNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'assignmentName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition>
      assignmentNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'assignmentName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition>
      assignmentNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'assignmentName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition>
      assignmentNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'assignmentName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition>
      assignmentNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'assignmentName',
        value: '',
      ));
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition>
      assignmentNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'assignmentName',
        value: '',
      ));
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition>
      maximumPointsEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'maximumPoints',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition>
      maximumPointsGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'maximumPoints',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition>
      maximumPointsLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'maximumPoints',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition>
      maximumPointsBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'maximumPoints',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension AssignmentQueryObject
    on QueryBuilder<Assignment, Assignment, QFilterCondition> {}

extension AssignmentQueryLinks
    on QueryBuilder<Assignment, Assignment, QFilterCondition> {
  QueryBuilder<Assignment, Assignment, QAfterFilterCondition> grades(
      FilterQuery<Grade> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'grades');
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition>
      gradesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'grades', length, true, length, true);
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition> gradesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'grades', 0, true, 0, true);
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition>
      gradesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'grades', 0, false, 999999, true);
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition>
      gradesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'grades', 0, true, length, include);
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition>
      gradesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'grades', length, include, 999999, true);
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition>
      gradesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'grades', lower, includeLower, upper, includeUpper);
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition> courses(
      FilterQuery<Course> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'courses');
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition>
      coursesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'courses', length, true, length, true);
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition> coursesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'courses', 0, true, 0, true);
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition>
      coursesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'courses', 0, false, 999999, true);
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition>
      coursesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'courses', 0, true, length, include);
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition>
      coursesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'courses', length, include, 999999, true);
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterFilterCondition>
      coursesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'courses', lower, includeLower, upper, includeUpper);
    });
  }
}

extension AssignmentQuerySortBy
    on QueryBuilder<Assignment, Assignment, QSortBy> {
  QueryBuilder<Assignment, Assignment, QAfterSortBy> sortByAssignmentName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'assignmentName', Sort.asc);
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterSortBy>
      sortByAssignmentNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'assignmentName', Sort.desc);
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterSortBy> sortByMaximumPoints() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maximumPoints', Sort.asc);
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterSortBy> sortByMaximumPointsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maximumPoints', Sort.desc);
    });
  }
}

extension AssignmentQuerySortThenBy
    on QueryBuilder<Assignment, Assignment, QSortThenBy> {
  QueryBuilder<Assignment, Assignment, QAfterSortBy> thenByAssignmentName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'assignmentName', Sort.asc);
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterSortBy>
      thenByAssignmentNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'assignmentName', Sort.desc);
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterSortBy> thenByMaximumPoints() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maximumPoints', Sort.asc);
    });
  }

  QueryBuilder<Assignment, Assignment, QAfterSortBy> thenByMaximumPointsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maximumPoints', Sort.desc);
    });
  }
}

extension AssignmentQueryWhereDistinct
    on QueryBuilder<Assignment, Assignment, QDistinct> {
  QueryBuilder<Assignment, Assignment, QDistinct> distinctByAssignmentName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'assignmentName',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Assignment, Assignment, QDistinct> distinctByMaximumPoints() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'maximumPoints');
    });
  }
}

extension AssignmentQueryProperty
    on QueryBuilder<Assignment, Assignment, QQueryProperty> {
  QueryBuilder<Assignment, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Assignment, String, QQueryOperations> assignmentNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'assignmentName');
    });
  }

  QueryBuilder<Assignment, double, QQueryOperations> maximumPointsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'maximumPoints');
    });
  }
}
