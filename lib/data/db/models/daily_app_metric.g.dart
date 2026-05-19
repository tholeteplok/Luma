// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_app_metric.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDailyAppMetricCollection on Isar {
  IsarCollection<DailyAppMetric> get dailyAppMetrics => this.collection();
}

const DailyAppMetricSchema = CollectionSchema(
  name: r'DailyAppMetric',
  id: 8460106096663554367,
  properties: {
    r'averageSessionDuration': PropertySchema(
      id: 0,
      name: r'averageSessionDuration',
      type: IsarType.double,
    ),
    r'createdAt': PropertySchema(
      id: 1,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'date': PropertySchema(
      id: 2,
      name: r'date',
      type: IsarType.dateTime,
    ),
    r'firstUseHour': PropertySchema(
      id: 3,
      name: r'firstUseHour',
      type: IsarType.long,
    ),
    r'isMorningApp': PropertySchema(
      id: 4,
      name: r'isMorningApp',
      type: IsarType.bool,
    ),
    r'isNightApp': PropertySchema(
      id: 5,
      name: r'isNightApp',
      type: IsarType.bool,
    ),
    r'lastUseHour': PropertySchema(
      id: 6,
      name: r'lastUseHour',
      type: IsarType.long,
    ),
    r'packageName': PropertySchema(
      id: 7,
      name: r'packageName',
      type: IsarType.string,
    ),
    r'sessionCount': PropertySchema(
      id: 8,
      name: r'sessionCount',
      type: IsarType.long,
    ),
    r'totalDurationSeconds': PropertySchema(
      id: 9,
      name: r'totalDurationSeconds',
      type: IsarType.long,
    )
  },
  estimateSize: _dailyAppMetricEstimateSize,
  serialize: _dailyAppMetricSerialize,
  deserialize: _dailyAppMetricDeserialize,
  deserializeProp: _dailyAppMetricDeserializeProp,
  idName: r'id',
  indexes: {
    r'date': IndexSchema(
      id: -7552997827385218417,
      name: r'date',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'date',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'packageName': IndexSchema(
      id: -3211024755902609907,
      name: r'packageName',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'packageName',
          type: IndexType.hash,
          caseSensitive: true,
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
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _dailyAppMetricGetId,
  getLinks: _dailyAppMetricGetLinks,
  attach: _dailyAppMetricAttach,
  version: '3.1.0+1',
);

int _dailyAppMetricEstimateSize(
  DailyAppMetric object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.packageName.length * 3;
  return bytesCount;
}

void _dailyAppMetricSerialize(
  DailyAppMetric object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.averageSessionDuration);
  writer.writeDateTime(offsets[1], object.createdAt);
  writer.writeDateTime(offsets[2], object.date);
  writer.writeLong(offsets[3], object.firstUseHour);
  writer.writeBool(offsets[4], object.isMorningApp);
  writer.writeBool(offsets[5], object.isNightApp);
  writer.writeLong(offsets[6], object.lastUseHour);
  writer.writeString(offsets[7], object.packageName);
  writer.writeLong(offsets[8], object.sessionCount);
  writer.writeLong(offsets[9], object.totalDurationSeconds);
}

DailyAppMetric _dailyAppMetricDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DailyAppMetric(
    createdAt: reader.readDateTimeOrNull(offsets[1]),
    date: reader.readDateTime(offsets[2]),
    firstUseHour: reader.readLong(offsets[3]),
    lastUseHour: reader.readLong(offsets[6]),
    packageName: reader.readString(offsets[7]),
    sessionCount: reader.readLong(offsets[8]),
    totalDurationSeconds: reader.readLong(offsets[9]),
  );
  object.averageSessionDuration = reader.readDouble(offsets[0]);
  object.id = id;
  object.isMorningApp = reader.readBool(offsets[4]);
  object.isNightApp = reader.readBool(offsets[5]);
  return object;
}

P _dailyAppMetricDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readBool(offset)) as P;
    case 5:
      return (reader.readBool(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    case 9:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _dailyAppMetricGetId(DailyAppMetric object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _dailyAppMetricGetLinks(DailyAppMetric object) {
  return [];
}

void _dailyAppMetricAttach(
    IsarCollection<dynamic> col, Id id, DailyAppMetric object) {
  object.id = id;
}

extension DailyAppMetricByIndex on IsarCollection<DailyAppMetric> {
  Future<DailyAppMetric?> getByDate(DateTime date) {
    return getByIndex(r'date', [date]);
  }

  DailyAppMetric? getByDateSync(DateTime date) {
    return getByIndexSync(r'date', [date]);
  }

  Future<bool> deleteByDate(DateTime date) {
    return deleteByIndex(r'date', [date]);
  }

  bool deleteByDateSync(DateTime date) {
    return deleteByIndexSync(r'date', [date]);
  }

  Future<List<DailyAppMetric?>> getAllByDate(List<DateTime> dateValues) {
    final values = dateValues.map((e) => [e]).toList();
    return getAllByIndex(r'date', values);
  }

  List<DailyAppMetric?> getAllByDateSync(List<DateTime> dateValues) {
    final values = dateValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'date', values);
  }

  Future<int> deleteAllByDate(List<DateTime> dateValues) {
    final values = dateValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'date', values);
  }

  int deleteAllByDateSync(List<DateTime> dateValues) {
    final values = dateValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'date', values);
  }

  Future<Id> putByDate(DailyAppMetric object) {
    return putByIndex(r'date', object);
  }

  Id putByDateSync(DailyAppMetric object, {bool saveLinks = true}) {
    return putByIndexSync(r'date', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByDate(List<DailyAppMetric> objects) {
    return putAllByIndex(r'date', objects);
  }

  List<Id> putAllByDateSync(List<DailyAppMetric> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'date', objects, saveLinks: saveLinks);
  }
}

extension DailyAppMetricQueryWhereSort
    on QueryBuilder<DailyAppMetric, DailyAppMetric, QWhere> {
  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterWhere> anyDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'date'),
      );
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterWhere> anyCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'createdAt'),
      );
    });
  }
}

