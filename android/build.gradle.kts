// Google Services plugin — diperlukan untuk google_sign_in
// buildscript HARUS di atas allprojects dan punya repositories sendiri
buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath("com.google.gms:google-services:4.4.2")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

subprojects {
    val configureProject = {
        if (plugins.hasPlugin("com.android.application") || plugins.hasPlugin("com.android.library")) {
            val android = extensions.findByName("android")
            if (android != null) {
                // 1. Dynamic namespace injection for legacy plugins
                try {
                    val getNamespace = android.javaClass.getMethod("getNamespace")
                    val setNamespace = android.javaClass.getMethod("setNamespace", String::class.java)
                    val currentNamespace = getNamespace.invoke(android) as? String
                    if (currentNamespace.isNullOrEmpty()) {
                        val defaultNamespace = "dev.isar.${project.name.replace("-", "_").replace(":", "_")}"
                        setNamespace.invoke(android, defaultNamespace)
                        println("Successfully injected dynamic fallback namespace '$defaultNamespace' for legacy plugin '${project.name}'")
                    }
                } catch (e: Exception) {
                    // Ignore errors if class signatures vary or properties don't exist
                }

                // 2. Dynamic compileSdk & targetSdk override to 34 for AAPT resource resolution (lStar issue)
                try {
                    android.javaClass.methods.find { it.name == "setCompileSdk" || it.name == "setCompileSdkVersion" }?.let { method ->
                        val params = method.parameterTypes
                        if (params.size == 1) {
                            try {
                                method.invoke(android, 34)
                                println("Successfully overrode compileSdk to 34 for plugin '${project.name}'")
                            } catch (e: Exception) {
                                try {
                                    method.invoke(android, "android-34")
                                    println("Successfully overrode compileSdk to 'android-34' for plugin '${project.name}'")
                                } catch (e2: Exception) {
                                    // Ignore
                                }
                            }
                        }
                    }
                    val defaultConfig = android.javaClass.methods.find { it.name == "getDefaultConfig" }?.invoke(android)
                    if (defaultConfig != null) {
                        defaultConfig.javaClass.methods.find { it.name == "setTargetSdk" || it.name == "setTargetSdkVersion" }?.let { method ->
                            val params = method.parameterTypes
                            if (params.size == 1 && (params[0] == Int::class.java || params[0] == java.lang.Integer::class.java)) {
                                method.invoke(defaultConfig, 34)
                                println("Successfully overrode targetSdk to 34 for plugin '${project.name}'")
                            }
                        }
                    }
                } catch (e: Exception) {
                    // Ignore errors if compileSdk/targetSdk signatures vary or properties don't exist
                }
            }
        }
    }

    if (state.executed) {
        configureProject()
    } else {
        afterEvaluate {
            configureProject()
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
