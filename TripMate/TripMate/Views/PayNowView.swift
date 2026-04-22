//
//  PayNowView.swift
//  TripMate
//
//  Created by iMac on 02/04/26.
//

// MARK: - PayNowView.swift
// TripMate — Pay a trip member via Razorpay Web Checkout
// Presented as a .sheet() from your expense summary row

import SwiftUI

struct PayNowView: View {

    // MARK: - Inputs
    let receiverName: String      // e.g. "Raj"
    let receiverPhone: String
    let prefilledAmount: Double   // the share amount from ExpenseMember.shareAmount
    let paymentStore: PaymentStore
    var onPaymentComplete: (() -> Void)? = nil

    @Environment(\.dismiss) private var dismiss

    // MARK: - State
    @State private var amount: String
    @State private var selectedMethod: PaymentMethod = .upi
    @State private var note: String = ""
    @State private var isCreatingOrder = false
    @State private var showCheckout    = false
    @State private var currentOrderId  = ""
    @State private var showAlert       = false
    @State private var alertTitle      = ""
    @State private var alertMessage    = ""
    @State private var paymentOK       = false
    @State private var dbPaymentId: Int? = nil

    // ✅ Replace with your Razorpay KEY ID (rzp_test_... for test mode)
    private let razorpayKeyId = "rzp_test_Sc6QPGj4MvO6Of"
    private let orderService  = RazorpayOrderService()

    init(receiverName: String,
         receiverPhone: String,
         prefilledAmount: Double,
         paymentStore: PaymentStore,
         onPaymentComplete: (() -> Void)? = nil) {
        self.receiverName      = receiverName
        self.receiverPhone     = receiverPhone
        self.prefilledAmount   = prefilledAmount
        self.paymentStore      = paymentStore
        self.onPaymentComplete = onPaymentComplete
        _amount = State(initialValue: prefilledAmount > 0 ? String(format: "%.0f", prefilledAmount) : "")
    }

    // MARK: - Computed
    var parsedAmount: Double { Double(amount) ?? 0 }
    var isValid: Bool        { parsedAmount > 0 }

    var razorpayMethod: String? {
        switch selectedMethod {
        case .upi:  return "upi"
        case .card: return "card"
        case .bank: return "netbanking"
        case .cash: return nil
        }
    }

