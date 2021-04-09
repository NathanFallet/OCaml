/*
*  Copyright (C) 2021 Groupe MINASTE
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

import UIKit
import WebKit

class ConsoleViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {
    
    // Views
    let output = WKWebView()
    let loading = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Navigation bar
        title = "console".localized()
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "arrow.clockwise"), style: .plain, target: self, action: #selector(reloadConsole(_:)))
        ]
        
        // Setup view
        view.backgroundColor = .systemBackground
        view.addSubview(output)
        output.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        output.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        output.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        output.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor).isActive = true
        output.translatesAutoresizingMaskIntoConstraints = false
        
        // Add loading indicator
        view.addSubview(loading)
        loading.translatesAutoresizingMaskIntoConstraints = false
        loading.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor).isActive = true
        loading.centerYAnchor.constraint(equalTo: view.layoutMarginsGuide.centerYAnchor).isActive = true
        loading.hidesWhenStopped = true
        loading.startAnimating()
        
        // Configure it
        output.isHidden = true
        output.scrollView.isScrollEnabled = false
        output.navigationDelegate = self
        if let url = Bundle.main.url(forResource: "index", withExtension: "html") {
            output.loadFileURL(url, allowingReadAccessTo: url)
        } else {
            output.loadHTMLString("console_failed".localized(), baseURL: nil)
        }
        
        // Handle text input
        output.uiDelegate = self
    }
    
    func execute(_ source: String, completionHandler: @escaping () -> ()) {
        // Start loading
        self.loading.startAnimating()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            // Create JS script to execute in console
            // Put current script into console and press enter to execute
            let js = """
            var t = document.getElementById("userinput");
            t.value = `\(source.escapeCode())`;
            t.onkeydown({"keyCode": 13, "preventDefault": function (){}});
            """
            
            // Put source in top level
            self.output.evaluateJavaScript(js) { _, _ in
                // Present output
                DispatchQueue.main.async {
                    self.loading.stopAnimating()
                    completionHandler()
                }
            }
        }
    }
    
    @objc func reloadConsole(_ sender: Any?) {
        // Reload console
        output.reloadFromOrigin()
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        // Hide while it starts loading
        loading.startAnimating()
        output.isHidden = true
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // Show console and stop loading
        output.isHidden = false
        loading.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        // Show a UIAlert controller
        let alert = UIAlertController(title: prompt, message: nil, preferredStyle: .alert)
        alert.addTextField { _ in }
        alert.addAction(UIAlertAction(title: "button_ok".localized(), style: .default, handler: { _ in
            completionHandler(alert.textFields?.first?.text)
        }))
        alert.addAction(UIAlertAction(title: "button_cancel".localized(), style: .cancel, handler: { _ in
            completionHandler(nil)
        }))
        present(alert, animated: true, completion: nil)
    }

}
