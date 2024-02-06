package com.example.music_player_app

import android.content.ContentValues
import android.content.Context
import android.media.RingtoneManager
import android.net.Uri
import android.provider.MediaStore
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {

    private val CHANNEL = "abhi"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "setRingtone") {
                val filePath = call.argument<String>("filePath")
                if (filePath != null) {
                    setRingtone(filePath)
                    result.success(null)
                } else {
                    result.error("INVALID_ARGUMENT", "File path is null", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun setRingtone(filePath: String) {
        val context: Context = applicationContext
        val values = ContentValues().apply {
            put(MediaStore.MediaColumns.DATA, filePath)
            put(MediaStore.MediaColumns.TITLE, "Custom Ringtone")
            put(MediaStore.MediaColumns.MIME_TYPE, "audio/x-wav")
            put(MediaStore.Audio.Media.IS_RINGTONE, true)
        }

        val uri: Uri? = context.contentResolver.insert(MediaStore.Audio.Media.EXTERNAL_CONTENT_URI, values)
        uri?.let {
            RingtoneManager.setActualDefaultRingtoneUri(context, RingtoneManager.TYPE_RINGTONE, it)
        }
    }

}
