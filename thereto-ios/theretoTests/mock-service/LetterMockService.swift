import RxSwift
import RxCocoa

@testable import thereto

struct LetterMockService: LetterServiceProtocol {
    func fetchLetters(receiverId: String) -> (Observable<[Letter]>) {
        let from = User(nickname: "보내는사람 닉네임", social: "apple", id: "idFrom", profileURL: "")
        let to = Friend(nickname: "받는사람 닉네임", social: "facebook", id: "idTo", profileURL: "")
        let location = Location(name: "장소 이름", addr: "주소주소", latitude: 0, longitude: 0)
        let letter = Letter(from: from, to: to, location: location, photo: "", message: "메시지 내용")
        
        return Observable.just([letter])
    }
}
