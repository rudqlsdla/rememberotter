# flutter_local_notifications - R8에서 Gson TypeToken 제네릭 서명 보존
-keep class com.google.gson.reflect.TypeToken { *; }
-keep class * extends com.google.gson.reflect.TypeToken
-keepattributes Signature
