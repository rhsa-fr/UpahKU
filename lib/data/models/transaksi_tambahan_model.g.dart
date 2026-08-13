// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaksi_tambahan_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetTransaksiTambahanModelCollection on Isar {
  IsarCollection<TransaksiTambahanModel> get transaksiTambahanModels =>
      this.collection();
}

const TransaksiTambahanModelSchema = CollectionSchema(
  name: r'TransaksiTambahan',
  id: -91602280,
  properties: {
    r'keterangan': PropertySchema(
      id: 0,
      name: r'keterangan',
      type: IsarType.string,
    ),
    r'nominal': PropertySchema(
      id: 1,
      name: r'nominal',
      type: IsarType.double,
    ),
    r'tanggal': PropertySchema(
      id: 2,
      name: r'tanggal',
      type: IsarType.dateTime,
    ),
    r'tipe': PropertySchema(
      id: 3,
      name: r'tipe',
      type: IsarType.string,
    )
  },
  estimateSize: _transaksiTambahanModelEstimateSize,
  serialize: _transaksiTambahanModelSerialize,
  deserialize: _transaksiTambahanModelDeserialize,
  deserializeProp: _transaksiTambahanModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'tanggal': IndexSchema(
      id: 51930705,
      name: r'tanggal',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'tanggal',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {
    r'karyawan': LinkSchema(
      id: -14261807,
      name: r'karyawan',
      target: r'Karyawan',
      single: true,
    )
  },
  embeddedSchemas: {},
  getId: _transaksiTambahanModelGetId,
  getLinks: _transaksiTambahanModelGetLinks,
  attach: _transaksiTambahanModelAttach,
  version: '3.1.0+1',
);

int _transaksiTambahanModelEstimateSize(
  TransaksiTambahanModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.keterangan.length * 3;
  bytesCount += 3 + object.tipe.length * 3;
  return bytesCount;
}

void _transaksiTambahanModelSerialize(
  TransaksiTambahanModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.keterangan);
  writer.writeDouble(offsets[1], object.nominal);
  writer.writeDateTime(offsets[2], object.tanggal);
  writer.writeString(offsets[3], object.tipe);
}

TransaksiTambahanModel _transaksiTambahanModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TransaksiTambahanModel();
  object.id = id;
  object.keterangan = reader.readString(offsets[0]);
  object.nominal = reader.readDouble(offsets[1]);
  object.tanggal = reader.readDateTime(offsets[2]);
  object.tipe = reader.readString(offsets[3]);
  return object;
}

P _transaksiTambahanModelDeserializeProp<P>(
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
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _transaksiTambahanModelGetId(TransaksiTambahanModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _transaksiTambahanModelGetLinks(
    TransaksiTambahanModel object) {
  return [object.karyawan];
}

void _transaksiTambahanModelAttach(
    IsarCollection<dynamic> col, Id id, TransaksiTambahanModel object) {
  object.id = id;
  object.karyawan
      .attach(col, col.isar.collection<KaryawanModel>(), r'karyawan', id);
}

extension TransaksiTambahanModelQueryWhereSort
    on QueryBuilder<TransaksiTambahanModel, TransaksiTambahanModel, QWhere> {
  QueryBuilder<TransaksiTambahanModel, TransaksiTambahanModel, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<TransaksiTambahanModel, TransaksiTambahanModel, QAfterWhere>
      anyTanggal() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'tanggal'),
      );
    });
  }
}

