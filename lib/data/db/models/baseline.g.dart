// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'baseline.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetBaselineCollection on Isar {
  IsarCollection<Baseline> get baselines => this.collection();
}

const BaselineSchema = CollectionSchema(
  name: r'Baseline',
  id: -3522003274524816052,
  properties: {
    r'avgDailyScreenTime': PropertySchema(
      id: 0,
      name: r'avgDailyScreenTime',
      type: IsarType.double,
    ),
    r'avgDistractionScore': PropertySchema(
      id: 1,
      name: r'avgDistractionScore',
      type: IsarType.double,
    ),
    r'avgFocusScore': PropertySchema(
      id: 2,
      name: r'avgFocusScore',
      type: IsarType.double,
    ),
    r'avgUnlockCount': PropertySchema(
      id: 3,
      name: r'avgUnlockCount',
      type: IsarType.long,
    ),
    r'categoryBaselinesJson': PropertySchema(
      id: 4,
      name: r'categoryBaselinesJson',
      type: IsarType.string,
    ),
    r'dataPointsCount': PropertySchema(
      id: 5,
      name: r'dataPointsCount',
      type: IsarType.long,
    ),
    r'hourlyActivityPatternJson': PropertySchema(
      id: 6,
      name: r'hourlyActivityPatternJson',
      type: IsarType.string,
    ),
    r'key': PropertySchema(
      id: 7,
      name: r'key',
      type: IsarType.string,
    ),
    r'lastUpdated': PropertySchema(
      id: 8,
      name: r'lastUpdated',
      type: IsarType.dateTime,
    ),
    r'weekdayPatternsJson': PropertySchema(
      id: 9,
      name: r'weekdayPatternsJson',
      type: IsarType.string,
    )
  },
  estimateSize: _baselineEstimateSize,
  serialize: _baselineSerialize,
  deserialize: _baselineDeserialize,
  deserializeProp: _baselineDeserializeProp,
  idName: r'id',
  indexes: {
    r'key': IndexSchema(
      id: -4906094122524121629,
      name: r'key',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'key',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'lastUpdated': IndexSchema(
      id: 8989359681631629925,
      name: r'lastUpdated',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'lastUpdated',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'dataPointsCount': IndexSchema(
      id: 8621274776439231192,
      name: r'dataPointsCount',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'dataPointsCount',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _baselineGetId,
  getLinks: _baselineGetLinks,
  attach: _baselineAttach,
  version: '3.1.0+1',
);

int _baselineEstimateSize(
  Baseline object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.categoryBaselinesJson;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.hourlyActivityPatternJson;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.key.length * 3;
  {
    final value = object.weekdayPatternsJson;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _baselineSerialize(
  Baseline object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.avgDailyScreenTime);
  writer.writeDouble(offsets[1], object.avgDistractionScore);
  writer.writeDouble(offsets[2], object.avgFocusScore);
  writer.writeLong(offsets[3], object.avgUnlockCount);
  writer.writeString(offsets[4], object.categoryBaselinesJson);
  writer.writeLong(offsets[5], object.dataPointsCount);
  writer.writeString(offsets[6], object.hourlyActivityPatternJson);
  writer.writeString(offsets[7], object.key);
  writer.writeDateTime(offsets[8], object.lastUpdated);
  writer.writeString(offsets[9], object.weekdayPatternsJson);
}

Baseline _baselineDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Baseline();
  object.avgDailyScreenTime = reader.readDouble(offsets[0]);
  object.avgDistractionScore = reader.readDouble(offsets[1]);
  object.avgFocusScore = reader.readDouble(offsets[2]);
  object.avgUnlockCount = reader.readLong(offsets[3]);
  object.categoryBaselinesJson = reader.readStringOrNull(offsets[4]);
  object.dataPointsCount = reader.readLong(offsets[5]);
  object.hourlyActivityPatternJson = reader.readStringOrNull(offsets[6]);
  object.id = id;
  object.key = reader.readString(offsets[7]);
  object.lastUpdated = reader.readDateTime(offsets[8]);
  object.weekdayPatternsJson = reader.readStringOrNull(offsets[9]);
  return object;
}

P _baselineDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readDouble(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readDateTime(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _baselineGetId(Baseline object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _baselineGetLinks(Baseline object) {
  return [];
}

void _baselineAttach(IsarCollection<dynamic> col, Id id, Baseline object) {
  object.id = id;
}

extension BaselineByIndex on IsarCollection<Baseline> {
  Future<Baseline?> getByKey(String key) {
    return getByIndex(r'key', [key]);
  }

  Baseline? getByKeySync(String key) {
    return getByIndexSync(r'key', [key]);
  }

  Future<bool> deleteByKey(String key) {
    return deleteByIndex(r'key', [key]);
  }

  bool deleteByKeySync(String key) {
    return deleteByIndexSync(r'key', [key]);
  }

  Future<List<Baseline?>> getAllByKey(List<String> keyValues) {
    final values = keyValues.map((e) => [e]).toList();
    return getAllByIndex(r'key', values);
  }

  List<Baseline?> getAllByKeySync(List<String> keyValues) {
    final values = keyValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'key', values);
  }

  Future<int> deleteAllByKey(List<String> keyValues) {
    final values = keyValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'key', values);
  }

  int deleteAllByKeySync(List<String> keyValues) {
    final values = keyValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'key', values);
  }

  Future<Id> putByKey(Baseline object) {
    return putByIndex(r'key', object);
  }

  Id putByKeySync(Baseline object, {bool saveLinks = true}) {
    return putByIndexSync(r'key', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByKey(List<Baseline> objects) {
    return putAllByIndex(r'key', objects);
  }

  List<Id> putAllByKeySync(List<Baseline> objects, {bool saveLinks = true}) {
    return putAllByIndexSync(r'key', objects, saveLinks: saveLinks);
  }
}

extension BaselineQueryWhereSort on QueryBuilder<Baseline, Baseline, QWhere> {
  QueryBuilder<Baseline, Baseline, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterWhere> anyLastUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'lastUpdated'),
      );
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterWhere> anyDataPointsCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'dataPointsCount'),
      );
    });
  }
}

