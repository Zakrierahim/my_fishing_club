// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Malay (`ms`).
class AppLocalizationsMs extends AppLocalizations {
  AppLocalizationsMs([String locale = 'ms']) : super(locale);

  @override
  String get appName => 'Aplikasi Memancing Saya';

  @override
  String get welcomeBack => 'Selamat Kembali';

  @override
  String get welcomeSubtitle => 'Pengembaraan memancing anda bermula di sini.';

  @override
  String get login => 'Log Masuk';

  @override
  String get home => 'Utama';

  @override
  String get explore => 'Teroka';

  @override
  String get notification => 'Notifikasi';

  @override
  String get settings => 'Tetapan';

  @override
  String get language => 'Bahasa';

  @override
  String get bahasaMelayu => 'Bahasa Melayu';

  @override
  String get english => 'English';

  @override
  String get email => 'E-mel';

  @override
  String get password => 'Kata laluan';

  @override
  String get showPassword => 'Tunjukkan kata laluan';

  @override
  String get hidePassword => 'Sembunyikan kata laluan';

  @override
  String get newUser => 'Baru?';

  @override
  String get register => 'Daftar';

  @override
  String get createAccount => 'Cipta akaun';

  @override
  String get createAccountSubtitle =>
      'Daftar untuk memulakan pengembaraan memancing seterusnya.';

  @override
  String get name => 'Nama';

  @override
  String get alreadyHaveAccount => 'Sudah ada akaun?';

  @override
  String get fishingHook => 'Mata kail';

  @override
  String get splashScene =>
      'Pemancing sedang melawan ikan yang melompat pada waktu malam';

  @override
  String get homeHeaderScene => 'Pemancing dan ikan yang melompat';

  @override
  String get continueWithGoogle => 'Teruskan dengan Google';

  @override
  String get continueWithFacebook => 'Teruskan dengan Facebook';

  @override
  String get continueWithTikTok => 'Teruskan dengan TikTok';

  @override
  String get continueWithWhatsApp => 'Teruskan dengan WhatsApp';

  @override
  String get linkedAccounts => 'Akaun Dipautkan';

  @override
  String get connected => 'Disambungkan';

  @override
  String get notConnected => 'Tidak disambungkan';

  @override
  String get linkAccount => 'Pautkan Akaun';

  @override
  String get unlinkAccount => 'Nyahpaut Akaun';

  @override
  String get authenticationFailed => 'Pengesahan gagal';

  @override
  String get authenticationCancelled => 'Pengesahan dibatalkan';

  @override
  String get verificationCode => 'Kod pengesahan';

  @override
  String get resendCode => 'Hantar semula kod';

  @override
  String get confirmUnlink => 'Sahkan nyahpaut';

  @override
  String confirmUnlinkMessage(String provider) {
    return 'Nyahpaut $provider? Anda tidak lagi boleh log masuk dengannya.';
  }

  @override
  String get configurationRequired => 'Konfigurasi diperlukan';

  @override
  String get unlinkLastMethod =>
      'Kekalkan sekurang-kurangnya satu kaedah log masuk yang dipautkan.';

  @override
  String get cancel => 'Batal';

  @override
  String get phoneNumber => 'Nombor telefon';

  @override
  String get whatsappVerificationTitle => 'Sahkan WhatsApp';

  @override
  String get whatsappVerificationSubtitle =>
      'Masukkan nombor telefon anda. Kod dihantar hanya selepas pengesahan WhatsApp dikonfigurasi.';

  @override
  String get verify => 'Sahkan';

  @override
  String get goodMorning => 'Selamat pagi';

  @override
  String get goodAfternoon => 'Selamat petang';

  @override
  String get goodEvening => 'Selamat malam';

  @override
  String get homePrompt => 'Perjalanan memancing seterusnya bermula di sini.';

  @override
  String get logACatch => 'Rekod tangkapan';

  @override
  String get spots => 'Lokasi';

  @override
  String get spotsSubtitle => 'Lihat tempat memancing';

