//
//  HeroSortingModel.swift
//  dota2heroes
//
//  Created by Eko Prasetiyo on 27/10/22.
//

import Foundation

struct HeroSortingModel: Decodable {
    let id: Int
    let label: String?
    let sortBy: String?
}

let heroSortingData: [HeroSortingModel] = [HeroSortingModel(id: 1, label: "Base Attack (Lower Limit)", sortBy: "base_attack_min"),HeroSortingModel(id: 2, label: "Base Health", sortBy: "base_health"),HeroSortingModel(id: 3, label: "Base Mana", sortBy: "base_mana"),HeroSortingModel(id: 4, label: "Base Speed", sortBy: "move_speed")]
