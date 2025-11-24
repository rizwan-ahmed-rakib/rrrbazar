//plugins {
//    id("com.android.application")
//    id("kotlin-android")
//    id("dev.flutter.flutter-gradle-plugin")
//}
//
//android {
//    namespace = "com.example.rrrbazar"
//    compileSdk = flutter.compileSdkVersion
////    ndkVersion = flutter.ndkVersion
//    // যদি উপরে NDK version error দেয়, তাহলে এটা আনকমেন্ট করো:
//     ndkVersion = "27.0.12077973"
//
//    compileOptions {
//        sourceCompatibility = JavaVersion.VERSION_11
//        targetCompatibility = JavaVersion.VERSION_11
//    }
//
//    kotlinOptions {
//        jvmTarget = JavaVersion.VERSION_11.toString()
//    }
//
//    defaultConfig {
//        applicationId = "com.example.rrrbazar"
//        minSdk = flutter.minSdkVersion
//        targetSdk = flutter.targetSdkVersion
//        versionCode = flutter.versionCode
//        versionName = flutter.versionName
//
//        // 🔹 এই লাইনটা খুব গুরুত্বপূর্ণ
//        manifestPlaceholders["appAuthRedirectScheme"] =
//            "com.googleusercontent.apps.895753625041-2f11rtjpcgt2rgq9rg3303hee3s5aa1g" //my android
////            "com.googleusercontent.apps.895753625041-1eqels2t6o99ieit8mr157oqkt4sl4lu"  //my web
////            "com.googleusercontent.apps.590339419279-68oe6vvg86t9chn5ruj83okftjuji2d7" //backend
//        // ↑ এখানে তোমার Google OAuth Client ID বসাও
//        // উদাহরণ: com.googleusercontent.apps.1234567890-abcdefghijklmno
//    }
//
//    buildTypes {
//        getByName("release") {
//            signingConfig = signingConfigs.getByName("debug")
//        }
//    }
//}
//
//flutter {
//    source = "../.."
//}





////////////////////////////////////////////////



//plugins {
//    id("com.android.application")
//    id("kotlin-android")
//    id("dev.flutter.flutter-gradle-plugin")
//}
//
//android {
//    namespace = "com.example.rrrbazar"
//    compileSdk = 34
//
//    // ---------------------------
//    // 🔐 1) Signing Configs Added
//    // ---------------------------
//    signingConfigs {
//        create("cobraRelease") {
//            storeFile = file("keystores/cobra.keystore")
//            storePassword = "123456rizwan"
//            keyAlias = "cobra_key"
//            keyPassword = "123456rizwan"
//        }
//
//        create("bdRelease") {
//            storeFile = file("keystores/bd.keystore")
//            storePassword = "123456rizwan"
//            keyAlias = "bd_key"
//            keyPassword = "123456rizwan"
//        }
//        create("zsRelease") {
//            storeFile = file("keystores/zs.keystore")
//            storePassword = "123456rizwan"
//            keyAlias = "zs_key"
//            keyPassword = "123456rizwan"
//        }
//
//        create("rrrRelease") {
//            storeFile = file("keystores/rrr.keystore")
//            storePassword = "123456rizwan"
//            keyAlias = "rrr_key"
//            keyPassword = "123456rizwan"
//        }
//
////        getByName("debug") {
////            storeFile = file("debug.keystore")
////            storePassword = "android"
////            keyAlias = "androiddebugkey"
////            keyPassword = "android"
////        }
//
//    }
//
//    defaultConfig {
//        applicationId = "com.example.rrrbazar"     // overridden by flavors
//        minSdk = 21
//        targetSdk = 34
//        versionCode = 1
//        versionName = "1.0"
//
//        manifestPlaceholders["appAuthRedirectScheme"] = ""
//    }
//
//    // ---------------------------
//    // 🔥 2) Flavor Dimension
//    // ---------------------------
//    flavorDimensions += "app"
//
//    // ---------------------------
//    // 🔥 3) Product Flavors
//    // ---------------------------
//    productFlavors {
//        create("cobra") {
//            dimension = "app"
//            applicationId = "com.cobratopup.app"
//            resValue("string", "app_name", "Cobra TopUp")
//            manifestPlaceholders["appAuthRedirectScheme"] =
////                "com.googleusercontent.apps.COBRA_CLIENT_ID"
//                "com.googleusercontent.apps.895753625041-u5rcnci9hpru02ucli9eju0ta6uuoq14"
//
//            signingConfig = signingConfigs.getByName("cobraRelease")
//        }
//
//        create("bd") {
//            dimension = "app"
//            applicationId = "com.bdgamebazar.app"
//            resValue("string", "app_name", "BD Game Bazar")
//            manifestPlaceholders["appAuthRedirectScheme"] =
////                "com.googleusercontent.apps.BD_CLIENT_ID"
//                "com.googleusercontent.apps.895753625041-c99u5c4btcil6mtvp08nahn8as7c5veu"
//
//            signingConfig = signingConfigs.getByName("bdRelease")
//        }
//        create("zs") {
//            dimension = "app"
//            applicationId = "com.zsshop.app"
//            resValue("string", "app_name", "ZS Shop")
//            manifestPlaceholders["appAuthRedirectScheme"] =
////                "com.googleusercontent.apps.ZS_CLIENT_ID"
//                "com.googleusercontent.apps.895753625041-pcnvuttdiu3oekaip8akh8r90g3fs39t"
//
//            signingConfig = signingConfigs.getByName("zsRelease")
//        }
//
//        create("rrr") {
//            dimension = "app"
//            applicationId = "com.rrrbazar.app"
//            resValue("string", "app_name", "RRR Bazar")
//            manifestPlaceholders["appAuthRedirectScheme"] =
////                "com.googleusercontent.apps.RRR_CLIENT_ID"
//                "com.googleusercontent.apps.895753625041-jtsgp71g6g22s3isom9phffgqq533dfh"
//
//            signingConfig = signingConfigs.getByName("rrrRelease")
//        }
//    }
//
//    // ---------------------------
//    // 🔐 4) Build Types
//    // ---------------------------
//
//
//    buildTypes {
////        getByName("debug") {
////            signingConfig = signingConfigs.getByName("debug")
////        }
//
//        getByName("release") {
//            isMinifyEnabled = false
//            isShrinkResources = false
//            proguardFiles(
//                getDefaultProguardFile("proguard-android-optimize.txt"),
//                "proguard-rules.pro"
//            )
//
//            // ⚠️ IMPORTANT: Don't hard-set signingConfig here.
//            // Flavor-specific release signingConfig will be used.
//        }
//    }
//
//    // ---------------------------
//    // Kotlin & Java Compatibility
//    // ---------------------------
//    compileOptions {
//        sourceCompatibility = JavaVersion.VERSION_11
//        targetCompatibility = JavaVersion.VERSION_11
//    }
//
//    kotlinOptions {
//        jvmTarget = "11"
//    }
//}
//
//flutter {
//    source = "../.."
//}





