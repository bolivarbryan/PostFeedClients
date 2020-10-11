import Foundation
import CoreData
import Moya

class PostsListViewModel {
    var posts: [Post] = [] {
        didSet {
            print(posts)
        }
    }
    
    func fetch(completion: @escaping () -> Void) {
        let provider = MoyaProvider<API>()
        provider.request(.request(query: "ios")) { result in
            switch result {
            case let .success(moyaResponse):
                let data = moyaResponse.data
                
                do {
                    let decoder = try JSONDecoder().decode(APIResponse.self, from: data)
                    self.posts = decoder.hits
                    completion()
                } catch {
                    print(error)
                }
            case let .failure(error):
                print(error)
            }
        }
    }
}

struct APIResponse: Codable {
    let hits: [Post]
}
