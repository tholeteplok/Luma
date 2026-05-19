// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_preferences.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAppPreferencesCollection on Isar {
  IsarCollection<AppPreferences> get appPreferences => this.collection();
}

const AppPreferencesSchema = CollectionSchema(
  name: r'AppPreferences',
  id: -1519881479793025673,
  properties: {
    r'analyticsEnabled': PropertySchema(
      id: 0,
      name: r'analyticsEnabled',
      type: IsarType.bool,
    ),
    r'backupEnabled': PropertySchema(
      id: 1,
      name: r'backupEnabled',
      type: IsarType.bool,
    ),
    r'dailySummaryEnabled': PropertySchema(
      id: 2,
      name: r'dailySummaryEnabled',
      type: IsarType.bool,
    ),
    r'dataCollectionEnabled': PropertySchema(
      id: 3,
      name: r'dataCollectionEnabled',
      type: IsarType.bool,
    ),
    r'key': PropertySchema(
      id: 4,
      name: r'key',
      type: IsarType.string,
    ),
    r'languageCode': PropertySchema(
      id: 5,
      name: r'languageCode',
      type: IsarType.string,
    ),
    r'lastBackupDate': PropertySchema(
      id: 6,
      name: r'lastBackupDate',
      type: IsarType.dateTime,
    ),
    r'lastUpdated': PropertySchema(
      id: 7,
      name: r'lastUpdated',
      type: IsarType.dateTime,
    ),
    r'notificationsEnabled': PropertySchema(
      id: 8,
      name: r'notificationsEnabled',
      type: IsarType.bool,
    ),
    r'onboardingCompleted': PropertySchema(
      id: 9,
      name: r'onboardingCompleted',
      type: IsarType.bool,
    ),
    r'onboardingLastVersion': PropertySchema(
      id: 10,
      name: r'onboardingLastVersion',
      type: IsarType.long,
    ),
    r'useDarkMode': PropertySchema(
      id: 11,
      name: r'useDarkMode',
      type: IsarType.bool,
    ),
    r'weeklyReportEnabled': PropertySchema(
      id: 12,
      name: r'weeklyReportEnabled',
      type: IsarType.bool,
    )
  },
  estimateSize: _appPreferencesEstimateSize,
  serialize: _appPreferencesSerialize,
  deserialize: _appPreferencesDeserialize,
  deserializeProp: _appPreferencesDeserializeProp,
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
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _appPreferencesGetId,
  getLinks: _appPreferencesGetLinks,
  attach: _appPreferencesAttach,
  version: '3.1.0+1',
);

int _appPreferencesEstimateSize(
  AppPreferences object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.key.length * 3;
  bytesCount += 3 + object.languageCode.length * 3;
  return bytesCount;
}

void _appPreferencesSerialize(
  AppPreferences object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.analyticsEnabled);
  writer.writeBool(offsets[1], object.backupEnabled);
  writer.writeBool(offsets[2], object.dailySummaryEnabled);
  writer.writeBool(offsets[3], object.dataCollectionEnabled);
  writer.writeString(offsets[4], object.key);
  writer.writeString(offsets[5], object.languageCode);
  writer.writeDateTime(offsets[6], object.lastBackupDate);
  writer.writeDateTime(offsets[7], object.lastUpdated);
  writer.writeBool(offsets[8], object.notificationsEnabled);
  writer.writeBool(offsets[9], object.onboardingCompleted);
  writer.writeLong(offsets[10], object.onboardingLastVersion);
  writer.writeBool(offsets[11], object.useDarkMode);
  writer.writeBool(offsets[12], object.weeklyReportEnabled);
}

AppPreferences _appPreferencesDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AppPreferences();
  object.analyticsEnabled = reader.readBool(offsets[0]);
  object.backupEnabled = reader.readBool(offsets[1]);
  object.dailySummaryEnabled = reader.readBool(offsets[2]);
  object.dataCollectionEnabled = reader.readBool(offsets[3]);
  object.id = id;
  object.key = reader.readString(offsets[4]);
  object.languageCode = reader.readString(offsets[5]);
  object.lastBackupDate = reader.readDateTimeOrNull(offsets[6]);
  object.lastUpdated = reader.readDateTime(offsets[7]);
  object.notificationsEnabled = reader.readBool(offsets[8]);
  object.onboardingCompleted = reader.readBool(offsets[9]);
  object.onboardingLastVersion = reader.readLongOrNull(offsets[10]);
  object.useDarkMode = reader.readBool(offsets[11]);
  object.weeklyReportEnabled = reader.readBool(offsets[12]);
  return object;
}

