import UIKit

extension UIColor {
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1.0) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: a)
    }
    
    class var themeColor: UIColor {
        return UIColor.init(r: 255, g: 248, b: 239)
    }
    
    class var orangeRed: UIColor {
        return UIColor.init(r: 255, g: 84, b: 41)
    }
    
    class var black30: UIColor {
        return UIColor.init(r: 30, g: 30, b: 30)
    }
    
    class var veryLightPink: UIColor {
        return UIColor.init(r: 255, g: 248, b: 239)
    }
    
    class var brownishGrey: UIColor {
        return UIColor.init(r: 114, g: 95, b: 95)
    }
    
    class var greyishBrown: UIColor {
        return UIColor.init(r: 60, g: 46, b: 42)
    }
    
    class var mushroom: UIColor {
        return UIColor.init(r: 165, g: 156, b: 156)
    }
    
    class var mudBrown: UIColor {
        return UIColor.init(r: 66, g: 40, b: 15)
    }
    
    class var pinkishGrey: UIColor {
        return UIColor.init(r: 208, g: 179, b: 168)
    }
    
    class var brownGrey: UIColor {
        return UIColor.init(r: 139, g: 139, b: 139)
    }
    
    class var black49: UIColor {
        return UIColor.init(r: 49, g: 49, b: 49)
    }
    
    class var greyishBrownTwo: UIColor {
        return UIColor.init(r: 74, g: 74, b: 74)
    }
    
    class var greyishBrownThree: UIColor {
        return UIColor.init(r: 79, g: 66, b: 65)
    }
    
    class var mushroomTwo: UIColor {
        return UIColor.init(r: 183, g: 162, b: 157)
    }
}
