//
//  DefaultTheme.swift
//  MyCheeseOrNothing
//
//  Created by administrateur on 24/03/2021.
//

import Foundation;
import UIKit;

public class DefaultTheme : ITheme {
 
    init() {
        
    }
    
    public func colorPrimary() -> UIColor {
        return UIColor.init(red: 255 / 255, green: 152 / 255, blue: 0 / 255, alpha: 255 / 255);
    }
    
    public func colorPrimaryVariant() -> UIColor {
        return UIColor.init(red: 255 / 255, green: 193 / 255, blue: 7 / 255, alpha: 255 / 255);
    }
    
    public func colorOnPrimary() -> UIColor {
        return UIColor.white;
    }
    
    public func colorSecondary() -> UIColor {
        return UIColor.init(red: 0 / 255, green: 107 / 255, blue: 255 / 255, alpha: 255 / 255);
    }
    
    public func colorSecondaryVariant() -> UIColor {
        return UIColor.init(red: 7 / 255, green: 117 / 255, blue: 255 / 255, alpha: 255 / 255);
    }
    
    public func colorOnSecondary() -> UIColor {
        return UIColor.white;
    }
    
    public func colorNavBar() -> UIColor {
        return colorPrimaryVariant();
    }
}