P _appPreferencesDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 7:
      return (reader.readDateTime(offset)) as P;
    case 8:
      return (reader.readBool(offset)) as P;
    case 9:
      return (reader.readBool(offset)) as P;
    case 10:
      return (reader.readLongOrNull(offset)) as P;
    case 11:
      return (reader.readBool(offset)) as P;
    case 12:
      return (reader.readBool(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _appPreferencesGetId(AppPreferences object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _appPreferencesGetLinks(AppPreferences object) {
  return [];
}

void _appPreferencesAttach(
    IsarCollection<dynamic> col, Id id, AppPreferences object) {
  object.id = id;
}

extension AppPreferencesByIndex on IsarCollection<AppPreferences> {
  Future<AppPreferences?> getByKey(String key) {
    return getByIndex(r'key', [key]);
  }

  AppPreferences? getByKeySync(String key) {
    return getByIndexSync(r'key', [key]);
  }

  Future<bool> deleteByKey(String key) {
    return deleteByIndex(r'key', [key]);
  }

  bool deleteByKeySync(String key) {
    return deleteByIndexSync(r'key', [key]);
  }

  Future<List<AppPreferences?>> getAllByKey(List<String> keyValues) {
    final values = keyValues.map((e) => [e]).toList();
    return getAllByIndex(r'key', values);
  }

  List<AppPreferences?> getAllByKeySync(List<String> keyValues) {
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

  Future<Id> putByKey(AppPreferences object) {
    return putByIndex(r'key', object);
  }

  Id putByKeySync(AppPreferences object, {bool saveLinks = true}) {
    return putByIndexSync(r'key', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByKey(List<AppPreferences> objects) {
    return putAllByIndex(r'key', objects);
  }

  List<Id> putAllByKeySync(List<AppPreferences> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'key', objects, saveLinks: saveLinks);
  }
}

extension AppPreferencesQueryWhereSort
    on QueryBuilder<AppPreferences, AppPreferences, QWhere> {
  QueryBuilder<AppPreferences, AppPreferences, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QAfterWhere> anyLastUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'lastUpdated'),
      );
    });
  }
}

