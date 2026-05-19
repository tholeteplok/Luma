// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_summary_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDailySummaryCollection on Isar {
  IsarCollection<DailySummary> get dailySummarys => this.collection();
}

const DailySummarySchema = CollectionSchema(
  name: r'DailySummary',
  id: -8264136505301072183,
  properties: {
    r'appUsageMinutesJson': PropertySchema(
      id: 0,
      name: r'appUsageMinutesJson',
      type: IsarType.string,
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
    r'distractionCount': PropertySchema(
      id: 3,
      name: r'distractionCount',
      type: IsarType.long,
    ),
    r'expiresAt': PropertySchema(
      id: 4,
      name: r'expiresAt',
      type: IsarType.dateTime,
    ),
    r'focusScore': PropertySchema(
      id: 5,
      name: r'focusScore',
      type: IsarType.double,
    ),
    r'screenOffCount': PropertySchema(
      id: 6,
      name: r'screenOffCount',
      type: IsarType.long,
    ),
    r'screenOnCount': PropertySchema(
      id: 7,
      name: r'screenOnCount',
      type: IsarType.long,
    ),
    r'topAppsJson': PropertySchema(
      id: 8,
      name: r'topAppsJson',
      type: IsarType.string,
    ),
    r'totalScreenTimeSeconds': PropertySchema(
      id: 9,
      name: r'totalScreenTimeSeconds',
      type: IsarType.long,
    )
  },
  estimateSize: _dailySummaryEstimateSize,
  serialize: _dailySummarySerialize,
  deserialize: _dailySummaryDeserialize,
  deserializeProp: _dailySummaryDeserializeProp,
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
  getId: _dailySummaryGetId,
  getLinks: _dailySummaryGetLinks,
  attach: _dailySummaryAttach,
  version: '3.1.0+1',
);

int _dailySummaryEstimateSize(
  DailySummary object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.appUsageMinutesJson;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.topAppsJson;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _dailySummarySerialize(
  DailySummary object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.appUsageMinutesJson);
  writer.writeDateTime(offsets[1], object.createdAt);
  writer.writeDateTime(offsets[2], object.date);
  writer.writeLong(offsets[3], object.distractionCount);
  writer.writeDateTime(offsets[4], object.expiresAt);
  writer.writeDouble(offsets[5], object.focusScore);
  writer.writeLong(offsets[6], object.screenOffCount);
  writer.writeLong(offsets[7], object.screenOnCount);
  writer.writeString(offsets[8], object.topAppsJson);
  writer.writeLong(offsets[9], object.totalScreenTimeSeconds);
}

DailySummary _dailySummaryDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DailySummary();
  object.appUsageMinutesJson = reader.readStringOrNull(offsets[0]);
  object.createdAt = reader.readDateTime(offsets[1]);
  object.date = reader.readDateTime(offsets[2]);
  object.distractionCount = reader.readLong(offsets[3]);
  object.expiresAt = reader.readDateTime(offsets[4]);
  object.focusScore = reader.readDouble(offsets[5]);
  object.id = id;
  object.screenOffCount = reader.readLong(offsets[6]);
  object.screenOnCount = reader.readLong(offsets[7]);
  object.topAppsJson = reader.readStringOrNull(offsets[8]);
  object.totalScreenTimeSeconds = reader.readLong(offsets[9]);
  return object;
}

