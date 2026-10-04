// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'veritabani.dart';

// ignore_for_file: type=lint
class $YerImleriTable extends YerImleri
    with TableInfo<$YerImleriTable, YerImleriData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $YerImleriTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _sureMeta = const VerificationMeta('sure');
  @override
  late final GeneratedColumn<int> sure = GeneratedColumn<int>(
    'sure',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ayetMeta = const VerificationMeta('ayet');
  @override
  late final GeneratedColumn<int> ayet = GeneratedColumn<int>(
    'ayet',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _olusturmaMeta = const VerificationMeta(
    'olusturma',
  );
  @override
  late final GeneratedColumn<DateTime> olusturma = GeneratedColumn<DateTime>(
    'olusturma',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, sure, ayet, olusturma];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'yer_imleri';
  @override
  VerificationContext validateIntegrity(
    Insertable<YerImleriData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('sure')) {
      context.handle(
        _sureMeta,
        sure.isAcceptableOrUnknown(data['sure']!, _sureMeta),
      );
    } else if (isInserting) {
      context.missing(_sureMeta);
    }
    if (data.containsKey('ayet')) {
      context.handle(
        _ayetMeta,
        ayet.isAcceptableOrUnknown(data['ayet']!, _ayetMeta),
      );
    } else if (isInserting) {
      context.missing(_ayetMeta);
    }
    if (data.containsKey('olusturma')) {
      context.handle(
        _olusturmaMeta,
        olusturma.isAcceptableOrUnknown(data['olusturma']!, _olusturmaMeta),
      );
    } else if (isInserting) {
      context.missing(_olusturmaMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {sure, ayet},
  ];
  @override
  YerImleriData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return YerImleriData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      sure: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sure'],
      )!,
      ayet: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ayet'],
      )!,
      olusturma: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}olusturma'],
      )!,
    );
  }

  @override
  $YerImleriTable createAlias(String alias) {
    return $YerImleriTable(attachedDatabase, alias);
  }
}

class YerImleriData extends DataClass implements Insertable<YerImleriData> {
  final int id;
  final int sure;
  final int ayet;
  final DateTime olusturma;
  const YerImleriData({
    required this.id,
    required this.sure,
    required this.ayet,
    required this.olusturma,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['sure'] = Variable<int>(sure);
    map['ayet'] = Variable<int>(ayet);
    map['olusturma'] = Variable<DateTime>(olusturma);
    return map;
  }

  YerImleriCompanion toCompanion(bool nullToAbsent) {
    return YerImleriCompanion(
      id: Value(id),
      sure: Value(sure),
      ayet: Value(ayet),
      olusturma: Value(olusturma),
    );
  }

  factory YerImleriData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return YerImleriData(
      id: serializer.fromJson<int>(json['id']),
      sure: serializer.fromJson<int>(json['sure']),
      ayet: serializer.fromJson<int>(json['ayet']),
      olusturma: serializer.fromJson<DateTime>(json['olusturma']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sure': serializer.toJson<int>(sure),
      'ayet': serializer.toJson<int>(ayet),
      'olusturma': serializer.toJson<DateTime>(olusturma),
    };
  }

  YerImleriData copyWith({
    int? id,
    int? sure,
    int? ayet,
    DateTime? olusturma,
  }) => YerImleriData(
    id: id ?? this.id,
    sure: sure ?? this.sure,
    ayet: ayet ?? this.ayet,
    olusturma: olusturma ?? this.olusturma,
  );
  YerImleriData copyWithCompanion(YerImleriCompanion data) {
    return YerImleriData(
      id: data.id.present ? data.id.value : this.id,
      sure: data.sure.present ? data.sure.value : this.sure,
      ayet: data.ayet.present ? data.ayet.value : this.ayet,
      olusturma: data.olusturma.present ? data.olusturma.value : this.olusturma,
    );
  }

  @override
  String toString() {
    return (StringBuffer('YerImleriData(')
          ..write('id: $id, ')
          ..write('sure: $sure, ')
          ..write('ayet: $ayet, ')
          ..write('olusturma: $olusturma')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, sure, ayet, olusturma);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is YerImleriData &&
          other.id == this.id &&
          other.sure == this.sure &&
          other.ayet == this.ayet &&
          other.olusturma == this.olusturma);
}

class YerImleriCompanion extends UpdateCompanion<YerImleriData> {
  final Value<int> id;
  final Value<int> sure;
  final Value<int> ayet;
  final Value<DateTime> olusturma;
  const YerImleriCompanion({
    this.id = const Value.absent(),
    this.sure = const Value.absent(),
    this.ayet = const Value.absent(),
    this.olusturma = const Value.absent(),
  });
  YerImleriCompanion.insert({
    this.id = const Value.absent(),
    required int sure,
    required int ayet,
    required DateTime olusturma,
  }) : sure = Value(sure),
       ayet = Value(ayet),
       olusturma = Value(olusturma);
  static Insertable<YerImleriData> custom({
    Expression<int>? id,
    Expression<int>? sure,
    Expression<int>? ayet,
    Expression<DateTime>? olusturma,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sure != null) 'sure': sure,
      if (ayet != null) 'ayet': ayet,
      if (olusturma != null) 'olusturma': olusturma,
    });
  }

  YerImleriCompanion copyWith({
    Value<int>? id,
    Value<int>? sure,
    Value<int>? ayet,
    Value<DateTime>? olusturma,
  }) {
    return YerImleriCompanion(
      id: id ?? this.id,
      sure: sure ?? this.sure,
      ayet: ayet ?? this.ayet,
      olusturma: olusturma ?? this.olusturma,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sure.present) {
      map['sure'] = Variable<int>(sure.value);
    }
    if (ayet.present) {
      map['ayet'] = Variable<int>(ayet.value);
    }
    if (olusturma.present) {
      map['olusturma'] = Variable<DateTime>(olusturma.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('YerImleriCompanion(')
          ..write('id: $id, ')
          ..write('sure: $sure, ')
          ..write('ayet: $ayet, ')
          ..write('olusturma: $olusturma')
          ..write(')'))
        .toString();
  }
}

