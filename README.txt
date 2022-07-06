# pedoman pengembangan project

Petunjuk Project (Firebase dan State Management Bloc/Cubit)

1. Cara run kode (pastikan menggunakan flutter 3)
a. ketikan di command line "flutter clean"
b. kemudian ketikan lagi "flutter pub get"
c. silakan running

2. Untuk update build (keperluan upload playstore nantinya)
a. edit sha1 dan sha256 di playstore dengan keystore yang ada dilaptop pemilik
(saat uji coba ini pakai punya pengembang)

3. Struktur Folder
A. Folder APP = untuk menyimpan data konstan seperti tema
B. Bloc = state management yang digunakan pada project ini bloc dan cubit (untuk logic controller dengan view (UI))
C. Model = pemodelan data pada firebase firestore
D. Service = untuk pemisahan logic antara firebase dan model
E. View = adalah User Interface (tampilannya) yang terdiri dari pages dan widget-widget
