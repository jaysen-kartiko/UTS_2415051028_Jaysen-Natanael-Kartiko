# MovieTracker
MovieTracker adalah aplikasi untuk membantu pengguna mencari detail film dan melakukan review film yang telah ditonton. Fokus proyek adalah demonstrasi kemampuan Flutter, state management, API, database, dan arsitektur.

# Identitas
- Jaysen Natanael Kartiko
- 2415051028
- PTI 5 A

# Daftar Fitur
- Search film menurut nama	
- Filter menurut kategori genre dan negara
- List/Grid film yang responsif.
- Detail film dengan passing data.
- Watchlist sebagai shared state.
- CRUD data rating pada database.
- Loading, empty, dan error state.
- SnackBar/AlertDialog untuk feedback.
- list/grid daftar film yang sudah di rating.


# Tech Stack
- Mobile Framework: Flutter 
- API: MockAPI
- Database: Supabase (PostgreSQL)

# Rest API
Menggunakan mockapi.io untuk menyimpan data film (link RestAPI ada dalam .env yang tidak di-push)

# Backend
Menggunaan Database Supabase untuk menyimpan data users dan ratings (link dan publishable ada dalam .env yaang tidak di-push)

# Struktur arsitektur aplikasi
Menggunakan Repository Pattern
UI -> Models -> Provider -> Repository -> Database/API

# Screenshot aplikasi 

# Cara menjalankan projek
1. Buka aplikasi
2. Akses halaman "Film" untuk mencari film
3. Tekan tombol "Watchlist" untuk memasukkan film ke halaman watchlist yang dapat dilihat dengan menekan icon bookmark di pojok kanan atas
4. Tekan pada film untuk membuka detail dari film. 
5. ketika detail muncul, pengguna dapat memberikan rating dan review film. 
6. untuk melakukan rating, isi seluruh field dalam form sesuai keinginan. klik Simpan Review untuk menyimpan. 
7. Rating dan Review yang dilakukan dapat dilihat di halaman Review.
8. jika ingin mengedit review, dapat mengklik film yang ada di halaman Review dan lakukan edit pada field dalam form lalu klik Perbarui Review
9. Jika ingin menghapus review film, dapat menekan icon tong sampah dan melakukan konfirmasi untuk menghapus review film tersebut.
