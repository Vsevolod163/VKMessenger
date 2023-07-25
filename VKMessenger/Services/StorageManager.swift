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
        let container = NSPersistentContainer(name: "VK")
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
    
    func fetchFriends(completion: (Result<[Friend], Error>) -> Void) {
        let fetchRequest = Friend.fetchRequest()
        
        do {
            let friends = try viewContext.fetch(fetchRequest)
            completion(.success(friends))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func fetchGroups(completion: (Result<[Group], Error>) -> Void) {
        let fetchRequest = Group.fetchRequest()
        
        do {
            let groups = try viewContext.fetch(fetchRequest)
            completion(.success(groups))
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
    
    func createFriend(id: Int, firstName: String, lastName: String, city: String, online: Int, photoTwoHundred: String) {
        let friend = Friend(context: viewContext)
        
        friend.id = Int64(id)
        friend.firstName = firstName
        friend.lastName = lastName
        friend.city = city
        friend.online = Int64(online)
        friend.photoTwoHundred = photoTwoHundred
        
        saveContext()
    }
    
    func createGroup(id: Int, name: String, groupDescription: String, photoTwoHundred: String) {
        let group = Group(context: viewContext)
        
        group.id = Int64(id)
        group.name = name
        group.groupDescription = groupDescription
        group.photoOneHundred = photoTwoHundred
        
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
    
    func deleteFriend(_ friend: Friend) {
        viewContext.delete(friend)
        
        saveContext()
    }
    
    func deleteGroup(_ group: Group) {
        viewContext.delete(group)
        
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
