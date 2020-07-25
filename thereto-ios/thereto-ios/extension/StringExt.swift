import Foundation

extension String {
    
    var localized: String {
        return NSLocalizedString(self, tableName: "Localization", value: "에베베", comment: "")
    }
    
}
