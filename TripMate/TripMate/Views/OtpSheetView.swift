//
//  OtpSheetView.swift
//  TripMate
//
//  Created by iMac on 24/03/26.
//

import SwiftUI

// MARK: - OTP Sheet (6 visual boxes, works on iPad)
struct OTPSheetView: View {
 
    @ObservedObject var authVM: AuthViewModel
    var onVerified: () -> Void
    @FocusState private var isOTPFocused: Bool
 
    var body: some View {
        ZStack {
            Color.BackgroundColor.ignoresSafeArea()
            VStack(spacing: 28) {
 
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 40, height: 5)
                    .padding(.top, 16)
 
                VStack(spacing: 8) {
                    Image(systemName: "lock.shield.fill")
                        .font(.system(size: 36))
                        .foregroundColor(.brown)
                    Text("Verify Phone")
                        .font(.title2).fontWeight(.bold)
                    VStack(spacing: 4) {
                        Text("Enter the 6-digit code sent to")
                        Text("\(authVM.countryCode)\(authVM.phoneNumber)")
                            .fontWeight(.semibold)
                            .foregroundColor(.brown)
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                }
 
                otpBoxes
                    .onTapGesture { isOTPFocused = true }
                    .onAppear { isOTPFocused = true }
 
                Button {
                    Task {
                        await authVM.verifyOTP()
                        if authVM.isPhoneVerified { onVerified() }
                    }
                } label: {
                    ZStack {
                        if authVM.isLoading {
                            ProgressView().tint(.white)
                        } else {
                            Text("VERIFY").font(.headline).foregroundColor(.white)
                        }
                    }
                    .frame(maxWidth: .infinity).frame(height: 52)
                    .background(authVM.canVerifyOTP ? Color.brown : Color.gray.opacity(0.3))
                    .cornerRadius(20)
                }
                .disabled(!authVM.canVerifyOTP || authVM.isLoading)
                .padding(.horizontal, 30)
 
                Button {
                    authVM.otpCode = ""
                    Task { await authVM.resendOTP() }
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "arrow.clockwise").font(.system(size: 12))
                        Text("Resend OTP").font(.subheadline)
                    }
                    .foregroundColor(.brown.opacity(0.7))
                }
 
                Spacer()
            }
        }
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }
 
    private var otpBoxes: some View {
        ZStack {
            TextField("", text: $authVM.otpCode)
                .keyboardType(.numberPad)
                .focused($isOTPFocused)
                .foregroundColor(.clear)
                .tint(.clear)
                .frame(width: 1, height: 1)
                .opacity(0.01)
                .onChange(of: authVM.otpCode) {
                    let filtered = authVM.otpCode.filter { $0.isNumber }
                    if authVM.otpCode != filtered { authVM.otpCode = filtered }
                    if authVM.otpCode.count > 6 {
                        authVM.otpCode = String(authVM.otpCode.prefix(6))
                    }
                }
 
            HStack(spacing: 12) {
                ForEach(0..<6, id: \.self) { index in
                    let digit = index < authVM.otpCode.count
                        ? String(authVM.otpCode[authVM.otpCode.index(
                            authVM.otpCode.startIndex, offsetBy: index)])
                        : ""
                    let isCurrent = index == authVM.otpCode.count
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.ContainerColor)
                            .frame(width: 46, height: 56)
                            .overlay(RoundedRectangle(cornerRadius: 12)
                                .stroke(
                                    isCurrent && isOTPFocused ? Color.brown
                                        : (!digit.isEmpty ? Color.brown.opacity(0.5)
                                            : Color.gray.opacity(0.3)),
                                    lineWidth: isCurrent && isOTPFocused ? 2 : 1.5
                                ))
                        if digit.isEmpty && isCurrent && isOTPFocused {
                            RoundedRectangle(cornerRadius: 1)
                                .fill(Color.brown).frame(width: 2, height: 24)
                        } else {
                            Text(digit)
                                .font(.system(size: 22, weight: .bold, design: .monospaced))
                                .foregroundColor(.brown)
                        }
                    }
                }
            }
        }
    }
}

