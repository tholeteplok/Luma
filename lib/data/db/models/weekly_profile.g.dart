// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weekly_profile.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetWeeklyProfileCollection on Isar {
  IsarCollection<WeeklyProfile> get weeklyProfiles => this.collection();
}

const WeeklyProfileSchema = CollectionSchema(
  name: r'WeeklyProfile',
  id: 8741056284145366870,
  properties: {
    r'averageDailyScreenTimeSeconds': PropertySchema(
      id: 0,
      name: r'averageDailyScreenTimeSeconds',
      type: IsarType.long,
    ),
    r'averageFocusScore': PropertySchema(
      id: 1,
      name: r'averageFocusScore',
      type: IsarType.double,
    ),
    r'createdAt': PropertySchema(
      id: 2,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'dailyPatternsJson': PropertySchema(
      id: 3,
      name: r'dailyPatternsJson',
      type: IsarType.string,
    ),
    r'dayCount': PropertySchema(
      id: 4,
      name: r'dayCount',
      type: IsarType.long,
    ),
    r'expiresAt': PropertySchema(
      id: 5,
      name: r'expiresAt',
      type: IsarType.dateTime,
    ),
    r'lowestActivityDay': PropertySchema(
      id: 6,
      name: r'lowestActivityDay',
      type: IsarType.string,
    ),
    r'peakActivityDay': PropertySchema(
      id: 7,
      name: r'peakActivityDay',
      type: IsarType.string,
    ),
    r'topAppsJson': PropertySchema(
      id: 8,
      name: r'topAppsJson',
      type: IsarType.string,
    ),
    r'topDistractions': PropertySchema(
      id: 9,
      name: r'topDistractions',
      type: IsarType.stringList,
    ),
    r'totalDistractions': PropertySchema(
      id: 10,
      name: r'totalDistractions',
      type: IsarType.long,
    ),
    r'totalScreenTimeSeconds': PropertySchema(
      id: 11,
      name: r'totalScreenTimeSeconds',
      type: IsarType.long,
    ),
    r'weekStart': PropertySchema(
      id: 12,
      name: r'weekStart',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _weeklyProfileEstimateSize,
  serialize: _weeklyProfileSerialize,
  deserialize: _weeklyProfileDeserialize,
  deserializeProp: _weeklyProfileDeserializeProp,
  idName: r'id',
  indexes: {
    r'weekStart': IndexSchema(
      id: 6730028936290595099,
      name: r'weekStart',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'weekStart',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'createdAt': IndexSchema(
      id: -3433535483987302584,
      name: r'createdAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'createdAt',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'expiresAt': IndexSchema(
      id: 4994901953235663716,
      name: r'expiresAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'expiresAt',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _weeklyProfileGetId,
  getLinks: _weeklyProfileGetLinks,
  attach: _weeklyProfileAttach,
  version: '3.1.0+1',
);

int _weeklyProfileEstimateSize(
  WeeklyProfile object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.dailyPatternsJson;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.lowestActivityDay.length * 3;
  bytesCount += 3 + object.peakActivityDay.length * 3;
  {
    final value = object.topAppsJson;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.topDistractions.length * 3;
  {
    for (var i = 0; i < object.topDistractions.length; i++) {
      final value = object.topDistractions[i];
      bytesCount += value.length * 3;
    }
  }
  return bytesCount;
}

void _weeklyProfileSerialize(
  WeeklyProfile object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.averageDailyScreenTimeSeconds);
  writer.writeDouble(offsets[1], object.averageFocusScore);
  writer.writeDateTime(offsets[2], object.createdAt);
  writer.writeString(offsets[3], object.dailyPatternsJson);
  writer.writeLong(offsets[4], object.dayCount);
  writer.writeDateTime(offsets[5], object.expiresAt);
  writer.writeString(offsets[6], object.lowestActivityDay);
  writer.writeString(offsets[7], object.peakActivityDay);
  writer.writeString(offsets[8], object.topAppsJson);
  writer.writeStringList(offsets[9], object.topDistractions);
  writer.writeLong(offsets[10], object.totalDistractions);
  writer.writeLong(offsets[11], object.totalScreenTimeSeconds);
  writer.writeDateTime(offsets[12], object.weekStart);
}

WeeklyProfile _weeklyProfileDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = WeeklyProfile(
    averageDailyScreenTimeSeconds: reader.readLong(offsets[0]),
    averageFocusScore: reader.readDouble(offsets[1]),
    createdAt: reader.readDateTimeOrNull(offsets[2]),
    dayCount: reader.readLong(offsets[4]),
    expiresAt: reader.readDateTimeOrNull(offsets[5]),
    lowestActivityDay: reader.readStringOrNull(offsets[6]) ?? '',
    peakActivityDay: reader.readStringOrNull(offsets[7]) ?? '',
    topDistractions: reader.readStringList(offsets[9]) ?? const [],
    totalDistractions: reader.readLong(offsets[10]),
    totalScreenTimeSeconds: reader.readLong(offsets[11]),
    weekStart: reader.readDateTime(offsets[12]),
  );
  object.dailyPatternsJson = reader.readStringOrNull(offsets[3]);
  object.id = id;
  object.topAppsJson = reader.readStringOrNull(offsets[8]);
  return object;
}

P _weeklyProfileDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 7:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readStringList(offset) ?? const []) as P;
    case 10:
      return (reader.readLong(offset)) as P;
    case 11:
      return (reader.readLong(offset)) as P;
    case 12:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _weeklyProfileGetId(WeeklyProfile object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _weeklyProfileGetLinks(WeeklyProfile object) {
  return [];
}

void _weeklyProfileAttach(
    IsarCollection<dynamic> col, Id id, WeeklyProfile object) {
  object.id = id;
}

extension WeeklyProfileByIndex on IsarCollection<WeeklyProfile> {
  Future<WeeklyProfile?> getByWeekStart(DateTime weekStart) {
    return getByIndex(r'weekStart', [weekStart]);
  }

  WeeklyProfile? getByWeekStartSync(DateTime weekStart) {
    return getByIndexSync(r'weekStart', [weekStart]);
  }

  Future<bool> deleteByWeekStart(DateTime weekStart) {
    return deleteByIndex(r'weekStart', [weekStart]);
  }

  bool deleteByWeekStartSync(DateTime weekStart) {
    return deleteByIndexSync(r'weekStart', [weekStart]);
  }

  Future<List<WeeklyProfile?>> getAllByWeekStart(
      List<DateTime> weekStartValues) {
    final values = weekStartValues.map((e) => [e]).toList();
    return getAllByIndex(r'weekStart', values);
  }

  List<WeeklyProfile?> getAllByWeekStartSync(List<DateTime> weekStartValues) {
    final values = weekStartValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'weekStart', values);
  }

  Future<int> deleteAllByWeekStart(List<DateTime> weekStartValues) {
    final values = weekStartValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'weekStart', values);
  }

  int deleteAllByWeekStartSync(List<DateTime> weekStartValues) {
    final values = weekStartValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'weekStart', values);
  }

  Future<Id> putByWeekStart(WeeklyProfile object) {
    return putByIndex(r'weekStart', object);
  }

  Id putByWeekStartSync(WeeklyProfile object, {bool saveLinks = true}) {
    return putByIndexSync(r'weekStart', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByWeekStart(List<WeeklyProfile> objects) {
    return putAllByIndex(r'weekStart', objects);
  }

  List<Id> putAllByWeekStartSync(List<WeeklyProfile> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'weekStart', objects, saveLinks: saveLinks);
  }
}

extension WeeklyProfileQueryWhereSort
    on QueryBuilder<WeeklyProfile, WeeklyProfile, QWhere> {
  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterWhere> anyWeekStart() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'weekStart'),
      );
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterWhere> anyCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'createdAt'),
      );
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterWhere> anyExpiresAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'expiresAt'),
      );
    });
  }
}