extension DailyAppMetricQueryWhere
    on QueryBuilder<DailyAppMetric, DailyAppMetric, QWhereClause> {
  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterWhereClause> idBetween(
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

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterWhereClause> dateEqualTo(
      DateTime date) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'date',
        value: [date],
      ));
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterWhereClause>
      dateNotEqualTo(DateTime date) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [],
              upper: [date],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [date],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [date],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [],
              upper: [date],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterWhereClause>
      dateGreaterThan(
    DateTime date, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'date',
        lower: [date],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterWhereClause> dateLessThan(
    DateTime date, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'date',
        lower: [],
        upper: [date],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterWhereClause> dateBetween(
    DateTime lowerDate,
    DateTime upperDate, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'date',
        lower: [lowerDate],
        includeLower: includeLower,
        upper: [upperDate],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterWhereClause>
      packageNameEqualTo(String packageName) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'packageName',
        value: [packageName],
      ));
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterWhereClause>
      packageNameNotEqualTo(String packageName) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'packageName',
              lower: [],
              upper: [packageName],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'packageName',
              lower: [packageName],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'packageName',
              lower: [packageName],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'packageName',
              lower: [],
              upper: [packageName],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterWhereClause>
      createdAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'createdAt',
        value: [null],
      ));
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterWhereClause>
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

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterWhereClause>
      createdAtEqualTo(DateTime? createdAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'createdAt',
        value: [createdAt],
      ));
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterWhereClause>
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

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterWhereClause>
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

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterWhereClause>
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

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterWhereClause>
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
}

