//
//  Model.swift
//  MilanDemo
//
//  Created by Milan on 03/09/21.
//  Copyright © 2021 Milan. All rights reserved.
//

import Foundation

struct BaseModel : Decodable {
    
    let results : [Results]?

    enum CodingKeys: String, CodingKey {
        case results = "results"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        results = try values.decodeIfPresent([Results].self, forKey: .results)
    }

}

struct Results : Decodable {
    let title : String?
    let body : String?

    enum CodingKeys: String, CodingKey {
        case title = "title"
        case body = "body"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
      
        title = try values.decodeIfPresent(String.self, forKey: .title)
        body = try values.decodeIfPresent(String.self, forKey: .body)
    }

}
