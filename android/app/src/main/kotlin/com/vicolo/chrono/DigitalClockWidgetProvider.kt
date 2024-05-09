package com.vicolo.chrono

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import android.content.SharedPreferences
import es.antonborri.home_widget.HomeWidgetBackgroundIntent
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider
import es.antonborri.home_widget.HomeWidgetPlugin
import android.util.Log

class DigitalClockWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences,
    ) { // Perform this loop procedure for each widget that belongs to this
        // provider.
        Log.d("TAG", "======================================YOO")

        appWidgetIds.forEach { appWidgetId ->
            // Create an Intent to launch ExampleActivity.
            // Open App on Widget Click
            val views =
                RemoteViews(context.packageName, R.layout.digital_clock_widget).apply {
                    // Open App on Widget Click
                    val pendingIntent: PendingIntent =
                        PendingIntent.getActivity(
                            // context =
                            context,
                            // requestCode =
                            0,
                            // intent =
                            Intent(context, MainActivity::class.java),
                            // flags =
                            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
                        )
                    val dateFormat = widgetData.getString("dateFormat", "EEE, d MMM")
                    val timeFormat = widgetData.getString("timeFormat", "HH:mm")
                    setCharSequence (R.id.widget_text_clock, "setFormat24Hour", timeFormat)
                    setCharSequence (R.id.widget_text_clock, "setFormat12Hour", timeFormat)
                    setCharSequence (R.id.widget_date, "setFormat24Hour", dateFormat)
                    setCharSequence (R.id.widget_date, "setFormat12Hour", dateFormat)
                    // Swap Title Text by calling Dart Code in the Background
                    // setTextViewText(R.id.widget_title, widgetData.getString("title", null)
                    //         ?: "No Title Set")
                    // val backgroundIntent = HomeWidgetBackgroundIntent.getBroadcast(
                    //         context,
                    //         Uri.parse("homeWidgetExample://titleClicked")
                    // )
                    // setOnClickPendingIntent(R.id.widget_title, backgroundIntent)
                    //
                    // val message = widgetData.getString("message", null)
                    // setTextViewText(R.id.widget_message, message
                    //         ?: "No Message Set")
                    // // Show Images saved with `renderFlutterWidget`
                    // val image = widgetData.getString("dashIcon", null)
                    // if (image != null) {
                    //  setImageViewBitmap(R.id.widget_img, BitmapFactory.decodeFile(image))
                    //  setViewVisibility(R.id.widget_img, View.VISIBLE)
                    // } else {
                    //     setViewVisibility(R.id.widget_img, View.GONE)
                    // }
                    //
                    // // Detect App opened via Click inside Flutter
                    // val pendingIntentWithData = HomeWidgetLaunchIntent.getActivity(
                    //         context,
                    //         MainActivity::class.java,
                    //         Uri.parse("homeWidgetExample://message?message=$message"))
                    // setOnClickPendingIntent(R.id.widget_message, pendingIntentWithData)
                }
            // Get the layout for the widget and attach an onClick listener to
            // the button.
            // val views: RemoteViews = RemoteViews(
            //         context.packageName,
            //         R.layout.appwidget_provider_layout
            // ).apply {
            //     setOnClickPendingIntent(R.id.button, pendingIntent)
            // }

            // Tell the AppWidgetManager to perform an update on the current
            // widget.
            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}
