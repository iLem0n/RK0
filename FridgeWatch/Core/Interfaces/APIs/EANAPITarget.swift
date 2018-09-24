//
//  GTINAPITarget.swift
//  FoodWatch
//
//  Created by Peter Christian Glade on 26.03.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import Foundation
import Moya
import RxMoya
import UIKit
import Freddy


let searchProviderOld = MoyaProvider<APITarget>()
enum APIDataTypeKey {
    case productName
    case productImage
}

enum APITarget: TargetType {
    case getInfo(API, APIDataTypeKey)
}

extension APITarget {
    static var userID: String { return "" }

    var baseURL: URL {
        return URL(string: "https://www.codecheck.info")!
//        switch self {
//        case .getData(let api, _):
//            switch api {
//            case .codecheck:
//                return URL(string: "https://www.codecheck.info")!
//            case .googleImageSearch:
//                return URL(string: "https://www.googleapis.com")!
//            case .gtinsuche:
//                return URL(string: "https://www.gtinsuche.de")!
//            case .datakick:
//                return URL(string: "https://www.datakick.org")!
//            }
//        }
    }
    
    var headers: [String : String]? {
        return nil
//        switch self {
//        case .getData(let api, _):
//            switch api {
//            case .codecheck:
//                return nil
//            case .googleImageSearch:
//                return nil
//            case .gtinsuche:
//                return nil
//            case .datakick:
//                return [
//                    "Content-Type": "application/json",
//                    "api-key": "ac7677d8-b9ce-4ae5-9686-c5a2d8eba075"
//                ]
//            }
//        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getInfo(_, _):
            return .get
        }
    }
    
    var path: String {
        return ""
//        switch self {
//        case .getInfo(let api, let gtin):
//            switch api {
//            case .codecheck:
//                return "/product.search"
//            case .google:
//                return "/customsearch/v1"
//            case .gtinsuche:
//                return "/detail"
//            case .datakick:
//                return "/api/items/\(gtin)"
//            }
//        }
    }
    
    var sampleData: Data {
        
//        switch self {
//        case .getInfo(let api, _):
//            switch api {
//            case .google:
//                return try! Data(contentsOf: Bundle.main.url(forResource: "ImageSearchExampleResponse", withExtension: "json")!)
//            default: break
//            }
//        }
        return Data(capacity: 0)
    }
    
    var parameters: [String: String]? {
        switch self {
        case .getInfo(_, _):
            return nil
        }
    }
    
    var task: Task {
//        switch self {
//        case .getInfo(let api, let gtin):
//            switch api {
//            case .codecheck:
//                return .requestParameters(
//                    parameters: [
//                        "q": gtin
//                    ],
//                    encoding: URLEncoding.default)
//            case .google:
//                return .requestParameters(
//                    parameters: [
//                        "key": "AIzaSyDtKuugX8IZST_53LnIMkTjpazmBzfLUK8",
//                        "cx": "008282570450252504370:pgdswsw7nxo",
//                        "q": gtin
//                    ],
//                    encoding: URLEncoding.default)
//            case .gtinsuche:
//                return .requestParameters(
//                    parameters: [
//                        "ean": gtin
//                    ],
//                    encoding: URLEncoding.default)
//            default: return .requestPlain
//            }
//        }
        return .requestPlain
    }
    
    var validate: Bool {
        return false
    }
}
