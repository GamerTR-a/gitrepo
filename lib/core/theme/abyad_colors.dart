import 'package:flutter/painting.dart';

/// Abyad renk paleti. Tasarımdaki bütün renkler buradan gelir;
/// ekranlarda doğrudan hex kod yazmayın, bu sınıfı kullanın.
class AbyadColors {
  AbyadColors._();

  // Ana renkler
  static const zumrut = Color(0xFF0F3D33); // ana renk, koyu başlık alanları
  static const zumrutKoyu = Color(0xFF0A2B24); // basılı durum
  static const pirinc = Color(0xFFE2C27A); // koyu zemin üstünde vurgu
  static const pirincYazi = Color(0xFF8A6316); // açık zemin üstünde pirinç yazı
  static const pirincSus = Color(
    0xFFB9944A,
  ); // açık zemin üstünde süsleme çizgisi
  static const pirincZemin = Color(0xFFF4EBD6); // "sıradaki" vurgusu
  static const pirincAcik = Color(0xFFFBF5E7); // seçili kart zemini
  static const pirincKenar = Color(0xFFE4D6B4);

  // Zeminler
  static const zemin = Color(0xFFF3F4EF); // ekran zemini
  static const yuzey = Color(0xFFFFFFFF); // kartlar
  static const okumaZemini = Color(0xFFFBFBF8); // Kur'an okuma ekranı
  static const yesilZemin = Color(0xFFE3ECE7); // ikon kutuları, ilerleme izi
  static const segmentZemin = Color(0xFFE6EAE4);

  // Çizgiler
  static const kenarlik = Color(0xFFE1E5DF);
  static const ayrac = Color(0xFFEEF1EC);

  // Yazılar
  static const metin = Color(0xFF17231F);
  static const metinIkincil = Color(0xFF56625D);
  static const metinPasif = Color(0xFF6B7772); // geçmiş vakitler
  static const menuPasif = Color(0xFF5E6B66);
  static const koyuUstuIkincil = Color(
    0xFFCFE0D8,
  ); // zümrüt zemin üstünde ikincil yazı

  // Zümrüt zemin üstündeki yarı saydam katmanlar
  static const koyuUstuKart = Color(0x0FFFFFFF); // %6 beyaz
  static const koyuUstuSecili = Color(0x29FFFFFF); // %16 beyaz
  static const koyuUstuKenar = Color(0x47FFFFFF); // %28 beyaz
}
