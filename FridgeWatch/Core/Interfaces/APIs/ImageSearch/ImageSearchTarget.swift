//
//  ImageSearchAPI.swift
//  FoodWatch
//
//  Created by Peter Christian Glade on 20.05.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import Foundation
import Moya
import RxMoya
import UIKit
import Freddy

let imageSearchBackend = MoyaProvider<ImageSearchTarget>()

enum ImageSearchTarget: TargetType {
    case googleImageSearch(String)
}

extension ImageSearchTarget {
    var baseURL: URL {
        switch self {
        case .googleImageSearch:
        return URL(string: "https://www.googleapis.com")!
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .googleImageSearch:
            return nil
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .googleImageSearch:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .googleImageSearch:
            return "/customsearch/v1"
        }
    }
    
    var sampleData: Data {        
        return try! Data(contentsOf: Bundle.main.url(forResource: "ImageSearchExampleResponse", withExtension: "json")!)
    }
    
    var parameters: [String: String]? {
        switch self {
        case .googleImageSearch(let searchTerm):
            return [
                "key": "AIzaSyDtKuugX8IZST_53LnIMkTjpazmBzfLUK8",
                "cx": "008282570450252504370:pgdswsw7nxo",
                "q": searchTerm
            ]
        }
    }
    
    var task: Task {
        switch self {
        case .googleImageSearch:
            return .requestParameters(parameters: self.parameters!, encoding: URLEncoding(destination: .queryString))
        }
    }
    
    var validate: Bool {
        return false
    }
    
    var responseParser: ResponseParserType {
        switch self {
        case .googleImageSearch:
            return GoogleImageResponseParser()
        }
    }
}