P _dailySummaryDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    case 5:
      return (reader.readDouble(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _dailySummaryGetId(DailySummary object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _dailySummaryGetLinks(DailySummary object) {
  return [];
}

void _dailySummaryAttach(
    IsarCollection<dynamic> col, Id id, DailySummary object) {
  object.id = id;
}

extension DailySummaryByIndex on IsarCollection<DailySummary> {
  Future<DailySummary?> getByDate(DateTime date) {
    return getByIndex(r'date', [date]);
  }

  DailySummary? getByDateSync(DateTime date) {
    return getByIndexSync(r'date', [date]);
  }

  Future<bool> deleteByDate(DateTime date) {
    return deleteByIndex(r'date', [date]);
  }

  bool deleteByDateSync(DateTime date) {
    return deleteByIndexSync(r'date', [date]);
  }

  Future<List<DailySummary?>> getAllByDate(List<DateTime> dateValues) {
    final values = dateValues.map((e) => [e]).toList();
    return getAllByIndex(r'date', values);
  }

  List<DailySummary?> getAllByDateSync(List<DateTime> dateValues) {
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

  Future<Id> putByDate(DailySummary object) {
    return putByIndex(r'date', object);
  }

  Id putByDateSync(DailySummary object, {bool saveLinks = true}) {
    return putByIndexSync(r'date', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByDate(List<DailySummary> objects) {
    return putAllByIndex(r'date', objects);
  }

  List<Id> putAllByDateSync(List<DailySummary> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'date', objects, saveLinks: saveLinks);
  }
}

extension DailySummaryQueryWhereSort
    on QueryBuilder<DailySummary, DailySummary, QWhere> {
  QueryBuilder<DailySummary, DailySummary, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<DailySummary, DailySummary, QAfterWhere> anyDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'date'),
      );
    });
  }

  QueryBuilder<DailySummary, DailySummary, QAfterWhere> anyCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'createdAt'),
      );
    });
  }

  QueryBuilder<DailySummary, DailySummary, QAfterWhere> anyExpiresAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'expiresAt'),
      );
    });
  }
}

