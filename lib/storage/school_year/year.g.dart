// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'year.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetYearCollection on Isar {
  IsarCollection<Year> get years => this.collection();
}

const YearSchema = CollectionSchema(
  name: r'Year',
  id: 8541492288853816011,
  properties: {
    r'year': PropertySchema(
      id: 0,
      name: r'year',
      type: IsarType.string,
    ),
    r'yearColorId': PropertySchema(
      id: 1,
      name: r'yearColorId',
      type: IsarType.long,
    ),
    r'yearColorInt': PropertySchema(
      id: 2,
      name: r'yearColorInt',
      type: IsarType.long,
    )
  },
  estimateSize: _yearEstimateSize,
  serialize: _yearSerialize,
  deserialize: _yearDeserialize,
  deserializeProp: _yearDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'courses': LinkSchema(
      id: 5447796699974793409,
      name: r'courses',
      target: r'Course',
      single: false,
      linkName: r'schoolYear',
    )
  },
  embeddedSchemas: {},
  getId: _yearGetId,
  getLinks: _yearGetLinks,
  attach: _yearAttach,
  version: '3.1.0+1',
);

int _yearEstimateSize(
  Year object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.year.length * 3;
  return bytesCount;
}

void _yearSerialize(
  Year object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.year);
  writer.writeLong(offsets[1], object.yearColorId);
  writer.writeLong(offsets[2], object.yearColorInt);
}

Year _yearDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Year(
    year: reader.readString(offsets[0]),
    yearColorId: reader.readLong(offsets[1]),
    yearColorInt: reader.readLong(offsets[2]),
  );
  object.id = id;
  return object;
}

P _yearDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _yearGetId(Year object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _yearGetLinks(Year object) {
  return [object.courses];
}

void _yearAttach(IsarCollection<dynamic> col, Id id, Year object) {
  object.id = id;
  object.courses.attach(col, col.isar.collection<Course>(), r'courses', id);
}

extension YearQueryWhereSort on QueryBuilder<Year, Year, QWhere> {
  QueryBuilder<Year, Year, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension YearQueryWhere on QueryBuilder<Year, Year, QWhereClause> {
  QueryBuilder<Year, Year, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Year, Year, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Year, Year, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Year, Year, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Year, Year, QAfterWhereClause> idBetween(
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

extension YearQueryFilter on QueryBuilder<Year, Year, QFilterCondition> {
  QueryBuilder<Year, Year, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Year, Year, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Year, Year, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Year, Year, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Year, Year, QAfterFilterCondition> yearEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'year',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Year, Year, QAfterFilterCondition> yearGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'year',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Year, Year, QAfterFilterCondition> yearLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'year',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Year, Year, QAfterFilterCondition> yearBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'year',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Year, Year, QAfterFilterCondition> yearStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'year',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Year, Year, QAfterFilterCondition> yearEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'year',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Year, Year, QAfterFilterCondition> yearContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'year',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Year, Year, QAfterFilterCondition> yearMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'year',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Year, Year, QAfterFilterCondition> yearIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'year',
        value: '',
      ));
    });
  }

  QueryBuilder<Year, Year, QAfterFilterCondition> yearIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'year',
        value: '',
      ));
    });
  }

  QueryBuilder<Year, Year, QAfterFilterCondition> yearColorIdEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'yearColorId',
        value: value,
      ));
    });
  }

  QueryBuilder<Year, Year, QAfterFilterCondition> yearColorIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'yearColorId',
        value: value,
      ));
    });
  }

  QueryBuilder<Year, Year, QAfterFilterCondition> yearColorIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'yearColorId',
        value: value,
      ));
    });
  }

  QueryBuilder<Year, Year, QAfterFilterCondition> yearColorIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'yearColorId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Year, Year, QAfterFilterCondition> yearColorIntEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'yearColorInt',
        value: value,
      ));
    });
  }

  QueryBuilder<Year, Year, QAfterFilterCondition> yearColorIntGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'yearColorInt',
        value: value,
      ));
    });
  }

  QueryBuilder<Year, Year, QAfterFilterCondition> yearColorIntLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'yearColorInt',
        value: value,
      ));
    });
  }

  QueryBuilder<Year, Year, QAfterFilterCondition> yearColorIntBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'yearColorInt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension YearQueryObject on QueryBuilder<Year, Year, QFilterCondition> {}

