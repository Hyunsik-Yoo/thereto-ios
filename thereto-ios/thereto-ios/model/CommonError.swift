import Foundation

struct CommonError: Error, CustomStringConvertible {

    let description: String
    
    init(desc: String) {
        self.description = desc
    }
}
