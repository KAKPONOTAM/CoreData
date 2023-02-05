import Foundation
import CoreData

final class CoreDataManager {
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataWork")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        return container
    }()
    
    lazy var viewContext = persistentContainer.viewContext
}

extension CoreDataManager {
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func retrieveMainUser() -> User {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: User.self))
        fetchRequest.predicate = NSPredicate(format: "isMain = true")
      
        if let users = try? viewContext.fetch(fetchRequest) as? [User], !users.isEmpty {
            return users.first!
        } else {
            let company = Company(context: viewContext)
            let user = User(context: viewContext)
            
            user.name = "Mark 777"
            user.age = 23
            user.company = company
            user.isMain = true
            
            do {
                try viewContext.save()
            } catch {
                print(error.localizedDescription)
            }
            
            return user
        }
    }
    
    func updateMainUser(name: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: User.self))
        fetchRequest.predicate = NSPredicate(format: "isMain = true")
        
        
        if let users = try? viewContext.fetch(fetchRequest) as? [User], !users.isEmpty {
            guard let mainUser = users.first else { return }
            
            mainUser.name = name
            
            try? viewContext.save()
        }
    }
    
    func removeMainUser() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: User.self))
        fetchRequest.predicate = NSPredicate(format: "isMain = true")
        
        if let users = try? viewContext.fetch(fetchRequest) as? [User], !users.isEmpty {
            guard let mainUser = users.first else { return }
            viewContext.delete(mainUser)
        }
    }
}