extension TransaksiTambahanModelQueryWhere on QueryBuilder<
    TransaksiTambahanModel, TransaksiTambahanModel, QWhereClause> {
  QueryBuilder<TransaksiTambahanModel, TransaksiTambahanModel,
      QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<TransaksiTambahanModel, TransaksiTambahanModel,
      QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<TransaksiTambahanModel, TransaksiTambahanModel,
      QAfterWhereClause> idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<TransaksiTambahanModel, TransaksiTambahanModel,
      QAfterWhereClause> idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<TransaksiTambahanModel, TransaksiTambahanModel,
      QAfterWhereClause> idBetween(
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

  QueryBuilder<TransaksiTambahanModel, TransaksiTambahanModel,
      QAfterWhereClause> tanggalEqualTo(DateTime tanggal) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'tanggal',
        value: [tanggal],
      ));
    });
  }

  QueryBuilder<TransaksiTambahanModel, TransaksiTambahanModel,
      QAfterWhereClause> tanggalNotEqualTo(DateTime tanggal) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tanggal',
              lower: [],
              upper: [tanggal],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tanggal',
              lower: [tanggal],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tanggal',
              lower: [tanggal],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tanggal',
              lower: [],
              upper: [tanggal],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<TransaksiTambahanModel, TransaksiTambahanModel,
      QAfterWhereClause> tanggalGreaterThan(
    DateTime tanggal, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'tanggal',
        lower: [tanggal],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<TransaksiTambahanModel, TransaksiTambahanModel,
      QAfterWhereClause> tanggalLessThan(
    DateTime tanggal, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'tanggal',
        lower: [],
        upper: [tanggal],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<TransaksiTambahanModel, TransaksiTambahanModel,
      QAfterWhereClause> tanggalBetween(
    DateTime lowerTanggal,
    DateTime upperTanggal, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'tanggal',
        lower: [lowerTanggal],
        includeLower: includeLower,
        upper: [upperTanggal],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension TransaksiTambahanModelQueryFilter on QueryBuilder<
    TransaksiTambahanModel, TransaksiTambahanModel, QFilterCondition> {
  QueryBuilder<TransaksiTambahanModel, TransaksiTambahanModel,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TransaksiTambahanModel, TransaksiTambahanModel,
      QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<TransaksiTambahanModel, TransaksiTambahanModel,
      QAfterFilterCondition> idLessThan(
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

  QueryBuilder<TransaksiTambahanModel, TransaksiTambahanModel,
      QAfterFilterCondition> idBetween(
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

  QueryBuilder<TransaksiTambahanModel, TransaksiTambahanModel,
      QAfterFilterCondition> keteranganEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'keterangan',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransaksiTambahanModel, TransaksiTambahanModel,
      QAfterFilterCondition> keteranganGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'keterangan',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransaksiTambahanModel, TransaksiTambahanModel,
      QAfterFilterCondition> keteranganLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'keterangan',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransaksiTambahanModel, TransaksiTambahanModel,
      QAfterFilterCondition> keteranganBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'keterangan',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransaksiTambahanModel, TransaksiTambahanModel,
      QAfterFilterCondition> keteranganStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'keterangan',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransaksiTambahanModel, TransaksiTambahanModel,
      QAfterFilterCondition> keteranganEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'keterangan',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransaksiTambahanModel, TransaksiTambahanModel,
          QAfterFilterCondition>
      keteranganContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'keterangan',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransaksiTambahanModel, TransaksiTambahanModel,
          QAfterFilterCondition>
      keteranganMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'keterangan',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransaksiTambahanModel, TransaksiTambahanModel,
      QAfterFilterCondition> keteranganIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'keterangan',
        value: '',
      ));
    });
  }

  QueryBuilder<TransaksiTambahanModel, TransaksiTambahanModel,
      QAfterFilterCondition> keteranganIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'keterangan',
        value: '',
      ));
    });
  }

  QueryBuilder<TransaksiTambahanModel, TransaksiTambahanModel,
      QAfterFilterCondition> nominalEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nominal',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TransaksiTambahanModel, TransaksiTambahanModel,
      QAfterFilterCondition> nominalGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'nominal',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TransaksiTambahanModel, TransaksiTambahanModel,
      QAfterFilterCondition> nominalLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'nominal',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TransaksiTambahanModel, TransaksiTambahanModel,
      QAfterFilterCondition> nominalBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'nominal',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TransaksiTambahanModel, TransaksiTambahanModel,
      QAfterFilterCondition> tanggalEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tanggal',
        value: value,
      ));
    });
  }

  QueryBuilder<TransaksiTambahanModel, TransaksiTambahanModel,
      QAfterFilterCondition> tanggalGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'tanggal',
        value: value,
      ));
    });
  }

  QueryBuilder<TransaksiTambahanModel, TransaksiTambahanModel,
      QAfterFilterCondition> tanggalLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'tanggal',
        value: value,
      ));
    });
  }

  QueryBuilder<TransaksiTambahanModel, TransaksiTambahanModel,
      QAfterFilterCondition> tanggalBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'tanggal',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TransaksiTambahanModel, TransaksiTambahanModel,
      QAfterFilterCondition> tipeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tipe',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransaksiTambahanModel, TransaksiTambahanModel,
      QAfterFilterCondition> tipeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'tipe',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransaksiTambahanModel, TransaksiTambahanModel,
      QAfterFilterCondition> tipeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'tipe',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransaksiTambahanModel, TransaksiTambahanModel,
      QAfterFilterCondition> tipeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'tipe',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransaksiTambahanModel, TransaksiTambahanModel,
      QAfterFilterCondition> tipeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'tipe',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransaksiTambahanModel, TransaksiTambahanModel,
      QAfterFilterCondition> tipeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'tipe',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransaksiTambahanModel, TransaksiTambahanModel,
          QAfterFilterCondition>
      tipeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'tipe',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransaksiTambahanModel, TransaksiTambahanModel,
          QAfterFilterCondition>
      tipeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'tipe',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransaksiTambahanModel, TransaksiTambahanModel,
      QAfterFilterCondition> tipeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tipe',
        value: '',
      ));
    });
  }

  QueryBuilder<TransaksiTambahanModel, TransaksiTambahanModel,
      QAfterFilterCondition> tipeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'tipe',
        value: '',
      ));
    });
  }
}

extension TransaksiTambahanModelQueryObject on QueryBuilder<
    TransaksiTambahanModel, TransaksiTambahanModel, QFilterCondition> {}

