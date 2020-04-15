package com.mt.myapplication

import android.app.Activity
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.text.TextUtils
import android.widget.Toast
import io.flutter.embedding.android.FlutterFragment
import io.flutter.plugin.common.*

class FlutterPlugin(private val flutterFragment: FlutterFragment) :
        MethodChannel.MethodCallHandler, EventChannel.StreamHandler, BasicMessageChannel.MessageHandler<Any> {


    private var mStateChangeReceiver: BroadcastReceiver? = null

    companion object {
        private const val TAG = "FlutterPlugin"

        const val STATE_CHANGE_ACTION = "com.demo.plugins.action.StateChangeAction"
        const val STATE_VALUE = "com.demo.plugins.value.StateValue"
        const val MESSAGE_CHANNEL_NAME = "flutter_channel"
        const val METHOD_CHANNEL_NAME: String = "method_channel"
        const val STREAM_CHANNEL_NAME: String = "stream_channel"

        @JvmStatic
        fun registerPlugin(flutterFragment: FlutterFragment) : FlutterPlugin {
            val instance = FlutterPlugin(flutterFragment)
            val binaryMessenger = flutterFragment.flutterEngine?.dartExecutor
            binaryMessenger?.let {
                val messageChannel = BasicMessageChannel(it,
                        MESSAGE_CHANNEL_NAME,
                        StandardMessageCodec.INSTANCE)
                val methodChannel = MethodChannel(it, METHOD_CHANNEL_NAME)
                val streamChannel = EventChannel(it, STREAM_CHANNEL_NAME)
                methodChannel.setMethodCallHandler(instance)
                messageChannel.setMessageHandler(instance)
                streamChannel.setStreamHandler(instance)
            }

            return instance
        }
    }

    override fun onMessage(message: Any?, reply: BasicMessageChannel.Reply<Any>) {
        Toast.makeText(flutterFragment.context, message.toString(),
                Toast.LENGTH_LONG).show()
        reply.reply("\"Hello Flutter\" --- an message from Android")
    }

    /**
     * methodChannel 回调方法
     */
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "finish" -> {
                val activity = flutterFragment.context as Activity
                val info = call.arguments.toString()
                val intent = Intent().apply {
                    putExtra("info", info)
                }

                activity.setResult(Activity.RESULT_OK, intent)
                activity.finish()

                result.success(true)
            }

            "finishProgress" -> {
                val activity = flutterFragment.context as MainActivity
                activity.finishFlutter();
                result.success(true)
            }

            else -> result.notImplemented()
        }
    }

    /**
     * streamChannel 回调方法
     */
    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        mStateChangeReceiver = createEventListener(events)
        flutterFragment.context.registerReceiver(mStateChangeReceiver,
                IntentFilter(STATE_CHANGE_ACTION))
    }

    private fun createEventListener(sink: EventChannel.EventSink?) :
            BroadcastReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent?) {
            if (TextUtils.equals(intent?.action, STATE_CHANGE_ACTION)) {
                sink?.success(intent?.getIntExtra(STATE_VALUE, -1))
            }
        }
    }

    override fun onCancel(arguments: Any?) {
        unregisterListener()
    }

    fun unregisterListener() {
        if (mStateChangeReceiver != null) {
            flutterFragment.context.unregisterReceiver(mStateChangeReceiver)
            mStateChangeReceiver = null
        }
    }
}