// MARK: - email OTP

struct EmailOTPSheetView: View {
 
    @ObservedObject var emailOTPVM: EmailOTPViewModel
    @FocusState private var isOTPFocused: Bool
 
    var body: some View {
        ZStack {
            Color.BackgroundColor.ignoresSafeArea()
            VStack(spacing: 28) {
 
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 40, height: 5)
                    .padding(.top, 16)
 
                VStack(spacing: 8) {
                    Image(systemName: "envelope.badge.shield.half.filled.fill")
                        .font(.system(size: 36))
                        .foregroundColor(.brown)
                    Text("Verify Email")
                        .font(.title2).fontWeight(.bold)
                    VStack(spacing: 4) {
                        Text("Enter the 6-digit code sent to")
                        Text(emailOTPVM.sentToEmail)
                            .fontWeight(.semibold)
                            .foregroundColor(.brown)
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                }
 
                otpBoxes
                    .onTapGesture { isOTPFocused = true }
                    .onAppear { isOTPFocused = true }
 
                Button {
                    emailOTPVM.verifyOTP()
                } label: {
                    Text("VERIFY").font(.headline).foregroundColor(.white)
                        .frame(maxWidth: .infinity).frame(height: 52)
                        .background(emailOTPVM.canVerifyOTP ? Color.brown : Color.gray.opacity(0.3))
                        .cornerRadius(20)
                }
                .disabled(!emailOTPVM.canVerifyOTP)
                .padding(.horizontal, 30)
 
                Button {
                    emailOTPVM.otpCode = ""
                    Task { await emailOTPVM.resendOTP(to: emailOTPVM.sentToEmail) }
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "arrow.clockwise").font(.system(size: 12))
                        Text("Resend OTP").font(.subheadline)
                    }
                    .foregroundColor(.brown.opacity(0.7))
                }
 
                Spacer()
            }
        }
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }
 
    private var otpBoxes: some View {
        ZStack {
            TextField("", text: $emailOTPVM.otpCode)
                .keyboardType(.numberPad)
                .focused($isOTPFocused)
                .foregroundColor(.clear)
                .tint(.clear)
                .frame(width: 1, height: 1)
                .opacity(0.01)
                .onChange(of: emailOTPVM.otpCode) {
                    let filtered = emailOTPVM.otpCode.filter { $0.isNumber }
                    if emailOTPVM.otpCode != filtered { emailOTPVM.otpCode = filtered }
                    if emailOTPVM.otpCode.count > 6 {
                        emailOTPVM.otpCode = String(emailOTPVM.otpCode.prefix(6))
                    }
                }
 
            HStack(spacing: 12) {
                ForEach(0..<6, id: \.self) { index in
                    let digit = index < emailOTPVM.otpCode.count
                        ? String(emailOTPVM.otpCode[emailOTPVM.otpCode.index(
                            emailOTPVM.otpCode.startIndex, offsetBy: index)])
                        : ""
                    let isCurrent = index == emailOTPVM.otpCode.count
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.ContainerColor)
                            .frame(width: 46, height: 56)
                            .overlay(RoundedRectangle(cornerRadius: 12)
                                .stroke(
                                    isCurrent && isOTPFocused ? Color.brown
                                        : (!digit.isEmpty ? Color.brown.opacity(0.5)
                                            : Color.gray.opacity(0.3)),
                                    lineWidth: isCurrent && isOTPFocused ? 2 : 1.5
                                ))
                        if digit.isEmpty && isCurrent && isOTPFocused {
                            RoundedRectangle(cornerRadius: 1)
                                .fill(Color.brown).frame(width: 2, height: 24)
                        } else {
                            Text(digit)
                                .font(.system(size: 22, weight: .bold, design: .monospaced))
                                .foregroundColor(.brown)
                        }
                    }
                }
            }
        }
    }
}
