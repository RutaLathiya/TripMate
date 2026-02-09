//
//  UserModel.swift
//  TripMate
//
//  Created by iMac on 06/02/26.
//
import SwiftUI
import Combine

class UserModel: ObservableObject{
    @Published var id: UUID = UUID()
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var phoneNo: String = ""
}
