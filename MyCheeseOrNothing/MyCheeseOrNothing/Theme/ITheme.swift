//
//  ITheme.swift
//  MyCheeseOrNothing
//
//  Created by administrateur on 24/03/2021.
//

import Foundation;
import UIKit;

public protocol ITheme {
    
    func colorPrimary() -> UIColor;
    func colorPrimaryVariant() -> UIColor;
    func colorOnPrimary() -> UIColor;
    
    func colorSecondary() -> UIColor;
    func colorSecondaryVariant() -> UIColor;
    func colorOnSecondary() -> UIColor;
    
    func colorNavBar() -> UIColor;
}
