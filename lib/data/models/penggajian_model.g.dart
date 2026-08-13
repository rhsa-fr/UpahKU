// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'penggajian_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPenggajianModelCollection on Isar {
  IsarCollection<PenggajianModel> get penggajianModels => this.collection();
}

const PenggajianModelSchema = CollectionSchema(
  name: r'Penggajian',
  id: 78921410,
  properties: {
    r'pathPdf': PropertySchema(
      id: 0,
      name: r'pathPdf',
      type: IsarType.string,
    ),
    r'periodeMulai': PropertySchema(
      id: 1,
      name: r'periodeMulai',
      type: IsarType.dateTime,
    ),
    r'periodeSelesai': PropertySchema(
      id: 2,
      name: r'periodeSelesai',
      type: IsarType.dateTime,
    ),
    r'tanggalGajian': PropertySchema(
      id: 3,
      name: r'tanggalGajian',
      type: IsarType.dateTime,
    ),
    r'tarifLemburSaatItu': PropertySchema(
      id: 4,
      name: r'tarifLemburSaatItu',
      type: IsarType.double,
    ),
    r'totalAlfa': PropertySchema(
      id: 5,
      name: r'totalAlfa',
      type: IsarType.long,
    ),
    r'totalBonus': PropertySchema(
      id: 6,
      name: r'totalBonus',
      type: IsarType.double,
    ),
    r'totalGajiBersih': PropertySchema(
      id: 7,
      name: r'totalGajiBersih',
      type: IsarType.double,
    ),
    r'totalHadir': PropertySchema(
      id: 8,
      name: r'totalHadir',
      type: IsarType.long,
    ),
    r'totalIzin': PropertySchema(
      id: 9,
      name: r'totalIzin',
      type: IsarType.long,
    ),
    r'totalJamLembur': PropertySchema(
      id: 10,
      name: r'totalJamLembur',
      type: IsarType.double,
    ),
    r'totalKasbon': PropertySchema(
      id: 11,
      name: r'totalKasbon',
      type: IsarType.double,
    ),
    r'totalPotongan': PropertySchema(
      id: 12,
      name: r'totalPotongan',
      type: IsarType.double,
    ),
    r'totalSakit': PropertySchema(
      id: 13,
      name: r'totalSakit',
      type: IsarType.long,
    ),
    r'totalUpahKerja': PropertySchema(
      id: 14,
      name: r'totalUpahKerja',
      type: IsarType.double,
    ),
    r'totalUpahLembur': PropertySchema(
      id: 15,
      name: r'totalUpahLembur',
      type: IsarType.double,
    ),
    r'upahHarianSaatItu': PropertySchema(
      id: 16,
      name: r'upahHarianSaatItu',
      type: IsarType.double,
    )
  },
  estimateSize: _penggajianModelEstimateSize,
  serialize: _penggajianModelSerialize,
  deserialize: _penggajianModelDeserialize,
  deserializeProp: _penggajianModelDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'karyawan': LinkSchema(
      id: -80576188,
      name: r'karyawan',
      target: r'Karyawan',
      single: true,
    )
  },
  embeddedSchemas: {},
  getId: _penggajianModelGetId,
  getLinks: _penggajianModelGetLinks,
  attach: _penggajianModelAttach,
  version: '3.1.0+1',
);

int _penggajianModelEstimateSize(
  PenggajianModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.pathPdf;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _penggajianModelSerialize(
  PenggajianModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.pathPdf);
  writer.writeDateTime(offsets[1], object.periodeMulai);
  writer.writeDateTime(offsets[2], object.periodeSelesai);
  writer.writeDateTime(offsets[3], object.tanggalGajian);
  writer.writeDouble(offsets[4], object.tarifLemburSaatItu);
  writer.writeLong(offsets[5], object.totalAlfa);
  writer.writeDouble(offsets[6], object.totalBonus);
  writer.writeDouble(offsets[7], object.totalGajiBersih);
  writer.writeLong(offsets[8], object.totalHadir);
  writer.writeLong(offsets[9], object.totalIzin);
  writer.writeDouble(offsets[10], object.totalJamLembur);
  writer.writeDouble(offsets[11], object.totalKasbon);
  writer.writeDouble(offsets[12], object.totalPotongan);
  writer.writeLong(offsets[13], object.totalSakit);
  writer.writeDouble(offsets[14], object.totalUpahKerja);
  writer.writeDouble(offsets[15], object.totalUpahLembur);
  writer.writeDouble(offsets[16], object.upahHarianSaatItu);
}