extension DailySummaryQueryWhere
    on QueryBuilder<DailySummary, DailySummary, QWhereClause> {
  QueryBuilder<DailySummary, DailySummary, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<DailySummary, DailySummary, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<DailySummary, DailySummary, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<DailySummary, DailySummary, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<DailySummary, DailySummary, QAfterWhereClause> idBetween(
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

  QueryBuilder<DailySummary, DailySummary, QAfterWhereClause> dateEqualTo(
      DateTime date) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'date',
        value: [date],
      ));
    });
  }

  QueryBuilder<DailySummary, DailySummary, QAfterWhereClause> dateNotEqualTo(
      DateTime date) {
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

  QueryBuilder<DailySummary, DailySummary, QAfterWhereClause> dateGreaterThan(
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

  QueryBuilder<DailySummary, DailySummary, QAfterWhereClause> dateLessThan(
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

  QueryBuilder<DailySummary, DailySummary, QAfterWhereClause> dateBetween(
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

  QueryBuilder<DailySummary, DailySummary, QAfterWhereClause> createdAtEqualTo(
      DateTime createdAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'createdAt',
        value: [createdAt],
      ));
    });
  }

  QueryBuilder<DailySummary, DailySummary, QAfterWhereClause>
      createdAtNotEqualTo(DateTime createdAt) {
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

  QueryBuilder<DailySummary, DailySummary, QAfterWhereClause>
      createdAtGreaterThan(
    DateTime createdAt, {
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

  QueryBuilder<DailySummary, DailySummary, QAfterWhereClause> createdAtLessThan(
    DateTime createdAt, {
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

  QueryBuilder<DailySummary, DailySummary, QAfterWhereClause> createdAtBetween(
    DateTime lowerCreatedAt,
    DateTime upperCreatedAt, {
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

  QueryBuilder<DailySummary, DailySummary, QAfterWhereClause> expiresAtEqualTo(
      DateTime expiresAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'expiresAt',
        value: [expiresAt],
      ));
    });
  }

  QueryBuilder<DailySummary, DailySummary, QAfterWhereClause>
      expiresAtNotEqualTo(DateTime expiresAt) {
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

  QueryBuilder<DailySummary, DailySummary, QAfterWhereClause>
      expiresAtGreaterThan(
    DateTime expiresAt, {
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

  QueryBuilder<DailySummary, DailySummary, QAfterWhereClause> expiresAtLessThan(
    DateTime expiresAt, {
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

  QueryBuilder<DailySummary, DailySummary, QAfterWhereClause> expiresAtBetween(
    DateTime lowerExpiresAt,
    DateTime upperExpiresAt, {
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

extension DailySummaryQueryFilter
    on QueryBuilder<DailySummary, DailySummary, QFilterCondition> {
  QueryBuilder<DailySummary, DailySummary, QAfterFilterCondition>
      appUsageMinutesJsonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'appUsageMinutesJson',
      ));
    });
  }

  QueryBuilder<DailySummary, DailySummary, QAfterFilterCondition>
      appUsageMinutesJsonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'appUsageMinutesJson',
      ));
    });
  }

  QueryBuilder<DailySummary, DailySummary, QAfterFilterCondition>
      appUsageMinutesJsonEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'appUsageMinutesJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailySummary, DailySummary, QAfterFilterCondition>
      appUsageMinutesJsonGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'appUsageMinutesJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailySummary, DailySummary, QAfterFilterCondition>
      appUsageMinutesJsonLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'appUsageMinutesJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailySummary, DailySummary, QAfterFilterCondition>
      appUsageMinutesJsonBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'appUsageMinutesJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailySummary, DailySummary, QAfterFilterCondition>
      appUsageMinutesJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'appUsageMinutesJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailySummary, DailySummary, QAfterFilterCondition>
      appUsageMinutesJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'appUsageMinutesJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailySummary, DailySummary, QAfterFilterCondition>
      appUsageMinutesJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'appUsageMinutesJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailySummary, DailySummary, QAfterFilterCondition>
      appUsageMinutesJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'appUsageMinutesJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailySummary, DailySummary, QAfterFilterCondition>
      appUsageMinutesJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'appUsageMinutesJson',
        value: '',
      ));
    });
  }

  QueryBuilder<DailySummary, DailySummary, QAfterFilterCondition>
      appUsageMinutesJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'appUsageMinutesJson',
        value: '',
      ));
    });
  }

  QueryBuilder<DailySummary, DailySummary, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DailySummary, DailySummary, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime value, {
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

  QueryBuilder<DailySummary, DailySummary, QAfterFilterCondition>
      createdAtLessThan(
    DateTime value, {
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

  QueryBuilder<DailySummary, DailySummary, QAfterFilterCondition>
      createdAtBetween(
    DateTime lower,
    DateTime upper, {
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

  QueryBuilder<DailySummary, DailySummary, QAfterFilterCondition> dateEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<DailySummary, DailySummary, QAfterFilterCondition>
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

  QueryBuilder<DailySummary, DailySummary, QAfterFilterCondition> dateLessThan(
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

  QueryBuilder<DailySummary, DailySummary, QAfterFilterCondition> dateBetween(
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

  QueryBuilder<DailySummary, DailySummary, QAfterFilterCondition>
      distractionCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'distractionCount',
        value: value,
      ));
    });
  }

  QueryBuilder<DailySummary, DailySummary, QAfterFilterCondition>
      distractionCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'distractionCount',
        value: value,
      ));
    });
  }

  QueryBuilder<DailySummary, DailySummary, QAfterFilterCondition>
      distractionCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'distractionCount',
        value: value,
      ));
    });
  }

  QueryBuilder<DailySummary, DailySummary, QAfterFilterCondition>
      distractionCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'distractionCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DailySummary, DailySummary, QAfterFilterCondition>
      expiresAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'expiresAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DailySummary, DailySummary, QAfterFilterCondition>
      expiresAtGreaterThan(
    DateTime value, {
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

  QueryBuilder<DailySummary, DailySummary, QAfterFilterCondition>
      expiresAtLessThan(
    DateTime value, {
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

  QueryBuilder<DailySummary, DailySummary, QAfterFilterCondition>
      expiresAtBetween(
    DateTime lower,
    DateTime upper, {
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

  QueryBuilder<DailySummary, DailySummary, QAfterFilterCondition>
      focusScoreEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'focusScore',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DailySummary, DailySummary, QAfterFilterCondition>
      focusScoreGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'focusScore',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DailySummary, DailySummary, QAfterFilterCondition>
      focusScoreLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'focusScore',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DailySummary, DailySummary, QAfterFilterCondition>
      focusScoreBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'focusScore',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DailySummary, DailySummary, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DailySummary, DailySummary, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<DailySummary, DailySummary, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<DailySummary, DailySummary, QAfterFilterCondition> idBetween(
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

  QueryBuilder<DailySummary, DailySummary, QAfterFilterCondition>
      screenOffCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'screenOffCount',
        value: value,
      ));
    });
  }

  QueryBuilder<DailySummary, DailySummary, QAfterFilterCondition>
      screenOffCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'screenOffCount',
        value: value,
      ));
    });
  }

  QueryBuilder<DailySummary, DailySummary, QAfterFilterCondition>
      screenOffCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'screenOffCount',
        value: value,
      ));
    });
  }

  QueryBuilder<DailySummary, DailySummary, QAfterFilterCondition>
      screenOffCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'screenOffCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DailySummary, DailySummary, QAfterFilterCondition>
      screenOnCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'screenOnCount',
        value: value,
      ));
    });
  }

  QueryBuilder<DailySummary, DailySummary, QAfterFilterCondition>
      screenOnCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'screenOnCount',
        value: value,
      ));
    });
  }

  QueryBuilder<DailySummary, DailySummary, QAfterFilterCondition>
      screenOnCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'screenOnCount',
        value: value,
      ));
    });
  }

  QueryBuilder<DailySummary, DailySummary, QAfterFilterCondition>
      screenOnCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'screenOnCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DailySummary, DailySummary, QAfterFilterCondition>
      topAppsJsonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'topAppsJson',
      ));
    });
  }

  QueryBuilder<DailySummary, DailySummary, QAfterFilterCondition>
      topAppsJsonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'topAppsJson',
      ));
    });
  }

  QueryBuilder<DailySummary, DailySummary, QAfterFilterCondition>
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

  QueryBuilder<DailySummary, DailySummary, QAfterFilterCondition>
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

  QueryBuilder<DailySummary, DailySummary, QAfterFilterCondition>
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

  QueryBuilder<DailySummary, DailySummary, QAfterFilterCondition>
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

  QueryBuilder<DailySummary, DailySummary, QAfterFilterCondition>
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

  QueryBuilder<DailySummary, DailySummary, QAfterFilterCondition>
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

  QueryBuilder<DailySummary, DailySummary, QAfterFilterCondition>
      topAppsJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'topAppsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailySummary, DailySummary, QAfterFilterCondition>
      topAppsJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'topAppsJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailySummary, DailySummary, QAfterFilterCondition>
      topAppsJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'topAppsJson',
        value: '',
      ));
    });
  }

  QueryBuilder<DailySummary, DailySummary, QAfterFilterCondition>
      topAppsJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'topAppsJson',
        value: '',
      ));
    });
  }

  QueryBuilder<DailySummary, DailySummary, QAfterFilterCondition>
      totalScreenTimeSecondsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalScreenTimeSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<DailySummary, DailySummary, QAfterFilterCondition>
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

  QueryBuilder<DailySummary, DailySummary, QAfterFilterCondition>
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

  QueryBuilder<DailySummary, DailySummary, QAfterFilterCondition>
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
}