extension DailyAppMetricQueryFilter
    on QueryBuilder<DailyAppMetric, DailyAppMetric, QFilterCondition> {
  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterFilterCondition>
      averageSessionDurationEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'averageSessionDuration',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterFilterCondition>
      averageSessionDurationGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'averageSessionDuration',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterFilterCondition>
      averageSessionDurationLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'averageSessionDuration',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterFilterCondition>
      averageSessionDurationBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'averageSessionDuration',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterFilterCondition>
      createdAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'createdAt',
      ));
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterFilterCondition>
      createdAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'createdAt',
      ));
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterFilterCondition>
      createdAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterFilterCondition>
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

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterFilterCondition>
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

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterFilterCondition>
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

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterFilterCondition>
      dateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterFilterCondition>
      dateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterFilterCondition>
      dateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterFilterCondition>
      dateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'date',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterFilterCondition>
      firstUseHourEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'firstUseHour',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterFilterCondition>
      firstUseHourGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'firstUseHour',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterFilterCondition>
      firstUseHourLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'firstUseHour',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterFilterCondition>
      firstUseHourBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'firstUseHour',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterFilterCondition>
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

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterFilterCondition>
      idLessThan(
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

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterFilterCondition> idBetween(
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

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterFilterCondition>
      isMorningAppEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isMorningApp',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterFilterCondition>
      isNightAppEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isNightApp',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterFilterCondition>
      lastUseHourEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastUseHour',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterFilterCondition>
      lastUseHourGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastUseHour',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterFilterCondition>
      lastUseHourLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastUseHour',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterFilterCondition>
      lastUseHourBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastUseHour',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterFilterCondition>
      packageNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'packageName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterFilterCondition>
      packageNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'packageName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterFilterCondition>
      packageNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'packageName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterFilterCondition>
      packageNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'packageName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterFilterCondition>
      packageNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'packageName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterFilterCondition>
      packageNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'packageName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterFilterCondition>
      packageNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'packageName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterFilterCondition>
      packageNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'packageName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterFilterCondition>
      packageNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'packageName',
        value: '',
      ));
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterFilterCondition>
      packageNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'packageName',
        value: '',
      ));
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterFilterCondition>
      sessionCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sessionCount',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterFilterCondition>
      sessionCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sessionCount',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterFilterCondition>
      sessionCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sessionCount',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterFilterCondition>
      sessionCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sessionCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterFilterCondition>
      totalDurationSecondsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalDurationSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterFilterCondition>
      totalDurationSecondsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalDurationSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterFilterCondition>
      totalDurationSecondsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalDurationSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterFilterCondition>
      totalDurationSecondsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalDurationSeconds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension DailyAppMetricQueryObject
    on QueryBuilder<DailyAppMetric, DailyAppMetric, QFilterCondition> {}

extension DailyAppMetricQueryLinks
    on QueryBuilder<DailyAppMetric, DailyAppMetric, QFilterCondition> {}

extension DailyAppMetricQuerySortBy
    on QueryBuilder<DailyAppMetric, DailyAppMetric, QSortBy> {
  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterSortBy>
      sortByAverageSessionDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averageSessionDuration', Sort.asc);
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterSortBy>
      sortByAverageSessionDurationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averageSessionDuration', Sort.desc);
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterSortBy> sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterSortBy> sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterSortBy>
      sortByFirstUseHour() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstUseHour', Sort.asc);
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterSortBy>
      sortByFirstUseHourDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstUseHour', Sort.desc);
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterSortBy>
      sortByIsMorningApp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isMorningApp', Sort.asc);
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterSortBy>
      sortByIsMorningAppDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isMorningApp', Sort.desc);
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterSortBy>
      sortByIsNightApp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isNightApp', Sort.asc);
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterSortBy>
      sortByIsNightAppDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isNightApp', Sort.desc);
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterSortBy>
      sortByLastUseHour() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUseHour', Sort.asc);
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterSortBy>
      sortByLastUseHourDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUseHour', Sort.desc);
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterSortBy>
      sortByPackageName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'packageName', Sort.asc);
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterSortBy>
      sortByPackageNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'packageName', Sort.desc);
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterSortBy>
      sortBySessionCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionCount', Sort.asc);
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterSortBy>
      sortBySessionCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionCount', Sort.desc);
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterSortBy>
      sortByTotalDurationSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalDurationSeconds', Sort.asc);
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterSortBy>
      sortByTotalDurationSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalDurationSeconds', Sort.desc);
    });
  }
}