PenggajianModel _penggajianModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PenggajianModel();
  object.id = id;
  object.pathPdf = reader.readStringOrNull(offsets[0]);
  object.periodeMulai = reader.readDateTime(offsets[1]);
  object.periodeSelesai = reader.readDateTime(offsets[2]);
  object.tanggalGajian = reader.readDateTime(offsets[3]);
  object.tarifLemburSaatItu = reader.readDouble(offsets[4]);
  object.totalAlfa = reader.readLong(offsets[5]);
  object.totalBonus = reader.readDouble(offsets[6]);
  object.totalGajiBersih = reader.readDouble(offsets[7]);
  object.totalHadir = reader.readLong(offsets[8]);
  object.totalIzin = reader.readLong(offsets[9]);
  object.totalJamLembur = reader.readDouble(offsets[10]);
  object.totalKasbon = reader.readDouble(offsets[11]);
  object.totalPotongan = reader.readDouble(offsets[12]);
  object.totalSakit = reader.readLong(offsets[13]);
  object.totalUpahKerja = reader.readDouble(offsets[14]);
  object.totalUpahLembur = reader.readDouble(offsets[15]);
  object.upahHarianSaatItu = reader.readDouble(offsets[16]);
  return object;
}

P _penggajianModelDeserializeProp<P>(
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
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readDouble(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readDouble(offset)) as P;
    case 7:
      return (reader.readDouble(offset)) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    case 9:
      return (reader.readLong(offset)) as P;
    case 10:
      return (reader.readDouble(offset)) as P;
    case 11:
      return (reader.readDouble(offset)) as P;
    case 12:
      return (reader.readDouble(offset)) as P;
    case 13:
      return (reader.readLong(offset)) as P;
    case 14:
      return (reader.readDouble(offset)) as P;
    case 15:
      return (reader.readDouble(offset)) as P;
    case 16:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _penggajianModelGetId(PenggajianModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _penggajianModelGetLinks(PenggajianModel object) {
  return [object.karyawan];
}

void _penggajianModelAttach(
    IsarCollection<dynamic> col, Id id, PenggajianModel object) {
  object.id = id;
  object.karyawan
      .attach(col, col.isar.collection<KaryawanModel>(), r'karyawan', id);
}

extension PenggajianModelQueryWhereSort
    on QueryBuilder<PenggajianModel, PenggajianModel, QWhere> {
  QueryBuilder<PenggajianModel, PenggajianModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PenggajianModelQueryWhere
    on QueryBuilder<PenggajianModel, PenggajianModel, QWhereClause> {
  QueryBuilder<PenggajianModel, PenggajianModel, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterWhereClause>
      idNotEqualTo(Id id) {
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

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterWhereClause> idBetween(
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

extension PenggajianModelQueryFilter
    on QueryBuilder<PenggajianModel, PenggajianModel, QFilterCondition> {
  QueryBuilder<PenggajianModel, PenggajianModel, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterFilterCondition>
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

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterFilterCondition>
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

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterFilterCondition>
      idBetween(
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

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterFilterCondition>
      pathPdfIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'pathPdf',
      ));
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterFilterCondition>
      pathPdfIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'pathPdf',
      ));
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterFilterCondition>
      pathPdfEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pathPdf',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterFilterCondition>
      pathPdfGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'pathPdf',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterFilterCondition>
      pathPdfLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'pathPdf',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterFilterCondition>
      pathPdfBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'pathPdf',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterFilterCondition>
      pathPdfStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'pathPdf',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterFilterCondition>
      pathPdfEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'pathPdf',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterFilterCondition>
      pathPdfContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'pathPdf',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterFilterCondition>
      pathPdfMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'pathPdf',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterFilterCondition>
      pathPdfIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pathPdf',
        value: '',
      ));
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterFilterCondition>
      pathPdfIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'pathPdf',
        value: '',
      ));
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterFilterCondition>
      periodeMulaiEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'periodeMulai',
        value: value,
      ));
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterFilterCondition>
      periodeMulaiGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'periodeMulai',
        value: value,
      ));
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterFilterCondition>
      periodeMulaiLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'periodeMulai',
        value: value,
      ));
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterFilterCondition>
      periodeMulaiBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'periodeMulai',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterFilterCondition>
      periodeSelesaiEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'periodeSelesai',
        value: value,
      ));
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterFilterCondition>
      periodeSelesaiGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'periodeSelesai',
        value: value,
      ));
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterFilterCondition>
      periodeSelesaiLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'periodeSelesai',
        value: value,
      ));
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterFilterCondition>
      periodeSelesaiBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'periodeSelesai',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterFilterCondition>
      tanggalGajianEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tanggalGajian',
        value: value,
      ));
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterFilterCondition>
      tanggalGajianGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'tanggalGajian',
        value: value,
      ));
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterFilterCondition>
      tanggalGajianLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'tanggalGajian',
        value: value,
      ));
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterFilterCondition>
      tanggalGajianBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'tanggalGajian',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterFilterCondition>
      tarifLemburSaatItuEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tarifLemburSaatItu',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterFilterCondition>
      tarifLemburSaatItuGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'tarifLemburSaatItu',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterFilterCondition>
      tarifLemburSaatItuLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'tarifLemburSaatItu',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterFilterCondition>
      tarifLemburSaatItuBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'tarifLemburSaatItu',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterFilterCondition>
      totalAlfaEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalAlfa',
        value: value,
      ));
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterFilterCondition>
      totalAlfaGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalAlfa',
        value: value,
      ));
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterFilterCondition>
      totalAlfaLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalAlfa',
        value: value,
      ));
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterFilterCondition>
      totalAlfaBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalAlfa',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterFilterCondition>
      totalBonusEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalBonus',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterFilterCondition>
      totalBonusGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalBonus',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterFilterCondition>
      totalBonusLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalBonus',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterFilterCondition>
      totalBonusBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalBonus',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterFilterCondition>
      totalGajiBersihEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalGajiBersih',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterFilterCondition>
      totalGajiBersihGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalGajiBersih',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterFilterCondition>
      totalGajiBersihLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalGajiBersih',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterFilterCondition>
      totalGajiBersihBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalGajiBersih',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterFilterCondition>
      totalHadirEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalHadir',
        value: value,
      ));
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterFilterCondition>
      totalHadirGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalHadir',
        value: value,
      ));
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterFilterCondition>
      totalHadirLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalHadir',
        value: value,
      ));
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterFilterCondition>
      totalHadirBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalHadir',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterFilterCondition>
      totalIzinEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalIzin',
        value: value,
      ));
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterFilterCondition>
      totalIzinGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalIzin',
        value: value,
      ));
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterFilterCondition>
      totalIzinLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalIzin',
        value: value,
      ));
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterFilterCondition>
      totalIzinBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalIzin',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterFilterCondition>
      totalJamLemburEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalJamLembur',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterFilterCondition>
      totalJamLemburGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalJamLembur',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterFilterCondition>
      totalJamLemburLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalJamLembur',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterFilterCondition>
      totalJamLemburBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalJamLembur',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterFilterCondition>
      totalKasbonEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalKasbon',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterFilterCondition>
      totalKasbonGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalKasbon',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterFilterCondition>
      totalKasbonLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalKasbon',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterFilterCondition>
      totalKasbonBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalKasbon',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterFilterCondition>
      totalPotonganEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalPotongan',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterFilterCondition>
      totalPotonganGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalPotongan',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterFilterCondition>
      totalPotonganLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalPotongan',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterFilterCondition>
      totalPotonganBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalPotongan',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterFilterCondition>
      totalSakitEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalSakit',
        value: value,
      ));
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterFilterCondition>
      totalSakitGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalSakit',
        value: value,
      ));
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterFilterCondition>
      totalSakitLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalSakit',
        value: value,
      ));
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterFilterCondition>
      totalSakitBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalSakit',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterFilterCondition>
      totalUpahKerjaEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalUpahKerja',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterFilterCondition>
      totalUpahKerjaGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalUpahKerja',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterFilterCondition>
      totalUpahKerjaLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalUpahKerja',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterFilterCondition>
      totalUpahKerjaBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalUpahKerja',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterFilterCondition>
      totalUpahLemburEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalUpahLembur',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterFilterCondition>
      totalUpahLemburGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalUpahLembur',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterFilterCondition>
      totalUpahLemburLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalUpahLembur',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterFilterCondition>
      totalUpahLemburBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalUpahLembur',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterFilterCondition>
      upahHarianSaatItuEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'upahHarianSaatItu',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterFilterCondition>
      upahHarianSaatItuGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'upahHarianSaatItu',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterFilterCondition>
      upahHarianSaatItuLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'upahHarianSaatItu',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterFilterCondition>
      upahHarianSaatItuBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'upahHarianSaatItu',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension PenggajianModelQueryObject
    on QueryBuilder<PenggajianModel, PenggajianModel, QFilterCondition> {}

