package me.nathanfallet.ocaml.extensions

import me.nathanfallet.digianalytics.DigiAnalytics

class DigiAnalyticsExtension {

    companion object {

        val shared = DigiAnalytics("https://app.ocaml.nathanfallet.me/")

    }

}