extension BaselineQueryWhere on QueryBuilder<Baseline, Baseline, QWhereClause> {
  QueryBuilder<Baseline, Baseline, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Baseline, Baseline, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterWhereClause> idBetween(
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

  QueryBuilder<Baseline, Baseline, QAfterWhereClause> keyEqualTo(String key) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'key',
        value: [key],
      ));
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterWhereClause> keyNotEqualTo(
      String key) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'key',
              lower: [],
              upper: [key],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'key',
              lower: [key],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'key',
              lower: [key],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'key',
              lower: [],
              upper: [key],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterWhereClause> lastUpdatedEqualTo(
      DateTime lastUpdated) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'lastUpdated',
        value: [lastUpdated],
      ));
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterWhereClause> lastUpdatedNotEqualTo(
      DateTime lastUpdated) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lastUpdated',
              lower: [],
              upper: [lastUpdated],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lastUpdated',
              lower: [lastUpdated],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lastUpdated',
              lower: [lastUpdated],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lastUpdated',
              lower: [],
              upper: [lastUpdated],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterWhereClause> lastUpdatedGreaterThan(
    DateTime lastUpdated, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'lastUpdated',
        lower: [lastUpdated],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterWhereClause> lastUpdatedLessThan(
    DateTime lastUpdated, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'lastUpdated',
        lower: [],
        upper: [lastUpdated],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterWhereClause> lastUpdatedBetween(
    DateTime lowerLastUpdated,
    DateTime upperLastUpdated, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'lastUpdated',
        lower: [lowerLastUpdated],
        includeLower: includeLower,
        upper: [upperLastUpdated],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterWhereClause> dataPointsCountEqualTo(
      int dataPointsCount) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'dataPointsCount',
        value: [dataPointsCount],
      ));
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterWhereClause> dataPointsCountNotEqualTo(
      int dataPointsCount) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'dataPointsCount',
              lower: [],
              upper: [dataPointsCount],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'dataPointsCount',
              lower: [dataPointsCount],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'dataPointsCount',
              lower: [dataPointsCount],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'dataPointsCount',
              lower: [],
              upper: [dataPointsCount],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterWhereClause>
      dataPointsCountGreaterThan(
    int dataPointsCount, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'dataPointsCount',
        lower: [dataPointsCount],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterWhereClause> dataPointsCountLessThan(
    int dataPointsCount, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'dataPointsCount',
        lower: [],
        upper: [dataPointsCount],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterWhereClause> dataPointsCountBetween(
    int lowerDataPointsCount,
    int upperDataPointsCount, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'dataPointsCount',
        lower: [lowerDataPointsCount],
        includeLower: includeLower,
        upper: [upperDataPointsCount],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension BaselineQueryFilter
    on QueryBuilder<Baseline, Baseline, QFilterCondition> {
  QueryBuilder<Baseline, Baseline, QAfterFilterCondition>
      avgDailyScreenTimeEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'avgDailyScreenTime',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterFilterCondition>
      avgDailyScreenTimeGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'avgDailyScreenTime',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterFilterCondition>
      avgDailyScreenTimeLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'avgDailyScreenTime',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterFilterCondition>
      avgDailyScreenTimeBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'avgDailyScreenTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterFilterCondition>
      avgDistractionScoreEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'avgDistractionScore',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterFilterCondition>
      avgDistractionScoreGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'avgDistractionScore',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterFilterCondition>
      avgDistractionScoreLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'avgDistractionScore',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterFilterCondition>
      avgDistractionScoreBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'avgDistractionScore',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterFilterCondition> avgFocusScoreEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'avgFocusScore',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterFilterCondition>
      avgFocusScoreGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'avgFocusScore',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterFilterCondition> avgFocusScoreLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'avgFocusScore',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterFilterCondition> avgFocusScoreBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'avgFocusScore',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterFilterCondition> avgUnlockCountEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'avgUnlockCount',
        value: value,
      ));
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterFilterCondition>
      avgUnlockCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'avgUnlockCount',
        value: value,
      ));
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterFilterCondition>
      avgUnlockCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'avgUnlockCount',
        value: value,
      ));
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterFilterCondition> avgUnlockCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'avgUnlockCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterFilterCondition>
      categoryBaselinesJsonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'categoryBaselinesJson',
      ));
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterFilterCondition>
      categoryBaselinesJsonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'categoryBaselinesJson',
      ));
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterFilterCondition>
      categoryBaselinesJsonEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'categoryBaselinesJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterFilterCondition>
      categoryBaselinesJsonGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'categoryBaselinesJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterFilterCondition>
      categoryBaselinesJsonLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'categoryBaselinesJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterFilterCondition>
      categoryBaselinesJsonBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'categoryBaselinesJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterFilterCondition>
      categoryBaselinesJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'categoryBaselinesJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterFilterCondition>
      categoryBaselinesJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'categoryBaselinesJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterFilterCondition>
      categoryBaselinesJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'categoryBaselinesJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterFilterCondition>
      categoryBaselinesJsonMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'categoryBaselinesJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterFilterCondition>
      categoryBaselinesJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'categoryBaselinesJson',
        value: '',
      ));
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterFilterCondition>
      categoryBaselinesJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'categoryBaselinesJson',
        value: '',
      ));
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterFilterCondition>
      dataPointsCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dataPointsCount',
        value: value,
      ));
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterFilterCondition>
      dataPointsCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dataPointsCount',
        value: value,
      ));
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterFilterCondition>
      dataPointsCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dataPointsCount',
        value: value,
      ));
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterFilterCondition>
      dataPointsCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dataPointsCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterFilterCondition>
      hourlyActivityPatternJsonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'hourlyActivityPatternJson',
      ));
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterFilterCondition>
      hourlyActivityPatternJsonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'hourlyActivityPatternJson',
      ));
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterFilterCondition>
      hourlyActivityPatternJsonEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hourlyActivityPatternJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterFilterCondition>
      hourlyActivityPatternJsonGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'hourlyActivityPatternJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterFilterCondition>
      hourlyActivityPatternJsonLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'hourlyActivityPatternJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterFilterCondition>
      hourlyActivityPatternJsonBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'hourlyActivityPatternJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterFilterCondition>
      hourlyActivityPatternJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'hourlyActivityPatternJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterFilterCondition>
      hourlyActivityPatternJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'hourlyActivityPatternJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterFilterCondition>
      hourlyActivityPatternJsonContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'hourlyActivityPatternJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterFilterCondition>
      hourlyActivityPatternJsonMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'hourlyActivityPatternJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterFilterCondition>
      hourlyActivityPatternJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hourlyActivityPatternJson',
        value: '',
      ));
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterFilterCondition>
      hourlyActivityPatternJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'hourlyActivityPatternJson',
        value: '',
      ));
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Baseline, Baseline, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Baseline, Baseline, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Baseline, Baseline, QAfterFilterCondition> keyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'key',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterFilterCondition> keyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'key',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterFilterCondition> keyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'key',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterFilterCondition> keyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'key',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterFilterCondition> keyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'key',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterFilterCondition> keyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'key',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterFilterCondition> keyContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'key',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterFilterCondition> keyMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'key',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterFilterCondition> keyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'key',
        value: '',
      ));
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterFilterCondition> keyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'key',
        value: '',
      ));
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterFilterCondition> lastUpdatedEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastUpdated',
        value: value,
      ));
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterFilterCondition>
      lastUpdatedGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastUpdated',
        value: value,
      ));
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterFilterCondition> lastUpdatedLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastUpdated',
        value: value,
      ));
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterFilterCondition> lastUpdatedBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastUpdated',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterFilterCondition>
      weekdayPatternsJsonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'weekdayPatternsJson',
      ));
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterFilterCondition>
      weekdayPatternsJsonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'weekdayPatternsJson',
      ));
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterFilterCondition>
      weekdayPatternsJsonEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'weekdayPatternsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterFilterCondition>
      weekdayPatternsJsonGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'weekdayPatternsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterFilterCondition>
      weekdayPatternsJsonLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'weekdayPatternsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterFilterCondition>
      weekdayPatternsJsonBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'weekdayPatternsJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterFilterCondition>
      weekdayPatternsJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'weekdayPatternsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterFilterCondition>
      weekdayPatternsJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'weekdayPatternsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterFilterCondition>
      weekdayPatternsJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'weekdayPatternsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterFilterCondition>
      weekdayPatternsJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'weekdayPatternsJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterFilterCondition>
      weekdayPatternsJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'weekdayPatternsJson',
        value: '',
      ));
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterFilterCondition>
      weekdayPatternsJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'weekdayPatternsJson',
        value: '',
      ));
    });
  }
}