extension DailySummaryQueryObject
    on QueryBuilder<DailySummary, DailySummary, QFilterCondition> {}

extension DailySummaryQueryLinks
    on QueryBuilder<DailySummary, DailySummary, QFilterCondition> {}

extension DailySummaryQuerySortBy
    on QueryBuilder<DailySummary, DailySummary, QSortBy> {
  QueryBuilder<DailySummary, DailySummary, QAfterSortBy>
      sortByAppUsageMinutesJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appUsageMinutesJson', Sort.asc);
    });
  }

  QueryBuilder<DailySummary, DailySummary, QAfterSortBy>
      sortByAppUsageMinutesJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appUsageMinutesJson', Sort.desc);
    });
  }

  QueryBuilder<DailySummary, DailySummary, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<DailySummary, DailySummary, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<DailySummary, DailySummary, QAfterSortBy> sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<DailySummary, DailySummary, QAfterSortBy> sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<DailySummary, DailySummary, QAfterSortBy>
      sortByDistractionCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'distractionCount', Sort.asc);
    });
  }

  QueryBuilder<DailySummary, DailySummary, QAfterSortBy>
      sortByDistractionCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'distractionCount', Sort.desc);
    });
  }

  QueryBuilder<DailySummary, DailySummary, QAfterSortBy> sortByExpiresAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiresAt', Sort.asc);
    });
  }

  QueryBuilder<DailySummary, DailySummary, QAfterSortBy> sortByExpiresAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiresAt', Sort.desc);
    });
  }

  QueryBuilder<DailySummary, DailySummary, QAfterSortBy> sortByFocusScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'focusScore', Sort.asc);
    });
  }

  QueryBuilder<DailySummary, DailySummary, QAfterSortBy>
      sortByFocusScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'focusScore', Sort.desc);
    });
  }

  QueryBuilder<DailySummary, DailySummary, QAfterSortBy>
      sortByScreenOffCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'screenOffCount', Sort.asc);
    });
  }

  QueryBuilder<DailySummary, DailySummary, QAfterSortBy>
      sortByScreenOffCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'screenOffCount', Sort.desc);
    });
  }

  QueryBuilder<DailySummary, DailySummary, QAfterSortBy> sortByScreenOnCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'screenOnCount', Sort.asc);
    });
  }

  QueryBuilder<DailySummary, DailySummary, QAfterSortBy>
      sortByScreenOnCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'screenOnCount', Sort.desc);
    });
  }

  QueryBuilder<DailySummary, DailySummary, QAfterSortBy> sortByTopAppsJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'topAppsJson', Sort.asc);
    });
  }

  QueryBuilder<DailySummary, DailySummary, QAfterSortBy>
      sortByTopAppsJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'topAppsJson', Sort.desc);
    });
  }

  QueryBuilder<DailySummary, DailySummary, QAfterSortBy>
      sortByTotalScreenTimeSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalScreenTimeSeconds', Sort.asc);
    });
  }

  QueryBuilder<DailySummary, DailySummary, QAfterSortBy>
      sortByTotalScreenTimeSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalScreenTimeSeconds', Sort.desc);
    });
  }
}