class $OkumaDurumuTable extends OkumaDurumu
    with TableInfo<$OkumaDurumuTable, OkumaDurumuData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OkumaDurumuTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sureMeta = const VerificationMeta('sure');
  @override
  late final GeneratedColumn<int> sure = GeneratedColumn<int>(
    'sure',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ayetMeta = const VerificationMeta('ayet');
  @override
  late final GeneratedColumn<int> ayet = GeneratedColumn<int>(
    'ayet',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _guncellemeMeta = const VerificationMeta(
    'guncelleme',
  );
  @override
  late final GeneratedColumn<DateTime> guncelleme = GeneratedColumn<DateTime>(
    'guncelleme',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, sure, ayet, guncelleme];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'okuma_durumu';
  @override
  VerificationContext validateIntegrity(
    Insertable<OkumaDurumuData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('sure')) {
      context.handle(
        _sureMeta,
        sure.isAcceptableOrUnknown(data['sure']!, _sureMeta),
      );
    } else if (isInserting) {
      context.missing(_sureMeta);
    }
    if (data.containsKey('ayet')) {
      context.handle(
        _ayetMeta,
        ayet.isAcceptableOrUnknown(data['ayet']!, _ayetMeta),
      );
    } else if (isInserting) {
      context.missing(_ayetMeta);
    }
    if (data.containsKey('guncelleme')) {
      context.handle(
        _guncellemeMeta,
        guncelleme.isAcceptableOrUnknown(data['guncelleme']!, _guncellemeMeta),
      );
    } else if (isInserting) {
      context.missing(_guncellemeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OkumaDurumuData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OkumaDurumuData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      sure: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sure'],
      )!,
      ayet: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ayet'],
      )!,
      guncelleme: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}guncelleme'],
      )!,
    );
  }

  @override
  $OkumaDurumuTable createAlias(String alias) {
    return $OkumaDurumuTable(attachedDatabase, alias);
  }
}

