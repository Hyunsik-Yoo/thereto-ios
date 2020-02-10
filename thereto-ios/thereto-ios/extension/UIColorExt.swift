import UIKit

extension UIColor {
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1.0) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: a)
    }
    
    class var themeColor: UIColor? {
        return UIColor.init(r: 255, g: 248, b: 239)
    }
    
    class var orange_red: UIColor {
        return UIColor.init(r: 255, g: 84, b: 41)
    }
    
    class var black_30: UIColor {
        return UIColor.init(r: 30, g: 30, b: 30)
    }
    
    class var veryLightPink: UIColor {
        return UIColor.init(r: 255, g: 248, b: 239)
    }
    
    class var brownish_grey: UIColor {
        return UIColor.init(r: 114, g: 95, b: 95)
    }
    
    class var greyishBrown: UIColor {
        return UIColor.init(r: 60, g: 46, b: 42)
    }
    
    class var mushroom: UIColor {
        return UIColor.init(r: 165, g: 156, b: 156)
    }
}
