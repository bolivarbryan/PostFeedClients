import Foundation
import Moya

class PostsListViewModel {
    var posts: [Post] = []
    
    /// Fetches Posts from API for loading, but first returns what is currently stored in database
    func fetch(completion: @escaping () -> Void) {
        let provider = MoyaProvider<API>()
        provider.request(.request(query: "ios")) { result in
            switch result {
            case let .success(moyaResponse):
                let data = moyaResponse.data
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
                    let serializedResponse = try decoder.decode(APIResponse.self, from: data)
                    let postsResponse = serializedResponse.hits
                    postsResponse.forEach { (post) in
                    }
                    self.posts = postsResponse
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

/// Struct used for decoding API response in PostsListViewModel.fetch function
struct APIResponse: Codable {
    let hits: [Post]
}

extension DateFormatter {
    /// Adds support for iso8601Full date format
    static let iso8601Full: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}
