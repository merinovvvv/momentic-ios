//
//  UIFont+ReadexPro.swift
//  Momentic
//
//  Created by Yaraslau Merynau on 21.10.25.
//

import UIKit

extension UIFont {
    
    enum ReadexProWeight {
        case light
        case regular
        case medium
        case semiBold
        case bold
        
        var fontName: String {
            switch self {
            case .light:
                return "ReadexPro-Light"
            case .regular:
                return "ReadexPro-Regular"
            case .medium:
                return "ReadexPro-Medium"
            case .semiBold:
                return "ReadexPro-SemiBold"
            case .bold:
                return "ReadexPro-Bold"
            }
        }
    }
    
    static func readexPro(size: CGFloat, weight: ReadexProWeight = .regular) -> UIFont {
        guard let font = UIFont(name: weight.fontName, size: size) else {
            print("Failed to load font: \(weight.fontName). Using system font instead.")
            return UIFont.systemFont(ofSize: size)
        }
        return font
    }
}
