//
//  DataModel.swift
//  WaifuOrNot
//
//  Created by Wei Chang Lin on 2023-01-01.
//

import Foundation

struct Response: Codable {
    var images: [Image]
}


struct Image: Codable {
    var signature: String
    var favourites: Int
    var source: String
    var width: Int
    var height: Int
    var url: String
}
