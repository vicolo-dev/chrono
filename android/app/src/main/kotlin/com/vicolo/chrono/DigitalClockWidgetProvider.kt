package com.vicolo.chrono

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.drawable.GradientDrawable
import android.net.Uri
import android.os.Build
import android.util.Log
import android.util.TypedValue
import android.view.View
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider

fun gradientDrawableToBitmap(drawable: GradientDrawable, width: Int, height: Int): Bitmap {
    // Tell the drawable its intrinsic size
    drawable.setSize(width, height)

    // Now create the bitmap
    val bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888)
    val canvas = Canvas(bitmap)

    // Optional: set the drawable bounds to match
    drawable.setBounds(0, 0, width, height)
    drawable.draw(canvas)

    return bitmap
}

class DigitalClockWidgetProvider : HomeWidgetProvider() {
    fun spToPx(
            sp: Float,
            context: Context,
    ): Int {
        return TypedValue.applyDimension(
                        TypedValue.COMPLEX_UNIT_SP,
                        sp,
                        context.resources.displayMetrics
                )
                .toInt()
    }

    private fun getDrawableWithRadius(color: Int, cornerRadius: Float): GradientDrawable {
        return GradientDrawable().apply {
            // Apply the same radius to all four corners
            cornerRadii =
                    floatArrayOf(
                            cornerRadius,
                            cornerRadius,
                            cornerRadius,
                            cornerRadius,
                            cornerRadius,
                            cornerRadius,
                            cornerRadius,
                            cornerRadius
                    )
            setColor(color)
        }
    }

    override fun onUpdate(
            context: Context,
            appWidgetManager: AppWidgetManager,
            appWidgetIds: IntArray,
            widgetData: SharedPreferences,
    ) { // Perform this loop procedure for each widget that belongs to this
        // provider.
        Log.d("CHRONO", "Updating Digital Clock Widget")

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
                                        PendingIntent.FLAG_UPDATE_CURRENT or
                                                PendingIntent.FLAG_IMMUTABLE,
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
                        val backgroundColor = widgetData.getString("backgroundColor", "#000000")
                        val borderRadius = widgetData.getInt("backgroundBorderRadius", 0)
                        val backgroundAlpha = widgetData.getInt("backgroundOpacity", 0) * 255 / 100
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
                        setCharSequence(textDate, "setFormat24Hour", dateFormat)
                        setCharSequence(textDate, "setFormat12Hour", dateFormat)

                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                            if (horizontalAlignment == 7) {
                                setInt(textClock, "setGravity", 1)
                                setInt(textDate, "setGravity", 1)
                                setInt(textClock, "setJustificationMode", 2)
                                setInt(textDate, "setJustificationMode", 2)
                            } else {
                                setInt(textClock, "setGravity", horizontalAlignment)
                                setInt(textDate, "setGravity", horizontalAlignment)
                            }
                        }

                        val drawableMap =
                                mapOf(
                                        0 to R.drawable.rounded_background_0,
                                        4 to R.drawable.rounded_background_4,
                                        8 to R.drawable.rounded_background_8,
                                        12 to R.drawable.rounded_background_12,
                                        16 to R.drawable.rounded_background_16,
                                        20 to R.drawable.rounded_background_20,
                                        24 to R.drawable.rounded_background_24,
                                        28 to R.drawable.rounded_background_28,
                                        32 to R.drawable.rounded_background_32,
                                        36 to R.drawable.rounded_background_36,
                                        40 to R.drawable.rounded_background_40,
                                        44 to R.drawable.rounded_background_44,
                                        48 to R.drawable.rounded_background_48,
                                        52 to R.drawable.rounded_background_52,
                                        56 to R.drawable.rounded_background_56,
                                        60 to R.drawable.rounded_background_60,
                                        64 to R.drawable.rounded_background_64,
                                )

                        val drawable = drawableMap[borderRadius] ?: R.drawable.rounded_background_0

                        setInt(R.id.background_imageview, "setImageResource", drawable)
                        setInt(
                                R.id.background_imageview,
                                "setColorFilter",
                                Color.parseColor(backgroundColor)
                        )
                        setInt(R.id.background_imageview, "setImageAlpha", backgroundAlpha)

                        setInt(textClock, "setTextColor", Color.parseColor(timeColor))
                        setInt(textDate, "setTextColor", Color.parseColor(dateColor))

                        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
                            setInt(textClock, "setMaxHeight", spToPx(timeSize.toFloat(), context))
                            setInt(textDate, "setMaxHeight", spToPx(dateSize.toFloat(), context))
                            setInt(textDate, "setHeight", spToPx(dateSize.toFloat(), context))
                            setInt(textClock, "setHeight", spToPx(timeSize.toFloat(), context))
                            // setViewLayoutHeight(textClock, timeSize.toFloat(),
                            // TypedValue.COMPLEX_UNIT_SP)
                            // setViewLayoutHeight(textDate, dateSize.toFloat(),
                            // TypedValue.COMPLEX_UNIT_SP)
                        }
                        setViewVisibility(textDate, if (showDate) View.VISIBLE else View.GONE)

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

            // Tell the AppWidgetManager to perform an update on the current
            // widget.
            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}