extension AppPreferencesQueryWhere
    on QueryBuilder<AppPreferences, AppPreferences, QWhereClause> {
  QueryBuilder<AppPreferences, AppPreferences, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<AppPreferences, AppPreferences, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QAfterWhereClause> idBetween(
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

  QueryBuilder<AppPreferences, AppPreferences, QAfterWhereClause> keyEqualTo(
      String key) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'key',
        value: [key],
      ));
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QAfterWhereClause> keyNotEqualTo(
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

  QueryBuilder<AppPreferences, AppPreferences, QAfterWhereClause>
      lastUpdatedEqualTo(DateTime lastUpdated) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'lastUpdated',
        value: [lastUpdated],
      ));
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QAfterWhereClause>
      lastUpdatedNotEqualTo(DateTime lastUpdated) {
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

  QueryBuilder<AppPreferences, AppPreferences, QAfterWhereClause>
      lastUpdatedGreaterThan(
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

  QueryBuilder<AppPreferences, AppPreferences, QAfterWhereClause>
      lastUpdatedLessThan(
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

  QueryBuilder<AppPreferences, AppPreferences, QAfterWhereClause>
      lastUpdatedBetween(
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
}

extension AppPreferencesQueryFilter
    on QueryBuilder<AppPreferences, AppPreferences, QFilterCondition> {
  QueryBuilder<AppPreferences, AppPreferences, QAfterFilterCondition>
      analyticsEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'analyticsEnabled',
        value: value,
      ));
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QAfterFilterCondition>
      backupEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'backupEnabled',
        value: value,
      ));
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QAfterFilterCondition>
      dailySummaryEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dailySummaryEnabled',
        value: value,
      ));
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QAfterFilterCondition>
      dataCollectionEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dataCollectionEnabled',
        value: value,
      ));
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QAfterFilterCondition>
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

  QueryBuilder<AppPreferences, AppPreferences, QAfterFilterCondition>
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

  QueryBuilder<AppPreferences, AppPreferences, QAfterFilterCondition> idBetween(
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

  QueryBuilder<AppPreferences, AppPreferences, QAfterFilterCondition>
      keyEqualTo(
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

  QueryBuilder<AppPreferences, AppPreferences, QAfterFilterCondition>
      keyGreaterThan(
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

  QueryBuilder<AppPreferences, AppPreferences, QAfterFilterCondition>
      keyLessThan(
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

  QueryBuilder<AppPreferences, AppPreferences, QAfterFilterCondition>
      keyBetween(
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

  QueryBuilder<AppPreferences, AppPreferences, QAfterFilterCondition>
      keyStartsWith(
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

  QueryBuilder<AppPreferences, AppPreferences, QAfterFilterCondition>
      keyEndsWith(
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

  QueryBuilder<AppPreferences, AppPreferences, QAfterFilterCondition>
      keyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'key',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QAfterFilterCondition>
      keyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'key',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QAfterFilterCondition>
      keyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'key',
        value: '',
      ));
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QAfterFilterCondition>
      keyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'key',
        value: '',
      ));
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QAfterFilterCondition>
      languageCodeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'languageCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QAfterFilterCondition>
      languageCodeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'languageCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QAfterFilterCondition>
      languageCodeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'languageCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QAfterFilterCondition>
      languageCodeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'languageCode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QAfterFilterCondition>
      languageCodeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'languageCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QAfterFilterCondition>
      languageCodeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'languageCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QAfterFilterCondition>
      languageCodeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'languageCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QAfterFilterCondition>
      languageCodeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'languageCode',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QAfterFilterCondition>
      languageCodeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'languageCode',
        value: '',
      ));
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QAfterFilterCondition>
      languageCodeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'languageCode',
        value: '',
      ));
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QAfterFilterCondition>
      lastBackupDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastBackupDate',
      ));
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QAfterFilterCondition>
      lastBackupDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastBackupDate',
      ));
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QAfterFilterCondition>
      lastBackupDateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastBackupDate',
        value: value,
      ));
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QAfterFilterCondition>
      lastBackupDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastBackupDate',
        value: value,
      ));
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QAfterFilterCondition>
      lastBackupDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastBackupDate',
        value: value,
      ));
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QAfterFilterCondition>
      lastBackupDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastBackupDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QAfterFilterCondition>
      lastUpdatedEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastUpdated',
        value: value,
      ));
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QAfterFilterCondition>
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

  QueryBuilder<AppPreferences, AppPreferences, QAfterFilterCondition>
      lastUpdatedLessThan(
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

  QueryBuilder<AppPreferences, AppPreferences, QAfterFilterCondition>
      lastUpdatedBetween(
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

  QueryBuilder<AppPreferences, AppPreferences, QAfterFilterCondition>
      notificationsEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notificationsEnabled',
        value: value,
      ));
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QAfterFilterCondition>
      onboardingCompletedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'onboardingCompleted',
        value: value,
      ));
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QAfterFilterCondition>
      onboardingLastVersionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'onboardingLastVersion',
      ));
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QAfterFilterCondition>
      onboardingLastVersionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'onboardingLastVersion',
      ));
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QAfterFilterCondition>
      onboardingLastVersionEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'onboardingLastVersion',
        value: value,
      ));
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QAfterFilterCondition>
      onboardingLastVersionGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'onboardingLastVersion',
        value: value,
      ));
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QAfterFilterCondition>
      onboardingLastVersionLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'onboardingLastVersion',
        value: value,
      ));
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QAfterFilterCondition>
      onboardingLastVersionBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'onboardingLastVersion',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QAfterFilterCondition>
      useDarkModeEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'useDarkMode',
        value: value,
      ));
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QAfterFilterCondition>
      weeklyReportEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'weeklyReportEnabled',
        value: value,
      ));
    });
  }
}

extension AppPreferencesQueryObject
    on QueryBuilder<AppPreferences, AppPreferences, QFilterCondition> {}

