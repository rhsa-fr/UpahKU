// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lembur_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetLemburModelCollection on Isar {
  IsarCollection<LemburModel> get lemburModels => this.collection();
}

const LemburModelSchema = CollectionSchema(
  name: r'Lembur',
  id: 689825664465960,
  properties: {
    r'jumlahJam': PropertySchema(
      id: 0,
      name: r'jumlahJam',
      type: IsarType.double,
    ),
    r'tanggal': PropertySchema(
      id: 1,
      name: r'tanggal',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _lemburModelEstimateSize,
  serialize: _lemburModelSerialize,
  deserialize: _lemburModelDeserialize,
  deserializeProp: _lemburModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'tanggal': IndexSchema(
      id: 519307059700219,
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
      id: 297011438826529,
      name: r'karyawan',
      target: r'Karyawan',
      single: true,
    )
  },
  embeddedSchemas: {},
  getId: _lemburModelGetId,
  getLinks: _lemburModelGetLinks,
  attach: _lemburModelAttach,
  version: '3.1.0+1',
);

int _lemburModelEstimateSize(
  LemburModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _lemburModelSerialize(
  LemburModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.jumlahJam);
  writer.writeDateTime(offsets[1], object.tanggal);
}

LemburModel _lemburModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = LemburModel();
  object.id = id;
  object.jumlahJam = reader.readDouble(offsets[0]);
  object.tanggal = reader.readDateTime(offsets[1]);
  return object;
}

P _lemburModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _lemburModelGetId(LemburModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _lemburModelGetLinks(LemburModel object) {
  return [object.karyawan];
}

void _lemburModelAttach(
    IsarCollection<dynamic> col, Id id, LemburModel object) {
  object.id = id;
  object.karyawan
      .attach(col, col.isar.collection<KaryawanModel>(), r'karyawan', id);
}

extension LemburModelQueryWhereSort
    on QueryBuilder<LemburModel, LemburModel, QWhere> {
  QueryBuilder<LemburModel, LemburModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<LemburModel, LemburModel, QAfterWhere> anyTanggal() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'tanggal'),
      );
    });
  }
}

extension LemburModelQueryWhere
    on QueryBuilder<LemburModel, LemburModel, QWhereClause> {
  QueryBuilder<LemburModel, LemburModel, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<LemburModel, LemburModel, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<LemburModel, LemburModel, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<LemburModel, LemburModel, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<LemburModel, LemburModel, QAfterWhereClause> idBetween(
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

  QueryBuilder<LemburModel, LemburModel, QAfterWhereClause> tanggalEqualTo(
      DateTime tanggal) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'tanggal',
        value: [tanggal],
      ));
    });
  }

  QueryBuilder<LemburModel, LemburModel, QAfterWhereClause> tanggalNotEqualTo(
      DateTime tanggal) {
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

  QueryBuilder<LemburModel, LemburModel, QAfterWhereClause> tanggalGreaterThan(
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

  QueryBuilder<LemburModel, LemburModel, QAfterWhereClause> tanggalLessThan(
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

  QueryBuilder<LemburModel, LemburModel, QAfterWhereClause> tanggalBetween(
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

extension LemburModelQueryFilter
    on QueryBuilder<LemburModel, LemburModel, QFilterCondition> {
  QueryBuilder<LemburModel, LemburModel, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<LemburModel, LemburModel, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<LemburModel, LemburModel, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<LemburModel, LemburModel, QAfterFilterCondition> idBetween(
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

  QueryBuilder<LemburModel, LemburModel, QAfterFilterCondition>
      jumlahJamEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'jumlahJam',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LemburModel, LemburModel, QAfterFilterCondition>
      jumlahJamGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'jumlahJam',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LemburModel, LemburModel, QAfterFilterCondition>
      jumlahJamLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'jumlahJam',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LemburModel, LemburModel, QAfterFilterCondition>
      jumlahJamBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'jumlahJam',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LemburModel, LemburModel, QAfterFilterCondition> tanggalEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tanggal',
        value: value,
      ));
    });
  }

  QueryBuilder<LemburModel, LemburModel, QAfterFilterCondition>
      tanggalGreaterThan(
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

  QueryBuilder<LemburModel, LemburModel, QAfterFilterCondition> tanggalLessThan(
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

  QueryBuilder<LemburModel, LemburModel, QAfterFilterCondition> tanggalBetween(
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
}

extension LemburModelQueryObject
    on QueryBuilder<LemburModel, LemburModel, QFilterCondition> {}

extension LemburModelQueryLinks
    on QueryBuilder<LemburModel, LemburModel, QFilterCondition> {
  QueryBuilder<LemburModel, LemburModel, QAfterFilterCondition> karyawan(
      FilterQuery<KaryawanModel> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'karyawan');
    });
  }

  QueryBuilder<LemburModel, LemburModel, QAfterFilterCondition>
      karyawanIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'karyawan', 0, true, 0, true);
    });
  }
}

extension LemburModelQuerySortBy
    on QueryBuilder<LemburModel, LemburModel, QSortBy> {
  QueryBuilder<LemburModel, LemburModel, QAfterSortBy> sortByJumlahJam() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'jumlahJam', Sort.asc);
    });
  }

  QueryBuilder<LemburModel, LemburModel, QAfterSortBy> sortByJumlahJamDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'jumlahJam', Sort.desc);
    });
  }

  QueryBuilder<LemburModel, LemburModel, QAfterSortBy> sortByTanggal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tanggal', Sort.asc);
    });
  }

  QueryBuilder<LemburModel, LemburModel, QAfterSortBy> sortByTanggalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tanggal', Sort.desc);
    });
  }
}

extension LemburModelQuerySortThenBy
    on QueryBuilder<LemburModel, LemburModel, QSortThenBy> {
  QueryBuilder<LemburModel, LemburModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<LemburModel, LemburModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<LemburModel, LemburModel, QAfterSortBy> thenByJumlahJam() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'jumlahJam', Sort.asc);
    });
  }

  QueryBuilder<LemburModel, LemburModel, QAfterSortBy> thenByJumlahJamDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'jumlahJam', Sort.desc);
    });
  }

  QueryBuilder<LemburModel, LemburModel, QAfterSortBy> thenByTanggal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tanggal', Sort.asc);
    });
  }

  QueryBuilder<LemburModel, LemburModel, QAfterSortBy> thenByTanggalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tanggal', Sort.desc);
    });
  }
}

extension LemburModelQueryWhereDistinct
    on QueryBuilder<LemburModel, LemburModel, QDistinct> {
  QueryBuilder<LemburModel, LemburModel, QDistinct> distinctByJumlahJam() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'jumlahJam');
    });
  }

  QueryBuilder<LemburModel, LemburModel, QDistinct> distinctByTanggal() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tanggal');
    });
  }
}

extension LemburModelQueryProperty
    on QueryBuilder<LemburModel, LemburModel, QQueryProperty> {
  QueryBuilder<LemburModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<LemburModel, double, QQueryOperations> jumlahJamProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'jumlahJam');
    });
  }

  QueryBuilder<LemburModel, DateTime, QQueryOperations> tanggalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tanggal');
    });
  }
}
