//
//  PostFeedClient_SwiftUIApp.swift
//  PostFeedClient-SwiftUI
//
//  Created by Bryan A Bolivar M on 10/12/20.
//

import SwiftUI

@main
struct PostFeedClient_SwiftUIApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            PostsView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