extension DailyAppMetricQuerySortThenBy
    on QueryBuilder<DailyAppMetric, DailyAppMetric, QSortThenBy> {
  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterSortBy>
      thenByAverageSessionDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averageSessionDuration', Sort.asc);
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterSortBy>
      thenByAverageSessionDurationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averageSessionDuration', Sort.desc);
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterSortBy> thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterSortBy> thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterSortBy>
      thenByFirstUseHour() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstUseHour', Sort.asc);
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterSortBy>
      thenByFirstUseHourDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstUseHour', Sort.desc);
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterSortBy>
      thenByIsMorningApp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isMorningApp', Sort.asc);
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterSortBy>
      thenByIsMorningAppDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isMorningApp', Sort.desc);
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterSortBy>
      thenByIsNightApp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isNightApp', Sort.asc);
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterSortBy>
      thenByIsNightAppDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isNightApp', Sort.desc);
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterSortBy>
      thenByLastUseHour() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUseHour', Sort.asc);
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterSortBy>
      thenByLastUseHourDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUseHour', Sort.desc);
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterSortBy>
      thenByPackageName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'packageName', Sort.asc);
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterSortBy>
      thenByPackageNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'packageName', Sort.desc);
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterSortBy>
      thenBySessionCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionCount', Sort.asc);
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterSortBy>
      thenBySessionCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionCount', Sort.desc);
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterSortBy>
      thenByTotalDurationSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalDurationSeconds', Sort.asc);
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QAfterSortBy>
      thenByTotalDurationSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalDurationSeconds', Sort.desc);
    });
  }
}

extension DailyAppMetricQueryWhereDistinct
    on QueryBuilder<DailyAppMetric, DailyAppMetric, QDistinct> {
  QueryBuilder<DailyAppMetric, DailyAppMetric, QDistinct>
      distinctByAverageSessionDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'averageSessionDuration');
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QDistinct> distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QDistinct>
      distinctByFirstUseHour() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'firstUseHour');
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QDistinct>
      distinctByIsMorningApp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isMorningApp');
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QDistinct>
      distinctByIsNightApp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isNightApp');
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QDistinct>
      distinctByLastUseHour() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastUseHour');
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QDistinct> distinctByPackageName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'packageName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QDistinct>
      distinctBySessionCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sessionCount');
    });
  }

  QueryBuilder<DailyAppMetric, DailyAppMetric, QDistinct>
      distinctByTotalDurationSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalDurationSeconds');
    });
  }
}

extension DailyAppMetricQueryProperty
    on QueryBuilder<DailyAppMetric, DailyAppMetric, QQueryProperty> {
  QueryBuilder<DailyAppMetric, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DailyAppMetric, double, QQueryOperations>
      averageSessionDurationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'averageSessionDuration');
    });
  }

  QueryBuilder<DailyAppMetric, DateTime?, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<DailyAppMetric, DateTime, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<DailyAppMetric, int, QQueryOperations> firstUseHourProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'firstUseHour');
    });
  }

  QueryBuilder<DailyAppMetric, bool, QQueryOperations> isMorningAppProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isMorningApp');
    });
  }

  QueryBuilder<DailyAppMetric, bool, QQueryOperations> isNightAppProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isNightApp');
    });
  }

  QueryBuilder<DailyAppMetric, int, QQueryOperations> lastUseHourProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastUseHour');
    });
  }

  QueryBuilder<DailyAppMetric, String, QQueryOperations> packageNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'packageName');
    });
  }

  QueryBuilder<DailyAppMetric, int, QQueryOperations> sessionCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sessionCount');
    });
  }

  QueryBuilder<DailyAppMetric, int, QQueryOperations>
      totalDurationSecondsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalDurationSeconds');
    });
  }
}
