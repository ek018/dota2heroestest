//
//  HeroBaseStatModel.swift
//  dota2heroes
//
//  Created by Eko Prasetiyo on 21/10/22.
//

import Foundation

struct HeroBaseStatModel: Decodable {
    let id: Int
    let icon: String?
    let baseStatus: String?
    let baseStatusData: Int?
}
