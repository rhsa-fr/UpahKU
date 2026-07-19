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
    val configureAndroid: Project.() -> Unit = {
        val android = extensions.findByName("android")
        if (android != null) {
            // Force compileSdk 36 on ALL subprojects (fixes isar_flutter_libs lStar error)
            try {
                val setCompileSdk = android.javaClass.getMethod("setCompileSdkVersion", Int::class.java)
                setCompileSdk.invoke(android, 36)
            } catch (_: Exception) {
                try {
                    val setCompileSdk = android.javaClass.getMethod("setCompileSdk", Int::class.java)
                    setCompileSdk.invoke(android, 36)
                } catch (_: Exception) {}
            }

            // Set namespace if missing
            try {
                val getNamespace = android.javaClass.getMethod("getNamespace")
                val setNamespace = android.javaClass.getMethod("setNamespace", String::class.java)
                if (getNamespace.invoke(android) == null) {
                    val ns = "com.dailypayroll.${project.name.replace('-', '_').replace('.', '_')}"
                    setNamespace.invoke(android, ns)
                }
            } catch (e: Exception) {
                // Ignore reflection errors
            }
        }
    }
    if (state.executed) {
        configureAndroid()
    } else {
        afterEvaluate {
            configureAndroid()
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
