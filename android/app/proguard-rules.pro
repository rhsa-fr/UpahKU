# Keep Isar core classes
-keep class io.isar.** { *; }
-keep class * extends io.isar.isar_flutter_libs.** { *; }

# Keep our Isar model classes and their generated schemas
-keep class com.dailypayroll.daily_payroll.data.models.** { *; }
-keep class com.dailypayroll.daily_payroll.data.models.* { *; }
-keep class **Model { *; }
-keep class **ModelSchema { *; }
-keep class * extends isar.** { *; }
