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

let imageSearchBackend = MoyaProvider<ImageSearchAPI>()

enum ImageSearchAPI: TargetType {
    case getImage(String)
}

extension ImageSearchAPI {
    var baseURL: URL {
        return URL(string: "https://www.googleapis.com")!
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var path: String {
        switch self {
        case .getImage(_):
            return "/customsearch/v1"
        }
    }
    
    var sampleData: Data {        
        return try! Data(contentsOf: Bundle.main.url(forResource: "ImageSearchExampleResponse", withExtension: "json")!)
    }
    
    var parameters: [String: String]? {
        switch self {
        case .getImage(let searchTerm):
            return [
                "key": "AIzaSyDtKuugX8IZST_53LnIMkTjpazmBzfLUK8",
                "cx": "008282570450252504370:pgdswsw7nxo",
                "q": searchTerm
            ]
        }
    }
    
    var task: Task {
        return .requestParameters(parameters: self.parameters!, encoding: URLEncoding(destination: .queryString))
    }
    
    var validate: Bool {
        return false
    }
}