extension PenggajianModelQueryLinks
    on QueryBuilder<PenggajianModel, PenggajianModel, QFilterCondition> {
  QueryBuilder<PenggajianModel, PenggajianModel, QAfterFilterCondition>
      karyawan(FilterQuery<KaryawanModel> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'karyawan');
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterFilterCondition>
      karyawanIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'karyawan', 0, true, 0, true);
    });
  }
}

extension PenggajianModelQuerySortBy
    on QueryBuilder<PenggajianModel, PenggajianModel, QSortBy> {
  QueryBuilder<PenggajianModel, PenggajianModel, QAfterSortBy> sortByPathPdf() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pathPdf', Sort.asc);
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterSortBy>
      sortByPathPdfDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pathPdf', Sort.desc);
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterSortBy>
      sortByPeriodeMulai() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'periodeMulai', Sort.asc);
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterSortBy>
      sortByPeriodeMulaiDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'periodeMulai', Sort.desc);
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterSortBy>
      sortByPeriodeSelesai() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'periodeSelesai', Sort.asc);
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterSortBy>
      sortByPeriodeSelesaiDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'periodeSelesai', Sort.desc);
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterSortBy>
      sortByTanggalGajian() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tanggalGajian', Sort.asc);
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterSortBy>
      sortByTanggalGajianDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tanggalGajian', Sort.desc);
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterSortBy>
      sortByTarifLemburSaatItu() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tarifLemburSaatItu', Sort.asc);
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterSortBy>
      sortByTarifLemburSaatItuDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tarifLemburSaatItu', Sort.desc);
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterSortBy>
      sortByTotalAlfa() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalAlfa', Sort.asc);
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterSortBy>
      sortByTotalAlfaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalAlfa', Sort.desc);
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterSortBy>
      sortByTotalBonus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalBonus', Sort.asc);
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterSortBy>
      sortByTotalBonusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalBonus', Sort.desc);
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterSortBy>
      sortByTotalGajiBersih() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalGajiBersih', Sort.asc);
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterSortBy>
      sortByTotalGajiBersihDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalGajiBersih', Sort.desc);
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterSortBy>
      sortByTotalHadir() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalHadir', Sort.asc);
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterSortBy>
      sortByTotalHadirDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalHadir', Sort.desc);
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterSortBy>
      sortByTotalIzin() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalIzin', Sort.asc);
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterSortBy>
      sortByTotalIzinDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalIzin', Sort.desc);
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterSortBy>
      sortByTotalJamLembur() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalJamLembur', Sort.asc);
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterSortBy>
      sortByTotalJamLemburDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalJamLembur', Sort.desc);
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterSortBy>
      sortByTotalKasbon() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalKasbon', Sort.asc);
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterSortBy>
      sortByTotalKasbonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalKasbon', Sort.desc);
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterSortBy>
      sortByTotalPotongan() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalPotongan', Sort.asc);
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterSortBy>
      sortByTotalPotonganDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalPotongan', Sort.desc);
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterSortBy>
      sortByTotalSakit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalSakit', Sort.asc);
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterSortBy>
      sortByTotalSakitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalSakit', Sort.desc);
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterSortBy>
      sortByTotalUpahKerja() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalUpahKerja', Sort.asc);
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterSortBy>
      sortByTotalUpahKerjaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalUpahKerja', Sort.desc);
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterSortBy>
      sortByTotalUpahLembur() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalUpahLembur', Sort.asc);
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterSortBy>
      sortByTotalUpahLemburDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalUpahLembur', Sort.desc);
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterSortBy>
      sortByUpahHarianSaatItu() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'upahHarianSaatItu', Sort.asc);
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterSortBy>
      sortByUpahHarianSaatItuDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'upahHarianSaatItu', Sort.desc);
    });
  }
}

