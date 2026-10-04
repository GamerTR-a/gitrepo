import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'veritabani.g.dart';

/// Kur'an'da ayet başına yer imi
class YerImleri extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get sure => integer()();
  IntColumn get ayet => integer()();
  DateTimeColumn get olusturma => dateTime()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {sure, ayet},
  ];
}

/// Kur'an'da kalınan yer (tek satır, id = 1)
class OkumaDurumu extends Table {
  IntColumn get id => integer()();
  IntColumn get sure => integer()();
  IntColumn get ayet => integer()();
  DateTimeColumn get guncelleme => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Kalan kaza sayıları (tur: KazaTuru.name)
class KazaSayaclari extends Table {
  TextColumn get tur => text()();
  IntColumn get kalan => integer()();

  @override
  Set<Column> get primaryKey => {tur};
}

/// Gün bazında sayaçlar: zikir toplamı ('zikir'), kılınan kaza ('kaza').
/// gun: yyyy-AA-GG
class GunlukSayaclar extends Table {
  TextColumn get gun => text()();
  TextColumn get anahtar => text()();
  IntColumn get adet => integer()();

  @override
  Set<Column> get primaryKey => {gun, anahtar};
}

String gunAnahtari(DateTime gun) =>
    '${gun.year}-${gun.month.toString().padLeft(2, '0')}-'
    '${gun.day.toString().padLeft(2, '0')}';

/// Yapısal verinin cihazdaki veritabanı. Veri cihazdan çıkmaz.
/// Tablo eklenince [schemaVersion] artırılıp göç yazılır.
@DriftDatabase(tables: [YerImleri, OkumaDurumu, KazaSayaclari, GunlukSayaclar])
class AbyadVeritabani extends _$AbyadVeritabani {
  AbyadVeritabani([QueryExecutor? baglanti])
    : super(baglanti ?? driftDatabase(name: 'abyad'));

  @override
  int get schemaVersion => 1;

  // --- Kur'an ---------------------------------------------------------------
  Stream<OkumaDurumuData?> okumaDurumunuIzle() =>
      (select(okumaDurumu)..where((t) => t.id.equals(1))).watchSingleOrNull();

  Future<void> okumaDurumunuKaydet(int sure, int ayet) =>
      into(okumaDurumu).insertOnConflictUpdate(
        OkumaDurumuCompanion.insert(
          id: const Value(1),
          sure: sure,
          ayet: ayet,
          guncelleme: DateTime.now(),
        ),
      );

  Stream<List<YerImleriData>> yerImleriniIzle() => (select(
    yerImleri,
  )..orderBy([(t) => OrderingTerm.desc(t.olusturma)])).watch();

  /// Yer imi varsa kaldırır, yoksa ekler. Eklendiyse `true`.
  Future<bool> yerImiDegistir(int sure, int ayet) async {
    final silinen = await (delete(
      yerImleri,
    )..where((t) => t.sure.equals(sure) & t.ayet.equals(ayet))).go();
    if (silinen > 0) return false;
    await into(yerImleri).insert(
      YerImleriCompanion.insert(
        sure: sure,
        ayet: ayet,
        olusturma: DateTime.now(),
      ),
    );
    return true;
  }

  // --- Kaza -----------------------------------------------------------------
  Stream<Map<String, int>> kazaSayaclariniIzle() => select(
    kazaSayaclari,
  ).watch().map((satirlar) => {for (final s in satirlar) s.tur: s.kalan});

  /// Sayacı [fark] kadar değiştirir; sıfırın altına inmez. Yeni değeri döner.
  Future<int> kazaDegistir(String tur, int fark) => transaction(() async {
    final mevcut = await (select(
      kazaSayaclari,
    )..where((t) => t.tur.equals(tur))).getSingleOrNull();
    final yeni = ((mevcut?.kalan ?? 0) + fark).clamp(0, 1 << 30);
    await kazaAyarla(tur, yeni);
    return yeni;
  });

  Future<void> kazaAyarla(String tur, int kalan) =>
      into(kazaSayaclari).insertOnConflictUpdate(
        KazaSayaclariCompanion.insert(tur: tur, kalan: kalan),
      );

  // --- Günlük sayaçlar ------------------------------------------------------
  Stream<int> gunlukSayaciIzle(String gun, String anahtar) =>
      (select(gunlukSayaclar)
            ..where((t) => t.gun.equals(gun) & t.anahtar.equals(anahtar)))
          .watchSingleOrNull()
          .map((s) => s?.adet ?? 0);

  Future<void> gunlukSayaciArtir(String gun, String anahtar, int fark) =>
      transaction(() async {
        final mevcut =
            await (select(gunlukSayaclar)
                  ..where((t) => t.gun.equals(gun) & t.anahtar.equals(anahtar)))
                .getSingleOrNull();
        final yeni = ((mevcut?.adet ?? 0) + fark).clamp(0, 1 << 30);
        await into(gunlukSayaclar).insertOnConflictUpdate(
          GunlukSayaclarCompanion.insert(
            gun: gun,
            anahtar: anahtar,
            adet: yeni,
          ),
        );
      });
}

final veritabaniProvider = Provider<AbyadVeritabani>((ref) {
  final vt = AbyadVeritabani();
  ref.onDispose(vt.close);
  return vt;
});
