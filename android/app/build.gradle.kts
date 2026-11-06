import java.io.FileInputStream
import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

// Flutter meneruskan `--target-platform` sebagai properti Gradle. Petakan ke ABI
// Android supaya .so milik plugin (Isar) untuk arsitektur lain ikut terbuang.
val flutterTargetAbis: List<String> = (project.findProperty("target-platform") as String?)
    ?.split(",")
    ?.map { it.trim() }
    ?.mapNotNull { platform ->
        when (platform) {
            "android-arm64" -> "arm64-v8a"
            "android-arm" -> "armeabi-v7a"
            "android-x64" -> "x86_64"
            else -> null
        }
    }
    ?.distinct()
    ?: emptyList()

android {
    namespace = "com.dailypayroll.daily_payroll"
    compileSdk = 36
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.dailypayroll.daily_payroll"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        if (keystorePropertiesFile.exists()) {
            create("release") {
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
                storeFile = file(keystoreProperties["storeFile"] as String)
                storePassword = keystoreProperties["storePassword"] as String
            }
        }
    }

    buildTypes {
        release {
            // Pakai keystore release bila `android/key.properties` tersedia.
            // Tanpa itu, fallback ke debug key supaya `flutter build apk` tetap jalan.
            signingConfig = if (keystorePropertiesFile.exists()) {
                signingConfigs.getByName("release")
            } else {
                signingConfigs.getByName("debug")
            }

            // Completely disable R8 / ProGuard minification and resource shrinking
            // to prevent stripping/obfuscating native Isar libraries and schemas
            isMinifyEnabled = false
            isShrinkResources = false

            // Dipasang di sini (bukan defaultConfig) karena FlutterPlugin mengisi
            // ulang abiFilters di level buildType saat plugin di-apply.
            if (flutterTargetAbis.isNotEmpty()) {
                ndk {
                    abiFilters.clear()
                    abiFilters.addAll(flutterTargetAbis)
                }
            }
        }
    }
}

flutter {
    source = "../.."
}
