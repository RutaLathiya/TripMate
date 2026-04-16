//
//  AvatarHelper.swift
//  TripMate
//
//  Created by iMac on 15/04/26.
//

import Foundation
import SwiftUI

struct AvatarHelper {
    static let bgColors = ["b6e3f4", "c0aede", "d1d4f9", "ffd5dc", "ffdfbf", "b5ead7"]

    static func url(seed: String) -> URL? {
        guard !seed.isEmpty else { return nil }
        let bg = bgColor(for: seed)
        let encoded = seed.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? seed
        let urlStr = "https://api.dicebear.com/9.x/adventurer/png?seed=\(encoded)&backgroundColor=\(bg)"
        return URL(string: urlStr)
    }

    private static func bgColor(for seed: String) -> String {
        let hash = seed.unicodeScalars.reduce(0) { $0 + Int($1.value) }
        return bgColors[hash % bgColors.count]
    }
}

