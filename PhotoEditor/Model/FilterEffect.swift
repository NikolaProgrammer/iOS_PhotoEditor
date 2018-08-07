//
//  FilterEffect.swift
//  PhotoEditor
//
//  Created by Nikolay Sereda on 23.07.2018.
//  Copyright © 2018 Nikolay Sereda. All rights reserved.
//

import Foundation

struct FilterEffect {
    var name: String
    var effectValue: Any?
    var effectValueName: String?
}

extension FilterEffect: Equatable {
    static func == (lhs: FilterEffect, rhs: FilterEffect) -> Bool {
        return lhs.name == rhs.name
    }

}
