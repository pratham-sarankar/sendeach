flutter clean
flutter pub get
flutter build apk -v --release --dart-define=host=https://sendeach.com/api
flutter install build/app/outputs/flutter-apk/app-release.apk