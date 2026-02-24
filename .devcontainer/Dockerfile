FROM ubuntu:22.04

# جلوگیری از درخواست‌های تعاملی 
ENV DEBIAN_FRONTEND=noninteractive

# نصب پیش‌نیازها
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    wget \
    zip \
    xz-utils \
    libglu1-mesa \
    openjdk-17-jdk \
    android-sdk \
    clang \
    cmake \
    ninja-build \
    pkg-config \
    libgtk-3-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# تنظیم متغیرهای محیطی Android SDK
ENV ANDROID_SDK_ROOT=/usr/lib/android-sdk
ENV ANDROID_HOME=$ANDROID_SDK_ROOT
ENV PATH=$PATH:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$ANDROID_SDK_ROOT/platform-tools

# نصب Android Command Line Tools
RUN mkdir -p $ANDROID_SDK_ROOT/cmdline-tools && \
    wget -q https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip -O /tmp/cmdline-tools.zip && \
    unzip /tmp/cmdline-tools.zip -d $ANDROID_SDK_ROOT/cmdline-tools && \
    mv $ANDROID_SDK_ROOT/cmdline-tools/cmdline-tools $ANDROID_SDK_ROOT/cmdline-tools/latest && \
    rm /tmp/cmdline-tools.zip

# پذیرش لایسنس‌ها و نصب کامپوننت‌های مورد نیاز
RUN yes | sdkmanager --licenses && \
    sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0"

# نصب Flutter SDK (نسخه 3.29.0)
ENV FLUTTER_ROOT=/opt/flutter
ENV FLUTTER_VERSION=3.29.0-stable
ENV PATH=$PATH:$FLUTTER_ROOT/bin

RUN git clone --branch stable https://github.com/flutter/flutter.git $FLUTTER_ROOT && \
    cd $FLUTTER_ROOT && \
    git checkout 3.29.0 && \
    flutter --disable-analytics && \
    flutter precache

# بررسی نصب
RUN flutter doctor

# ایجاد کاربر غیر روت (اختیاری، برای امنیت بیشتر)
RUN useradd -ms /bin/bash developer && \
    chown -R developer:developer /opt/flutter /usr/lib/android-sdk
USER developer

# تنظیم دایرکتوری کاری
WORKDIR /workspace