extension WeeklyProfileQueryWhere
    on QueryBuilder<WeeklyProfile, WeeklyProfile, QWhereClause> {
  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterWhereClause> idBetween(
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

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterWhereClause>
      weekStartEqualTo(DateTime weekStart) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'weekStart',
        value: [weekStart],
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterWhereClause>
      weekStartNotEqualTo(DateTime weekStart) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'weekStart',
              lower: [],
              upper: [weekStart],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'weekStart',
              lower: [weekStart],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'weekStart',
              lower: [weekStart],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'weekStart',
              lower: [],
              upper: [weekStart],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterWhereClause>
      weekStartGreaterThan(
    DateTime weekStart, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'weekStart',
        lower: [weekStart],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterWhereClause>
      weekStartLessThan(
    DateTime weekStart, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'weekStart',
        lower: [],
        upper: [weekStart],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterWhereClause>
      weekStartBetween(
    DateTime lowerWeekStart,
    DateTime upperWeekStart, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'weekStart',
        lower: [lowerWeekStart],
        includeLower: includeLower,
        upper: [upperWeekStart],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterWhereClause>
      createdAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'createdAt',
        value: [null],
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterWhereClause>
      createdAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'createdAt',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterWhereClause>
      createdAtEqualTo(DateTime? createdAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'createdAt',
        value: [createdAt],
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterWhereClause>
      createdAtNotEqualTo(DateTime? createdAt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdAt',
              lower: [],
              upper: [createdAt],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdAt',
              lower: [createdAt],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdAt',
              lower: [createdAt],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdAt',
              lower: [],
              upper: [createdAt],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterWhereClause>
      createdAtGreaterThan(
    DateTime? createdAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'createdAt',
        lower: [createdAt],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterWhereClause>
      createdAtLessThan(
    DateTime? createdAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'createdAt',
        lower: [],
        upper: [createdAt],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterWhereClause>
      createdAtBetween(
    DateTime? lowerCreatedAt,
    DateTime? upperCreatedAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'createdAt',
        lower: [lowerCreatedAt],
        includeLower: includeLower,
        upper: [upperCreatedAt],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterWhereClause>
      expiresAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'expiresAt',
        value: [null],
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterWhereClause>
      expiresAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'expiresAt',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterWhereClause>
      expiresAtEqualTo(DateTime? expiresAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'expiresAt',
        value: [expiresAt],
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterWhereClause>
      expiresAtNotEqualTo(DateTime? expiresAt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'expiresAt',
              lower: [],
              upper: [expiresAt],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'expiresAt',
              lower: [expiresAt],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'expiresAt',
              lower: [expiresAt],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'expiresAt',
              lower: [],
              upper: [expiresAt],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterWhereClause>
      expiresAtGreaterThan(
    DateTime? expiresAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'expiresAt',
        lower: [expiresAt],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterWhereClause>
      expiresAtLessThan(
    DateTime? expiresAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'expiresAt',
        lower: [],
        upper: [expiresAt],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterWhereClause>
      expiresAtBetween(
    DateTime? lowerExpiresAt,
    DateTime? upperExpiresAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'expiresAt',
        lower: [lowerExpiresAt],
        includeLower: includeLower,
        upper: [upperExpiresAt],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension WeeklyProfileQueryFilter
    on QueryBuilder<WeeklyProfile, WeeklyProfile, QFilterCondition> {
  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      averageDailyScreenTimeSecondsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'averageDailyScreenTimeSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      averageDailyScreenTimeSecondsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'averageDailyScreenTimeSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      averageDailyScreenTimeSecondsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'averageDailyScreenTimeSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      averageDailyScreenTimeSecondsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'averageDailyScreenTimeSeconds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      averageFocusScoreEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'averageFocusScore',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      averageFocusScoreGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'averageFocusScore',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      averageFocusScoreLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'averageFocusScore',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      averageFocusScoreBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'averageFocusScore',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      createdAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'createdAt',
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      createdAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'createdAt',
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      createdAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      createdAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      createdAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      dailyPatternsJsonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dailyPatternsJson',
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      dailyPatternsJsonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dailyPatternsJson',
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      dailyPatternsJsonEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dailyPatternsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      dailyPatternsJsonGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dailyPatternsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      dailyPatternsJsonLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dailyPatternsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      dailyPatternsJsonBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dailyPatternsJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      dailyPatternsJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'dailyPatternsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      dailyPatternsJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'dailyPatternsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      dailyPatternsJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'dailyPatternsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      dailyPatternsJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'dailyPatternsJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      dailyPatternsJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dailyPatternsJson',
        value: '',
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      dailyPatternsJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'dailyPatternsJson',
        value: '',
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      dayCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dayCount',
        value: value,
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      dayCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dayCount',
        value: value,
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      dayCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dayCount',
        value: value,
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      dayCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dayCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      expiresAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'expiresAt',
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      expiresAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'expiresAt',
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      expiresAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'expiresAt',
        value: value,
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      expiresAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'expiresAt',
        value: value,
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      expiresAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'expiresAt',
        value: value,
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      expiresAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'expiresAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      idGreaterThan(
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

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition> idBetween(
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

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      lowestActivityDayEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lowestActivityDay',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      lowestActivityDayGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lowestActivityDay',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      lowestActivityDayLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lowestActivityDay',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      lowestActivityDayBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lowestActivityDay',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      lowestActivityDayStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'lowestActivityDay',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      lowestActivityDayEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'lowestActivityDay',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      lowestActivityDayContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lowestActivityDay',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      lowestActivityDayMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lowestActivityDay',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      lowestActivityDayIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lowestActivityDay',
        value: '',
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      lowestActivityDayIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lowestActivityDay',
        value: '',
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      peakActivityDayEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'peakActivityDay',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      peakActivityDayGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'peakActivityDay',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      peakActivityDayLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'peakActivityDay',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      peakActivityDayBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'peakActivityDay',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      peakActivityDayStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'peakActivityDay',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      peakActivityDayEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'peakActivityDay',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      peakActivityDayContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'peakActivityDay',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      peakActivityDayMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'peakActivityDay',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      peakActivityDayIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'peakActivityDay',
        value: '',
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      peakActivityDayIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'peakActivityDay',
        value: '',
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      topAppsJsonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'topAppsJson',
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      topAppsJsonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'topAppsJson',
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      topAppsJsonEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'topAppsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      topAppsJsonGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'topAppsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      topAppsJsonLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'topAppsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      topAppsJsonBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'topAppsJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      topAppsJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'topAppsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      topAppsJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'topAppsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      topAppsJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'topAppsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      topAppsJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'topAppsJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      topAppsJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'topAppsJson',
        value: '',
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      topAppsJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'topAppsJson',
        value: '',
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      topDistractionsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'topDistractions',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      topDistractionsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'topDistractions',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      topDistractionsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'topDistractions',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      topDistractionsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'topDistractions',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      topDistractionsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'topDistractions',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      topDistractionsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'topDistractions',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      topDistractionsElementContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'topDistractions',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      topDistractionsElementMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'topDistractions',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      topDistractionsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'topDistractions',
        value: '',
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      topDistractionsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'topDistractions',
        value: '',
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      topDistractionsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'topDistractions',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      topDistractionsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'topDistractions',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      topDistractionsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'topDistractions',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      topDistractionsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'topDistractions',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      topDistractionsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'topDistractions',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      topDistractionsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'topDistractions',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      totalDistractionsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalDistractions',
        value: value,
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      totalDistractionsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalDistractions',
        value: value,
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      totalDistractionsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalDistractions',
        value: value,
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      totalDistractionsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalDistractions',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      totalScreenTimeSecondsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalScreenTimeSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      totalScreenTimeSecondsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalScreenTimeSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      totalScreenTimeSecondsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalScreenTimeSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      totalScreenTimeSecondsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalScreenTimeSeconds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      weekStartEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'weekStart',
        value: value,
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      weekStartGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'weekStart',
        value: value,
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      weekStartLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'weekStart',
        value: value,
      ));
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterFilterCondition>
      weekStartBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'weekStart',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension WeeklyProfileQueryObject
    on QueryBuilder<WeeklyProfile, WeeklyProfile, QFilterCondition> {}

extension WeeklyProfileQueryLinks
    on QueryBuilder<WeeklyProfile, WeeklyProfile, QFilterCondition> {}

extension WeeklyProfileQuerySortBy
    on QueryBuilder<WeeklyProfile, WeeklyProfile, QSortBy> {
  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterSortBy>
      sortByAverageDailyScreenTimeSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averageDailyScreenTimeSeconds', Sort.asc);
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterSortBy>
      sortByAverageDailyScreenTimeSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averageDailyScreenTimeSeconds', Sort.desc);
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterSortBy>
      sortByAverageFocusScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averageFocusScore', Sort.asc);
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterSortBy>
      sortByAverageFocusScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averageFocusScore', Sort.desc);
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterSortBy>
      sortByDailyPatternsJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyPatternsJson', Sort.asc);
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterSortBy>
      sortByDailyPatternsJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyPatternsJson', Sort.desc);
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterSortBy> sortByDayCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayCount', Sort.asc);
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterSortBy>
      sortByDayCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayCount', Sort.desc);
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterSortBy> sortByExpiresAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiresAt', Sort.asc);
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterSortBy>
      sortByExpiresAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiresAt', Sort.desc);
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterSortBy>
      sortByLowestActivityDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lowestActivityDay', Sort.asc);
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterSortBy>
      sortByLowestActivityDayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lowestActivityDay', Sort.desc);
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterSortBy>
      sortByPeakActivityDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'peakActivityDay', Sort.asc);
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterSortBy>
      sortByPeakActivityDayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'peakActivityDay', Sort.desc);
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterSortBy> sortByTopAppsJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'topAppsJson', Sort.asc);
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterSortBy>
      sortByTopAppsJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'topAppsJson', Sort.desc);
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterSortBy>
      sortByTotalDistractions() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalDistractions', Sort.asc);
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterSortBy>
      sortByTotalDistractionsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalDistractions', Sort.desc);
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterSortBy>
      sortByTotalScreenTimeSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalScreenTimeSeconds', Sort.asc);
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterSortBy>
      sortByTotalScreenTimeSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalScreenTimeSeconds', Sort.desc);
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterSortBy> sortByWeekStart() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weekStart', Sort.asc);
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterSortBy>
      sortByWeekStartDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weekStart', Sort.desc);
    });
  }
}

extension WeeklyProfileQuerySortThenBy
    on QueryBuilder<WeeklyProfile, WeeklyProfile, QSortThenBy> {
  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterSortBy>
      thenByAverageDailyScreenTimeSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averageDailyScreenTimeSeconds', Sort.asc);
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterSortBy>
      thenByAverageDailyScreenTimeSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averageDailyScreenTimeSeconds', Sort.desc);
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterSortBy>
      thenByAverageFocusScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averageFocusScore', Sort.asc);
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterSortBy>
      thenByAverageFocusScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averageFocusScore', Sort.desc);
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterSortBy>
      thenByDailyPatternsJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyPatternsJson', Sort.asc);
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterSortBy>
      thenByDailyPatternsJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyPatternsJson', Sort.desc);
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterSortBy> thenByDayCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayCount', Sort.asc);
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterSortBy>
      thenByDayCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayCount', Sort.desc);
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterSortBy> thenByExpiresAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiresAt', Sort.asc);
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterSortBy>
      thenByExpiresAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiresAt', Sort.desc);
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterSortBy>
      thenByLowestActivityDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lowestActivityDay', Sort.asc);
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterSortBy>
      thenByLowestActivityDayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lowestActivityDay', Sort.desc);
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterSortBy>
      thenByPeakActivityDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'peakActivityDay', Sort.asc);
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterSortBy>
      thenByPeakActivityDayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'peakActivityDay', Sort.desc);
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterSortBy> thenByTopAppsJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'topAppsJson', Sort.asc);
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterSortBy>
      thenByTopAppsJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'topAppsJson', Sort.desc);
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterSortBy>
      thenByTotalDistractions() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalDistractions', Sort.asc);
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterSortBy>
      thenByTotalDistractionsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalDistractions', Sort.desc);
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterSortBy>
      thenByTotalScreenTimeSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalScreenTimeSeconds', Sort.asc);
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterSortBy>
      thenByTotalScreenTimeSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalScreenTimeSeconds', Sort.desc);
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterSortBy> thenByWeekStart() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weekStart', Sort.asc);
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QAfterSortBy>
      thenByWeekStartDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weekStart', Sort.desc);
    });
  }
}

extension WeeklyProfileQueryWhereDistinct
    on QueryBuilder<WeeklyProfile, WeeklyProfile, QDistinct> {
  QueryBuilder<WeeklyProfile, WeeklyProfile, QDistinct>
      distinctByAverageDailyScreenTimeSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'averageDailyScreenTimeSeconds');
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QDistinct>
      distinctByAverageFocusScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'averageFocusScore');
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QDistinct>
      distinctByDailyPatternsJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dailyPatternsJson',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QDistinct> distinctByDayCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dayCount');
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QDistinct> distinctByExpiresAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'expiresAt');
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QDistinct>
      distinctByLowestActivityDay({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lowestActivityDay',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QDistinct>
      distinctByPeakActivityDay({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'peakActivityDay',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QDistinct> distinctByTopAppsJson(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'topAppsJson', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QDistinct>
      distinctByTopDistractions() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'topDistractions');
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QDistinct>
      distinctByTotalDistractions() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalDistractions');
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QDistinct>
      distinctByTotalScreenTimeSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalScreenTimeSeconds');
    });
  }

  QueryBuilder<WeeklyProfile, WeeklyProfile, QDistinct> distinctByWeekStart() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'weekStart');
    });
  }
}