extension DailySummaryQuerySortThenBy
    on QueryBuilder<DailySummary, DailySummary, QSortThenBy> {
  QueryBuilder<DailySummary, DailySummary, QAfterSortBy>
      thenByAppUsageMinutesJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appUsageMinutesJson', Sort.asc);
    });
  }

  QueryBuilder<DailySummary, DailySummary, QAfterSortBy>
      thenByAppUsageMinutesJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appUsageMinutesJson', Sort.desc);
    });
  }

  QueryBuilder<DailySummary, DailySummary, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<DailySummary, DailySummary, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<DailySummary, DailySummary, QAfterSortBy> thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<DailySummary, DailySummary, QAfterSortBy> thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<DailySummary, DailySummary, QAfterSortBy>
      thenByDistractionCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'distractionCount', Sort.asc);
    });
  }

  QueryBuilder<DailySummary, DailySummary, QAfterSortBy>
      thenByDistractionCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'distractionCount', Sort.desc);
    });
  }

  QueryBuilder<DailySummary, DailySummary, QAfterSortBy> thenByExpiresAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiresAt', Sort.asc);
    });
  }

  QueryBuilder<DailySummary, DailySummary, QAfterSortBy> thenByExpiresAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiresAt', Sort.desc);
    });
  }

  QueryBuilder<DailySummary, DailySummary, QAfterSortBy> thenByFocusScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'focusScore', Sort.asc);
    });
  }

  QueryBuilder<DailySummary, DailySummary, QAfterSortBy>
      thenByFocusScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'focusScore', Sort.desc);
    });
  }

  QueryBuilder<DailySummary, DailySummary, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DailySummary, DailySummary, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<DailySummary, DailySummary, QAfterSortBy>
      thenByScreenOffCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'screenOffCount', Sort.asc);
    });
  }

  QueryBuilder<DailySummary, DailySummary, QAfterSortBy>
      thenByScreenOffCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'screenOffCount', Sort.desc);
    });
  }

  QueryBuilder<DailySummary, DailySummary, QAfterSortBy> thenByScreenOnCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'screenOnCount', Sort.asc);
    });
  }

  QueryBuilder<DailySummary, DailySummary, QAfterSortBy>
      thenByScreenOnCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'screenOnCount', Sort.desc);
    });
  }

  QueryBuilder<DailySummary, DailySummary, QAfterSortBy> thenByTopAppsJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'topAppsJson', Sort.asc);
    });
  }

  QueryBuilder<DailySummary, DailySummary, QAfterSortBy>
      thenByTopAppsJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'topAppsJson', Sort.desc);
    });
  }

  QueryBuilder<DailySummary, DailySummary, QAfterSortBy>
      thenByTotalScreenTimeSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalScreenTimeSeconds', Sort.asc);
    });
  }

  QueryBuilder<DailySummary, DailySummary, QAfterSortBy>
      thenByTotalScreenTimeSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalScreenTimeSeconds', Sort.desc);
    });
  }
}

