//
//  HomeViewModel.swift
//  dota2heroes
//
//  Created by Eko Prasetiyo on 19/10/22.
//

import Foundation

class HomeViewModel {
    func combine<T>(_ arrays: Array<T>?...) -> Set<T> {
        return arrays.compactMap{$0}.compactMap{Set($0)}.reduce(Set<T>()){$0.union($1)}
    }
    
    func fetchHeroListStat(completionHandler: @escaping(HeroStats) -> Void) {
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
                completionHandler(decodeHero)
            } catch let error {
                print("error : \(error)")
            }
        }
        
        data.resume()
    }
}
