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

struct OpenSourceRepositoryView: View {
    @Environment(\.openURL) var openURL
    @State var user: String
    @State var repo: String

    var body: some View {
        HStack(spacing: 12) {
            if let url = URL(string: "https://github.com/\(user).png") {
                AsyncImage(
                    url: url,
                    content: { image in
                        image
                            .resizable()
                    },
                    placeholder: {
                        Image("Avatar").resizable()
                    }
                )
                .frame(width: 44, height: 44)
                .cornerRadius(8)
                .padding(.vertical, 8)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text("\(user)/\(repo)")
                Text("opensource_repo_\(repo)".localized())
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .onTapGesture {
            if let url = URL(string: "https://github.com/\(user)/\(repo)") {
                openURL(url)
            }
        }
    }
}

struct OpenSourceRepositoryView_Previews: PreviewProvider {
    static var previews: some View {
        OpenSourceRepositoryView(user: "NathanFallet", repo: "OCaml")
    }
}
