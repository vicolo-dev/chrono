package com.vicolo.chrono

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.graphics.Color
import android.net.Uri
import android.util.Log
import android.util.TypedValue
import android.view.View
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider

class DigitalClockWidgetProvider : HomeWidgetProvider() {
    fun spToPx(
        sp: Float,
        context: Context,
    ): Int {
        return TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_SP, sp, context.resources.displayMetrics).toInt()
    }

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences,
    ) { // Perform this loop procedure for each widget that belongs to this
        // provider.
        Log.d("TAG", "Updating Digital Clock Widget")

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
                    val dateSize = widgetData.getInt("dateSize", 15)
                    val timeSize = widgetData.getInt("timeSize", 70)
                    val timeColor = widgetData.getString("timeColor", "#FFFFFF")
                    val dateColor = widgetData.getString("dateColor", "#FFFFFF")
                    val horizontalAlignment = widgetData.getInt("horizontalAlignment", 11)
                    val verticalAlignment = widgetData.getInt("verticalAlignment", 10)
                    val timeFontWeight = widgetData.getInt("timeFontWeight", 500)
                    val dateFontWeight = widgetData.getInt("dateFontWeight", 500)
                    // val shadowColor = widgetData.getString("shadowColor", "#000000")
                    // val shadowElevation = widgetData.getFloat("shadowElevation", 1.0f)
                    // val shadowBlur = widgetData.getFloat("shadowBlur", 1.0f)
                    val showDate = widgetData.getBoolean("showDate", true)
                    //
                    val timeFontWeightMap =
                        mapOf(
                            100 to R.id.widget_clock_100,
                            200 to R.id.widget_clock_200,
                            300 to R.id.widget_clock_300,
                            400 to R.id.widget_clock_400,
                            500 to R.id.widget_clock_500,
                            600 to R.id.widget_clock_600,
                            700 to R.id.widget_clock_700,
                            800 to R.id.widget_clock_800,
                            900 to R.id.widget_clock_900,
                        )

                    timeFontWeightMap.forEach { it ->
                        if (it.key != timeFontWeight) {
                            setViewVisibility(it.value, View.GONE)
                        } else {
                            setViewVisibility(it.value, View.VISIBLE)
                        }
                    }

                    val dateFontWeightMap =
                        mapOf(
                            100 to R.id.widget_date_100,
                            200 to R.id.widget_date_200,
                            300 to R.id.widget_date_300,
                            400 to R.id.widget_date_400,
                            500 to R.id.widget_date_500,
                            600 to R.id.widget_date_600,
                            700 to R.id.widget_date_700,
                            800 to R.id.widget_date_800,
                            900 to R.id.widget_date_900,
                        )

                    dateFontWeightMap.forEach { it ->
                        if (it.key != dateFontWeight) {
                            setViewVisibility(it.value, View.GONE)
                        } else {
                            setViewVisibility(it.value, View.VISIBLE)
                        }
                    }
                    val textClock = timeFontWeightMap[timeFontWeight] ?: R.id.widget_clock_500
                    val textDate = dateFontWeightMap[dateFontWeight] ?: R.id.widget_date_500
                    //
                    setCharSequence(textClock, "setFormat24Hour", timeFormat)
                    setCharSequence(textClock, "setFormat12Hour", timeFormat)
                    setCharSequence(textDate, "setFormat24Hour", "EEE, d MMM")
                    setCharSequence(textDate, "setFormat12Hour", "EEE, d MMM")
                    if (horizontalAlignment == 7) {
                        setInt(textClock, "setGravity", 1)
                        setInt(textDate, "setGravity", 1)
                        setInt(textClock, "setJustificationMode", 2)
                        setInt(textDate, "setJustificationMode", 2)
                    } else {
                        setInt(textClock, "setGravity", horizontalAlignment)
                        setInt(textDate, "setGravity", horizontalAlignment)
                    }
                    // setInt(R.id.digital_clock_holder, "setVerticalGravity", 10)

                    setInt(textClock, "setTextColor", Color.parseColor(timeColor))
                    setInt(textDate, "setTextColor", Color.parseColor(dateColor))
                    setInt(textClock, "setMaxHeight", spToPx(timeSize.toFloat(), context))
                    setInt(textDate, "setMaxHeight", spToPx(dateSize.toFloat(), context))
                    setInt(textDate, "setHeight", spToPx(dateSize.toFloat(), context))
                    setInt(textClock, "setHeight", spToPx(timeSize.toFloat(), context))
                    if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.S) {
                        // setViewLayoutHeight(textClock, timeSize.toFloat(), TypedValue.COMPLEX_UNIT_SP)
                        // setViewLayoutHeight(textDate, dateSize.toFloat(), TypedValue.COMPLEX_UNIT_SP)
                    }
                    setViewVisibility(textDate, if (showDate) View.VISIBLE else View.GONE)
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
                    val pendingIntentWithData =
                        HomeWidgetLaunchIntent.getActivity(
                            context,
                            MainActivity::class.java,
                            Uri.parse("chrono://digitalClockClicked"),
                        )
                    setOnClickPendingIntent(textClock, pendingIntentWithData)
                    setOnClickPendingIntent(textDate, pendingIntentWithData)
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
