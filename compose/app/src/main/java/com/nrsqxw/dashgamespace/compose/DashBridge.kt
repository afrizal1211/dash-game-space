package com.nrsqxw.dashgamespace.compose

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.app.Activity
import android.os.Handler
import android.os.Looper

object DashBridge {
    private const val ACTION = "io.github.neeschal.dashessential.GAME_SPACE_BRIDGE"
    private const val PACKAGE = "io.github.neeschal.dashessential"

    fun send(context: Context, command: String, onResult: (String) -> Unit) {
        val intent = Intent(ACTION).setPackage(PACKAGE).putExtra("cmd", command)
        val main = Handler(Looper.getMainLooper())
        val timeout = Runnable { onResult("{\"ok\":false,\"error\":\"timeout\"}") }
        main.postDelayed(timeout, 3000)
        context.sendOrderedBroadcast(
            intent,
            null,
            object : BroadcastReceiver() {
                override fun onReceive(context: Context?, intent: Intent?) {
                    main.removeCallbacks(timeout)
                    onResult(resultData ?: "{}")
                }
            },
            null,
            Activity.RESULT_OK,
            null,
            null,
        )
    }
}
