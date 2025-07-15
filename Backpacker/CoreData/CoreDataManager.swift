//
//  CoreDataManager.swift
//  Backpacker
//
//  Created by Mobile on 04/07/25.
//

import Foundation
import Foundation
import CoreData
import UIKit

class CoreDataManager {
    
    static let shared = CoreDataManager()
    private let context: NSManagedObjectContext

    private init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Unable to get AppDelegate")
        }
        self.context = appDelegate.persistentContainer.viewContext
    }

//    // MARK: - Create / Add
//    func addUser(phoneNumber: Int16, phoneCode: Int16, roleType: String?, countryName: String?, isUserLoggedIn: Bool) {
//        let user = LogInEntity(context: context)
//        user.phoneNumber = phoneNumber
//        user.phoneCode = phoneCode
//        user.roleType = roleType
//        user.countryName = countryName
//        user.isUserLoggedIn = isUserLoggedIn
//        saveContext()
//    }
//    func fetchUser(byPhoneNumber phoneNumber: Int16) -> LogInEntity? {
//        let request: NSFetchRequest<LogInEntity> = LogInEntity.fetchRequest()
//        request.predicate = NSPredicate(format: "phoneNumber == %d", phoneNumber)
//        request.fetchLimit = 1
//
//        do {
//            return try context.fetch(request).first
//        } catch {
//            print("❌ Fetch error: \(error)")
//            return nil
//        }
//    }
//
//    // MARK: - Fetch All
//    func fetchAllUsers() -> [LogInEntity] {
//        let request: NSFetchRequest<LogInEntity> = LogInEntity.fetchRequest()
//        do {
//            return try context.fetch(request)
//        } catch {
//            print("❌ Fetch error: \(error)")
//            return []
//        }
//    }
//
//    // MARK: - Update
//    func updateUser(phoneNumber: Int16, newRoleType: String?, newCountryName: String?, isUserLoggedIn: Bool) {
//        let request: NSFetchRequest<LogInEntity> = LogInEntity.fetchRequest()
//        request.predicate = NSPredicate(format: "phoneNumber == %d", phoneNumber)
//        
//        do {
//            let users = try context.fetch(request)
//            if let user = users.first {
//                user.roleType = newRoleType
//                user.countryName = newCountryName
//                user.isUserLoggedIn = isUserLoggedIn
//                saveContext()
//            }
//        } catch {
//            print("❌ Update error: \(error)")
//        }
//    }
//
//    // MARK: - Delete
//    func deleteUser(phoneNumber: Int16) {
//        let request: NSFetchRequest<LogInEntity> = LogInEntity.fetchRequest()
//        request.predicate = NSPredicate(format: "phoneNumber == %d", phoneNumber)
//        
//        do {
//            let users = try context.fetch(request)
//            for user in users {
//                context.delete(user)
//            }
//            saveContext()
//        } catch {
//            print("❌ Delete error: \(error)")
//        }
//    }
//
//    // MARK: - Save Context
//    private func saveContext() {
//        do {
//            try context.save()
//        } catch {
//            print("❌ Save error: \(error)")
//        }
//    }
}