  @override
  String get trips => 'Perjalanan';

  @override
  String get tripsSubtitle => 'Rancang perjalanan seterusnya';

  @override
  String get recentActivity => 'Aktiviti terkini';

  @override
  String get noCatchesYet => 'Belum ada tangkapan.';

  @override
  String get membershipSection => 'Keahlian';

  @override
  String get noMembershipYet => 'Belum ada keahlian.';

  @override
  String get myFishingPass => 'Pas Memancing Saya';

  @override
  String get passCardSubtitle =>
      'Buka pas kolam anda apabila anda mempunyai keahlian.';

  @override
  String get explorePonds => 'Teroka Kolam';

  @override
  String get myMemberships => 'Keahlian Saya';

  @override
  String get myTrips => 'Perjalanan Saya';

  @override
  String get quickActions => 'Tindakan pantas';

  @override
  String get searchPonds => 'Cari kolam';

  @override
  String get fishSpecies => 'Spesies ikan';

  @override
  String get pondType => 'Jenis kolam';

  @override
  String get noPondsYet => 'Belum ada kolam untuk dipaparkan.';

  @override
  String get noMatchingPonds => 'Tiada kolam sepadan dengan carian anda.';

  @override
  String get noFiltersYet => 'Penapis dipaparkan apabila kolam tersedia.';

  @override
  String get clearFilters => 'Kosongkan penapis';

  @override
  String get pondDetails => 'Butiran kolam';

  @override
  String get speciesLabel => 'Spesies';

  @override
  String get noMembershipAtPond => 'Tiada keahlian di kolam ini.';

  @override
  String get membershipsEmptyBody =>
      'Apabila anda menyertai kolam, keahlian itu dipaparkan di sini. Setiap kolam mempunyai keahlian tersendiri.';

  @override
  String get membershipDetails => 'Butiran keahlian';

  @override
  String get demoPreview => 'Pratonton demo';

  @override
  String get notVerifiedMembership => 'Ini bukan keahlian yang disahkan.';

  @override
  String get demoData => 'Data demo';

  @override
  String get demoDataHint =>
      'Menunjukkan pratonton tempatan bagi lokasi yang disenaraikan secara awam. Ini bukan data langsung.';

  @override
  String get demoPond => 'Kolam demo';

  @override
  String get previewData => 'Pratonton data';

  @override
  String get notConfirmed => 'Belum disahkan';

  @override
  String get saltwater => 'Air masin';

  @override
  String get freshwater => 'Air tawar';

  @override
  String get mixedWater => 'Air masin dan air tawar';

  @override
  String get unknownWater => 'Tidak diketahui';

  @override
  String get waterType => 'Jenis air';

  @override
  String get openInGoogleMaps => 'Buka dalam Google Maps';

  @override
  String get searchInGoogleMaps => 'Cari dalam Google Maps';

  @override
  String get coordinatesLabel => 'Koordinat';

  @override
  String get imageUnavailable => 'Imej tidak tersedia';

  @override
  String get price => 'Harga';

  @override
  String get openingHours => 'Waktu operasi';

  @override
  String get samplePrice => 'Harga sampel';

  @override
  String get sampleOpeningHours => 'Waktu operasi sampel';

  @override
  String get facilities => 'Kemudahan';

  @override
  String get areaLabel => 'Kawasan';

  @override
  String get verifiedMembership => 'Keahlian disahkan';

  @override
  String get passEmptyTitle => 'Belum ada pas memancing';

  @override
  String get passEmptyBody =>
      'Pas dipaparkan di sini selepas anda mempunyai keahlian di sesuatu kolam.';

  @override
  String get qrUnavailable => 'Kod QR tidak dipaparkan dalam versi ini.';

  @override
  String get demoPassBody => 'Pratonton ini bukan kelayakan keahlian.';

  @override
  String get demoPreviewBadge => 'PRATONTON DEMO';

  @override
  String get demoQrCode => 'Kod QR demo';

  @override
  String get demoBarcode => 'Kod bar demo';