extension WeeklyProfileQueryProperty
    on QueryBuilder<WeeklyProfile, WeeklyProfile, QQueryProperty> {
  QueryBuilder<WeeklyProfile, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<WeeklyProfile, int, QQueryOperations>
      averageDailyScreenTimeSecondsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'averageDailyScreenTimeSeconds');
    });
  }

  QueryBuilder<WeeklyProfile, double, QQueryOperations>
      averageFocusScoreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'averageFocusScore');
    });
  }

  QueryBuilder<WeeklyProfile, DateTime?, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<WeeklyProfile, String?, QQueryOperations>
      dailyPatternsJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dailyPatternsJson');
    });
  }

  QueryBuilder<WeeklyProfile, int, QQueryOperations> dayCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dayCount');
    });
  }

  QueryBuilder<WeeklyProfile, DateTime?, QQueryOperations> expiresAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'expiresAt');
    });
  }

  QueryBuilder<WeeklyProfile, String, QQueryOperations>
      lowestActivityDayProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lowestActivityDay');
    });
  }

  QueryBuilder<WeeklyProfile, String, QQueryOperations>
      peakActivityDayProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'peakActivityDay');
    });
  }

  QueryBuilder<WeeklyProfile, String?, QQueryOperations> topAppsJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'topAppsJson');
    });
  }

  QueryBuilder<WeeklyProfile, List<String>, QQueryOperations>
      topDistractionsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'topDistractions');
    });
  }

  QueryBuilder<WeeklyProfile, int, QQueryOperations>
      totalDistractionsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalDistractions');
    });
  }

  QueryBuilder<WeeklyProfile, int, QQueryOperations>
      totalScreenTimeSecondsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalScreenTimeSeconds');
    });
  }

  QueryBuilder<WeeklyProfile, DateTime, QQueryOperations> weekStartProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'weekStart');
    });
  }
}
