//
//  GoogleImageResponse.swift
//  FridgeWatch
//
//  Created by iLem0n on 25.09.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import Foundation
import UIKit

struct GoogleImageResponse: Decodable, ImageResponse {
    struct Item: Decodable {
        struct Pagemap: Decodable {
            struct ImageSrc: Decodable {
                let src: String
                
                private enum CodingKeys: String, CodingKey {
                    case src = "src"
                }
            }
            
            let imageSrc: [ImageSrc]?
            
            private enum CodingKeys: String, CodingKey {
                case imageSrc = "cse_image"
            }
        }
        
        let pagemap: Pagemap
        
        private enum CodingKeys: String, CodingKey {
            case pagemap = "pagemap"
        }
    }
    
    let items: [Item]
    
    private enum CodingKeys: String, CodingKey {
        case items = "items"
    }
    
    var images: [UIImage] {
        return self.items.compactMap({
            $0.pagemap.imageSrc?
                .compactMap({ $0.src })
                .compactMap({ URL(string: $0) })
                .compactMap({ try? Data(contentsOf: $0) })
                .compactMap({ UIImage(data: $0) })
        }).flatMap({ $0 })
    }
}
