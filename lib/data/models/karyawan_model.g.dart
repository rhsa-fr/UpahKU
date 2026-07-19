// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'karyawan_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetKaryawanModelCollection on Isar {
  IsarCollection<KaryawanModel> get karyawanModels => this.collection();
}

const KaryawanModelSchema = CollectionSchema(
  name: r'Karyawan',
  id: 465754058898660,
  properties: {
    r'createdAt': PropertySchema(
      id: 0,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'jabatan': PropertySchema(
      id: 1,
      name: r'jabatan',
      type: IsarType.string,
    ),
    r'nama': PropertySchema(
      id: 2,
      name: r'nama',
      type: IsarType.string,
    ),
    r'statusAktif': PropertySchema(
      id: 3,
      name: r'statusAktif',
      type: IsarType.bool,
    ),
    r'tarifLembur': PropertySchema(
      id: 4,
      name: r'tarifLembur',
      type: IsarType.double,
    ),
    r'upahHarian': PropertySchema(
      id: 5,
      name: r'upahHarian',
      type: IsarType.double,
    )
  },
  estimateSize: _karyawanModelEstimateSize,
  serialize: _karyawanModelSerialize,
  deserialize: _karyawanModelDeserialize,
  deserializeProp: _karyawanModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'nama': IndexSchema(
      id: 503954265355155,
      name: r'nama',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'nama',
          type: IndexType.hash,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _karyawanModelGetId,
  getLinks: _karyawanModelGetLinks,
  attach: _karyawanModelAttach,
  version: '3.1.0+1',
);

int _karyawanModelEstimateSize(
  KaryawanModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.jabatan.length * 3;
  bytesCount += 3 + object.nama.length * 3;
  return bytesCount;
}

void _karyawanModelSerialize(
  KaryawanModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeString(offsets[1], object.jabatan);
  writer.writeString(offsets[2], object.nama);
  writer.writeBool(offsets[3], object.statusAktif);
  writer.writeDouble(offsets[4], object.tarifLembur);
  writer.writeDouble(offsets[5], object.upahHarian);
}

KaryawanModel _karyawanModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = KaryawanModel();
  object.createdAt = reader.readDateTime(offsets[0]);
  object.id = id;
  object.jabatan = reader.readString(offsets[1]);
  object.nama = reader.readString(offsets[2]);
  object.statusAktif = reader.readBool(offsets[3]);
  object.tarifLembur = reader.readDouble(offsets[4]);
  object.upahHarian = reader.readDouble(offsets[5]);
  return object;
}

P _karyawanModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readDouble(offset)) as P;
    case 5:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _karyawanModelGetId(KaryawanModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _karyawanModelGetLinks(KaryawanModel object) {
  return [];
}

void _karyawanModelAttach(
    IsarCollection<dynamic> col, Id id, KaryawanModel object) {
  object.id = id;
}

extension KaryawanModelByIndex on IsarCollection<KaryawanModel> {
  Future<KaryawanModel?> getByNama(String nama) {
    return getByIndex(r'nama', [nama]);
  }

  KaryawanModel? getByNamaSync(String nama) {
    return getByIndexSync(r'nama', [nama]);
  }

  Future<bool> deleteByNama(String nama) {
    return deleteByIndex(r'nama', [nama]);
  }

  bool deleteByNamaSync(String nama) {
    return deleteByIndexSync(r'nama', [nama]);
  }

  Future<List<KaryawanModel?>> getAllByNama(List<String> namaValues) {
    final values = namaValues.map((e) => [e]).toList();
    return getAllByIndex(r'nama', values);
  }

  List<KaryawanModel?> getAllByNamaSync(List<String> namaValues) {
    final values = namaValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'nama', values);
  }

  Future<int> deleteAllByNama(List<String> namaValues) {
    final values = namaValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'nama', values);
  }

  int deleteAllByNamaSync(List<String> namaValues) {
    final values = namaValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'nama', values);
  }

  Future<Id> putByNama(KaryawanModel object) {
    return putByIndex(r'nama', object);
  }

  Id putByNamaSync(KaryawanModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'nama', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByNama(List<KaryawanModel> objects) {
    return putAllByIndex(r'nama', objects);
  }

  List<Id> putAllByNamaSync(List<KaryawanModel> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'nama', objects, saveLinks: saveLinks);
  }
}

extension KaryawanModelQueryWhereSort
    on QueryBuilder<KaryawanModel, KaryawanModel, QWhere> {
  QueryBuilder<KaryawanModel, KaryawanModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension KaryawanModelQueryWhere
    on QueryBuilder<KaryawanModel, KaryawanModel, QWhereClause> {
  QueryBuilder<KaryawanModel, KaryawanModel, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<KaryawanModel, KaryawanModel, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<KaryawanModel, KaryawanModel, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<KaryawanModel, KaryawanModel, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<KaryawanModel, KaryawanModel, QAfterWhereClause> idBetween(
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

  QueryBuilder<KaryawanModel, KaryawanModel, QAfterWhereClause> namaEqualTo(
      String nama) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'nama',
        value: [nama],
      ));
    });
  }

  QueryBuilder<KaryawanModel, KaryawanModel, QAfterWhereClause> namaNotEqualTo(
      String nama) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'nama',
              lower: [],
              upper: [nama],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'nama',
              lower: [nama],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'nama',
              lower: [nama],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'nama',
              lower: [],
              upper: [nama],
              includeUpper: false,
            ));
      }
    });
  }
}

