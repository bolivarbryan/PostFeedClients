//
//  API.swift
//  PostFeedClient-iOS
//
//  Created by Bryan A Bolivar M on 10/11/20.
//

import Foundation
import Moya

enum API {
    case request(query: String)
}

extension API: TargetType {
    
    public var baseURL: URL { return URL(string: "https://hn.algolia.com")! }

    public var path: String {
        switch self {
        case .request:
            return "/api/v1/search_by_date"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .request:
            return .get
        }
    }

    public var task: Task {
        switch self {
        case .request(let query):
            return .requestParameters(parameters: ["query": query], encoding: URLEncoding.default)
        }
    }

    var headers: [String: String]? {
        return ["Cookie" : "__cfduid=d43aada735e2d00bd520559a4a58f51071602436013"]
    }

    public var sampleData: Data {
        switch self {
        case .request:
            return "{}".data(using: String.Encoding.utf8)!
        }
    }
}