extension AppPreferencesQueryLinks
    on QueryBuilder<AppPreferences, AppPreferences, QFilterCondition> {}

extension AppPreferencesQuerySortBy
    on QueryBuilder<AppPreferences, AppPreferences, QSortBy> {
  QueryBuilder<AppPreferences, AppPreferences, QAfterSortBy>
      sortByAnalyticsEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'analyticsEnabled', Sort.asc);
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QAfterSortBy>
      sortByAnalyticsEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'analyticsEnabled', Sort.desc);
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QAfterSortBy>
      sortByBackupEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backupEnabled', Sort.asc);
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QAfterSortBy>
      sortByBackupEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backupEnabled', Sort.desc);
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QAfterSortBy>
      sortByDailySummaryEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailySummaryEnabled', Sort.asc);
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QAfterSortBy>
      sortByDailySummaryEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailySummaryEnabled', Sort.desc);
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QAfterSortBy>
      sortByDataCollectionEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataCollectionEnabled', Sort.asc);
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QAfterSortBy>
      sortByDataCollectionEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataCollectionEnabled', Sort.desc);
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QAfterSortBy> sortByKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.asc);
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QAfterSortBy> sortByKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.desc);
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QAfterSortBy>
      sortByLanguageCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'languageCode', Sort.asc);
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QAfterSortBy>
      sortByLanguageCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'languageCode', Sort.desc);
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QAfterSortBy>
      sortByLastBackupDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastBackupDate', Sort.asc);
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QAfterSortBy>
      sortByLastBackupDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastBackupDate', Sort.desc);
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QAfterSortBy>
      sortByLastUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.asc);
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QAfterSortBy>
      sortByLastUpdatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.desc);
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QAfterSortBy>
      sortByNotificationsEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notificationsEnabled', Sort.asc);
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QAfterSortBy>
      sortByNotificationsEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notificationsEnabled', Sort.desc);
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QAfterSortBy>
      sortByOnboardingCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'onboardingCompleted', Sort.asc);
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QAfterSortBy>
      sortByOnboardingCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'onboardingCompleted', Sort.desc);
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QAfterSortBy>
      sortByOnboardingLastVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'onboardingLastVersion', Sort.asc);
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QAfterSortBy>
      sortByOnboardingLastVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'onboardingLastVersion', Sort.desc);
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QAfterSortBy>
      sortByUseDarkMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useDarkMode', Sort.asc);
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QAfterSortBy>
      sortByUseDarkModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useDarkMode', Sort.desc);
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QAfterSortBy>
      sortByWeeklyReportEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weeklyReportEnabled', Sort.asc);
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QAfterSortBy>
      sortByWeeklyReportEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weeklyReportEnabled', Sort.desc);
    });
  }
}

extension AppPreferencesQuerySortThenBy
    on QueryBuilder<AppPreferences, AppPreferences, QSortThenBy> {
  QueryBuilder<AppPreferences, AppPreferences, QAfterSortBy>
      thenByAnalyticsEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'analyticsEnabled', Sort.asc);
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QAfterSortBy>
      thenByAnalyticsEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'analyticsEnabled', Sort.desc);
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QAfterSortBy>
      thenByBackupEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backupEnabled', Sort.asc);
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QAfterSortBy>
      thenByBackupEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backupEnabled', Sort.desc);
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QAfterSortBy>
      thenByDailySummaryEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailySummaryEnabled', Sort.asc);
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QAfterSortBy>
      thenByDailySummaryEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailySummaryEnabled', Sort.desc);
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QAfterSortBy>
      thenByDataCollectionEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataCollectionEnabled', Sort.asc);
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QAfterSortBy>
      thenByDataCollectionEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataCollectionEnabled', Sort.desc);
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QAfterSortBy> thenByKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.asc);
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QAfterSortBy> thenByKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.desc);
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QAfterSortBy>
      thenByLanguageCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'languageCode', Sort.asc);
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QAfterSortBy>
      thenByLanguageCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'languageCode', Sort.desc);
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QAfterSortBy>
      thenByLastBackupDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastBackupDate', Sort.asc);
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QAfterSortBy>
      thenByLastBackupDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastBackupDate', Sort.desc);
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QAfterSortBy>
      thenByLastUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.asc);
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QAfterSortBy>
      thenByLastUpdatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.desc);
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QAfterSortBy>
      thenByNotificationsEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notificationsEnabled', Sort.asc);
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QAfterSortBy>
      thenByNotificationsEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notificationsEnabled', Sort.desc);
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QAfterSortBy>
      thenByOnboardingCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'onboardingCompleted', Sort.asc);
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QAfterSortBy>
      thenByOnboardingCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'onboardingCompleted', Sort.desc);
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QAfterSortBy>
      thenByOnboardingLastVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'onboardingLastVersion', Sort.asc);
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QAfterSortBy>
      thenByOnboardingLastVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'onboardingLastVersion', Sort.desc);
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QAfterSortBy>
      thenByUseDarkMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useDarkMode', Sort.asc);
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QAfterSortBy>
      thenByUseDarkModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useDarkMode', Sort.desc);
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QAfterSortBy>
      thenByWeeklyReportEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weeklyReportEnabled', Sort.asc);
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QAfterSortBy>
      thenByWeeklyReportEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weeklyReportEnabled', Sort.desc);
    });
  }
}

