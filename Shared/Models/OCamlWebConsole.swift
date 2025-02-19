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

import Foundation
@preconcurrency import WebKit
import Combine
import DigiAnalytics

class OCamlWebConsole: NSObject, OCamlConsole, WKNavigationDelegate, WKUIDelegate {

    // The environment to execute OCaml code
    private lazy var webView: WKWebView = {
        let webView = WKWebView()

        webView.isHidden = true
        #if !os(macOS)
        webView.scrollView.isScrollEnabled = false
        #endif
        webView.navigationDelegate = self
        webView.uiDelegate = self

        if let url = Bundle.main.url(forResource: "index", withExtension: "html") {
            webView.loadFileURL(url, allowingReadAccessTo: url)
        } else {
            webView.loadHTMLString("console_failed".localized(), baseURL: nil)
        }

        return webView
    }()

    // Content of the console
    var output: [ConsoleEntry]?

    // Any prompt
    var prompt: String?
    var promptCompletionHandler: ((String?) -> Void)?

    // Delegate
    weak var delegate: OCamlConsoleDelegate?

    // Load the console
    func loadConsoleIfNeeded() {
        _ = webView
    }

    // Refresh the output
    func refreshOutput() {
        webView.evaluateJavaScript("document.getElementById('output').innerHTML") { data, _ in
            self.output = (data as? String)?.trimEndlines().splitInSpans()
            self.delegate?.didFinishLoading()
            self.delegate?.didExecute()
        }
    }

    // Execute code
    func execute(_ source: String) {
        // Create JS script to execute in console
        // Put current script into console and press enter to execute
        let js = """
        var t = document.getElementById("userinput");
        t.value = `\(source.escapeCode())`;
        t.onkeydown({"keyCode": 13, "preventDefault": function (){}});
        """

        // Put source in top level
        self.webView.evaluateJavaScript(js) { _, _ in
            // Present output
            self.refreshOutput()
        }
    }

    // Reload console
    func reloadConsole() {
        // Reload console
        webView.reloadFromOrigin()
    }

    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        // Hide while it starts loading
        delegate?.didStartLoading()
        webView.isHidden = true
    }

    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // Show console and stop loading
        webView.isHidden = false
        refreshOutput()
    }

    public func webView(
        _ webView: WKWebView,
        runJavaScriptTextInputPanelWithPrompt prompt: String,
        defaultText: String?,
        initiatedByFrame frame: WKFrameInfo,
        completionHandler: @escaping (String?) -> Void
    ) {
        // Update prompt
        self.prompt = prompt
        self.promptCompletionHandler = completionHandler
    }

}