extension TransaksiTambahanModelQueryLinks on QueryBuilder<
    TransaksiTambahanModel, TransaksiTambahanModel, QFilterCondition> {
  QueryBuilder<TransaksiTambahanModel, TransaksiTambahanModel,
      QAfterFilterCondition> karyawan(FilterQuery<KaryawanModel> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'karyawan');
    });
  }

  QueryBuilder<TransaksiTambahanModel, TransaksiTambahanModel,
      QAfterFilterCondition> karyawanIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'karyawan', 0, true, 0, true);
    });
  }
}

extension TransaksiTambahanModelQuerySortBy
    on QueryBuilder<TransaksiTambahanModel, TransaksiTambahanModel, QSortBy> {
  QueryBuilder<TransaksiTambahanModel, TransaksiTambahanModel, QAfterSortBy>
      sortByKeterangan() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'keterangan', Sort.asc);
    });
  }

  QueryBuilder<TransaksiTambahanModel, TransaksiTambahanModel, QAfterSortBy>
      sortByKeteranganDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'keterangan', Sort.desc);
    });
  }

  QueryBuilder<TransaksiTambahanModel, TransaksiTambahanModel, QAfterSortBy>
      sortByNominal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nominal', Sort.asc);
    });
  }

  QueryBuilder<TransaksiTambahanModel, TransaksiTambahanModel, QAfterSortBy>
      sortByNominalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nominal', Sort.desc);
    });
  }

  QueryBuilder<TransaksiTambahanModel, TransaksiTambahanModel, QAfterSortBy>
      sortByTanggal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tanggal', Sort.asc);
    });
  }

  QueryBuilder<TransaksiTambahanModel, TransaksiTambahanModel, QAfterSortBy>
      sortByTanggalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tanggal', Sort.desc);
    });
  }

  QueryBuilder<TransaksiTambahanModel, TransaksiTambahanModel, QAfterSortBy>
      sortByTipe() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tipe', Sort.asc);
    });
  }

  QueryBuilder<TransaksiTambahanModel, TransaksiTambahanModel, QAfterSortBy>
      sortByTipeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tipe', Sort.desc);
    });
  }
}

extension TransaksiTambahanModelQuerySortThenBy on QueryBuilder<
    TransaksiTambahanModel, TransaksiTambahanModel, QSortThenBy> {
  QueryBuilder<TransaksiTambahanModel, TransaksiTambahanModel, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<TransaksiTambahanModel, TransaksiTambahanModel, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<TransaksiTambahanModel, TransaksiTambahanModel, QAfterSortBy>
      thenByKeterangan() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'keterangan', Sort.asc);
    });
  }

  QueryBuilder<TransaksiTambahanModel, TransaksiTambahanModel, QAfterSortBy>
      thenByKeteranganDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'keterangan', Sort.desc);
    });
  }

  QueryBuilder<TransaksiTambahanModel, TransaksiTambahanModel, QAfterSortBy>
      thenByNominal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nominal', Sort.asc);
    });
  }

  QueryBuilder<TransaksiTambahanModel, TransaksiTambahanModel, QAfterSortBy>
      thenByNominalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nominal', Sort.desc);
    });
  }

  QueryBuilder<TransaksiTambahanModel, TransaksiTambahanModel, QAfterSortBy>
      thenByTanggal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tanggal', Sort.asc);
    });
  }

  QueryBuilder<TransaksiTambahanModel, TransaksiTambahanModel, QAfterSortBy>
      thenByTanggalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tanggal', Sort.desc);
    });
  }

  QueryBuilder<TransaksiTambahanModel, TransaksiTambahanModel, QAfterSortBy>
      thenByTipe() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tipe', Sort.asc);
    });
  }

  QueryBuilder<TransaksiTambahanModel, TransaksiTambahanModel, QAfterSortBy>
      thenByTipeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tipe', Sort.desc);
    });
  }
}

extension TransaksiTambahanModelQueryWhereDistinct
    on QueryBuilder<TransaksiTambahanModel, TransaksiTambahanModel, QDistinct> {
  QueryBuilder<TransaksiTambahanModel, TransaksiTambahanModel, QDistinct>
      distinctByKeterangan({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'keterangan', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransaksiTambahanModel, TransaksiTambahanModel, QDistinct>
      distinctByNominal() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nominal');
    });
  }

  QueryBuilder<TransaksiTambahanModel, TransaksiTambahanModel, QDistinct>
      distinctByTanggal() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tanggal');
    });
  }

  QueryBuilder<TransaksiTambahanModel, TransaksiTambahanModel, QDistinct>
      distinctByTipe({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tipe', caseSensitive: caseSensitive);
    });
  }
}

extension TransaksiTambahanModelQueryProperty on QueryBuilder<
    TransaksiTambahanModel, TransaksiTambahanModel, QQueryProperty> {
  QueryBuilder<TransaksiTambahanModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<TransaksiTambahanModel, String, QQueryOperations>
      keteranganProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'keterangan');
    });
  }

  QueryBuilder<TransaksiTambahanModel, double, QQueryOperations>
      nominalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nominal');
    });
  }

  QueryBuilder<TransaksiTambahanModel, DateTime, QQueryOperations>
      tanggalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tanggal');
    });
  }

  QueryBuilder<TransaksiTambahanModel, String, QQueryOperations>
      tipeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tipe');
    });
  }
}