extension AppPreferencesQueryWhereDistinct
    on QueryBuilder<AppPreferences, AppPreferences, QDistinct> {
  QueryBuilder<AppPreferences, AppPreferences, QDistinct>
      distinctByAnalyticsEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'analyticsEnabled');
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QDistinct>
      distinctByBackupEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'backupEnabled');
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QDistinct>
      distinctByDailySummaryEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dailySummaryEnabled');
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QDistinct>
      distinctByDataCollectionEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dataCollectionEnabled');
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QDistinct> distinctByKey(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'key', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QDistinct>
      distinctByLanguageCode({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'languageCode', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QDistinct>
      distinctByLastBackupDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastBackupDate');
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QDistinct>
      distinctByLastUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastUpdated');
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QDistinct>
      distinctByNotificationsEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notificationsEnabled');
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QDistinct>
      distinctByOnboardingCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'onboardingCompleted');
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QDistinct>
      distinctByOnboardingLastVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'onboardingLastVersion');
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QDistinct>
      distinctByUseDarkMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'useDarkMode');
    });
  }

  QueryBuilder<AppPreferences, AppPreferences, QDistinct>
      distinctByWeeklyReportEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'weeklyReportEnabled');
    });
  }
}

extension AppPreferencesQueryProperty
    on QueryBuilder<AppPreferences, AppPreferences, QQueryProperty> {
  QueryBuilder<AppPreferences, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<AppPreferences, bool, QQueryOperations>
      analyticsEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'analyticsEnabled');
    });
  }

  QueryBuilder<AppPreferences, bool, QQueryOperations> backupEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'backupEnabled');
    });
  }

  QueryBuilder<AppPreferences, bool, QQueryOperations>
      dailySummaryEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dailySummaryEnabled');
    });
  }

  QueryBuilder<AppPreferences, bool, QQueryOperations>
      dataCollectionEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dataCollectionEnabled');
    });
  }

  QueryBuilder<AppPreferences, String, QQueryOperations> keyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'key');
    });
  }

  QueryBuilder<AppPreferences, String, QQueryOperations>
      languageCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'languageCode');
    });
  }

  QueryBuilder<AppPreferences, DateTime?, QQueryOperations>
      lastBackupDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastBackupDate');
    });
  }

  QueryBuilder<AppPreferences, DateTime, QQueryOperations>
      lastUpdatedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastUpdated');
    });
  }

  QueryBuilder<AppPreferences, bool, QQueryOperations>
      notificationsEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notificationsEnabled');
    });
  }

  QueryBuilder<AppPreferences, bool, QQueryOperations>
      onboardingCompletedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'onboardingCompleted');
    });
  }

  QueryBuilder<AppPreferences, int?, QQueryOperations>
      onboardingLastVersionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'onboardingLastVersion');
    });
  }

  QueryBuilder<AppPreferences, bool, QQueryOperations> useDarkModeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'useDarkMode');
    });
  }

  QueryBuilder<AppPreferences, bool, QQueryOperations>
      weeklyReportEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'weeklyReportEnabled');
    });
  }
}
