//
//  Theme.swift
//  MyCheeseOrNothing
//
//  Created by administrateur on 24/03/2021.
//

import Foundation;
import UIKit;


public class Theme : ITheme {
    
    public static let getInstance = Theme();
    
    private var theme : ITheme;
    
    private init() {
        theme = DefaultTheme();
    }
    
    public func colorPrimary() -> UIColor {
        return self.theme.colorPrimary();
    }
    
    public func colorPrimaryVariant() -> UIColor {
        return self.theme.colorPrimaryVariant();
    }
    
    public func colorOnPrimary() -> UIColor {
        return self.theme.colorOnPrimary();
    }
    
    public func colorSecondary() -> UIColor {
        return self.theme.colorSecondary();
    }
    
    public func colorSecondaryVariant() -> UIColor {
        return self.theme.colorSecondaryVariant();
    }
    
    public func colorOnSecondary() -> UIColor {
        return self.theme.colorOnSecondary();
    }
    
    public func colorNavBar() -> UIColor {
        return self.theme.colorNavBar();
    }
    
    public func colorWrong() -> UIColor {
        return UIColor.init(red: 255 / 255, green: 17 / 255, blue: 17 / 255, alpha: 255 / 255);
    }
    
    public func colorGood() -> UIColor {
        return UIColor.init(red: 53 / 255, green: 134 / 255, blue: 34 / 255, alpha: 255 / 255);
    }
}