extension BaselineQueryObject
    on QueryBuilder<Baseline, Baseline, QFilterCondition> {}

extension BaselineQueryLinks
    on QueryBuilder<Baseline, Baseline, QFilterCondition> {}

extension BaselineQuerySortBy on QueryBuilder<Baseline, Baseline, QSortBy> {
  QueryBuilder<Baseline, Baseline, QAfterSortBy> sortByAvgDailyScreenTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avgDailyScreenTime', Sort.asc);
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterSortBy>
      sortByAvgDailyScreenTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avgDailyScreenTime', Sort.desc);
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterSortBy> sortByAvgDistractionScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avgDistractionScore', Sort.asc);
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterSortBy>
      sortByAvgDistractionScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avgDistractionScore', Sort.desc);
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterSortBy> sortByAvgFocusScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avgFocusScore', Sort.asc);
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterSortBy> sortByAvgFocusScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avgFocusScore', Sort.desc);
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterSortBy> sortByAvgUnlockCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avgUnlockCount', Sort.asc);
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterSortBy> sortByAvgUnlockCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avgUnlockCount', Sort.desc);
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterSortBy> sortByCategoryBaselinesJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryBaselinesJson', Sort.asc);
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterSortBy>
      sortByCategoryBaselinesJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryBaselinesJson', Sort.desc);
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterSortBy> sortByDataPointsCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataPointsCount', Sort.asc);
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterSortBy> sortByDataPointsCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataPointsCount', Sort.desc);
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterSortBy>
      sortByHourlyActivityPatternJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hourlyActivityPatternJson', Sort.asc);
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterSortBy>
      sortByHourlyActivityPatternJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hourlyActivityPatternJson', Sort.desc);
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterSortBy> sortByKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.asc);
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterSortBy> sortByKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.desc);
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterSortBy> sortByLastUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.asc);
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterSortBy> sortByLastUpdatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.desc);
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterSortBy> sortByWeekdayPatternsJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weekdayPatternsJson', Sort.asc);
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterSortBy>
      sortByWeekdayPatternsJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weekdayPatternsJson', Sort.desc);
    });
  }
}

