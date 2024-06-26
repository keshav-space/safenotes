/*
 * Copyright (C) Keshav Priyadarshi and others - All Rights Reserved.
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 * You may use, distribute and modify this code under the
 * terms of the GPL-3.0+ license.
 *
 * You should have received a copy of the GNU General Public License v3.0 with
 * this file. If not, please visit https://www.gnu.org/licenses/gpl-3.0.html
 *
 * See https://safenotes.dev for support or download.
 */

package com.trisven.safenotes

import android.content.SharedPreferences
import android.os.Build
import android.os.Bundle
import android.view.WindowManager
import io.flutter.embedding.android.FlutterFragmentActivity

class MainActivity : FlutterFragmentActivity() {

    private val PREFS_NAME = "FlutterSharedPreferences"
    private val SECURE_FLAG_KEY = "flutter.isFlagSecure"

    private val prefsListener =
        SharedPreferences.OnSharedPreferenceChangeListener { sharedPreferences, key ->
            if (key == SECURE_FLAG_KEY) {
                updateSecureDisplaySetting()
            }
        }

    override fun onCreate(savedInstanceState: Bundle?) {
        // Initial secure display setting
        updateSecureDisplaySetting()

        // Listen for changes in the secure display setting
        val prefs = getSharedPreferences(PREFS_NAME, MODE_PRIVATE)
        prefs.registerOnSharedPreferenceChangeListener(prefsListener)
        super.onCreate(savedInstanceState)
    }

    override fun onDestroy() {
        val prefs = getSharedPreferences(PREFS_NAME, MODE_PRIVATE)
        prefs.unregisterOnSharedPreferenceChangeListener(prefsListener)
        super.onDestroy()
    }

    private fun updateSecureDisplaySetting() {
        val prefs = getSharedPreferences(PREFS_NAME, MODE_PRIVATE)
        val isSecure = prefs.getBoolean(SECURE_FLAG_KEY, true)

        if (isSecure) {
            window.setFlags(
                WindowManager.LayoutParams.FLAG_SECURE,
                WindowManager.LayoutParams.FLAG_SECURE
            )
            
        } else {
            window.clearFlags(WindowManager.LayoutParams.FLAG_SECURE)
        }


        // Disable screenshots in recents screen if API level is 33 or higher
        // https://developer.android.com/reference/android/app/Activity#setRecentsScreenshotEnabled(boolean)
        
        // Note: App screenshots will never appear in recent screens even if secure display is turned off 
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            setRecentsScreenshotEnabled(false)
        }
    }
}
