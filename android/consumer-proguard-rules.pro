-keep class com.linecorp.flutter_line_sdk.** { *; }
-keepattributes Signature
-keepattributes *Annotation*

## gson
-dontwarn sun.misc.**
-keep class com.linecorp.flutter_line_sdk.model.** { *; }
-keepclassmembers class com.linecorp.flutter_line_sdk.model.** { <fields>; }
-keepclassmembers class com.linecorp.linesdk.** { <fields>; }
-keep class * implements com.google.gson.TypeAdapter
-keep class * implements com.google.gson.TypeAdapterFactory
-keep class * implements com.google.gson.JsonSerializer
-keep class * implements com.google.gson.JsonDeserializer

# Prevent R8 from leaving Data object members always null
-keepclassmembers class * {
  @com.google.gson.annotations.SerializedName <fields>;
}