extension BaselineQuerySortThenBy
    on QueryBuilder<Baseline, Baseline, QSortThenBy> {
  QueryBuilder<Baseline, Baseline, QAfterSortBy> thenByAvgDailyScreenTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avgDailyScreenTime', Sort.asc);
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterSortBy>
      thenByAvgDailyScreenTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avgDailyScreenTime', Sort.desc);
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterSortBy> thenByAvgDistractionScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avgDistractionScore', Sort.asc);
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterSortBy>
      thenByAvgDistractionScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avgDistractionScore', Sort.desc);
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterSortBy> thenByAvgFocusScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avgFocusScore', Sort.asc);
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterSortBy> thenByAvgFocusScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avgFocusScore', Sort.desc);
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterSortBy> thenByAvgUnlockCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avgUnlockCount', Sort.asc);
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterSortBy> thenByAvgUnlockCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avgUnlockCount', Sort.desc);
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterSortBy> thenByCategoryBaselinesJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryBaselinesJson', Sort.asc);
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterSortBy>
      thenByCategoryBaselinesJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryBaselinesJson', Sort.desc);
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterSortBy> thenByDataPointsCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataPointsCount', Sort.asc);
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterSortBy> thenByDataPointsCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataPointsCount', Sort.desc);
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterSortBy>
      thenByHourlyActivityPatternJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hourlyActivityPatternJson', Sort.asc);
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterSortBy>
      thenByHourlyActivityPatternJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hourlyActivityPatternJson', Sort.desc);
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterSortBy> thenByKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.asc);
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterSortBy> thenByKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.desc);
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterSortBy> thenByLastUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.asc);
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterSortBy> thenByLastUpdatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.desc);
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterSortBy> thenByWeekdayPatternsJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weekdayPatternsJson', Sort.asc);
    });
  }

  QueryBuilder<Baseline, Baseline, QAfterSortBy>
      thenByWeekdayPatternsJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weekdayPatternsJson', Sort.desc);
    });
  }
}

