    //
    //  TermsCheckboxView.swift
    //  ProCare
    //
    //  Created by ahmed hussien on 12/07/2025.
    //


    import SwiftUI
    import WebKit
    import SafariServices

    // MARK: - Main View with Checkbox
    struct TermsCheckboxView: View {
        
        @Binding var isChecked: Bool
        @State private var showTerms = false
        
        var body: some View {
            HStack(alignment: .top, spacing: 5) {
                Button(action: {
                    isChecked.toggle()
                }) {
                    Image(systemName: isChecked ? "checkmark.square.fill" : "square")
                        .font(.title2)
                        .foregroundColor(isChecked ?  .appPrimary : .gray)
                }
                
                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        Text("agree_to_terms_prefix")
                            .font(.body)
                            .foregroundColor(.primary)

                        Button("terms_and_conditions".localized()) {
                            showTerms = true
                        }
                        .font(.body)
                        .foregroundColor(.appPrimary)
                        .underline()
                    }
                }
                
                Spacer()
            }
            .padding()
            .sheet(isPresented: $showTerms) {
               // TermsWebView(isPresented: $showTerms)
                SafariView(url: URL(string: "https://www.example.com")!)
            }
        }
    }
    struct SafariView: UIViewControllerRepresentable {
        let url: URL
        
        func makeUIViewController(context: Context) -> SFSafariViewController {
            SFSafariViewController(url: url)
        }
        
        func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
            // No updates needed
        }
    }

    //// MARK: - WebView for Terms and Conditions
    //struct TermsWebView: View {
    //    @Binding var isPresented: Bool
    //
    //    var body: some View {
    //        NavigationView {
    //            WebView()
    //                .navigationTitle("Terms & Conditions")
    //                .navigationBarTitleDisplayMode(.inline)
    //                .toolbar {
    //                    ToolbarItem(placement: .navigationBarTrailing) {
    //                        Button("Done") {
    //                            isPresented = false
    //                        }
    //                    }
    //                }
    //        }
    //    }
    //}
    //
    //// MARK: - UIViewRepresentable for WKWebView
    //struct WebView: UIViewRepresentable {
    //    func makeUIView(context: Context) -> WKWebView {
    //        let webView = WKWebView()
    //        webView.navigationDelegate = context.coordinator
    //        loadTermsContent(webView: webView)
    //        return webView
    //    }
    //
    //    func updateUIView(_ uiView: WKWebView, context: Context) {
    //        // No updates needed
    //    }
    //
    //    func makeCoordinator() -> Coordinator {
    //        Coordinator(self)
    //    }
    //
    //    class Coordinator: NSObject, WKNavigationDelegate {
    //        var parent: WebView
    //
    //        init(_ parent: WebView) {
    //            self.parent = parent
    //        }
    //
    //        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    //            print("Terms loaded successfully")
    //        }
    //
    //        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
    //            print("Failed to load terms: \(error.localizedDescription)")
    //        }
    //    }
    //
    //    private func loadTermsContent(webView: WKWebView) {
    //        let htmlContent = """
    //        <!DOCTYPE html>
    //        <html>
    //        <head>
    //            <meta charset="UTF-8">
    //            <meta name="viewport" content="width=device-width, initial-scale=1.0">
    //            <title>Terms and Conditions</title>
    //            <style>
    //                body {
    //                    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
    //                    margin: 20px;
    //                    line-height: 1.6;
    //                    color: #333;
    //                    background-color: #f9f9f9;
    //                }
    //                .container {
    //                    background-color: white;
    //                    padding: 20px;
    //                    border-radius: 10px;
    //                    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
    //                }
    //                h1 {
    //                    color: #007AFF;
    //                    text-align: center;
    //                    margin-bottom: 30px;
    //                }
    //                h2 {
    //                    color: #007AFF;
    //                    border-bottom: 2px solid #007AFF;
    //                    padding-bottom: 10px;
    //                }
    //                h3 {
    //                    color: #333;
    //                    margin-top: 25px;
    //                }
    //                ul {
    //                    padding-left: 20px;
    //                }
    //                .section {
    //                    margin-bottom: 40px;
    //                }
    //                .highlight {
    //                    background-color: #f0f8ff;
    //                    padding: 15px;
    //                    border-left: 4px solid #007AFF;
    //                    margin: 20px 0;
    //                    border-radius: 5px;
    //                }
    //            </style>
    //        </head>
    //        <body>
    //            <div class="container">
    //                <h1>Terms and Conditions</h1>
    //
    //                <div class="section">
    //                    <h2>Sample Terms</h2>
    //
    //                    <div class="highlight">
    //                        <p><strong>Welcome to our app!</strong> This is a sample terms and conditions page.</p>
    //                    </div>
    //
    //                    <p>By using this app, you agree to the following terms and conditions:</p>
    //
    //                    <h3>1. Acceptance of Terms:</h3>
    //                    <p>By using our app, you explicitly agree to be bound by these terms. If you do not agree, please discontinue use immediately.</p>
    //
    //                    <h3>2. Data Collection:</h3>
    //                    <p>We collect and store your data to provide our services.</p>
    //
    //                    <h3>3. Privacy:</h3>
    //                    <p>We are committed to protecting your personal data with high standards of confidentiality and security.</p>
    //
    //                    <h3>4. Disclaimer:</h3>
    //                    <ul>
    //                        <li>The app is provided "as is" without warranties</li>
    //                        <li>We are not liable for unexpected outcomes</li>
    //                        <li>You are responsible for how you use the services</li>
    //                    </ul>
    //
    //                    <h3>5. Changes to Terms:</h3>
    //                    <p>We may update these terms at any time. Users will be notified of changes.</p>
    //
    //                    <p><em>You can replace this content with your actual terms and conditions.</em></p>
    //                </div>
    //            </div>
    //        </body>
    //        </html>
    //        """
    //
    //        webView.loadHTMLString(htmlContent, baseURL: nil)
    //    }
    //}
    //
    //// MARK: - Alternative Checkbox Style
    //struct CustomCheckboxStyle: View {
    //    @Binding var isChecked: Bool
    //    let action: () -> Void
    //
    //    var body: some View {
    //        Button(action: action) {
    //            HStack {
    //                Image(systemName: isChecked ? "checkmark.circle.fill" : "circle")
    //                    .font(.title2)
    //                    .foregroundColor(isChecked ? .blue : .gray)
    //
    //                Text("I agree to the ")
    //                    .font(.body)
    //                    .foregroundColor(.primary)
    //
    //                Text("Terms and Conditions")
    //                    .font(.body)
    //                    .foregroundColor(.blue)
    //                    .underline()
    //            }
    //        }
    //        .buttonStyle(PlainButtonStyle())
    //    }
    //}

    // MARK: - Preview
    struct TermsCheckboxView_Previews: PreviewProvider {
        static var previews: some View {
            TermsCheckboxView(isChecked: .constant(false))
        }
    }
