//
//  Markup.swift
//  JSONLayout
//
//  Created by Maxim Volgin on 10/02/2019.
//  Copyright © 2019 Maxim Volgin. All rights reserved.
//

import Foundation

struct MarkupLayout: Codable {
    var views: [String: MarkupElement]
    var metrics: [String: Float]
    var constraints: [String: String]
}

struct MarkupElement: Codable {
    var type: String
    var children: [String: MarkupElement]?
}