//////////////////////////////////////////




plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.rrrbazar"
    compileSdk = 35

    // ---------------------------
    // 🔐 1) Signing Configs (সাইনিং কনফিগারেশন)
    // ---------------------------
    signingConfigs {
        // cobra flavor release keystore
        create("cobraRelease") {
            storeFile = file("keystores/cobra.keystore")
            storePassword = "123456rizwan"
            keyAlias = "cobra_key"
            keyPassword = "123456rizwan"
        }

        // cobra flavor debug build-এর জন্যও release keystore ব্যবহার করা হবে
        create("cobraDebug") {
            storeFile = file("keystores/cobra.keystore")
            storePassword = "123456rizwan"
            keyAlias = "cobra_key"
            keyPassword = "123456rizwan"
        }

        // bd flavor release keystore
        create("bdRelease") {
            storeFile = file("keystores/bd.keystore")
            storePassword = "123456rizwan"
            keyAlias = "bd_key"
            keyPassword = "123456rizwan"
        }
        // bd flavor debug build-এর জন্যও release keystore
        create("bdDebug") {
            storeFile = file("keystores/bd.keystore")
            storePassword = "123456rizwan"
            keyAlias = "bd_key"
            keyPassword = "123456rizwan"
        }

        // zs flavor release keystore
        create("zsRelease") {
            storeFile = file("keystores/zs.keystore")
            storePassword = "123456rizwan"
            keyAlias = "zs_key"
            keyPassword = "123456rizwan"
        }
        // zs flavor debug build-এর জন্যও release keystore
        create("zsDebug") {
            storeFile = file("keystores/zs.keystore")
            storePassword = "123456rizwan"
            keyAlias = "zs_key"
            keyPassword = "123456rizwan"
        }

        // rrr flavor release keystore
        create("rrrRelease") {
            storeFile = file("keystores/rrr.keystore")
            storePassword = "123456rizwan"
            keyAlias = "rrr_key"
            keyPassword = "123456rizwan"
        }
        // rrr flavor debug build-এর জন্যও release keystore
        create("rrrDebug") {
            storeFile = file("keystores/rrr.keystore")
            storePassword = "123456rizwan"
            keyAlias = "rrr_key"
            keyPassword = "123456rizwan"
        }
        // evo flavor release keystore
        create("evoRelease") {
            storeFile = file("keystores/evo.keystore")
            storePassword = "123456rizwan"
            keyAlias = "evo_key"
            keyPassword = "123456rizwan"
        }
        // evo flavor debug build-এর জন্যও release keystore
        create("evoDebug") {
            storeFile = file("keystores/evo.keystore")
            storePassword = "123456rizwan"
            keyAlias = "evo_key"
            keyPassword = "123456rizwan"
        }
        // rangvo flavor release keystore
        create("rangvoRelease") {
            storeFile = file("keystores/rangvo.keystore")
            storePassword = "123456rizwan"
            keyAlias = "rangvo_key"
            keyPassword = "123456rizwan"
        }
        // rangvo flavor debug build-এর জন্যও release keystore
        create("rangvoDebug") {
            storeFile = file("keystores/rangvo.keystore")
            storePassword = "123456rizwan"
            keyAlias = "rangvo_key"
            keyPassword = "123456rizwan"
        }
        // pipo flavor release keystore
        create("pipoRelease") {
            storeFile = file("keystores/pipo.keystore")
            storePassword = "123456rizwan"
            keyAlias = "pipo_key"
            keyPassword = "123456rizwan"
        }
        // pipo flavor debug build-এর জন্যও release keystore
        create("pipoDebug") {
            storeFile = file("keystores/pipo.keystore")
            storePassword = "123456rizwan"
            keyAlias = "pipo_key"
            keyPassword = "123456rizwan"
        }
    }

    defaultConfig {
        applicationId = "com.example.rrrbazar" // Default applicationId, flavor দ্বারা override হবে
        minSdk = 21
        targetSdk = 34
        versionCode = 1
        versionName = "1.0"

        // Google Sign-In redirect scheme placeholder
        manifestPlaceholders["appAuthRedirectScheme"] = ""
    }

    // ---------------------------
    // 🔥 2) Flavor Dimension
    // ---------------------------
    flavorDimensions += "app"

    // ---------------------------
    // 🔥 3) Product Flavors
    // ---------------------------
    productFlavors {
        create("cobra") {
            dimension = "app"
            applicationId = "com.cobratopup.app"
            resValue("string", "app_name", "Cobra TopUp")
            manifestPlaceholders["appAuthRedirectScheme"] =
                "com.googleusercontent.apps.895753625041-u5rcnci9hpru02ucli9eju0ta6uuoq14"

            // debug build এর জন্য release keystore ব্যবহার
            signingConfig = signingConfigs.getByName("cobraDebug")
        }

        create("bd") {
            dimension = "app"
            applicationId = "com.bdgamebazar.app"
            resValue("string", "app_name", "BD Game Bazar")
            manifestPlaceholders["appAuthRedirectScheme"] =
                "com.googleusercontent.apps.895753625041-c99u5c4btcil6mtvp08nahn8as7c5veu"

            signingConfig = signingConfigs.getByName("bdDebug")
        }

        create("zs") {
            dimension = "app"
            applicationId = "com.zsshop.app"
            resValue("string", "app_name", "ZS Shop")
            manifestPlaceholders["appAuthRedirectScheme"] =
                "com.googleusercontent.apps.895753625041-pcnvuttdiu3oekaip8akh8r90g3fs39t"

            signingConfig = signingConfigs.getByName("zsDebug")
        }

        create("rrr") {
            dimension = "app"
            applicationId = "com.rrrbazar.app"
            resValue("string", "app_name", "RRR Bazar")
            manifestPlaceholders["appAuthRedirectScheme"] =
                "com.googleusercontent.apps.895753625041-jtsgp71g6g22s3isom9phffgqq533dfh"

            signingConfig = signingConfigs.getByName("rrrDebug")
        }
        create("evo") {
            dimension = "app"
            applicationId = "com.evotopup.app"
            resValue("string", "app_name", "EVO TOPUP")
            manifestPlaceholders["appAuthRedirectScheme"] =
                "com.googleusercontent.apps.895753625041-pk4sq7rjnscpbvr7jujt8vl2tkgtbobp"

            signingConfig = signingConfigs.getByName("evoDebug")
        }
        create("rangvo") {
            dimension = "app"
            applicationId = "com.rangvotopup.app"
            resValue("string", "app_name", "RANGVO TOPUP")
            manifestPlaceholders["appAuthRedirectScheme"] =
                "com.googleusercontent.apps.895753625041-9645lddcnnpj5gh2acgj9g5ktll3rv2m"

            signingConfig = signingConfigs.getByName("rangvoDebug")
        }
        create("pipo") {
            dimension = "app"
            applicationId = "com.pipobazar.app"
            resValue("string", "app_name", "PIPO Bazar")
            manifestPlaceholders["appAuthRedirectScheme"] =
                "com.googleusercontent.apps.895753625041-qug7foloj441haa2tovmulv2t80p57jv"

            signingConfig = signingConfigs.getByName("pipoDebug")
        }
    }

    // ---------------------------
    // 🔐 4) Build Types
    // ---------------------------








    buildTypes {
        getByName("debug") {
            // 🔥 Debug build-এ flavor অনুযায়ী signingConfig override করতে allow করলো
            isDebuggable = true
            signingConfig = null   // খুব গুরুত্বপূর্ণ!!
        }

        getByName("release") {
            isMinifyEnabled = false
            isShrinkResources = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }


    // ---------------------------
    // Kotlin & Java Compatibility
    // ---------------------------
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = "11"
    }
}

flutter {
    source = "../.."
}

