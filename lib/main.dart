name: Build Flutter APK  # نام workflow که در تب Actions نمایش داده می‌شود

# تعیین زمان اجرای workflow
on:
  push:                 # هنگام push به شاخه‌های main یا master
    branches: [ main, master ]
  pull_request:         # هنگام ایجاد pull request به این شاخه‌ها
    branches: [ main, master ]
  workflow_dispatch:    # امکان اجرای دستی از طریق تب Actions

jobs:
  build:
    name: Build APK
    runs-on: ubuntu-latest   # اجرا روی آخرین نسخه اوبونتو

    steps:
      # 1. دریافت کد از مخزن
      - name: Checkout repository
        uses: actions/checkout@v4

      # 2. نصب Java (مورد نیاز برای کامپایل اندروید)
      - name: Setup Java
        uses: actions/setup-java@v4
        with:
          distribution: 'zulu'
          java-version: '17'   # نسخه مناسب برای پروژه خود را انتخاب کنید (معمولاً 11 یا 17)

      # 3. نصب فلاتر
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.x'   # می‌توانید نسخه دقیق مثلاً '3.16.0' یا 'stable' بگذارید
          channel: 'stable'

      # 4. کش کردن وابستگی‌های پاب (برای سرعت بخشیدن به buildهای بعدی)
      - name: Cache Flutter dependencies
        uses: actions/cache@v3
        with:
          path: /opt/hostedtoolcache/flutter
          key: ${{ runner.os }}-flutter-${{ hashFiles('**/pubspec.lock') }}
          restore-keys: |
            ${{ runner.os }}-flutter-

      # 5. دریافت وابستگی‌های پروژه
      - name: Install dependencies
        run: flutter pub get

      # 6. ساخت APK (حالت debug برای تست)
      - name: Build APK
        run: flutter build apk --debug  # اگر می‌خواهید release بسازید از --release استفاده کنید

      # 7. آپلود فایل APK به عنوان artifact
      - name: Upload APK artifact
        uses: actions/upload-artifact@v4
        with:
          name: app-debug-apk
          path: build/app/outputs/flutter-apk/app-debug.apk
