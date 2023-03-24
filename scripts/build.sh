flutter clean
flutter pub get
flutter build apk  --dart-define=host=https://demo.sendeach.com/api/app
flutter install build/app/outputs/flutter-apk/app-debug.apk