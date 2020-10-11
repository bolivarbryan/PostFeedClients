//
//  Post.swift
//  PostFeedClient-iOS
//
//  Created by Bryan A Bolivar M on 10/11/20.
//

import Foundation

// MARK: - Post
struct Post: Codable {
    let createdAt, author , storyTitle: String?
    let storyID: Int?
    let storyURL: String?
    let objectID: String?

    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case author
        case storyID = "story_id"
        case storyTitle = "story_title"
        case storyURL = "story_url"
        case objectID
    }
}

extension Post {
    var cellDescription: String {
        switch (author != nil, createdAt != nil) {
        case (true, true):
            return author! + " - " + createdAt!
        case (true, false):
            return author!
        case (false, true):
            return createdAt!
        case (false, false):
            return ""
        }
    }
    
    var cellTitle: String {
        return storyTitle ?? "No Title"
    }
}
