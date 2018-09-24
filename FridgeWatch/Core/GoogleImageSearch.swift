//
//  GoogleImageSearch.swift
//  FridgeWatch
//
//  Created by Peter Christian Glade on 23.09.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import Foundation
import Moya
import Result
import UIKit

let endpointProvider = MoyaProvider<EndpointTarget>()

enum EndpointTarget: TargetType {
    case googleImageSearch(String)
    case gtinsuche(String)
    case datakick(String)
    case codecheck(String)
}

extension EndpointTarget {
    var method: Moya.Method {
        return .get
    }
    
    var baseURL: URL {
        return URL(string: "https://www.googleapis.com")!
    }
    
    var path: String {
        return "/customsearch/v1"
    }
    
    var headers: [String: String]? {
        return nil
    }
    
    var sampleData: Data {
        return try! Data(contentsOf: Bundle.main.url(forResource: "ImageSearchExampleResponse", withExtension: "json")!)
    }
    
    var task: Task {
        switch self {
        case .getImage(let productID):
            return .requestParameters(
                parameters: [
                    "key": "AIzaSyDtKuugX8IZST_53LnIMkTjpazmBzfLUK8",
                    "cx": "008282570450252504370:pgdswsw7nxo",
                    "q": productID
                ],
                encoding: URLEncoding.default)
        }
    }
    
    var validationType: ValidationType {
        return .none
    }
    
    var responseParser: (Result<Response, MoyaError>) -> [UIImage] {
        return { result in
            log.debug(result)
            return []
        }
    }
}
