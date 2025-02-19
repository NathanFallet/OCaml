/*
*  Copyright (C) 2023 Nathan Fallet
*
* This program is free software; you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation; either version 2 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License along
* with this program; if not, write to the Free Software Foundation, Inc.,
* 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
*
*/

import SwiftUI
import DigiAnalytics

struct SettingsView: View {

    @Environment(\.openURL) var openURL
    @Environment(\.backgroundColor) var backgroundColor
    @Environment(\.plainColor) var plainColor
    @Environment(\.numberColor) var numberColor
    @Environment(\.stringColor) var stringColor
    @Environment(\.identifierColor) var identifierColor
    @Environment(\.keywordColor) var keywordColor
    @Environment(\.commentColor) var commentColor

    #if os(iOS)
    var body: some View {
        List {
            Section(header: Text("editor_settings")) {
                EditorColorView(name: "backgroundColor", color: backgroundColor)
                EditorColorView(name: "plainColor", color: plainColor)
                EditorColorView(name: "numberColor", color: numberColor)
                EditorColorView(name: "stringColor", color: stringColor)
                EditorColorView(name: "identifierColor", color: identifierColor)
                EditorColorView(name: "keywordColor", color: keywordColor)
                EditorColorView(name: "commentColor", color: commentColor)
                Button("button_reset") {
                    backgroundColor.wrappedValue = -1
                    plainColor.wrappedValue = -1
                    numberColor.wrappedValue = -1
                    stringColor.wrappedValue = -1
                    identifierColor.wrappedValue = -1
                    keywordColor.wrappedValue = -1
                    commentColor.wrappedValue = -1
                }
            }

            Section(header: Text("about")) {
                Text("developer_text")
                    .onTapGesture {
                        if let url = URL(string: "https://www.nathanfallet.me/") {
                            openURL(url)
                        }
                    }
                Button("documentation") {
                    if let url = URL(string: "https://ocaml.nathanfallet.me/learn") {
                        DigiAnalytics.shared.send(path: "learn")
                        openURL(url)
                    }
                }
                Button("App Store") {
                    if let url = URL(string: "https://apps.apple.com/app/ocaml-learn-code/id1547506826") {
                        openURL(url)
                    }
                }
                Button("TestFlight") {
                    if let url = URL(string: "https://testflight.apple.com/join/xDGBk6wD") {
                        openURL(url)
                    }
                }
                NavigationLink(destination: OpenSourceView()) {
                    Text("opensource")
                }
                NavigationLink(destination: DonateView()) {
                    Text("donate_title")
                }
            }
        }
        .navigationTitle("settings")
        .listStyleInsetGroupedIfAvailable()
        .onAppear {
            DigiAnalytics.shared.send(path: "settings")
        }
    }
    #endif

    #if os(macOS)
    var body: some View {
        TabView {
            Form {
                EditorColorView(name: "backgroundColor", color: backgroundColor)
                EditorColorView(name: "plainColor", color: plainColor)
                EditorColorView(name: "numberColor", color: numberColor)
                EditorColorView(name: "stringColor", color: stringColor)
                EditorColorView(name: "identifierColor", color: identifierColor)
                EditorColorView(name: "keywordColor", color: keywordColor)
                EditorColorView(name: "commentColor", color: commentColor)
                Button("button_reset") {
                    backgroundColor.wrappedValue = -1
                    plainColor.wrappedValue = -1
                    numberColor.wrappedValue = -1
                    stringColor.wrappedValue = -1
                    identifierColor.wrappedValue = -1
                    keywordColor.wrappedValue = -1
                    commentColor.wrappedValue = -1
                }
            }
            .tabItem {
                Label("editor_settings", systemImage: "pencil.circle")
            }

            Form {
                Text("developer_text")
                    .onTapGesture {
                        if let url = URL(string: "https://www.nathanfallet.me/") {
                            openURL(url)
                        }
                    }
            }
            .tabItem {
                Label("about", systemImage: "info.circle")
            }

            OpenSourceView()
            .tabItem {
                Label("opensource", systemImage: "chevron.left.slash.chevron.right")
            }

            DonateView()
            .tabItem {
                Label("donate_title", systemImage: "giftcard")
            }
        }
        .padding()
        .frame(minWidth: 512)
        .onAppear {
            DigiAnalytics.shared.send(path: "settings")
        }
    }
    #endif
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
