package ir.jrweb.avangvpn

import android.content.Intent
import android.net.VpnService
import android.os.ParcelFileDescriptor

class AvangVpnService : VpnService() {
    private var vpnInterface: ParcelFileDescriptor? = null

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        if (intent?.action == "STOP_VPN") {
            stopVpn()
            return START_NOT_STICKY
        }
        val configName = intent?.getStringExtra("CONFIG_NAME") ?: "Avang Server"
        startTunnel(configName)
        return START_STICKY
    }

    private fun startTunnel(serverName: String) {
        if (vpnInterface != null) return
        val builder = Builder()
        builder.setSession("آونگ وی‌پی‌ان - $serverName")
        builder.addAddress("10.0.0.2", 32)
        builder.addDnsServer("1.1.1.1")
        builder.addRoute("0.0.0.0", 0)
        builder.setMtu(1500)
        vpnInterface = builder.establish()
    }

    private fun stopVpn() {
        try {
            vpnInterface?.close()
            vpnInterface = null
        } catch (_: Exception) {
        }
        stopSelf()
    }

    override fun onDestroy() {
        stopVpn()
        super.onDestroy()
    }
}