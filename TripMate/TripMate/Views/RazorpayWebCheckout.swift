//
//  RazorpayWebCheckout.swift
//  TripMate
//
//  Created by iMac on 02/04/26.
//

// MARK: - RazorpayWebCheckout.swift
// Uses Razorpay Web Checkout (WKWebView) — No SDK, Swift 6 compatible
// Docs: https://razorpay.com/docs/payments/payment-gateway/web-integration/standard/

import SwiftUI
import WebKit

// MARK: - Razorpay Web Checkout Result
enum RazorpayResult {
    case success(paymentId: String, orderId: String, signature: String)
    case failure(code: String, description: String)
    case dismissed
}

// MARK: - WKWebView wrapper for Razorpay Checkout
struct RazorpayWebView: UIViewRepresentable {
    let htmlContent: String
    let onResult: (RazorpayResult) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(onResult: onResult)
    }

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()

        // Allow Razorpay JS to call back into Swift
        config.userContentController.add(context.coordinator, name: "razorpayHandler")

        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator
        webView.backgroundColor = UIColor.clear
        webView.isOpaque = false
        webView.scrollView.isScrollEnabled = false
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        webView.loadHTMLString(htmlContent, baseURL: URL(string: "https://checkout.razorpay.com"))
    }

    // MARK: - Coordinator (handles JS → Swift callbacks)
    class Coordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
        let onResult: (RazorpayResult) -> Void

        init(onResult: @escaping (RazorpayResult) -> Void) {
            self.onResult = onResult
        }

        // Receive messages from JavaScript
        func userContentController(_ controller: WKUserContentController, didReceive message: WKScriptMessage) {
            guard message.name == "razorpayHandler",
                  let body = message.body as? [String: Any],
                  let event = body["event"] as? String else { return }

            DispatchQueue.main.async {
                switch event {
                case "payment.success":
                    let paymentId = body["razorpay_payment_id"] as? String ?? ""
                    let orderId   = body["razorpay_order_id"]   as? String ?? ""
                    let signature = body["razorpay_signature"]  as? String ?? ""
                    self.onResult(.success(paymentId: paymentId, orderId: orderId, signature: signature))

                case "payment.error":
                    let code = body["code"] as? String ?? "UNKNOWN"
                    let desc = body["description"] as? String ?? "Payment failed"
                    self.onResult(.failure(code: code, description: desc))

                case "payment.dismiss":
                    self.onResult(.dismissed)

                default:
                    break
                }
            }
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            // Automatically open Razorpay checkout once page loads
            webView.evaluateJavaScript("openRazorpay();", completionHandler: nil)
        }
    }
}

// MARK: - HTML Generator for Razorpay Web Checkout
struct RazorpayHTMLBuilder {

    /// Builds the full HTML page that loads Razorpay checkout
    static func build(
        keyId: String,
        orderId: String,
        amount: Double,          // in rupees — we convert to paise
        receiverName: String,
        receiverPhone: String,
        note: String,
        preferredMethod: String? = nil  // "upi", "card", "netbanking", "wallet"
    ) -> String {
        let amountPaise = Int(amount * 100)

        return """
        <!DOCTYPE html>
        <html>
        <head>
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <script src="https://checkout.razorpay.com/v1/checkout.js"></script>
            <style>
                body { margin: 0; background: transparent; font-family: -apple-system; }
                #loader {
                    display: flex; justify-content: center; align-items: center;
                    height: 100vh; flex-direction: column; gap: 12px;
                    color: #6C63FF; font-size: 14px;
                }
                .spinner {
                    width: 36px; height: 36px; border: 3px solid #e0dfff;
                    border-top-color: #6C63FF; border-radius: 50%;
                    animation: spin 0.8s linear infinite;
                }
                @keyframes spin { to { transform: rotate(360deg); } }
            </style>
        </head>
        <body>
            <div id="loader">
                <div class="spinner"></div>
                <span>Opening Razorpay...</span>
            </div>

            <script>
            function openRazorpay() {
                var options = {
                    key: "\(keyId)",
                    amount: \(amountPaise),
                    currency: "INR",
                    name: "TripMate",
                    description: "\(note.isEmpty ? "Trip payment to \(receiverName)" : note)",
                    order_id: "\(orderId)",
                    prefill: {
                        name: "\(receiverName)",
                        contact: "\(receiverPhone)"
                    },
                    theme: { color: "#6C63FF" },
                    modal: {
                        ondismiss: function() {
                            window.webkit.messageHandlers.razorpayHandler.postMessage({
                                event: "payment.dismiss"
                            });
                        }
                    },
                    handler: function(response) {
                        window.webkit.messageHandlers.razorpayHandler.postMessage({
                            event: "payment.success",
                            razorpay_payment_id: response.razorpay_payment_id,
                            razorpay_order_id:   response.razorpay_order_id,
                            razorpay_signature:  response.razorpay_signature
                        });
                    }
                };

                // Optionally pre-select payment method
                \(preferredMethod != nil ? "options.method = { \(preferredMethod!): true };" : "")

                var rzp = new Razorpay(options);

                rzp.on("payment.failed", function(response) {
                    window.webkit.messageHandlers.razorpayHandler.postMessage({
                        event: "payment.error",
                        code: String(response.error.code),
                        description: response.error.description
                    });
                });

                rzp.open();
            }
            </script>
        </body>
        </html>
        """
    }
}

// MARK: - Razorpay Sheet View (wraps the WebView in a presentable sheet)
struct RazorpayCheckoutSheet: View {
    let keyId: String
    let orderId: String
    let amount: Double
    let receiver: TripMember
    let note: String
    let preferredMethod: String?
    let onResult: (RazorpayResult) -> Void

    @Environment(\.dismiss) private var dismiss

    private var htmlContent: String {
        RazorpayHTMLBuilder.build(
            keyId: keyId,
            orderId: orderId,
            amount: amount,
            receiverName: receiver.name,
            receiverPhone: receiver.phone,
            note: note,
            preferredMethod: preferredMethod
        )
    }

    var body: some View {
        NavigationStack {
            RazorpayWebView(htmlContent: htmlContent) { result in
                onResult(result)
                dismiss()
            }
            .ignoresSafeArea()
            .navigationTitle("Secure Payment")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        onResult(.dismissed)
                        dismiss()
                    }
                    .foregroundColor(Color("#6C63FF"))
                }
            }
        }
    }
}

// MARK: - Order Creator (calls your backend)
actor RazorpayOrderService {

    // ✅ Replace with your actual backend URL
    private let backendURL = "https://your-backend.com/api/payment/create-order"

    func createOrder(amount: Double, tripId: Int, payerId: Int, receiverId: Int) async throws -> String {
        guard let url = URL(string: backendURL) else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Add your auth token if needed:
        // request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")

        let body: [String: Any] = [
            "amount":      Int(amount * 100),   // Razorpay needs paise
            "currency":    "INR",
            "receipt":     "trip_\(tripId)_\(Int(Date().timeIntervalSince1970))",
            "payer_id":    payerId,
            "receiver_id": receiverId
        ]

        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }

        guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
              let orderId = json["id"] as? String else {
            throw URLError(.cannotParseResponse)
        }

        return orderId
    }
}
