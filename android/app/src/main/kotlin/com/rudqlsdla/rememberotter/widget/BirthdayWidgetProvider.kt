package com.rudqlsdla.rememberotter.widget

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.view.View
import android.widget.RemoteViews
import com.rudqlsdla.rememberotter.MainActivity
import com.rudqlsdla.rememberotter.R
import org.json.JSONArray

class BirthdayWidgetProvider : AppWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            updateWidget(context, appWidgetManager, appWidgetId)
        }
    }

    override fun onAppWidgetOptionsChanged(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetId: Int,
        newOptions: Bundle
    ) {
        updateWidget(context, appWidgetManager, appWidgetId)
    }

    private fun updateWidget(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetId: Int
    ) {
        val birthdays = loadBirthdays(context)
        val options = appWidgetManager.getAppWidgetOptions(appWidgetId)
        val minWidth = options.getInt(AppWidgetManager.OPTION_APPWIDGET_MIN_WIDTH, 110)
        val minHeight = options.getInt(AppWidgetManager.OPTION_APPWIDGET_MIN_HEIGHT, 110)

        val views = when {
            birthdays.isEmpty() -> buildEmptyView(context)
            minHeight < 60 && minWidth >= 200 -> buildInlineWideView(context, birthdays)
            minHeight < 60 -> buildInlineView(context, birthdays)
            minWidth >= 200 -> buildMediumView(context, birthdays)
            else -> buildSmallView(context, birthdays)
        }

        // 위젯 탭 시 앱 실행
        val intent = Intent(context, MainActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
        }
        val pendingIntent = PendingIntent.getActivity(
            context, appWidgetId, intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        views.setOnClickPendingIntent(R.id.widget_root, pendingIntent)

        appWidgetManager.updateAppWidget(appWidgetId, views)
    }

    private fun loadBirthdays(context: Context): List<BirthdayData> {
        val prefs = context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)
        val jsonString = prefs.getString("upcoming_birthdays", null) ?: return emptyList()

        return try {
            val jsonArray = JSONArray(jsonString)
            val list = mutableListOf<BirthdayData>()
            for (i in 0 until jsonArray.length()) {
                val obj = jsonArray.getJSONObject(i)
                list.add(
                    BirthdayData(
                        name = obj.getString("name"),
                        daysUntil = obj.getInt("daysUntil"),
                        month = obj.getInt("month"),
                        day = obj.getInt("day"),
                        ageText = obj.optString("ageText", "")
                    )
                )
            }
            list
        } catch (e: Exception) {
            emptyList()
        }
    }

    // ───── Empty View ─────

    private fun buildEmptyView(context: Context): RemoteViews {
        return RemoteViews(context.packageName, R.layout.birthday_widget_empty)
    }

    // ───── Inline (1x2) ─────

    private fun buildInlineView(context: Context, birthdays: List<BirthdayData>): RemoteViews {
        val views = RemoteViews(context.packageName, R.layout.birthday_widget_inline)
        val b = birthdays.first()

        views.setTextViewText(R.id.inline_name, b.name)
        views.setTextViewText(R.id.inline_dday, b.ddayText)
        views.setInt(
            R.id.inline_dday, "setBackgroundResource",
            if (b.daysUntil <= 1) R.drawable.badge_accent else R.drawable.badge_primary
        )

        return views
    }

    // ───── Inline Wide (1x4) ─────

    private fun buildInlineWideView(context: Context, birthdays: List<BirthdayData>): RemoteViews {
        val views = RemoteViews(context.packageName, R.layout.birthday_widget_inline_wide)
        val b1 = birthdays.first()

        views.setTextViewText(R.id.inline_wide_name1, b1.name)
        views.setTextViewText(R.id.inline_wide_dday1, b1.ddayText)
        views.setInt(
            R.id.inline_wide_dday1, "setBackgroundResource",
            if (b1.daysUntil <= 1) R.drawable.badge_accent else R.drawable.badge_primary
        )

        if (birthdays.size >= 2) {
            val b2 = birthdays[1]
            views.setViewVisibility(R.id.inline_wide_divider, View.VISIBLE)
            views.setViewVisibility(R.id.inline_wide_item2, View.VISIBLE)
            views.setTextViewText(R.id.inline_wide_name2, b2.name)
            views.setTextViewText(R.id.inline_wide_dday2, b2.ddayText)
            views.setInt(
                R.id.inline_wide_dday2, "setBackgroundResource",
                if (b2.daysUntil <= 1) R.drawable.badge_accent else R.drawable.badge_primary
            )
        }

        return views
    }

    // ───── Small (2x2) ─────

    private fun buildSmallView(context: Context, birthdays: List<BirthdayData>): RemoteViews {
        val views = RemoteViews(context.packageName, R.layout.birthday_widget_small)
        val b = birthdays.first()

        views.setTextViewText(R.id.birthday_name, b.name)
        views.setTextViewText(R.id.birthday_date, "${b.month}월 ${b.day}일")
        views.setTextViewText(R.id.dday_badge, b.ddayText)
        views.setInt(
            R.id.dday_badge, "setBackgroundResource",
            if (b.daysUntil <= 1) R.drawable.badge_accent else R.drawable.badge_primary
        )

        if (b.ageText.isNotEmpty()) {
            views.setTextViewText(R.id.birthday_age, b.ageText)
            views.setViewVisibility(R.id.birthday_age, View.VISIBLE)
        } else {
            views.setViewVisibility(R.id.birthday_age, View.GONE)
        }

        return views
    }

    // ───── Medium (4x2) ─────

    private fun buildMediumView(context: Context, birthdays: List<BirthdayData>): RemoteViews {
        val views = RemoteViews(context.packageName, R.layout.birthday_widget_medium)

        data class RowIds(
            val row: Int, val name: Int, val date: Int,
            val age: Int, val dday: Int, val divider: Int?
        )

        val rows = listOf(
            RowIds(R.id.row1, R.id.row1_name, R.id.row1_date, R.id.row1_age, R.id.row1_dday, null),
            RowIds(R.id.row2, R.id.row2_name, R.id.row2_date, R.id.row2_age, R.id.row2_dday, R.id.divider1),
            RowIds(R.id.row3, R.id.row3_name, R.id.row3_date, R.id.row3_age, R.id.row3_dday, R.id.divider2),
        )

        for (i in birthdays.indices.take(3)) {
            val b = birthdays[i]
            val r = rows[i]

            views.setViewVisibility(r.row, View.VISIBLE)
            views.setTextViewText(r.name, b.name)
            views.setTextViewText(r.date, "${b.month}월 ${b.day}일")
            views.setTextViewText(r.dday, b.ddayText)
            views.setInt(
                r.dday, "setBackgroundResource",
                if (b.daysUntil <= 1) R.drawable.badge_accent else R.drawable.badge_primary
            )

            if (b.ageText.isNotEmpty()) {
                views.setTextViewText(r.age, b.ageText)
                views.setViewVisibility(r.age, View.VISIBLE)
            } else {
                views.setViewVisibility(r.age, View.GONE)
            }

            r.divider?.let { views.setViewVisibility(it, View.VISIBLE) }
        }

        return views
    }

    data class BirthdayData(
        val name: String,
        val daysUntil: Int,
        val month: Int,
        val day: Int,
        val ageText: String
    ) {
        val ddayText: String
            get() = if (daysUntil == 0) "D-Day" else "D-$daysUntil"
    }
}
