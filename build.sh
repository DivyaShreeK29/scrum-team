flutter clean
rm -rf pubspec.lock
rm -rf build
flutter pub get
flutter build web --web-renderer html --dart-define=RELEASE_TYPE=$1