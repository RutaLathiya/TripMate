//
//  ExpenseRepository.swift
//  TripMate
//
//  Created by iMac on 31/03/26.
//

import CoreData

protocol ExpenseRepositoryProtocol {
    func saveExpense(_ expense: Expense, tripID: NSManagedObjectID) throws
    func fetchExpenses(for tripID: NSManagedObjectID) throws -> [Expense]
    func deleteExpense(id: UUID, tripID: NSManagedObjectID) throws
    func markSettled(expenseId: UUID, memberName: String) throws
}

final class ExpenseRepository: ExpenseRepositoryProtocol {

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = PersistenceController.shared.context) {
        self.context = context
    }

    // MARK: - Save
    func saveExpense(_ expense: Expense, tripID: NSManagedObjectID) throws {
        guard let trip = try? context.existingObject(with: tripID) as? TripEntity else { return }

        let entity          = ExpenseEntity(context: context)
        entity.expenseId    = expense.id
        entity.title        = expense.title
        entity.amount       = expense.amount
        entity.category     = expense.category.rawValue
        entity.date         = expense.date
        entity.payerName    = expense.payerName
        entity.splitType    = expense.splitType.rawValue
        entity.notes        = expense.notes
        entity.createdAt    = Date()
        entity.trip         = trip

        // Save shares
        for member in expense.members {
            let share           = ExpenseShareEntity(context: context)
            share.shareId       = member.id
            share.memberName    = member.name
            share.shareAmount   = member.shareAmount
            share.isPaid        = member.isPaid
            share.expense       = entity
        }

        try context.save()
        print("✅ Expense saved: \(expense.title)")
    }

    // MARK: - Fetch
    func fetchExpenses(for tripID: NSManagedObjectID) throws -> [Expense] {
        guard let trip = try? context.existingObject(with: tripID) as? TripEntity else { return [] }

        let request = ExpenseEntity.fetchRequest()
        request.predicate = NSPredicate(format: "trip == %@", trip)
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]

        let entities = try context.fetch(request)
        return entities.map { entity in
            let shares = (entity.shares?.allObjects as? [ExpenseShareEntity] ?? [])
                .map { share in
                    ExpenseMember(
                        id: share.shareId ?? UUID(),
                        name: share.memberName ?? "",
                        shareAmount: share.shareAmount,
                        isPaid: share.isPaid
                    )
                }
            return Expense(
                id:         entity.expenseId ?? UUID(),
                title:      entity.title ?? "",
                amount:     entity.amount,
                category:   ExpenseCategory(rawValue: entity.category ?? "") ?? .other,
                date:       entity.date ?? Date(),
                payerName:  entity.payerName ?? "",
                members:    shares,
                splitType:  SplitType(rawValue: entity.splitType ?? "") ?? .equal,
                notes:      entity.notes ?? ""
            )
        }
    }

    // MARK: - Delete
    func deleteExpense(id: UUID, tripID: NSManagedObjectID) throws {
        guard let trip = try? context.existingObject(with: tripID) as? TripEntity else { return }

        let request = ExpenseEntity.fetchRequest()
        request.predicate = NSPredicate(
            format: "expenseId == %@ AND trip == %@", id as CVarArg, trip
        )
        request.fetchLimit = 1

        if let entity = try context.fetch(request).first {
            context.delete(entity)
            try context.save()
            print("🗑️ Expense deleted")
        }
    }

    // MARK: - Mark Settled
    func markSettled(expenseId: UUID, memberName: String) throws {
        let request = ExpenseShareEntity.fetchRequest()
        request.predicate = NSPredicate(
            format: "expense.expenseId == %@ AND memberName == %@",
            expenseId as CVarArg, memberName
        )
        request.fetchLimit = 1

        if let share = try context.fetch(request).first {
            share.isPaid = true
            try context.save()
            print("✅ Settled: \(memberName)")
        }
    }
}
