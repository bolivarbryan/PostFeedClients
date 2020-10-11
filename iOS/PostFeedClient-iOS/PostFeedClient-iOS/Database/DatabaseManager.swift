//
//  DatabaseManager.swift
//  PostFeedClient-iOS
//
//  Created by Bryan A Bolivar M on 10/11/20.
//

import Foundation
import CoreData
import UIKit

class DatabaseManager {
    /// Fetched posts from local Database
    var posts: [NSManagedObject] = []
    
    ///Singleton Property for easy DB handling
    static let shared = DatabaseManager()
    
    init(){}
    
    func delete(post: Post) {
        guard
            let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let id = post.objectID
        else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "PostEntity")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        do {
            let object = try managedContext.fetch(fetchRequest)
            if let postObject = object.first {
                postObject.setValue(true, forKeyPath: "deletedObject")
                do {
                    try managedContext.save()
                } catch let error as NSError {
                    print("Could not fetch. \(error), \(error.userInfo)")
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    /// Fetches all posts that are not marked as deleted
    func getPosts() ->  [Post] {
        guard
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
        else { return [] }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "PostEntity")
        fetchRequest.predicate = NSPredicate(format: "deletedObject == %d", false)
        let sort = NSSortDescriptor(key: "createdAt", ascending: false)
        fetchRequest.sortDescriptors = [sort]
        
        do {
            posts = try managedContext.fetch(fetchRequest)
            let postsResult = posts.compactMap { object -> Post? in
                guard
                    let date = object.value(forKey: "createdAt") as? Date,
                    let author = object.value(forKey: "author") as? String,
                    let storyTitle = object.value(forKey: "storyTitle") as? String,
                    let storyURL = object.value(forKey: "storyURL") as? String,
                    let objectID = object.value(forKey: "id") as? String
                else { return nil }
                
                return Post(createdAt: date, author: author, storyTitle: storyTitle, storyURL: storyURL, objectID: objectID)
            }
            
            return postsResult
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return []
    }
    
    
    
}