class OkumaDurumuData extends DataClass implements Insertable<OkumaDurumuData> {
  final int id;
  final int sure;
  final int ayet;
  final DateTime guncelleme;
  const OkumaDurumuData({
    required this.id,
    required this.sure,
    required this.ayet,
    required this.guncelleme,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['sure'] = Variable<int>(sure);
    map['ayet'] = Variable<int>(ayet);
    map['guncelleme'] = Variable<DateTime>(guncelleme);
    return map;
  }

  OkumaDurumuCompanion toCompanion(bool nullToAbsent) {
    return OkumaDurumuCompanion(
      id: Value(id),
      sure: Value(sure),
      ayet: Value(ayet),
      guncelleme: Value(guncelleme),
    );
  }

  factory OkumaDurumuData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OkumaDurumuData(
      id: serializer.fromJson<int>(json['id']),
      sure: serializer.fromJson<int>(json['sure']),
      ayet: serializer.fromJson<int>(json['ayet']),
      guncelleme: serializer.fromJson<DateTime>(json['guncelleme']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sure': serializer.toJson<int>(sure),
      'ayet': serializer.toJson<int>(ayet),
      'guncelleme': serializer.toJson<DateTime>(guncelleme),
    };
  }

  OkumaDurumuData copyWith({
    int? id,
    int? sure,
    int? ayet,
    DateTime? guncelleme,
  }) => OkumaDurumuData(
    id: id ?? this.id,
    sure: sure ?? this.sure,
    ayet: ayet ?? this.ayet,
    guncelleme: guncelleme ?? this.guncelleme,
  );
  OkumaDurumuData copyWithCompanion(OkumaDurumuCompanion data) {
    return OkumaDurumuData(
      id: data.id.present ? data.id.value : this.id,
      sure: data.sure.present ? data.sure.value : this.sure,
      ayet: data.ayet.present ? data.ayet.value : this.ayet,
      guncelleme: data.guncelleme.present
          ? data.guncelleme.value
          : this.guncelleme,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OkumaDurumuData(')
          ..write('id: $id, ')
          ..write('sure: $sure, ')
          ..write('ayet: $ayet, ')
          ..write('guncelleme: $guncelleme')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, sure, ayet, guncelleme);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OkumaDurumuData &&
          other.id == this.id &&
          other.sure == this.sure &&
          other.ayet == this.ayet &&
          other.guncelleme == this.guncelleme);
}

class OkumaDurumuCompanion extends UpdateCompanion<OkumaDurumuData> {
  final Value<int> id;
  final Value<int> sure;
  final Value<int> ayet;
  final Value<DateTime> guncelleme;
  const OkumaDurumuCompanion({
    this.id = const Value.absent(),
    this.sure = const Value.absent(),
    this.ayet = const Value.absent(),
    this.guncelleme = const Value.absent(),
  });
  OkumaDurumuCompanion.insert({
    this.id = const Value.absent(),
    required int sure,
    required int ayet,
    required DateTime guncelleme,
  }) : sure = Value(sure),
       ayet = Value(ayet),
       guncelleme = Value(guncelleme);
  static Insertable<OkumaDurumuData> custom({
    Expression<int>? id,
    Expression<int>? sure,
    Expression<int>? ayet,
    Expression<DateTime>? guncelleme,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sure != null) 'sure': sure,
      if (ayet != null) 'ayet': ayet,
      if (guncelleme != null) 'guncelleme': guncelleme,
    });
  }

  OkumaDurumuCompanion copyWith({
    Value<int>? id,
    Value<int>? sure,
    Value<int>? ayet,
    Value<DateTime>? guncelleme,
  }) {
    return OkumaDurumuCompanion(
      id: id ?? this.id,
      sure: sure ?? this.sure,
      ayet: ayet ?? this.ayet,
      guncelleme: guncelleme ?? this.guncelleme,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sure.present) {
      map['sure'] = Variable<int>(sure.value);
    }
    if (ayet.present) {
      map['ayet'] = Variable<int>(ayet.value);
    }
    if (guncelleme.present) {
      map['guncelleme'] = Variable<DateTime>(guncelleme.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OkumaDurumuCompanion(')
          ..write('id: $id, ')
          ..write('sure: $sure, ')
          ..write('ayet: $ayet, ')
          ..write('guncelleme: $guncelleme')
          ..write(')'))
        .toString();
  }
}

class $KazaSayaclariTable extends KazaSayaclari
    with TableInfo<$KazaSayaclariTable, KazaSayaclariData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KazaSayaclariTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _turMeta = const VerificationMeta('tur');
  @override
  late final GeneratedColumn<String> tur = GeneratedColumn<String>(
    'tur',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kalanMeta = const VerificationMeta('kalan');
  @override
  late final GeneratedColumn<int> kalan = GeneratedColumn<int>(
    'kalan',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [tur, kalan];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'kaza_sayaclari';
  @override
  VerificationContext validateIntegrity(
    Insertable<KazaSayaclariData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('tur')) {
      context.handle(
        _turMeta,
        tur.isAcceptableOrUnknown(data['tur']!, _turMeta),
      );
    } else if (isInserting) {
      context.missing(_turMeta);
    }
    if (data.containsKey('kalan')) {
      context.handle(
        _kalanMeta,
        kalan.isAcceptableOrUnknown(data['kalan']!, _kalanMeta),
      );
    } else if (isInserting) {
      context.missing(_kalanMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {tur};
  @override
  KazaSayaclariData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return KazaSayaclariData(
      tur: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tur'],
      )!,
      kalan: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}kalan'],
      )!,
    );
  }

  @override
  $KazaSayaclariTable createAlias(String alias) {
    return $KazaSayaclariTable(attachedDatabase, alias);
  }
}

class KazaSayaclariData extends DataClass
    implements Insertable<KazaSayaclariData> {
  final String tur;
  final int kalan;
  const KazaSayaclariData({required this.tur, required this.kalan});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['tur'] = Variable<String>(tur);
    map['kalan'] = Variable<int>(kalan);
    return map;
  }

  KazaSayaclariCompanion toCompanion(bool nullToAbsent) {
    return KazaSayaclariCompanion(tur: Value(tur), kalan: Value(kalan));
  }