extension PenggajianModelQuerySortThenBy
    on QueryBuilder<PenggajianModel, PenggajianModel, QSortThenBy> {
  QueryBuilder<PenggajianModel, PenggajianModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterSortBy> thenByPathPdf() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pathPdf', Sort.asc);
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterSortBy>
      thenByPathPdfDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pathPdf', Sort.desc);
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterSortBy>
      thenByPeriodeMulai() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'periodeMulai', Sort.asc);
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterSortBy>
      thenByPeriodeMulaiDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'periodeMulai', Sort.desc);
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterSortBy>
      thenByPeriodeSelesai() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'periodeSelesai', Sort.asc);
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterSortBy>
      thenByPeriodeSelesaiDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'periodeSelesai', Sort.desc);
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterSortBy>
      thenByTanggalGajian() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tanggalGajian', Sort.asc);
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterSortBy>
      thenByTanggalGajianDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tanggalGajian', Sort.desc);
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterSortBy>
      thenByTarifLemburSaatItu() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tarifLemburSaatItu', Sort.asc);
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterSortBy>
      thenByTarifLemburSaatItuDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tarifLemburSaatItu', Sort.desc);
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterSortBy>
      thenByTotalAlfa() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalAlfa', Sort.asc);
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterSortBy>
      thenByTotalAlfaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalAlfa', Sort.desc);
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterSortBy>
      thenByTotalBonus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalBonus', Sort.asc);
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterSortBy>
      thenByTotalBonusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalBonus', Sort.desc);
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterSortBy>
      thenByTotalGajiBersih() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalGajiBersih', Sort.asc);
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterSortBy>
      thenByTotalGajiBersihDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalGajiBersih', Sort.desc);
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterSortBy>
      thenByTotalHadir() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalHadir', Sort.asc);
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterSortBy>
      thenByTotalHadirDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalHadir', Sort.desc);
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterSortBy>
      thenByTotalIzin() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalIzin', Sort.asc);
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterSortBy>
      thenByTotalIzinDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalIzin', Sort.desc);
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterSortBy>
      thenByTotalJamLembur() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalJamLembur', Sort.asc);
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterSortBy>
      thenByTotalJamLemburDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalJamLembur', Sort.desc);
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterSortBy>
      thenByTotalKasbon() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalKasbon', Sort.asc);
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterSortBy>
      thenByTotalKasbonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalKasbon', Sort.desc);
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterSortBy>
      thenByTotalPotongan() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalPotongan', Sort.asc);
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterSortBy>
      thenByTotalPotonganDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalPotongan', Sort.desc);
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterSortBy>
      thenByTotalSakit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalSakit', Sort.asc);
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterSortBy>
      thenByTotalSakitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalSakit', Sort.desc);
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterSortBy>
      thenByTotalUpahKerja() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalUpahKerja', Sort.asc);
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterSortBy>
      thenByTotalUpahKerjaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalUpahKerja', Sort.desc);
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterSortBy>
      thenByTotalUpahLembur() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalUpahLembur', Sort.asc);
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterSortBy>
      thenByTotalUpahLemburDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalUpahLembur', Sort.desc);
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterSortBy>
      thenByUpahHarianSaatItu() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'upahHarianSaatItu', Sort.asc);
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QAfterSortBy>
      thenByUpahHarianSaatItuDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'upahHarianSaatItu', Sort.desc);
    });
  }
}

