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

struct OpenSourceView: View {
    let data: [(String, [(String, String)])] = [
        ("", [
            ("nathanfallet", "ocaml")
        ]),
        ("opensource_swiftpackages", [
            ("twostraws", "Sourceful"),
            ("GroupeMINASTE", "DigiAnalytics")
        ]),
        ("opensource_others", [
            ("ocsigen", "js_of_ocaml")
        ])
    ]

    #if os(iOS)
    var body: some View {
        List {
            ForEach(data, id: \.0) { section in
                if section.0.isEmpty {
                    Section() {
                        ForEach(section.1, id: \.1) { repo in
                            OpenSourceRepositoryView(user: repo.0, repo: repo.1)
                        }
                    }
                } else {
                    Section(header: Text(section.0.localized())) {
                        ForEach(section.1, id: \.1) { repo in
                            OpenSourceRepositoryView(user: repo.0, repo: repo.1)
                        }
                    }
                }
            }
        }
        .navigationTitle("opensource")
        .listStyleInsetGroupedIfAvailable()
    }
    #endif

    #if os(macOS)
    var body: some View {
        Form {
            ForEach(data, id: \.0) { section in
                if !section.0.isEmpty {
                    Text(section.0.localized())
                        .padding(.top)
                }
                ForEach(section.1, id: \.1) { repo in
                    OpenSourceRepositoryView(user: repo.0, repo: repo.1)
                }
            }
        }
    }
    #endif
}

struct OpenSourceView_Previews: PreviewProvider {
    static var previews: some View {
        OpenSourceView()
    }
}