  factory KazaSayaclariData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return KazaSayaclariData(
      tur: serializer.fromJson<String>(json['tur']),
      kalan: serializer.fromJson<int>(json['kalan']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'tur': serializer.toJson<String>(tur),
      'kalan': serializer.toJson<int>(kalan),
    };
  }

  KazaSayaclariData copyWith({String? tur, int? kalan}) =>
      KazaSayaclariData(tur: tur ?? this.tur, kalan: kalan ?? this.kalan);
  KazaSayaclariData copyWithCompanion(KazaSayaclariCompanion data) {
    return KazaSayaclariData(
      tur: data.tur.present ? data.tur.value : this.tur,
      kalan: data.kalan.present ? data.kalan.value : this.kalan,
    );
  }

  @override
  String toString() {
    return (StringBuffer('KazaSayaclariData(')
          ..write('tur: $tur, ')
          ..write('kalan: $kalan')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(tur, kalan);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is KazaSayaclariData &&
          other.tur == this.tur &&
          other.kalan == this.kalan);
}

class KazaSayaclariCompanion extends UpdateCompanion<KazaSayaclariData> {
  final Value<String> tur;
  final Value<int> kalan;
  final Value<int> rowid;
  const KazaSayaclariCompanion({
    this.tur = const Value.absent(),
    this.kalan = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  KazaSayaclariCompanion.insert({
    required String tur,
    required int kalan,
    this.rowid = const Value.absent(),
  }) : tur = Value(tur),
       kalan = Value(kalan);
  static Insertable<KazaSayaclariData> custom({
    Expression<String>? tur,
    Expression<int>? kalan,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (tur != null) 'tur': tur,
      if (kalan != null) 'kalan': kalan,
      if (rowid != null) 'rowid': rowid,
    });
  }

  KazaSayaclariCompanion copyWith({
    Value<String>? tur,
    Value<int>? kalan,
    Value<int>? rowid,
  }) {
    return KazaSayaclariCompanion(
      tur: tur ?? this.tur,
      kalan: kalan ?? this.kalan,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (tur.present) {
      map['tur'] = Variable<String>(tur.value);
    }
    if (kalan.present) {
      map['kalan'] = Variable<int>(kalan.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KazaSayaclariCompanion(')
          ..write('tur: $tur, ')
          ..write('kalan: $kalan, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GunlukSayaclarTable extends GunlukSayaclar
    with TableInfo<$GunlukSayaclarTable, GunlukSayaclarData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GunlukSayaclarTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _gunMeta = const VerificationMeta('gun');
  @override
  late final GeneratedColumn<String> gun = GeneratedColumn<String>(
    'gun',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _anahtarMeta = const VerificationMeta(
    'anahtar',
  );
  @override
  late final GeneratedColumn<String> anahtar = GeneratedColumn<String>(
    'anahtar',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _adetMeta = const VerificationMeta('adet');
  @override
  late final GeneratedColumn<int> adet = GeneratedColumn<int>(
    'adet',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [gun, anahtar, adet];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'gunluk_sayaclar';
  @override
  VerificationContext validateIntegrity(
    Insertable<GunlukSayaclarData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('gun')) {
      context.handle(
        _gunMeta,
        gun.isAcceptableOrUnknown(data['gun']!, _gunMeta),
      );
    } else if (isInserting) {
      context.missing(_gunMeta);
    }
    if (data.containsKey('anahtar')) {
      context.handle(
        _anahtarMeta,
        anahtar.isAcceptableOrUnknown(data['anahtar']!, _anahtarMeta),
      );
    } else if (isInserting) {
      context.missing(_anahtarMeta);
    }
    if (data.containsKey('adet')) {
      context.handle(
        _adetMeta,
        adet.isAcceptableOrUnknown(data['adet']!, _adetMeta),
      );
    } else if (isInserting) {
      context.missing(_adetMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {gun, anahtar};
  @override
  GunlukSayaclarData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GunlukSayaclarData(
      gun: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gun'],
      )!,
      anahtar: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}anahtar'],
      )!,
      adet: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}adet'],
      )!,
    );
  }

  @override
  $GunlukSayaclarTable createAlias(String alias) {
    return $GunlukSayaclarTable(attachedDatabase, alias);
  }
}

class GunlukSayaclarData extends DataClass
    implements Insertable<GunlukSayaclarData> {
  final String gun;
  final String anahtar;
  final int adet;
  const GunlukSayaclarData({
    required this.gun,
    required this.anahtar,
    required this.adet,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['gun'] = Variable<String>(gun);
    map['anahtar'] = Variable<String>(anahtar);
    map['adet'] = Variable<int>(adet);
    return map;
  }

  GunlukSayaclarCompanion toCompanion(bool nullToAbsent) {
    return GunlukSayaclarCompanion(
      gun: Value(gun),
      anahtar: Value(anahtar),
      adet: Value(adet),
    );
  }

  factory GunlukSayaclarData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GunlukSayaclarData(
      gun: serializer.fromJson<String>(json['gun']),
      anahtar: serializer.fromJson<String>(json['anahtar']),
      adet: serializer.fromJson<int>(json['adet']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'gun': serializer.toJson<String>(gun),
      'anahtar': serializer.toJson<String>(anahtar),
      'adet': serializer.toJson<int>(adet),
    };
  }

  GunlukSayaclarData copyWith({String? gun, String? anahtar, int? adet}) =>
      GunlukSayaclarData(
        gun: gun ?? this.gun,
        anahtar: anahtar ?? this.anahtar,
        adet: adet ?? this.adet,
      );
  GunlukSayaclarData copyWithCompanion(GunlukSayaclarCompanion data) {
    return GunlukSayaclarData(
      gun: data.gun.present ? data.gun.value : this.gun,
      anahtar: data.anahtar.present ? data.anahtar.value : this.anahtar,
      adet: data.adet.present ? data.adet.value : this.adet,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GunlukSayaclarData(')
          ..write('gun: $gun, ')
          ..write('anahtar: $anahtar, ')
          ..write('adet: $adet')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(gun, anahtar, adet);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GunlukSayaclarData &&
          other.gun == this.gun &&
          other.anahtar == this.anahtar &&
          other.adet == this.adet);
}

class GunlukSayaclarCompanion extends UpdateCompanion<GunlukSayaclarData> {
  final Value<String> gun;
  final Value<String> anahtar;
  final Value<int> adet;
  final Value<int> rowid;
  const GunlukSayaclarCompanion({
    this.gun = const Value.absent(),
    this.anahtar = const Value.absent(),
    this.adet = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GunlukSayaclarCompanion.insert({
    required String gun,
    required String anahtar,
    required int adet,
    this.rowid = const Value.absent(),
  }) : gun = Value(gun),
       anahtar = Value(anahtar),
       adet = Value(adet);
  static Insertable<GunlukSayaclarData> custom({
    Expression<String>? gun,
    Expression<String>? anahtar,
    Expression<int>? adet,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (gun != null) 'gun': gun,
      if (anahtar != null) 'anahtar': anahtar,
      if (adet != null) 'adet': adet,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GunlukSayaclarCompanion copyWith({
    Value<String>? gun,
    Value<String>? anahtar,
    Value<int>? adet,
    Value<int>? rowid,
  }) {
    return GunlukSayaclarCompanion(
      gun: gun ?? this.gun,
      anahtar: anahtar ?? this.anahtar,
      adet: adet ?? this.adet,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (gun.present) {
      map['gun'] = Variable<String>(gun.value);
    }
    if (anahtar.present) {
      map['anahtar'] = Variable<String>(anahtar.value);
    }
    if (adet.present) {
      map['adet'] = Variable<int>(adet.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GunlukSayaclarCompanion(')
          ..write('gun: $gun, ')
          ..write('anahtar: $anahtar, ')
          ..write('adet: $adet, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AbyadVeritabani extends GeneratedDatabase {
  _$AbyadVeritabani(QueryExecutor e) : super(e);
  $AbyadVeritabaniManager get managers => $AbyadVeritabaniManager(this);
  late final $YerImleriTable yerImleri = $YerImleriTable(this);
  late final $OkumaDurumuTable okumaDurumu = $OkumaDurumuTable(this);
  late final $KazaSayaclariTable kazaSayaclari = $KazaSayaclariTable(this);
  late final $GunlukSayaclarTable gunlukSayaclar = $GunlukSayaclarTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    yerImleri,
    okumaDurumu,
    kazaSayaclari,
    gunlukSayaclar,
  ];
}

typedef $$YerImleriTableCreateCompanionBuilder =
    YerImleriCompanion Function({
      Value<int> id,
      required int sure,
      required int ayet,
      required DateTime olusturma,
    });
typedef $$YerImleriTableUpdateCompanionBuilder =
    YerImleriCompanion Function({
      Value<int> id,
      Value<int> sure,
      Value<int> ayet,
      Value<DateTime> olusturma,
    });

class $$YerImleriTableFilterComposer
    extends Composer<_$AbyadVeritabani, $YerImleriTable> {
  $$YerImleriTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sure => $composableBuilder(
    column: $table.sure,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ayet => $composableBuilder(
    column: $table.ayet,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get olusturma => $composableBuilder(
    column: $table.olusturma,
    builder: (column) => ColumnFilters(column),
  );
}

class $$YerImleriTableOrderingComposer
    extends Composer<_$AbyadVeritabani, $YerImleriTable> {
  $$YerImleriTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sure => $composableBuilder(
    column: $table.sure,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ayet => $composableBuilder(
    column: $table.ayet,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get olusturma => $composableBuilder(
    column: $table.olusturma,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$YerImleriTableAnnotationComposer
    extends Composer<_$AbyadVeritabani, $YerImleriTable> {
  $$YerImleriTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get sure =>
      $composableBuilder(column: $table.sure, builder: (column) => column);

  GeneratedColumn<int> get ayet =>
      $composableBuilder(column: $table.ayet, builder: (column) => column);

  GeneratedColumn<DateTime> get olusturma =>
      $composableBuilder(column: $table.olusturma, builder: (column) => column);
}

class $$YerImleriTableTableManager
    extends
        RootTableManager<
          _$AbyadVeritabani,
          $YerImleriTable,
          YerImleriData,
          $$YerImleriTableFilterComposer,
          $$YerImleriTableOrderingComposer,
          $$YerImleriTableAnnotationComposer,
          $$YerImleriTableCreateCompanionBuilder,
          $$YerImleriTableUpdateCompanionBuilder,
          (
            YerImleriData,
            BaseReferences<_$AbyadVeritabani, $YerImleriTable, YerImleriData>,
          ),
          YerImleriData,
          PrefetchHooks Function()
        > {
  $$YerImleriTableTableManager(_$AbyadVeritabani db, $YerImleriTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$YerImleriTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$YerImleriTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$YerImleriTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> sure = const Value.absent(),
                Value<int> ayet = const Value.absent(),
                Value<DateTime> olusturma = const Value.absent(),
              }) => YerImleriCompanion(
                id: id,
                sure: sure,
                ayet: ayet,
                olusturma: olusturma,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int sure,
                required int ayet,
                required DateTime olusturma,
              }) => YerImleriCompanion.insert(
                id: id,
                sure: sure,
                ayet: ayet,
                olusturma: olusturma,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$YerImleriTableProcessedTableManager =
    ProcessedTableManager<
      _$AbyadVeritabani,
      $YerImleriTable,
      YerImleriData,
      $$YerImleriTableFilterComposer,
      $$YerImleriTableOrderingComposer,
      $$YerImleriTableAnnotationComposer,
      $$YerImleriTableCreateCompanionBuilder,
      $$YerImleriTableUpdateCompanionBuilder,
      (
        YerImleriData,
        BaseReferences<_$AbyadVeritabani, $YerImleriTable, YerImleriData>,
      ),
      YerImleriData,
      PrefetchHooks Function()
    >;
typedef $$OkumaDurumuTableCreateCompanionBuilder =
    OkumaDurumuCompanion Function({
      Value<int> id,
      required int sure,
      required int ayet,
      required DateTime guncelleme,
    });
typedef $$OkumaDurumuTableUpdateCompanionBuilder =
    OkumaDurumuCompanion Function({
      Value<int> id,
      Value<int> sure,
      Value<int> ayet,
      Value<DateTime> guncelleme,
    });

class $$OkumaDurumuTableFilterComposer
    extends Composer<_$AbyadVeritabani, $OkumaDurumuTable> {
  $$OkumaDurumuTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sure => $composableBuilder(
    column: $table.sure,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ayet => $composableBuilder(
    column: $table.ayet,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get guncelleme => $composableBuilder(
    column: $table.guncelleme,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OkumaDurumuTableOrderingComposer
    extends Composer<_$AbyadVeritabani, $OkumaDurumuTable> {
  $$OkumaDurumuTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sure => $composableBuilder(
    column: $table.sure,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ayet => $composableBuilder(
    column: $table.ayet,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get guncelleme => $composableBuilder(
    column: $table.guncelleme,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OkumaDurumuTableAnnotationComposer
    extends Composer<_$AbyadVeritabani, $OkumaDurumuTable> {
  $$OkumaDurumuTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get sure =>
      $composableBuilder(column: $table.sure, builder: (column) => column);

  GeneratedColumn<int> get ayet =>
      $composableBuilder(column: $table.ayet, builder: (column) => column);

  GeneratedColumn<DateTime> get guncelleme => $composableBuilder(
    column: $table.guncelleme,
    builder: (column) => column,
  );
}

class $$OkumaDurumuTableTableManager
    extends
        RootTableManager<
          _$AbyadVeritabani,
          $OkumaDurumuTable,
          OkumaDurumuData,
          $$OkumaDurumuTableFilterComposer,
          $$OkumaDurumuTableOrderingComposer,
          $$OkumaDurumuTableAnnotationComposer,
          $$OkumaDurumuTableCreateCompanionBuilder,
          $$OkumaDurumuTableUpdateCompanionBuilder,
          (
            OkumaDurumuData,
            BaseReferences<
              _$AbyadVeritabani,
              $OkumaDurumuTable,
              OkumaDurumuData
            >,
          ),
          OkumaDurumuData,
          PrefetchHooks Function()
        > {
  $$OkumaDurumuTableTableManager(_$AbyadVeritabani db, $OkumaDurumuTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OkumaDurumuTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OkumaDurumuTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OkumaDurumuTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> sure = const Value.absent(),
                Value<int> ayet = const Value.absent(),
                Value<DateTime> guncelleme = const Value.absent(),
              }) => OkumaDurumuCompanion(
                id: id,
                sure: sure,
                ayet: ayet,
                guncelleme: guncelleme,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int sure,
                required int ayet,
                required DateTime guncelleme,
              }) => OkumaDurumuCompanion.insert(
                id: id,
                sure: sure,
                ayet: ayet,
                guncelleme: guncelleme,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OkumaDurumuTableProcessedTableManager =
    ProcessedTableManager<
      _$AbyadVeritabani,
      $OkumaDurumuTable,
      OkumaDurumuData,
      $$OkumaDurumuTableFilterComposer,
      $$OkumaDurumuTableOrderingComposer,
      $$OkumaDurumuTableAnnotationComposer,
      $$OkumaDurumuTableCreateCompanionBuilder,
      $$OkumaDurumuTableUpdateCompanionBuilder,
      (
        OkumaDurumuData,
        BaseReferences<_$AbyadVeritabani, $OkumaDurumuTable, OkumaDurumuData>,
      ),
      OkumaDurumuData,
      PrefetchHooks Function()
    >;
typedef $$KazaSayaclariTableCreateCompanionBuilder =
    KazaSayaclariCompanion Function({
      required String tur,
      required int kalan,
      Value<int> rowid,
    });
typedef $$KazaSayaclariTableUpdateCompanionBuilder =
    KazaSayaclariCompanion Function({
      Value<String> tur,
      Value<int> kalan,
      Value<int> rowid,
    });

class $$KazaSayaclariTableFilterComposer
    extends Composer<_$AbyadVeritabani, $KazaSayaclariTable> {
  $$KazaSayaclariTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get tur => $composableBuilder(
    column: $table.tur,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get kalan => $composableBuilder(
    column: $table.kalan,
    builder: (column) => ColumnFilters(column),
  );
}

class $$KazaSayaclariTableOrderingComposer
    extends Composer<_$AbyadVeritabani, $KazaSayaclariTable> {
  $$KazaSayaclariTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get tur => $composableBuilder(
    column: $table.tur,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get kalan => $composableBuilder(
    column: $table.kalan,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$KazaSayaclariTableAnnotationComposer
    extends Composer<_$AbyadVeritabani, $KazaSayaclariTable> {
  $$KazaSayaclariTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get tur =>
      $composableBuilder(column: $table.tur, builder: (column) => column);

  GeneratedColumn<int> get kalan =>
      $composableBuilder(column: $table.kalan, builder: (column) => column);
}

class $$KazaSayaclariTableTableManager
    extends
        RootTableManager<
          _$AbyadVeritabani,
          $KazaSayaclariTable,
          KazaSayaclariData,
          $$KazaSayaclariTableFilterComposer,
          $$KazaSayaclariTableOrderingComposer,
          $$KazaSayaclariTableAnnotationComposer,
          $$KazaSayaclariTableCreateCompanionBuilder,
          $$KazaSayaclariTableUpdateCompanionBuilder,
          (
            KazaSayaclariData,
            BaseReferences<
              _$AbyadVeritabani,
              $KazaSayaclariTable,
              KazaSayaclariData
            >,
          ),
          KazaSayaclariData,
          PrefetchHooks Function()
        > {
  $$KazaSayaclariTableTableManager(
    _$AbyadVeritabani db,
    $KazaSayaclariTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$KazaSayaclariTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$KazaSayaclariTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$KazaSayaclariTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> tur = const Value.absent(),
                Value<int> kalan = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) =>
                  KazaSayaclariCompanion(tur: tur, kalan: kalan, rowid: rowid),
          createCompanionCallback:
              ({
                required String tur,
                required int kalan,
                Value<int> rowid = const Value.absent(),
              }) => KazaSayaclariCompanion.insert(
                tur: tur,
                kalan: kalan,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$KazaSayaclariTableProcessedTableManager =
    ProcessedTableManager<
      _$AbyadVeritabani,
      $KazaSayaclariTable,
      KazaSayaclariData,
      $$KazaSayaclariTableFilterComposer,
      $$KazaSayaclariTableOrderingComposer,
      $$KazaSayaclariTableAnnotationComposer,
      $$KazaSayaclariTableCreateCompanionBuilder,
      $$KazaSayaclariTableUpdateCompanionBuilder,
      (
        KazaSayaclariData,
        BaseReferences<
          _$AbyadVeritabani,
          $KazaSayaclariTable,
          KazaSayaclariData
        >,
      ),
      KazaSayaclariData,
      PrefetchHooks Function()
    >;
typedef $$GunlukSayaclarTableCreateCompanionBuilder =
    GunlukSayaclarCompanion Function({
      required String gun,
      required String anahtar,
      required int adet,
      Value<int> rowid,
    });
typedef $$GunlukSayaclarTableUpdateCompanionBuilder =
    GunlukSayaclarCompanion Function({
      Value<String> gun,
      Value<String> anahtar,
      Value<int> adet,
      Value<int> rowid,
    });

class $$GunlukSayaclarTableFilterComposer
    extends Composer<_$AbyadVeritabani, $GunlukSayaclarTable> {
  $$GunlukSayaclarTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get gun => $composableBuilder(
    column: $table.gun,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get anahtar => $composableBuilder(
    column: $table.anahtar,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get adet => $composableBuilder(
    column: $table.adet,
    builder: (column) => ColumnFilters(column),
  );
}

class $$GunlukSayaclarTableOrderingComposer
    extends Composer<_$AbyadVeritabani, $GunlukSayaclarTable> {
  $$GunlukSayaclarTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get gun => $composableBuilder(
    column: $table.gun,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get anahtar => $composableBuilder(
    column: $table.anahtar,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get adet => $composableBuilder(
    column: $table.adet,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GunlukSayaclarTableAnnotationComposer
    extends Composer<_$AbyadVeritabani, $GunlukSayaclarTable> {
  $$GunlukSayaclarTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get gun =>
      $composableBuilder(column: $table.gun, builder: (column) => column);

  GeneratedColumn<String> get anahtar =>
      $composableBuilder(column: $table.anahtar, builder: (column) => column);

  GeneratedColumn<int> get adet =>
      $composableBuilder(column: $table.adet, builder: (column) => column);
}

class $$GunlukSayaclarTableTableManager
    extends
        RootTableManager<
          _$AbyadVeritabani,
          $GunlukSayaclarTable,
          GunlukSayaclarData,
          $$GunlukSayaclarTableFilterComposer,
          $$GunlukSayaclarTableOrderingComposer,
          $$GunlukSayaclarTableAnnotationComposer,
          $$GunlukSayaclarTableCreateCompanionBuilder,
          $$GunlukSayaclarTableUpdateCompanionBuilder,
          (
            GunlukSayaclarData,
            BaseReferences<
              _$AbyadVeritabani,
              $GunlukSayaclarTable,
              GunlukSayaclarData
            >,
          ),
          GunlukSayaclarData,
          PrefetchHooks Function()
        > {
  $$GunlukSayaclarTableTableManager(
    _$AbyadVeritabani db,
    $GunlukSayaclarTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GunlukSayaclarTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GunlukSayaclarTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GunlukSayaclarTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> gun = const Value.absent(),
                Value<String> anahtar = const Value.absent(),
                Value<int> adet = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GunlukSayaclarCompanion(
                gun: gun,
                anahtar: anahtar,
                adet: adet,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String gun,
                required String anahtar,
                required int adet,
                Value<int> rowid = const Value.absent(),
              }) => GunlukSayaclarCompanion.insert(
                gun: gun,
                anahtar: anahtar,
                adet: adet,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GunlukSayaclarTableProcessedTableManager =
    ProcessedTableManager<
      _$AbyadVeritabani,
      $GunlukSayaclarTable,
      GunlukSayaclarData,
      $$GunlukSayaclarTableFilterComposer,
      $$GunlukSayaclarTableOrderingComposer,
      $$GunlukSayaclarTableAnnotationComposer,
      $$GunlukSayaclarTableCreateCompanionBuilder,
      $$GunlukSayaclarTableUpdateCompanionBuilder,
      (
        GunlukSayaclarData,
        BaseReferences<
          _$AbyadVeritabani,
          $GunlukSayaclarTable,
          GunlukSayaclarData
        >,
      ),
      GunlukSayaclarData,
      PrefetchHooks Function()
    >;

class $AbyadVeritabaniManager {
  final _$AbyadVeritabani _db;
  $AbyadVeritabaniManager(this._db);
  $$YerImleriTableTableManager get yerImleri =>
      $$YerImleriTableTableManager(_db, _db.yerImleri);
  $$OkumaDurumuTableTableManager get okumaDurumu =>
      $$OkumaDurumuTableTableManager(_db, _db.okumaDurumu);
  $$KazaSayaclariTableTableManager get kazaSayaclari =>
      $$KazaSayaclariTableTableManager(_db, _db.kazaSayaclari);
  $$GunlukSayaclarTableTableManager get gunlukSayaclar =>
      $$GunlukSayaclarTableTableManager(_db, _db.gunlukSayaclar);
}
