//
//  ExpenseEntityExtensions.swift
//  TripMate
//
//  Created by iMac on 16/04/26.
//

import SwiftUI

extension ExpenseEntity {
    var sharesArray: [ExpenseShareEntity] {
        let set = shares as? Set<ExpenseShareEntity> ?? []
        return set.sorted { (a: ExpenseShareEntity, b: ExpenseShareEntity) in
            (a.memberName ?? "") < (b.memberName ?? "")
        }
    }
}
