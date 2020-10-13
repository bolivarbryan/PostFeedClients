//
//  PreviewData.swift
//  FaceValidator
//
//  Created by Bryan Bolivar on 9/10/20.
//

import Foundation

protocol PreviewData {
    associatedtype myType
    static var data: myType { get  }
}

extension Post: PreviewData {
    typealias myType = Post
    
    static var data: Post {
        return Post(createdAt: Date(), author: "Bryan", storyTitle: "Test", storyURL: "http://www.google.com", objectID: "0")
    }
    
    static var previewArray: [Post] {
        return [
          
        ]
    }
    
}
