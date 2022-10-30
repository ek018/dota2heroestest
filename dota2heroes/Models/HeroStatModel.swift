//
//  HeroStatModel.swift
//  dota2heroes
//
//  Created by Eko Prasetiyo on 27/10/22.
//

import Foundation

// MARK: - HeroStat
struct HeroStat: Codable {
    let id: Int
    let name, localizedName, primaryAttr, attackType: String?
    let roles: [String]
    let img, icon: String?
    let baseHealth: Int?
    let baseHealthRegen, baseManaRegen, baseArmor: Double?
    let baseMana, baseMr: Int?
    let baseAttackMin, baseAttackMax, baseStr, baseAgi: Int?
    let baseInt: Int?
    let moveSpeed: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case localizedName = "localized_name"
        case primaryAttr = "primary_attr"
        case attackType = "attack_type"
        case roles, img, icon
        case baseHealth = "base_health"
        case baseHealthRegen = "base_health_regen"
        case baseMana = "base_mana"
        case baseManaRegen = "base_mana_regen"
        case baseArmor = "base_armor"
        case baseMr = "base_mr"
        case baseAttackMin = "base_attack_min"
        case baseAttackMax = "base_attack_max"
        case baseStr = "base_str"
        case baseAgi = "base_agi"
        case baseInt = "base_int"
        case moveSpeed = "move_speed"
        
    }
}

typealias HeroStats = [HeroStat]

