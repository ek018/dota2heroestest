//
//  HomeViewModel.swift
//  dota2heroes
//
//  Created by Eko Prasetiyo on 27/10/22.
//

import Foundation

class HomeViewModel {
    
    func fetchHeroListStat(completionHandler: @escaping(HeroStats, [String]) -> Void) {
        guard let url = URL(string: "\(ApiServices.baseURL)/api/herostats") else {
            return
        }
        
        let data = URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                let decodeHero = try JSONDecoder().decode(HeroStats.self, from: data)
                let heroRoles = decodeHero.map(\.roles).flatMap { $0 }
                let heroRolesSet = Set<String>(heroRoles)
                var heroRolesArr = Array(heroRolesSet).sorted()
                heroRolesArr.insert("All", at: 0)
                completionHandler(decodeHero, heroRolesArr)
            } catch let error {
                print("error : \(error)")
            }
        }
        
        data.resume()
    }
}