  @override
  String get memberId => 'ID ahli';

  @override
  String get demoPassOnly =>
      'Pas demo sahaja. Tidak sah untuk masuk atau daftar masuk.';

  @override
  String get membershipNotVerified => 'Keahlian tidak disahkan.';

  @override
  String get checkInUnavailable => 'Daftar masuk tidak tersedia.';

  @override
  String get profile => 'Profil';

  @override
  String get editProfile => 'Edit profil';

  @override
  String get nameNotSet => 'Nama belum ditetapkan';

  @override
  String get unavailable => 'Tidak tersedia';

  @override
  String get displayName => 'Nama paparan';

  @override
  String get savedOnDeviceOnly => 'Disimpan pada peranti ini sahaja.';

  @override
  String get save => 'Simpan';

  @override
  String get preferences => 'Keutamaan';

  @override
  String get about => 'Perihal';

  @override
  String versionLabel(String version) {
    return 'Versi $version';
  }

  @override
  String get noNotificationsYet => 'Belum ada pemberitahuan';

  @override
  String get noNotificationsBody =>
      'Apabila ada sesuatu yang perlu perhatian anda, ia akan dipaparkan di sini.';

  @override
  String get screenNotReady => 'Skrin ini belum sedia. Tiada apa-apa disimpan.';

  @override
  String get viewMap => 'Lihat peta';

  @override
  String get navigate => 'Navigasi';

  @override
  String get chooseNavigation => 'Pilih aplikasi peta';

  @override
  String get navigationSuggested => 'Dicadangkan';

  @override
  String get googleMaps => 'Google Maps';

  @override
  String get waze => 'Waze';

  @override
  String get appleMaps => 'Apple Maps';

  @override
  String get navigationSearchNote =>
      'Ini mencari berdasarkan nama dan alamat kolam. Ia bukan pin yang disahkan.';

  @override
  String get mapsLaunchFailed => 'Peta tidak dapat dibuka.';

  @override
  String get mapsOpenedInBrowser =>
      'Halaman peta dibuka dalam pelayar. Navigasi tidak dimulakan dalam aplikasi.';

  @override
  String get favorites => 'Kegemaran';

  @override
  String get noFavoritesYet => 'Belum ada kolam kegemaran.';

  @override
  String get favoritePond => 'Tambah ke kegemaran';

  @override
  String get unfavoritePond => 'Buang daripada kegemaran';

  @override
  String get pondUnavailable => 'Kolam ini tiada dalam senarai semasa.';

  @override
  String get sortByName => 'Nama (A–Z)';

  @override
  String get catchLog => 'Log tangkapan';

  @override
  String get addCatch => 'Tambah tangkapan';

  @override
  String get editCatch => 'Edit tangkapan';

  @override
  String get catchDetails => 'Butiran tangkapan';

  @override
  String get speciesRequired => 'Masukkan nama spesies.';

  @override
  String get catchDate => 'Tarikh tangkapan';

  @override
  String get catchTime => 'Masa tangkapan';

  @override
  String get weightKg => 'Berat (kg, pilihan)';

  @override
  String get lengthCm => 'Panjang (cm, pilihan)';

  @override
  String get notesOptional => 'Nota (pilihan)';

  @override
  String get associatedPond => 'Kolam (pilihan)';

  @override
  String get noPondSelected => 'Tiada kolam';

  @override
  String get invalidNumber => 'Masukkan nombor sifar atau lebih.';

  @override
  String get addPhoto => 'Tambah foto';

  @override
  String get removePhoto => 'Buang foto';

  @override
  String get photoSelected => 'Foto telah dilampirkan.';

  @override
  String get photoUnavailable => 'Foto tidak dapat disimpan.';

  @override
  String get couldNotSave => 'Tidak dapat disimpan. Tiada perubahan.';

  @override
  String get delete => 'Padam';

  @override
  String get deleteConfirmTitle => 'Padam rekod ini?';

  @override
  String get deleteConfirmBody => 'Ini membuangnya daripada peranti ini.';

