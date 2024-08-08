// package com.example.educational_app

// import io.flutter.embedding.android.FlutterActivity

// class MainActivity: FlutterActivity() {
// }

 package com.example.educational_app
import android.util.Log
import android.widget.Toast
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.lang.reflect.Method
import java.net.NetworkInterface
import java.util.*
import android.view.WindowManager.LayoutParams
class MainActivity: FlutterActivity() {



    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        window.addFlags(LayoutParams.FLAG_SECURE)
        super.configureFlutterEngine(flutterEngine)       
    }

//    private fun isDeviceRooted(): Boolean {
//        val buildTags = Build.TAGS
//        if (buildTags != null && buildTags.contains("test-keys")) {
//            return true
//        }
//
//        // Check for common root binaries
//        val paths = arrayOf(
//            "/system/app/Superuser.apk",
//            "/sbin/su",
//            "/system/bin/su",
//            "/system/xbin/su",
//            "/data/local/xbin/su",
//            "/data/local/bin/su",
//            "/system/sd/xbin/su",
//            "/system/bin/failsafe/su",
//            "/data/local/su"
//        )
//
//        for (path in paths) {
//            if (File(path).exists()) {
//                return true
//            }
//        }
//
//        return false
//    }

    // a function that return mac 
    // private fun getMacAddress(): String? {
    //     try {
    //         val all: List<NetworkInterface> =
    //                 Collections.list<NetworkInterface>(NetworkInterface.getNetworkInterfaces())
    //         for (nif in all) {
    //             if (!nif.getName().equals("wlan0", ignoreCase = true)) continue
    //             val macBytes: ByteArray = nif.getHardwareAddress() ?: return ""
    //             val res1 = StringBuilder()
    //             for (b in macBytes) {
    //                 res1.append(String.format("%02X:", b))
    //             }
    //             if (res1.length > 0) {
    //                 res1.deleteCharAt(res1.length - 1)
    //             }
    //             return res1.toString()
    //         }
    //     } catch (ex: java.lang.Exception) {
    //     }
    //     return "02:00:00:00:00:00"
    // }
}