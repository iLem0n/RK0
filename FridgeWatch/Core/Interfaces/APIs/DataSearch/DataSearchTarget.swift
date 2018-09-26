//
//  DataSearchTarget.swift
//  FridgeWatch
//
//  Created by iLem0n on 25.09.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import Foundation
import Moya

let dataSearchProvider = MoyaProvider<DataSearchTarget>()

enum DataSearchTarget: TargetType {
    case gtinsuche(String)
}

extension DataSearchTarget {
    var method: Moya.Method {
        return .get
    }
    
    var baseURL: URL {
        switch self {
        case .gtinsuche(_):
            return URL(string: "https://www.gtinsuche.de")!
        }
    }
    
    var path: String {
        switch self {
        case .gtinsuche(_):
            return "/detail"
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default:
            return nil
        }
    }
    
    var sampleData: Data {
        return Data(capacity: 0)
    }
    
    var task: Task {
        switch self {
        case .gtinsuche(let gtin):
            return .requestParameters(
                parameters: [
                    "ean": gtin
                ],
                encoding: URLEncoding.default)                    
        }
    }
    
    var validationType: ValidationType  {
        return .none
    }
    
    var responseParser: ResponseParserType {
        switch self {
        case .gtinsuche:
            return GTINSucheResponseParser()
        }
    }
}
