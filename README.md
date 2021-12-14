# Note App

Note App application.

## Genel Bilgilendirme
 - Uygulama Google Flutter Framework'ü kullanılarak geliştirilmiştir.
 - Uygulamanın Amacı;
   Kullanıcının Not Defteri olarak kullanabilildiği, Kullanıcının notlarının görüntülendiği üzerinde işlemler yapabildiği, Notlarına fotoğraf ekleyebildiği,Mikrofon ile birlikte sesli notların text haline dönüştürülüğü ve bunları uygulama silinmediği sürece saklanılabildiği, Kullanıcının kullanım kolaylığını amaçlayan mobil uygulamadır.
 - Emulator ve Gerçek Android Cihaz olarak test edilmiştir(Mac cihaz bulunmadığından IOS tarafı test edilememiştir.
   Olası Sorun; kullanılan kütüphanelerin IOS konfigürasyonları yapılmadığından hata verebilir.)

## NOT
  - Uygulama içerisinde State Management kullanışmış olsa da bazı yerlerde farklı şeylerde göstermek amaçlı State Management dışında Flutter'ın kendi Stateful Widget'larının State yapısıda kullanılmıştır.

## Kullanılan Kütüphaneler


- [GetX(State Management)](https://pub.dev/packages/get)
- [Get It(Dependency Injection)](https://pub.dev/packages/get_it)
- [Logger](https://pub.dev/packages/logger)
- [Photo View](https://pub.dev/packages/photo_view)
- [Intl](https://pub.dev/packages/intl)
- [Speech To Text](https://pub.dev/packages/speech_to_text)
- [Shared Preferences](https://pub.dev/packages/shared_preferences)
- [Sqflite](https://pub.dev/packages/sqflite)
- [Image Picker](https://pub.dev/packages/image_picker)
- [Carousel Slider](https://pub.dev/packages/carousel_slider)


## Tasarım yaklaşımı

- Kullanılan Widget'ların parçalanması ve gerekli yerlerde tekrar kullanılmasını amaçlayan Atomic Design yaklaşımı referans alınmıştır.
Amaç; Kod Okunabilirliği, Widgeti'ların tekrar tekrar kullanılabilme opsiyonu ve dinamikleştirmek.Atomic Design için örnek döküman;
https://itnext.io/atomic-design-with-flutter-11f6fcb62017
- [Atomic Design](https://itnext.io/atomic-design-with-flutter-11f6fcb62017)
- Kullanılan Widget'lar UI bazlı veya Uygulama geneli olma durumuna göre View dosyasının altında veya Core Katmanına eklendi

## Kullanılan Mimari

- Katmanlı mimari alt yapısı kullanılarak her katmanın kendi işini yapması amacıyla, kod okunabilirliği açısından ve sonra ki süreçte yapılan uygulamanın değişime direnç göstermemesi amacıyla MVC Design Pattern kullanımıştır(Alternatif; BLoC Pattern, MVVM)
- Katmanlar; 
  - Models(Model class'ların tutulduğu katmandır.Kullanılan dataların referans modelleri saklanır.)
  - Views(UI elemanlarının tutulduğu katmandır ve sadece UI ile ilgili elemanlar tutulmalıdır)
  - Controller(Business kodunun yazıldığı UI ve Service katmanı arasında ki iş akışını sağlayan katmandır.)
  - Services(Veri tabanı işlerinin yürütüldüğü katmandır)
  - Core(Uygulama özelinde olmayan ve her hangi bir projede kullanılabilmesi amaçlanan uygulama geneli yapıları tutar,Uygulama bağımsızdır(Örn; Helpers, Constants ve Uygulama dışı kullanılabilecek uygulamaya bağımlı olmayan widgetların tutulduğu katmandır))

  İş akışı;
   View --> Controller --> Services 
  ya da
   View <-- Controller <-- Services (Diğer yapılar ilgili iş akışına göre ilgili katmanda kullanılmaktadır.)