extension BaselineQueryWhereDistinct
    on QueryBuilder<Baseline, Baseline, QDistinct> {
  QueryBuilder<Baseline, Baseline, QDistinct> distinctByAvgDailyScreenTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'avgDailyScreenTime');
    });
  }

  QueryBuilder<Baseline, Baseline, QDistinct> distinctByAvgDistractionScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'avgDistractionScore');
    });
  }

  QueryBuilder<Baseline, Baseline, QDistinct> distinctByAvgFocusScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'avgFocusScore');
    });
  }

  QueryBuilder<Baseline, Baseline, QDistinct> distinctByAvgUnlockCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'avgUnlockCount');
    });
  }

  QueryBuilder<Baseline, Baseline, QDistinct> distinctByCategoryBaselinesJson(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'categoryBaselinesJson',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Baseline, Baseline, QDistinct> distinctByDataPointsCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dataPointsCount');
    });
  }

  QueryBuilder<Baseline, Baseline, QDistinct>
      distinctByHourlyActivityPatternJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hourlyActivityPatternJson',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Baseline, Baseline, QDistinct> distinctByKey(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'key', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Baseline, Baseline, QDistinct> distinctByLastUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastUpdated');
    });
  }

  QueryBuilder<Baseline, Baseline, QDistinct> distinctByWeekdayPatternsJson(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'weekdayPatternsJson',
          caseSensitive: caseSensitive);
    });
  }
}

extension BaselineQueryProperty
    on QueryBuilder<Baseline, Baseline, QQueryProperty> {
  QueryBuilder<Baseline, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Baseline, double, QQueryOperations>
      avgDailyScreenTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'avgDailyScreenTime');
    });
  }

  QueryBuilder<Baseline, double, QQueryOperations>
      avgDistractionScoreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'avgDistractionScore');
    });
  }

  QueryBuilder<Baseline, double, QQueryOperations> avgFocusScoreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'avgFocusScore');
    });
  }

  QueryBuilder<Baseline, int, QQueryOperations> avgUnlockCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'avgUnlockCount');
    });
  }

  QueryBuilder<Baseline, String?, QQueryOperations>
      categoryBaselinesJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'categoryBaselinesJson');
    });
  }

  QueryBuilder<Baseline, int, QQueryOperations> dataPointsCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dataPointsCount');
    });
  }

  QueryBuilder<Baseline, String?, QQueryOperations>
      hourlyActivityPatternJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hourlyActivityPatternJson');
    });
  }

  QueryBuilder<Baseline, String, QQueryOperations> keyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'key');
    });
  }

  QueryBuilder<Baseline, DateTime, QQueryOperations> lastUpdatedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastUpdated');
    });
  }

  QueryBuilder<Baseline, String?, QQueryOperations>
      weekdayPatternsJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'weekdayPatternsJson');
    });
  }
}