extension KaryawanModelQueryFilter
    on QueryBuilder<KaryawanModel, KaryawanModel, QFilterCondition> {
  QueryBuilder<KaryawanModel, KaryawanModel, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<KaryawanModel, KaryawanModel, QAfterFilterCondition>
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

  QueryBuilder<KaryawanModel, KaryawanModel, QAfterFilterCondition>
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

  QueryBuilder<KaryawanModel, KaryawanModel, QAfterFilterCondition>
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

  QueryBuilder<KaryawanModel, KaryawanModel, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<KaryawanModel, KaryawanModel, QAfterFilterCondition>
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

  QueryBuilder<KaryawanModel, KaryawanModel, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<KaryawanModel, KaryawanModel, QAfterFilterCondition> idBetween(
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

  QueryBuilder<KaryawanModel, KaryawanModel, QAfterFilterCondition>
      jabatanEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'jabatan',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KaryawanModel, KaryawanModel, QAfterFilterCondition>
      jabatanGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'jabatan',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KaryawanModel, KaryawanModel, QAfterFilterCondition>
      jabatanLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'jabatan',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KaryawanModel, KaryawanModel, QAfterFilterCondition>
      jabatanBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'jabatan',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KaryawanModel, KaryawanModel, QAfterFilterCondition>
      jabatanStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'jabatan',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KaryawanModel, KaryawanModel, QAfterFilterCondition>
      jabatanEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'jabatan',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KaryawanModel, KaryawanModel, QAfterFilterCondition>
      jabatanContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'jabatan',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KaryawanModel, KaryawanModel, QAfterFilterCondition>
      jabatanMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'jabatan',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KaryawanModel, KaryawanModel, QAfterFilterCondition>
      jabatanIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'jabatan',
        value: '',
      ));
    });
  }

  QueryBuilder<KaryawanModel, KaryawanModel, QAfterFilterCondition>
      jabatanIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'jabatan',
        value: '',
      ));
    });
  }

  QueryBuilder<KaryawanModel, KaryawanModel, QAfterFilterCondition> namaEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nama',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KaryawanModel, KaryawanModel, QAfterFilterCondition>
      namaGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'nama',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KaryawanModel, KaryawanModel, QAfterFilterCondition>
      namaLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'nama',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KaryawanModel, KaryawanModel, QAfterFilterCondition> namaBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'nama',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KaryawanModel, KaryawanModel, QAfterFilterCondition>
      namaStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'nama',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KaryawanModel, KaryawanModel, QAfterFilterCondition>
      namaEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'nama',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KaryawanModel, KaryawanModel, QAfterFilterCondition>
      namaContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'nama',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KaryawanModel, KaryawanModel, QAfterFilterCondition> namaMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'nama',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KaryawanModel, KaryawanModel, QAfterFilterCondition>
      namaIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nama',
        value: '',
      ));
    });
  }

  QueryBuilder<KaryawanModel, KaryawanModel, QAfterFilterCondition>
      namaIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'nama',
        value: '',
      ));
    });
  }

  QueryBuilder<KaryawanModel, KaryawanModel, QAfterFilterCondition>
      statusAktifEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'statusAktif',
        value: value,
      ));
    });
  }

  QueryBuilder<KaryawanModel, KaryawanModel, QAfterFilterCondition>
      tarifLemburEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tarifLembur',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<KaryawanModel, KaryawanModel, QAfterFilterCondition>
      tarifLemburGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'tarifLembur',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<KaryawanModel, KaryawanModel, QAfterFilterCondition>
      tarifLemburLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'tarifLembur',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<KaryawanModel, KaryawanModel, QAfterFilterCondition>
      tarifLemburBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'tarifLembur',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<KaryawanModel, KaryawanModel, QAfterFilterCondition>
      upahHarianEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'upahHarian',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<KaryawanModel, KaryawanModel, QAfterFilterCondition>
      upahHarianGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'upahHarian',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<KaryawanModel, KaryawanModel, QAfterFilterCondition>
      upahHarianLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'upahHarian',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<KaryawanModel, KaryawanModel, QAfterFilterCondition>
      upahHarianBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'upahHarian',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension KaryawanModelQueryObject
    on QueryBuilder<KaryawanModel, KaryawanModel, QFilterCondition> {}

extension KaryawanModelQueryLinks
    on QueryBuilder<KaryawanModel, KaryawanModel, QFilterCondition> {}

