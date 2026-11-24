package com.nrsqxw.dashgamespace

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.app.Activity
import android.os.Handler
import android.os.Looper
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class BridgeChannel : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL,
        ).setMethodCallHandler { call, result ->
            if (call.method != "send") {
                result.notImplemented()
                return@setMethodCallHandler
            }
            val command = call.arguments as? String
            if (command.isNullOrEmpty() || command.length > 4096) {
                result.error("BAD_COMMAND", "command must be 1..4096 chars", null)
                return@setMethodCallHandler
            }
            val intent = Intent(DASH_ACTION).setPackage(DASH_PACKAGE)
            intent.putExtra("cmd", command)
            val settled = java.util.concurrent.atomic.AtomicBoolean(false)
            Handler(Looper.getMainLooper()).postDelayed({
                if (settled.compareAndSet(false, true)) {
                    result.error("DASH_TIMEOUT", "Dash did not answer", null)
                }
            }, 3000)
            sendOrderedBroadcast(
                intent,
                null,
                object : BroadcastReceiver() {
                    override fun onReceive(context: Context?, received: Intent?) {
                        if (settled.compareAndSet(false, true)) {
                            result.success(resultData ?: "{}")
                        }
                    }
                },
                null,
                Activity.RESULT_OK,
                null,
                null,
            )
        }
    }

    private companion object {
        const val CHANNEL = "com.nrsqxw.dashgamespace/bridge"
        const val DASH_ACTION = "io.github.neeschal.dashessential.GAME_SPACE_BRIDGE"
        const val DASH_PACKAGE = "io.github.neeschal.dashessential"
    }
}
