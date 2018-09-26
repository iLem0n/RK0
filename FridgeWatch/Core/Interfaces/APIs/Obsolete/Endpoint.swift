////
////  GTINAPITarget.swift
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
//
//let searchProvider = MoyaProvider<Endpoint>()
//
//enum Endpoint: TargetType {
//    case google(String)
//    case codecheck(String)
//    case gtinsuche(String)
//    case datakick(String)
////    case suggestion(String)
//}
//
//extension Endpoint {
//    var baseURL: URL {
//        switch self {
//        case .codecheck:
//            return URL(string: "https://www.codecheck.info")!
//        case .google:
//            return URL(string: "https://www.googleapis.com")!
//        case .gtinsuche:
//            return URL(string: "https://www.gtinsuche.de")!
//        case .datakick:
//            return URL(string: "https://www.datakick.org")!
////        case .suggestion:
////            return URL(string: "http://suggestqueries.google.com")!
////        }
//    }
//    
//    var headers: [String : String]? {
//        switch self {
//        case .codecheck:
//            return nil
//        case .google:
//            return nil
//        case .gtinsuche:
//            return nil
//        case .datakick:
//            return [
//                "Content-Type": "application/json",
//                "api-key": "ac7677d8-b9ce-4ae5-9686-c5a2d8eba075"
//            ]
//        }
//    }
//    
//    var method: Moya.Method {
//        return .get
//    }
//    
//    var path: String {
//        switch self {
//        case .codecheck:
//            return "/product.search"
//        case .google:
//            return "/customsearch/v1"
//        case .gtinsuche:
//            return "/detail"
//        case .datakick(let gtin):
//            return "/api/items/\(gtin)"
//        }
//    }
//    
//    var sampleData: Data {
//        switch self {
//        case .google:
//            return try! Data(contentsOf: Bundle.main.url(forResource: "ImageSearchExampleResponse", withExtension: "json")!)
//        default: break
//        }
//
//        return Data(capacity: 0)
//    }
//    
//    var parameters: [String: String]? {
//        return nil
//    }
//    
//    var task: Task {
//        switch self {
//        case .codecheck(let gtin):
//            return .requestParameters(
//                parameters: [
//                    "q": gtin
//                ],
//                encoding: URLEncoding.default)
//        case .google(let gtin):
//            return .requestParameters(
//                parameters: [
//                    "key": "AIzaSyDtKuugX8IZST_53LnIMkTjpazmBzfLUK8",
//                    "cx": "008282570450252504370:pgdswsw7nxo",
//                    "q": gtin
//                ],
//                encoding: URLEncoding.default)
//        case .gtinsuche(let gtin):
//            return .requestParameters(
//                parameters: [
//                    "ean": gtin
//                ],
//                encoding: URLEncoding.default)
//        default: return .requestPlain
//        }
//    }
//    
//    var validate: Bool {
//        return false
//    }
//    
//    func itemFound(data: Data) -> Bool {
//        switch self {
//        case .codecheck:
//            return false
//        case .google:
//            return false
//        case .gtinsuche:
//            guard let string = String(data: data, encoding: String.Encoding.utf8) else { return false }
//            if string == "EAN nicht eingetragen!" { return false }
//            return true
//        case .datakick:
//            guard let json = try? JSON(data: data)
//                else {
//                    let dataString = String(describing: String(data: data, encoding: String.Encoding.utf8))
//                    log.error("Unable to convert data to JSON:\nData:\n\(dataString)")
//                    return false
//            }
//            guard let message = try? json.getString(at: "message"), message == "Item not found" else { return true }
//            return false
//        }
//    }
//    
//    var parser: ProductDataResponseParserType {
//        switch self {
//        case .gtinsuche:
//            return GTINSucheResponseParser()
//        case .codecheck:
//            return CodecheckResponseParser()
//        case .datakick:
//            return DataKickResponseParser()
//        case .google:
//            return GoogleSearchResponseParser()
//        }
//    }
//}
