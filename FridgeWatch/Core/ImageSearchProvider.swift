//
//  SearchProvider.swift
//  FridgeWatch
//
//  Created by Peter Christian Glade on 23.09.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import Moya

let searchProvider = MoyaProvider<SearchTarget>()

enum SearchKey {
    case productName
    case productImage
}

enum SearchTarget: TargetType {
    case search(SearchKey, String)
}

extension SearchTarget {
    var method: Method {
        return .get
    }

    var baseURL: URL {
        switch self {
        case .search(let key, let productID):
            switch key {
            case .productName:
                
            case .productImage:
                return URL(string: "https://www.googleapis.com")!
            }
        }
    }
    
    var path: String {
        switch self {
        case .search(let key, let productID):
            switch key {
            case .productName:
                
            case .productImage:
                
            }
        }
    }

    var headers: [String : String]? {
        switch self {
        case .search(let key, let productID):
            switch key {
            case .productName:
                
            case .productImage:
                
            }
        }
    }
    
    var sampleData: Data {
        switch self {
        case .search(let key, let productID):
            switch key {
            case .productName:
                
            case .productImage:
                
            }
        }
    }
    
    var task: Task {
        switch self {
        case .search(let key, let productID):
            switch key {
            case .productName:
                
            case .productImage:
                
            }
        }
    }
    
    var validationType: ValidationType {
        return .none
    }
}