extension DailySummaryQueryWhereDistinct
    on QueryBuilder<DailySummary, DailySummary, QDistinct> {
  QueryBuilder<DailySummary, DailySummary, QDistinct>
      distinctByAppUsageMinutesJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'appUsageMinutesJson',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DailySummary, DailySummary, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<DailySummary, DailySummary, QDistinct> distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }

  QueryBuilder<DailySummary, DailySummary, QDistinct>
      distinctByDistractionCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'distractionCount');
    });
  }

  QueryBuilder<DailySummary, DailySummary, QDistinct> distinctByExpiresAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'expiresAt');
    });
  }

  QueryBuilder<DailySummary, DailySummary, QDistinct> distinctByFocusScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'focusScore');
    });
  }

  QueryBuilder<DailySummary, DailySummary, QDistinct>
      distinctByScreenOffCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'screenOffCount');
    });
  }

  QueryBuilder<DailySummary, DailySummary, QDistinct>
      distinctByScreenOnCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'screenOnCount');
    });
  }

  QueryBuilder<DailySummary, DailySummary, QDistinct> distinctByTopAppsJson(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'topAppsJson', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DailySummary, DailySummary, QDistinct>
      distinctByTotalScreenTimeSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalScreenTimeSeconds');
    });
  }
}

extension DailySummaryQueryProperty
    on QueryBuilder<DailySummary, DailySummary, QQueryProperty> {
  QueryBuilder<DailySummary, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DailySummary, String?, QQueryOperations>
      appUsageMinutesJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'appUsageMinutesJson');
    });
  }

  QueryBuilder<DailySummary, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<DailySummary, DateTime, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<DailySummary, int, QQueryOperations> distractionCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'distractionCount');
    });
  }

  QueryBuilder<DailySummary, DateTime, QQueryOperations> expiresAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'expiresAt');
    });
  }

  QueryBuilder<DailySummary, double, QQueryOperations> focusScoreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'focusScore');
    });
  }

  QueryBuilder<DailySummary, int, QQueryOperations> screenOffCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'screenOffCount');
    });
  }

  QueryBuilder<DailySummary, int, QQueryOperations> screenOnCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'screenOnCount');
    });
  }

  QueryBuilder<DailySummary, String?, QQueryOperations> topAppsJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'topAppsJson');
    });
  }

  QueryBuilder<DailySummary, int, QQueryOperations>
      totalScreenTimeSecondsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalScreenTimeSeconds');
    });
  }
}
