package com.vicolo.chrono

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.util.Log
import android.widget.RemoteViews
import android.graphics.Color
import es.antonborri.home_widget.HomeWidgetProvider
import android.view.ViewGroup.LayoutParams
import android.view.View
import android.util.TypedValue

class DigitalClockWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences,
    ) { // Perform this loop procedure for each widget that belongs to this
        // provider.
        Log.d("TAG", "Updating Digital Clock Widget");

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
                    val dateSize = widgetData.getInt("dateSize", 25)
                    val timeSize = widgetData.getInt("timeSize", 100)
                    val textColor = widgetData.getString("textColor", "#FFFFFF")
                    // val shadowColor = widgetData.getString("shadowColor", "#000000")
                    // val shadowElevation = widgetData.getFloat("shadowElevation", 1.0f)
                    // val shadowBlur = widgetData.getFloat("shadowBlur", 1.0f)
                    val showDate = widgetData.getBoolean("showDate", true)

                    setCharSequence(R.id.widget_text_clock, "setFormat24Hour", timeFormat)
                    setCharSequence(R.id.widget_text_clock, "setFormat12Hour", timeFormat)
                    setCharSequence(R.id.widget_date, "setFormat24Hour", "EEE, d MMM")
                    setCharSequence(R.id.widget_date, "setFormat12Hour", "EEE, d MMM")
                    setColorInt(R.id.widget_text_clock, "setTextColor", Color.parseColor(textColor), Color.parseColor(textColor))
                    setColorInt(R.id.widget_date, "setTextColor", Color.parseColor(textColor), Color.parseColor(textColor))
                    // setFloat(R.id.widget_text_clock, "setTextSize", timeSize.toFloat())
                    // setFloat(R.id.widget_date, "setTextSize", dateSize.toFloat())
                    setViewLayoutHeight(R.id.widget_text_clock, timeSize.toFloat(), TypedValue.COMPLEX_UNIT_SP)
                    setViewLayoutHeight(R.id.widget_date, dateSize.toFloat(), TypedValue.COMPLEX_UNIT_SP)
                    setViewVisibility(R.id.widget_date, if(showDate) View.VISIBLE else View.GONE)
                    //
                    // R.layout.digital_clock_widget.findViewById(R.id.widget_text_clock).apply {
                    //     val param =
                    //         LinearLayout.LayoutParams(
                    //             LayoutParams.MATCH_PARENT,
                    //             LayoutParams.MATCH_PARENT,
                    //             timeSize,
                    //         )
                    //     setLayoutParams(param)
                    //     setShadowLayer(shadowBlur, 0f, shadowElevation, shadowColor)
                    // }
                    //
                    // R.layout.digital_clock_widget.findViewById(R.id.widget_date).apply {
                    //     val param =
                    //         LinearLayout.LayoutParams(
                    //             LayoutParams.MATCH_PARENT,
                    //             LayoutParams.MATCH_PARENT,
                    //             dateSize,
                    //         )
                    //     setLayoutParams(param)
                    //     setTextColor(textColor)
                    //     setShadowLayer(shadowBlur, 0f, shadowElevation, shadowColor)
                    // }

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