  @override
  String get planATrip => 'Rancang perjalanan';

  @override
  String get editTrip => 'Edit perjalanan';

  @override
  String get tripDetails => 'Butiran perjalanan';

  @override
  String get tripTitleLabel => 'Tajuk perjalanan';

  @override
  String get tripTitleRequired => 'Masukkan tajuk perjalanan.';

  @override
  String get startDate => 'Tarikh mula';

  @override
  String get endDate => 'Tarikh tamat (pilihan)';

  @override
  String get clearEndDate => 'Kosongkan tarikh tamat';

  @override
  String get endBeforeStart => 'Tarikh tamat adalah sebelum tarikh mula.';

  @override
  String get tripStatusPlanned => 'Dirancang';

  @override
  String get tripStatusCompleted => 'Selesai';

  @override
  String get tripStatusCancelled => 'Dibatalkan';

  @override
  String get markCompleted => 'Tanda selesai';

  @override
  String get cancelTrip => 'Batalkan perjalanan';

  @override
  String get reopenTrip => 'Tanda sebagai dirancang';

  @override
  String get notAReservation => 'Ini tidak menempah kolam.';

  @override
  String get noTripsYet => 'Belum ada perjalanan.';

  @override
  String get selectPond => 'Kolam';

  @override
  String get noPondsForTrip => 'Tiada kolam untuk dipilih.';

  @override
  String get loadingRecords => 'Memuatkan rekod tersimpan…';

  @override
  String get recordsLoadFailed => 'Rekod tersimpan tidak dapat dimuatkan.';

  @override
  String get recordMissing => 'Rekod ini tiada lagi pada peranti ini.';

  @override
  String get fishingSession => 'Sesi memancing';

  @override
  String get fishingHistory => 'Sejarah memancing';

  @override
  String get startSession => 'Mula sesi';

  @override
  String get resumeSession => 'Sambung sesi';

  @override
  String get sessionActive => 'Sedang berlangsung';

  @override
  String get sessionCompleted => 'Selesai';

  @override
  String get sessionInProgress => 'Satu sesi sedang berlangsung.';

  @override
  String get sessionStartedAt => 'Bermula';

  @override
  String get sessionEndedAt => 'Tamat';

  @override
  String get sessionElapsed => 'Tempoh';

  @override
  String sessionDurationHours(int hours, int minutes) {
    return '$hours j $minutes min';
  }

  @override
  String sessionDurationMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String sessionCatchCount(int count) {
    return 'Tangkapan: $count';
  }

  @override
  String get endSession => 'Tamatkan sesi';

  @override
  String get endSessionConfirmTitle => 'Tamatkan sesi ini?';

  @override
  String get endSessionConfirmBody =>
      'Masa tamat direkodkan. Tangkapan baharu tidak boleh ditambah daripada sesi ini.';

  @override
  String get sessionTitleLabel => 'Tajuk sesi (pilihan)';

  @override
  String get noSessionsYet => 'Belum ada sesi memancing.';

  @override
  String get sessionNotABooking =>
      'Disimpan pada peranti ini. Ini bukan tempahan.';

  @override
  String get addCatchToSession => 'Tambah tangkapan';

  @override
  String get sessionPond => 'Kolam';

  @override
  String get noPondOnSession => 'Tiada kolam dipilih';

  @override
  String get markLinkedTripCompleted =>
      'Tanda perjalanan berkaitan sebagai selesai';

  @override
  String get linkedTripMissing =>
      'Perjalanan berkaitan tiada lagi pada peranti ini.';

  @override
  String get sessionSummary => 'Ringkasan sesi';

  @override
  String get activeSessionSection => 'Sesi sedang berlangsung';

  @override
  String get completedSessionsSection => 'Selesai';

  @override
  String get sessionCatchLinked =>
      'Tangkapan ini sebahagian daripada sesi memancing.';

  @override
  String get sessionEndMissing => 'Masa tamat tidak direkodkan.';
}
