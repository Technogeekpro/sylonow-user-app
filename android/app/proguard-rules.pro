## Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

## Gson
-keepattributes Signature
-keepattributes *Annotation*
-dontwarn sun.misc.**
-keep class com.google.gson.** { *; }
-keep class * implements com.google.gson.TypeAdapterFactory
-keep class * implements com.google.gson.JsonSerializer
-keep class * implements com.google.gson.JsonDeserializer

## Supabase / Realtime
-keep class io.supabase.** { *; }
-keep class io.realtime.** { *; }

## Razorpay
-keep class com.razorpay.** { *; }
-dontwarn com.razorpay.**

## Google Sign In
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.android.gms.**

## Firebase
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

## OkHttp
-dontwarn okhttp3.**
-dontwarn okio.**
-keep class okhttp3.** { *; }
-keep interface okhttp3.** { *; }

## Retrofit (if used by plugins)
-dontwarn retrofit2.**
-keep class retrofit2.** { *; }

## Keep data models (adjust package names as needed)
-keep class com.sylonow.sylonowUser.** { *; }

## Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

## Keep enum classes
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

## Keep Parcelable classes
-keep class * implements android.os.Parcelable {
  public static final android.os.Parcelable$Creator *;
}

## Keep serializable classes
-keepnames class * implements java.io.Serializable
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    !static !transient <fields>;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}
