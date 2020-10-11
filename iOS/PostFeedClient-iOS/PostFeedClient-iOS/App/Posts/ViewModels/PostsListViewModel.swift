import Foundation
import CoreData
import Moya

class PostsListViewModel {
    var posts: [Post] = []
    
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
                    self.posts = serializedResponse.hits
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

extension DateFormatter {
    static let iso8601Full: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}