extension YearQueryLinks on QueryBuilder<Year, Year, QFilterCondition> {
  QueryBuilder<Year, Year, QAfterFilterCondition> courses(
      FilterQuery<Course> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'courses');
    });
  }

  QueryBuilder<Year, Year, QAfterFilterCondition> coursesLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'courses', length, true, length, true);
    });
  }

  QueryBuilder<Year, Year, QAfterFilterCondition> coursesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'courses', 0, true, 0, true);
    });
  }

  QueryBuilder<Year, Year, QAfterFilterCondition> coursesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'courses', 0, false, 999999, true);
    });
  }

  QueryBuilder<Year, Year, QAfterFilterCondition> coursesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'courses', 0, true, length, include);
    });
  }

  QueryBuilder<Year, Year, QAfterFilterCondition> coursesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'courses', length, include, 999999, true);
    });
  }

  QueryBuilder<Year, Year, QAfterFilterCondition> coursesLengthBetween(
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

extension YearQuerySortBy on QueryBuilder<Year, Year, QSortBy> {
  QueryBuilder<Year, Year, QAfterSortBy> sortByYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'year', Sort.asc);
    });
  }

  QueryBuilder<Year, Year, QAfterSortBy> sortByYearDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'year', Sort.desc);
    });
  }

  QueryBuilder<Year, Year, QAfterSortBy> sortByYearColorId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'yearColorId', Sort.asc);
    });
  }

  QueryBuilder<Year, Year, QAfterSortBy> sortByYearColorIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'yearColorId', Sort.desc);
    });
  }

  QueryBuilder<Year, Year, QAfterSortBy> sortByYearColorInt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'yearColorInt', Sort.asc);
    });
  }

  QueryBuilder<Year, Year, QAfterSortBy> sortByYearColorIntDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'yearColorInt', Sort.desc);
    });
  }
}

extension YearQuerySortThenBy on QueryBuilder<Year, Year, QSortThenBy> {
  QueryBuilder<Year, Year, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Year, Year, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Year, Year, QAfterSortBy> thenByYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'year', Sort.asc);
    });
  }

  QueryBuilder<Year, Year, QAfterSortBy> thenByYearDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'year', Sort.desc);
    });
  }

  QueryBuilder<Year, Year, QAfterSortBy> thenByYearColorId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'yearColorId', Sort.asc);
    });
  }

  QueryBuilder<Year, Year, QAfterSortBy> thenByYearColorIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'yearColorId', Sort.desc);
    });
  }

  QueryBuilder<Year, Year, QAfterSortBy> thenByYearColorInt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'yearColorInt', Sort.asc);
    });
  }

  QueryBuilder<Year, Year, QAfterSortBy> thenByYearColorIntDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'yearColorInt', Sort.desc);
    });
  }
}

extension YearQueryWhereDistinct on QueryBuilder<Year, Year, QDistinct> {
  QueryBuilder<Year, Year, QDistinct> distinctByYear(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'year', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Year, Year, QDistinct> distinctByYearColorId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'yearColorId');
    });
  }

  QueryBuilder<Year, Year, QDistinct> distinctByYearColorInt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'yearColorInt');
    });
  }
}

extension YearQueryProperty on QueryBuilder<Year, Year, QQueryProperty> {
  QueryBuilder<Year, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Year, String, QQueryOperations> yearProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'year');
    });
  }

  QueryBuilder<Year, int, QQueryOperations> yearColorIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'yearColorId');
    });
  }

  QueryBuilder<Year, int, QQueryOperations> yearColorIntProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'yearColorInt');
    });
  }
}
