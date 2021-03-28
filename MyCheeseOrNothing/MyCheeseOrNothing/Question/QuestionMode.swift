//
//  QuestionMode.swift
//  MyCheeseOrNothing
//
//  Created by administrateur on 24/03/2021.
//

import Foundation;

public enum QuestionMode : String {
    case ALL = "all";
    case RANDOM = "random";
    case EASY = "easy";
    case MEDIUM = "medium";
    case HARD = "hard";
    
    public static func getModeFrench(mode : QuestionMode)  -> String {
        switch mode {
            case .EASY: return "Facile";
            case .MEDIUM: return "Moyen";
            case .HARD: return "Difficile";
            case .RANDOM: return "Aléatoire";
            default: return "Tout";
        }
    }
}
