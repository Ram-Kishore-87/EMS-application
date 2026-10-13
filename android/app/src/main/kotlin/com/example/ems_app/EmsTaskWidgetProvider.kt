package com.example.ems_app

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider
import org.json.JSONObject

class EmsTaskWidgetProvider : HomeWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.ems_widget_layout).apply {
                // Open app on click
                val pendingIntent = HomeWidgetLaunchIntent.getActivity(
                    context,
                    MainActivity::class.java
                )
                setOnClickPendingIntent(R.id.widget_container, pendingIntent)

                val rawJson = widgetData.getString("ems_weekly_widget_data", null)
                val weeklyProgressPct = widgetData.getInt("weeklyProgressPct", 0)

                setProgressBar(R.id.widget_progress_bar, 100, weeklyProgressPct, false)
                setTextViewText(R.id.widget_weekly_badge, "Week: $weeklyProgressPct%")

                if (rawJson != null) {
                    try {
                        val json = JSONObject(rawJson)
                        val todayDuties = json.optJSONArray("todayDuties")
                        val tomorrowDuties = json.optJSONArray("tomorrowDuties")
                        val upcomingDuties = json.optJSONArray("upcomingDuties")

                        // Format Today
                        if (todayDuties != null && todayDuties.length() > 0) {
                            val first = todayDuties.getJSONObject(0)
                            val title = first.optString("title", "Duty")
                            val emp = first.optString("employeeName", "")
                            val shift = first.optString("shiftLabel", "")
                            val time = first.optString("time", "")
                            val totalToday = todayDuties.length()
                            val suffix = if (totalToday > 1) " (+${totalToday - 1} more)" else ""
                            setTextViewText(
                                R.id.widget_today_content,
                                "[$time] $title\n$emp ($shift)$suffix"
                            )
                        } else {
                            setTextViewText(R.id.widget_today_content, "No duties scheduled today.")
                        }

                        // Format Tomorrow
                        if (tomorrowDuties != null && tomorrowDuties.length() > 0) {
                            val first = tomorrowDuties.getJSONObject(0)
                            val title = first.optString("title", "Duty")
                            val emp = first.optString("employeeName", "")
                            val shift = first.optString("shiftLabel", "")
                            val time = first.optString("time", "")
                            val totalTomorrow = tomorrowDuties.length()
                            val suffix = if (totalTomorrow > 1) " (+${totalTomorrow - 1} more)" else ""
                            setTextViewText(
                                R.id.widget_tomorrow_content,
                                "[$time] $title\n$emp ($shift)$suffix"
                            )
                        } else {
                            setTextViewText(R.id.widget_tomorrow_content, "No duties tomorrow.")
                        }

                        // Upcoming count
                        val upcomingCount = upcomingDuties?.length() ?: 0
                        setTextViewText(
                            R.id.widget_upcoming_content,
                            "Days 3-7: $upcomingCount scheduled duties"
                        )
                    } catch (e: Exception) {
                        setTextViewText(R.id.widget_today_content, "Unable to load duties.")
                    }
                } else {
                    setTextViewText(R.id.widget_today_content, "Tap to open EMS Scheduler.")
                }
            }

            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
