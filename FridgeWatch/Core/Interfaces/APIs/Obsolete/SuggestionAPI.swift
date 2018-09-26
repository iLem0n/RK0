////
////  SuggestionAPI.swift
////  FoodWatch
////
////  Created by Peter Christian Glade on 26.03.18.
////  Copyright © 2018 Peter Christian Glade. All rights reserved.
////
//
//import Foundation
//import Moya
//import RxMoya
//import UIKit
//import Freddy
//
//let suggestionsBackend = MoyaProvider<SuggestionAPI>()
//
//enum SuggestionAPI: TargetType {
//    case getSuggestions(String)
//}
//
//extension SuggestionAPI {
//    var baseURL: URL {
//        return URL(string: "http://suggestqueries.google.com")!
//    }
//
//    var headers: [String : String]? {
//        return nil
//    }
//
//    var method: Moya.Method {
//        return .get
//    }
//
//    var path: String {
//        switch self {
//        case .getSuggestions(_):
//            return "/complete/search"
//        }
//    }
//
//    var sampleData: Data {
//        return Data(capacity: 0)
//    }
//
//    var parameters: [String: String]? {
//        switch self {
//        case .getSuggestions(let searchTerm):
//            return [
//                "client": "firefox",
//                "output": "toolbar",
//                "hl": Locale.current.languageCode ?? "en",
//                "q": searchTerm,
//            ]
//        }
//    }
//
//    var task: Task {
//        return .requestParameters(parameters: self.parameters!, encoding: URLEncoding(destination: .queryString))
//    }
//
//    var validate: Bool {
//        return false
//    }
//}