    // MARK: - Body
    var body: some View {
        NavigationStack {
            ZStack {
                Color.BackgroundColor.ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        
                        receiverHeader
                        amountCard
                        methodCard
                        noteCard
                        payButton
                        securityNote
                        
                        Spacer(minLength: 32)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                }
            }
            .navigationTitle("Pay Now")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                        .font(.system(size: 13, design: .monospaced))
                        .foregroundColor(Color.AccentColor)
                }
            }
            .sheet(isPresented: $showCheckout) {
                RazorpayCheckoutSheet(
                    keyId: razorpayKeyId,
                    orderId: currentOrderId,
                    amount: parsedAmount,
                    receiverName: receiverName,
                    receiverPhone: receiverPhone,
                    note: note,
                    preferredMethod: razorpayMethod,
                    onResult: handleCheckoutResult
                )
            }
            .alert(alertTitle, isPresented: $showAlert) {
                Button("OK") {
                    if paymentOK {
                        onPaymentComplete?()
                        dismiss()
                    }
                }
            } message: {
                Text(alertMessage)
            }
        }
    }
    // MARK: - Subviews

    private var receiverHeader: some View {
        VStack(spacing: 10) {
            // Avatar — matches memberChip avatar style from AddExpenseView
            ZStack {
                Circle()
                    .fill(Color.AccentColor.opacity(0.15))
                    .overlay(Circle().stroke(Color.AccentColor.opacity(0.3), lineWidth: 1))
                Text(String(receiverName.prefix(1)).uppercased())
                    .font(.system(size: 24, weight: .bold, design: .monospaced))
                    .foregroundColor(Color.AccentColor)
            }
            .frame(width: 60, height: 60)

            Text("PAYING \(receiverName.uppercased())")
                .font(.system(size: 11, weight: .bold, design: .monospaced))
                .foregroundColor(Color.AccentColor.opacity(0.5))
                .kerning(2)
        }
        .padding(.top, 4)
    }

    private var amountCard: some View {
        // Matches fieldCard style from AddExpenseView exactly
        VStack(alignment: .leading, spacing: 10) {
            Text("AMOUNT (₹)")
                .font(.system(size: 10, weight: .bold, design: .monospaced))
                .foregroundColor(Color.AccentColor.opacity(0.5))
                .kerning(2)

            HStack(alignment: .bottom, spacing: 4) {
                Text("₹")
                    .font(.system(size: 20, weight: .bold, design: .monospaced))
                    .foregroundColor(Color.AccentColor)
                    .padding(.bottom, 4)
                TextField("0", text: $amount)
                    .font(.system(size: 36, weight: .heavy, design: .monospaced))
                    .foregroundColor(Color.AccentColor)
                    .keyboardType(.decimalPad)
            }
        }
        .padding(16)
        .background(Color.BackgroundColor)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.AccentColor.opacity(0.15), lineWidth: 1)
        )
    }

    private var methodCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("PAYMENT METHOD")
                .font(.system(size: 10, weight: .bold, design: .monospaced))
                .foregroundColor(Color.AccentColor.opacity(0.5))
                .kerning(2)

            // Method chips — match categoryChip style from AddExpenseView
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(PaymentMethod.allCases) { method in
                        methodChip(method)
                    }
                }
            }

            // Cash note
            if selectedMethod == .cash {
                HStack(spacing: 8) {
                    Image(systemName: "info.circle")
                        .font(.system(size: 11))
                        .foregroundColor(Color.AccentColor.opacity(0.5))
                    Text("Cash payments are marked manually.")
                        .font(.system(size: 11, design: .monospaced))
                        .foregroundColor(Color.AccentColor.opacity(0.4))
                }
                .padding(10)
                .background(Color.AccentColor.opacity(0.05))
                .cornerRadius(8)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(16)
        .background(Color.BackgroundColor)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.AccentColor.opacity(0.15), lineWidth: 1)
        )
    }

    private func methodChip(_ method: PaymentMethod) -> some View {
        let isSelected = selectedMethod == method
        return Button { withAnimation(.spring(response: 0.25)) { selectedMethod = method } } label: {
            HStack(spacing: 6) {
                Image(systemName: method.icon).font(.system(size: 11))
                Text(method.rawValue)
                    .font(.system(size: 11, weight: .medium, design: .monospaced))
            }
            .foregroundColor(isSelected ? Color.AccentColor : Color.AccentColor.opacity(0.4))
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(isSelected ? Color.AccentColor.opacity(0.12) : Color.clear)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(
                        isSelected ? Color.AccentColor.opacity(0.4) : Color.AccentColor.opacity(0.2),
                        lineWidth: 1
                    )
            )
        }
    }

    private var noteCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("NOTE (OPTIONAL)")
                .font(.system(size: 10, weight: .bold, design: .monospaced))
                .foregroundColor(Color.AccentColor.opacity(0.5))
                .kerning(2)
            TextField("Any extra details...", text: $note, axis: .vertical)
                .font(.system(size: 13, design: .monospaced))
                .foregroundColor(Color.AccentColor)
                .lineLimit(3)
        }
        .padding(16)
        .background(Color.BackgroundColor)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.AccentColor.opacity(0.15), lineWidth: 1)
        )
    }

    private var payButton: some View {
        Button(action: handlePayTap) {
            HStack(spacing: 8) {
                if isCreatingOrder {
                    ProgressView().tint(Color.AccentColor).scaleEffect(0.8)
                } else {
                    Image(systemName: selectedMethod == .cash ? "checkmark.circle" : "lock.fill")
                        .font(.system(size: 13))
                }
                Text(buttonLabel)
                    .font(.system(size: 14, weight: .heavy, design: .rounded))
                    .kerning(2)
            }
            .foregroundColor(isValid ? Color.AccentColor : Color.AccentColor.opacity(0.3))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 19)
            .background(ZStack {
                Color.white.opacity(0.1)
                Color.BackgroundColor.opacity(0.5)
            })
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(
                        isValid ? Color.AccentColor.opacity(0.5) : Color.AccentColor.opacity(0.1),
                        lineWidth: 1.5
                    )
            )
        }
        .disabled(!isValid)
    }

    private var buttonLabel: String {
       // if isCreatingOrder { return "CREATING ORDER..." }
        let amt = parsedAmount > 0 ? "  ₹\(Int(parsedAmount))" : ""
        return selectedMethod == .cash ? "MARK AS PAID\(amt)" : "PAY\(amt)"
    }

    @ViewBuilder
    private var securityNote: some View {
        if selectedMethod != .cash {
            Text("SECURED BY RAZORPAY · 256-BIT SSL")
                .font(.system(size: 8, design: .monospaced))
                .foregroundColor(Color.AccentColor.opacity(0.5))
                .kerning(1.5)
        }
    }

    // MARK: - Actions
    private func handlePayTap() {
        if selectedMethod == .cash {
            savePaymentRecord(paymentId: nil, status: .success)
            paymentOK    = true
            alertTitle   = "Marked as Paid"
            alertMessage = "₹\(Int(parsedAmount)) cash payment to \(receiverName) recorded."
            showAlert    = true
            return
        }

        isCreatingOrder = true
        Task {
            do {
                let result = try await orderService.createOrder(
                    amount: parsedAmount,
                    tripId: 1,
                    payerId: 1,
                    receiverId: 1
                )
                await MainActor.run {
                    currentOrderId  = result.orderId   // ← use the real order ID
                    dbPaymentId     = result.dbPaymentId 
                    isCreatingOrder = false
                    showCheckout    = true
                }
            } catch {
                await MainActor.run {
                    isCreatingOrder = false
                    alertTitle      = "Order Failed"
                    alertMessage    = "Could not reach server.\n\(error.localizedDescription)"
                    paymentOK       = false
                    showAlert       = true
                }
            }
        }
    }
    
    private func handleCheckoutResult(_ result: RazorpayResult) {
        switch result {
        case .success(let paymentId, let orderId, let signature):
            // Verify with backend
            Task {
                await verifyPayment(
                    razorpayPaymentId: paymentId,
                    razorpayOrderId: orderId,
                    razorpaySignature: signature
                )
            }

        case .failure(_, let description):
            savePaymentRecord(paymentId: nil, status: .failed)
            paymentOK    = false
            alertTitle   = "Payment Failed"
            alertMessage = description
            showAlert    = true

        case .dismissed:
            return
        }
    }

    private func verifyPayment(razorpayPaymentId: String, razorpayOrderId: String, razorpaySignature: String) async {
        guard let url = URL(string: "http://localhost:3000/api/payment/verify") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "razorpay_order_id":   razorpayOrderId,
            "razorpay_payment_id": razorpayPaymentId,
            "razorpay_signature":  razorpaySignature,
            "payment_id":          dbPaymentId ?? 0
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            let status = json?["status"] as? String ?? "failed"

            await MainActor.run {
                savePaymentRecord(paymentId: razorpayPaymentId, status: status == "success" ? .success : .failed)
                paymentOK    = status == "success"
                alertTitle   = status == "success" ? "Payment Successful" : "Verification Failed"
                alertMessage = status == "success"
                    ? "₹\(Int(parsedAmount)) paid to \(receiverName).\nID: \(razorpayPaymentId)"
                    : "Payment could not be verified."
                showAlert = true
            }
        } catch {
            await MainActor.run {
                alertTitle   = "Verification Error"
                alertMessage = error.localizedDescription
                showAlert    = true
            }
        }
    }

    private func savePaymentRecord(paymentId: String?, status: PaymentStatus) {
        let record = PaymentRecord(
            fromName: "You",
            toName: receiverName,
            amount: parsedAmount,
            method: selectedMethod,
            status: status,
            date: Date(),
            razorpayPaymentId: paymentId,
            note: note
        )
        paymentStore.add(record)
    }
}

#Preview {
    PayNowView(receiverName: "Raj", receiverPhone: "9999999999", prefilledAmount: 450, paymentStore: PaymentStore())
        .preferredColorScheme(.light)
}