extension PenggajianModelQueryWhereDistinct
    on QueryBuilder<PenggajianModel, PenggajianModel, QDistinct> {
  QueryBuilder<PenggajianModel, PenggajianModel, QDistinct> distinctByPathPdf(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pathPdf', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QDistinct>
      distinctByPeriodeMulai() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'periodeMulai');
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QDistinct>
      distinctByPeriodeSelesai() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'periodeSelesai');
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QDistinct>
      distinctByTanggalGajian() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tanggalGajian');
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QDistinct>
      distinctByTarifLemburSaatItu() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tarifLemburSaatItu');
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QDistinct>
      distinctByTotalAlfa() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalAlfa');
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QDistinct>
      distinctByTotalBonus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalBonus');
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QDistinct>
      distinctByTotalGajiBersih() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalGajiBersih');
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QDistinct>
      distinctByTotalHadir() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalHadir');
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QDistinct>
      distinctByTotalIzin() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalIzin');
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QDistinct>
      distinctByTotalJamLembur() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalJamLembur');
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QDistinct>
      distinctByTotalKasbon() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalKasbon');
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QDistinct>
      distinctByTotalPotongan() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalPotongan');
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QDistinct>
      distinctByTotalSakit() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalSakit');
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QDistinct>
      distinctByTotalUpahKerja() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalUpahKerja');
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QDistinct>
      distinctByTotalUpahLembur() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalUpahLembur');
    });
  }

  QueryBuilder<PenggajianModel, PenggajianModel, QDistinct>
      distinctByUpahHarianSaatItu() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'upahHarianSaatItu');
    });
  }
}

