//
//  ContentView.swift
//  PostFeedClient-SwiftUI
//
//  Created by Bryan A Bolivar M on 10/12/20.
//

import SwiftUI
import CoreData
import SwiftUIRefresh
import Combine
import Networking

struct PostsView: View {
    let noTitle = "No Title"
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \PostEntity.createdAt, ascending: false)],
        predicate: NSPredicate(format: "deletedObject == %d", false),
        animation: .default)
    private var posts: FetchedResults<PostEntity>
    
    var viewModel = PostsListViewModel()
    
    @State private var isShowing = false
    @State var postsSubscriber: AnyCancellable?
    @State var postsObjects: [Post] = []

    private let itemFormatter: RelativeDateTimeFormatter = {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter
    }()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(posts)  { post in
                    VStack(alignment: .leading) {
                        Text(post.postRepresentation.cellTitle)
                            .font(.headline)
                            .padding(.bottom, 2)
                        Text(post.postRepresentation.cellDescription)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .pullToRefresh(isShowing: $isShowing) {
                reloadData()
            }
            .navigationTitle("Posts Feed")
            .onAppear() {
                reloadData()
            }
        }
   
    }

    func reloadData() {
        viewModel.fetch {
            viewModel.posts.forEach { (post) in
                self.addItem(post: post)
            }
            self.isShowing = false
        }
    }
    
    private func addItem(post: Post) {
        withAnimation {
            let postEntity = PostEntity(context: viewContext)
            postEntity.author = post.author
            postEntity.createdAt = post.createdAt
            postEntity.id = post.id
            postEntity.storyTitle = post.storyTitle
            postEntity.storyURL = post.storyURL
            postEntity.deletedObject = false
            do {
                viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { posts[$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        PostsView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