extension KaryawanModelQuerySortBy
    on QueryBuilder<KaryawanModel, KaryawanModel, QSortBy> {
  QueryBuilder<KaryawanModel, KaryawanModel, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<KaryawanModel, KaryawanModel, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<KaryawanModel, KaryawanModel, QAfterSortBy> sortByJabatan() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'jabatan', Sort.asc);
    });
  }

  QueryBuilder<KaryawanModel, KaryawanModel, QAfterSortBy> sortByJabatanDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'jabatan', Sort.desc);
    });
  }

  QueryBuilder<KaryawanModel, KaryawanModel, QAfterSortBy> sortByNama() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nama', Sort.asc);
    });
  }

  QueryBuilder<KaryawanModel, KaryawanModel, QAfterSortBy> sortByNamaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nama', Sort.desc);
    });
  }

  QueryBuilder<KaryawanModel, KaryawanModel, QAfterSortBy> sortByStatusAktif() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statusAktif', Sort.asc);
    });
  }

  QueryBuilder<KaryawanModel, KaryawanModel, QAfterSortBy>
      sortByStatusAktifDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statusAktif', Sort.desc);
    });
  }

  QueryBuilder<KaryawanModel, KaryawanModel, QAfterSortBy> sortByTarifLembur() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tarifLembur', Sort.asc);
    });
  }

  QueryBuilder<KaryawanModel, KaryawanModel, QAfterSortBy>
      sortByTarifLemburDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tarifLembur', Sort.desc);
    });
  }

  QueryBuilder<KaryawanModel, KaryawanModel, QAfterSortBy> sortByUpahHarian() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'upahHarian', Sort.asc);
    });
  }

  QueryBuilder<KaryawanModel, KaryawanModel, QAfterSortBy>
      sortByUpahHarianDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'upahHarian', Sort.desc);
    });
  }
}

extension KaryawanModelQuerySortThenBy
    on QueryBuilder<KaryawanModel, KaryawanModel, QSortThenBy> {
  QueryBuilder<KaryawanModel, KaryawanModel, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<KaryawanModel, KaryawanModel, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<KaryawanModel, KaryawanModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<KaryawanModel, KaryawanModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<KaryawanModel, KaryawanModel, QAfterSortBy> thenByJabatan() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'jabatan', Sort.asc);
    });
  }

  QueryBuilder<KaryawanModel, KaryawanModel, QAfterSortBy> thenByJabatanDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'jabatan', Sort.desc);
    });
  }

  QueryBuilder<KaryawanModel, KaryawanModel, QAfterSortBy> thenByNama() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nama', Sort.asc);
    });
  }

  QueryBuilder<KaryawanModel, KaryawanModel, QAfterSortBy> thenByNamaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nama', Sort.desc);
    });
  }

  QueryBuilder<KaryawanModel, KaryawanModel, QAfterSortBy> thenByStatusAktif() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statusAktif', Sort.asc);
    });
  }

  QueryBuilder<KaryawanModel, KaryawanModel, QAfterSortBy>
      thenByStatusAktifDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statusAktif', Sort.desc);
    });
  }

  QueryBuilder<KaryawanModel, KaryawanModel, QAfterSortBy> thenByTarifLembur() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tarifLembur', Sort.asc);
    });
  }

  QueryBuilder<KaryawanModel, KaryawanModel, QAfterSortBy>
      thenByTarifLemburDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tarifLembur', Sort.desc);
    });
  }

  QueryBuilder<KaryawanModel, KaryawanModel, QAfterSortBy> thenByUpahHarian() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'upahHarian', Sort.asc);
    });
  }

  QueryBuilder<KaryawanModel, KaryawanModel, QAfterSortBy>
      thenByUpahHarianDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'upahHarian', Sort.desc);
    });
  }
}

extension KaryawanModelQueryWhereDistinct
    on QueryBuilder<KaryawanModel, KaryawanModel, QDistinct> {
  QueryBuilder<KaryawanModel, KaryawanModel, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<KaryawanModel, KaryawanModel, QDistinct> distinctByJabatan(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'jabatan', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<KaryawanModel, KaryawanModel, QDistinct> distinctByNama(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nama', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<KaryawanModel, KaryawanModel, QDistinct>
      distinctByStatusAktif() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'statusAktif');
    });
  }

  QueryBuilder<KaryawanModel, KaryawanModel, QDistinct>
      distinctByTarifLembur() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tarifLembur');
    });
  }

  QueryBuilder<KaryawanModel, KaryawanModel, QDistinct> distinctByUpahHarian() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'upahHarian');
    });
  }
}

extension KaryawanModelQueryProperty
    on QueryBuilder<KaryawanModel, KaryawanModel, QQueryProperty> {
  QueryBuilder<KaryawanModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<KaryawanModel, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<KaryawanModel, String, QQueryOperations> jabatanProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'jabatan');
    });
  }

  QueryBuilder<KaryawanModel, String, QQueryOperations> namaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nama');
    });
  }

  QueryBuilder<KaryawanModel, bool, QQueryOperations> statusAktifProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'statusAktif');
    });
  }

  QueryBuilder<KaryawanModel, double, QQueryOperations> tarifLemburProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tarifLembur');
    });
  }

  QueryBuilder<KaryawanModel, double, QQueryOperations> upahHarianProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'upahHarian');
    });
  }
}