extension PenggajianModelQueryProperty
    on QueryBuilder<PenggajianModel, PenggajianModel, QQueryProperty> {
  QueryBuilder<PenggajianModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PenggajianModel, String?, QQueryOperations> pathPdfProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pathPdf');
    });
  }

  QueryBuilder<PenggajianModel, DateTime, QQueryOperations>
      periodeMulaiProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'periodeMulai');
    });
  }

  QueryBuilder<PenggajianModel, DateTime, QQueryOperations>
      periodeSelesaiProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'periodeSelesai');
    });
  }

  QueryBuilder<PenggajianModel, DateTime, QQueryOperations>
      tanggalGajianProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tanggalGajian');
    });
  }

  QueryBuilder<PenggajianModel, double, QQueryOperations>
      tarifLemburSaatItuProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tarifLemburSaatItu');
    });
  }

  QueryBuilder<PenggajianModel, int, QQueryOperations> totalAlfaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalAlfa');
    });
  }

  QueryBuilder<PenggajianModel, double, QQueryOperations> totalBonusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalBonus');
    });
  }

  QueryBuilder<PenggajianModel, double, QQueryOperations>
      totalGajiBersihProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalGajiBersih');
    });
  }

  QueryBuilder<PenggajianModel, int, QQueryOperations> totalHadirProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalHadir');
    });
  }

  QueryBuilder<PenggajianModel, int, QQueryOperations> totalIzinProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalIzin');
    });
  }

  QueryBuilder<PenggajianModel, double, QQueryOperations>
      totalJamLemburProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalJamLembur');
    });
  }

  QueryBuilder<PenggajianModel, double, QQueryOperations>
      totalKasbonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalKasbon');
    });
  }

  QueryBuilder<PenggajianModel, double, QQueryOperations>
      totalPotonganProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalPotongan');
    });
  }

  QueryBuilder<PenggajianModel, int, QQueryOperations> totalSakitProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalSakit');
    });
  }

  QueryBuilder<PenggajianModel, double, QQueryOperations>
      totalUpahKerjaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalUpahKerja');
    });
  }

  QueryBuilder<PenggajianModel, double, QQueryOperations>
      totalUpahLemburProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalUpahLembur');
    });
  }

  QueryBuilder<PenggajianModel, double, QQueryOperations>
      upahHarianSaatItuProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'upahHarianSaatItu');
    });
  }
}
