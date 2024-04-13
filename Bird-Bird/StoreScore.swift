//
//  StoreScore.swift
//  Bird-Bird
//
//  Created by Gia Huy on 17/04/2022.
//

import Foundation

struct SaveScore {
    
    static var bestScore: Int = Int()
    static var score: Int = 0
    
    static func Save() -> Int
    {
        if bestScore == 0
        {
            bestScore = score
        } else if bestScore != 0 && score > bestScore
        {
            bestScore = score
        }
        UserDefaults().set(bestScore, forKey: "bestScore")
        return bestScore
    }
}
