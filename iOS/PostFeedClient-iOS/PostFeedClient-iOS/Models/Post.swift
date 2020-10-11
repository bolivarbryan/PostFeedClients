//
//  Post.swift
//  PostFeedClient-iOS
//
//  Created by Bryan A Bolivar M on 10/11/20.
//

import Foundation
import UIKit
import CoreData
// MARK: - Post
struct Post: Codable {
    /// Created timestamp from post
    private let createdAt: Date
    
    /// Author Name
    private let author: String?
    
    /// Story title
    private let storyTitle: String?
    
    /// Story URL for Post, used for see more details about post
    private let storyURL: String?
    
    /// Post identifier
    let objectID: String?
    
    /// coding keys for decoding from api Response
    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case author
        case storyTitle = "story_title"
        case storyURL = "story_url"
        case objectID
    }
    
    init(createdAt: Date, author: String?, storyTitle: String?, storyURL: String?, objectID: String?) {
        self.createdAt = createdAt
        self.author = author
        self.storyTitle = storyTitle
        self.storyURL = storyURL
        self.objectID = objectID
    }
}

extension Post {
    
    /// Cell Description  which helps to format post information in Cells.
    /// Contains author name with time ago info, just one of them or none
    var cellDescription: String {
        switch (author != nil, timeAgo != nil) {
        case (true, true):
            return author! + " - " + timeAgo!
        case (true, false):
            return author!
        case (false, true):
            return timeAgo!
        case (false, false):
            return ""
        }
    }
    
    /// Post title, in case post is nil format is set as 'No Title'
    var cellTitle: String {
        return storyTitle ?? "No Title"
    }
    
    ///Validated url from post, used for opening in a web browser
    var url: URL? {
        guard
            let urlString = storyURL,
            let url = URL(string: urlString),
            UIApplication.shared.canOpenURL(url)
        else { return nil }
        return url
    }
    
    var timeAgo: String? {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: createdAt, relativeTo: Date())
    }
}

/// Database
extension Post {
    func save() {
        guard
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
        else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "PostEntity", in: managedContext)!
        let post = NSManagedObject(entity: entity, insertInto: managedContext)
        
        post.setValue(createdAt, forKeyPath: "createdAt")
        post.setValue(storyTitle, forKeyPath: "storyTitle")
        post.setValue(author, forKeyPath: "author")
        post.setValue(storyURL, forKeyPath: "storyURL")
        post.setValue(objectID, forKeyPath: "id")
        post.setValue(false, forKeyPath: "deletedObject")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
