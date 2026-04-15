//
//  AvatarHelper.swift
//  TripMate
//
//  Created by iMac on 15/04/26.
//

import Foundation
import SwiftUI

struct AvatarHelper {
    static let bgColors = [ "b6e3f4", "c0aede", "d1d4f9", "ffd5dc", "ffdfbf", "b5ead7" ]
    
    static func url(seed: String, size: Int = 80) -> URL? {
        let bg = bgColor(for: seed)
        let urlStr = "https://api.dicebear.com/9.x/adventurer/svg" 
        + "?seed=\(seed)&backgroundColor=\(bg)"
        return URL(string: urlStr)
    }
    
    // Deterministic color pick — same seed = same color
    private static func bgColor(for seed: String) -> String {
        let hash = seed.unicodeScalars.reduce(0) { $0 + Int($1.value)}
        return bgColors[hash % bgColors.count]
        // Usage in SwiftUI:
        //AsyncImage(url: AvatarHelper.url(seed: user.username))
    }
}

