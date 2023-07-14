//
//  StorageManager.swift
//  WebViewApp
//
//  Created by Vsevolod Lashin on 15.07.2023.
//

import CoreData

final class StorageManager {
    static var shared = StorageManager()
    
    // MARK: - Core Data Stack
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ChatList")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        return container
    }()
    
    private let viewContext: NSManagedObjectContext
    private init() {
        viewContext = persistentContainer.viewContext
    }
    
    // MARK: - CRUD
    func fetchData(completion: (Result<[Chat], Error>) -> Void) {
        let fetchRequest = Chat.fetchRequest()
        
        do {
            let chats = try viewContext.fetch(fetchRequest)
            completion(.success(chats))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func create(id: Int, messages: [String]) {
        let chat = Chat(context: viewContext)
        
        chat.id = Int64(id)
        chat.messages = messages
        
        saveContext()
    }
    
    func update(_ chat: Chat, message: String) {
        chat.messages?.append(message)
        
        saveContext()
    }
    
    func delete(_ chat: Chat) {
        viewContext.delete(chat)

        saveContext()
    }
    
    func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
