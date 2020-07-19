import RxSwift

class AddFriendViewModel: BaseViewModel {
    
    var userService: UserServiceProtocol
    var userDefaults: UserDefaultsUtil
    var input: Input
    var output: Output
    
    struct Input {
        var nicknameText: AnyObserver<String>
        var tapSearch: AnyObserver<Void>
        var requestFriend: AnyObserver<Int>
    }
    
    struct Output {
        var userList: Observable<[Friend]>
        var dataMode: Observable<AddFriendView.DataType>
        var showLoading: Observable<Bool>
        var showAlert: Observable<(String, String)>
    }
    
    let nicknameTextPublisher = PublishSubject<String>()
    let tapSearchPublisher = PublishSubject<Void>()
    let requestFirendPublisher = PublishSubject<Int>()
    
    let userListPublisher = PublishSubject<[Friend]>()
    let dataModePublisher = PublishSubject<AddFriendView.DataType>()
    let friendListPublisher = PublishSubject<[Friend]>()
    let myInfoPublisher = PublishSubject<Friend>()
    let showLoadingPublisher = PublishSubject<Bool>()
    let showAlertPublisher = PublishSubject<(String, String)>()
    
    init(userService: UserServiceProtocol,
         userDefaults: UserDefaultsUtil) {
        self.userService = userService
        self.userDefaults = userDefaults
        input = Input(nicknameText: nicknameTextPublisher.asObserver(),
                       tapSearch: tapSearchPublisher.asObserver(),
                       requestFriend: requestFirendPublisher.asObserver())
        output = Output(userList: userListPublisher,
                        dataMode: dataModePublisher,
                        showLoading: showLoadingPublisher,
                        showAlert: showAlertPublisher)
        super.init()
        
        tapSearchPublisher.withLatestFrom(Observable.combineLatest(nicknameTextPublisher, friendListPublisher)).bind { [weak self] (nickname, friends) in
            guard let self = self else { return }
            
            if nickname.isEmpty {
                self.showAlertPublisher.onNext(("유저 조회 오류", "닉네임을 제대로 입력해주세요."))
                return
            }
            
            self.showLoadingPublisher.onNext(true)
            userService.findUser(nickname: nickname) { (userObservable) in
                userObservable.subscribe(onNext: { (userList) in
                    let filteredList = userList.filter { (user) -> Bool in
                        !friends.contains { (friend) -> Bool in
                            friend.nickname == user.nickname && friend.requestState == State.FRIEND
                        }
                    }.map { (user) -> Friend in
                        if friends.contains(where: { (friend) -> Bool in
                            friend.nickname == user.nickname
                        }) {
                            var newUser = Friend(user: user)
                            newUser.requestState = State.REQUEST_SENT
                            return newUser
                        } else {
                            return Friend(user: user)
                        }
                    }
                    
                    self.dataModePublisher.onNext(filteredList.isEmpty ? .NOTEXIST : .EXIST)
                    self.userListPublisher.onNext(filteredList)
                    self.showLoadingPublisher.onNext(false)
                }, onError: { (error) in
                    if let error = error as? CommonError {
                        self.showAlertPublisher.onNext(("유저 조회 오류", error.description))
                    } else {
                        self.showAlertPublisher.onNext(("유저 조회 오류", error.localizedDescription))
                    }
                    self.showLoadingPublisher.onNext(false)
                }).disposed(by: self.disposeBag)
            }
        }.disposed(by: disposeBag)
        
        requestFirendPublisher.withLatestFrom(Observable.combineLatest(requestFirendPublisher, userListPublisher, myInfoPublisher)).bind { [weak self] (index, friends, myInfo) in
            guard let self = self else { return }
            var friend = friends[index]
            // 주고받은 편지 개수 초기화
            friend.requestState = .REQUEST_SENT
            friend.receivedCount = 0
            friend.sentCount = 0
            
            self.showLoadingPublisher.onNext(true)
            userService.requestFriend(id: self.userDefaults.getUserToken()!, friend: friend, withAlarm: false) { (observable) in
                observable.subscribe(onNext: { (_) in
                    // 내 친구가 추가되었을때, 친구 필드에도 나를 WAIT 상태로 추가해야합니다.
                    // 친구 요청 완료한 뒤, 앱 화면 초기화 시켜야합니다.
                    userService.requestFriend(id: friend.id, friend: myInfo, withAlarm: true) { (observable) in
                        observable.subscribe(onNext: { (_) in
                            self.showAlertPublisher.onNext(("","친구 요청 성공"))
                            self.userService.insertAlarm(userId: friend.id, type: .NEW_REQUEST)
                            self.nicknameTextPublisher.onNext("")
                            self.showLoadingPublisher.onNext(false)
                            self.dataModePublisher.onNext(.DEFAULT)
                            self.fetchFriend()
                        }, onError: { (error) in
                            self.showAlertPublisher.onNext(("친구 요청 오류", error.localizedDescription))
                            self.showLoadingPublisher.onNext(false)
                        }).disposed(by: self.disposeBag)
                    }
                }, onError: { (error) in
                    self.showAlertPublisher.onNext(("친구 요청 오류", error.localizedDescription))
                    self.showLoadingPublisher.onNext(false)
                }).disposed(by: self.disposeBag)
            }
        }.disposed(by: disposeBag)
    }
        
    func fetchFriend() {
        self.showLoadingPublisher.onNext(true)
        userService.getFriends(id: userDefaults.getUserToken()!) { [weak self] (friendsObservable) in
            guard let self = self else { return }
            friendsObservable.subscribe(onNext: { (friendList) in
                self.friendListPublisher.onNext(friendList)
                self.showLoadingPublisher.onNext(false)
            }, onError: { (error) in
                if let error = error as? CommonError {
                    self.showAlertPublisher.onNext(("친구 조회 오류", error.description))
                } else {
                    self.showAlertPublisher.onNext(("친구 조회 오류", error.localizedDescription))
                }
                self.showLoadingPublisher.onNext(false)
            }).disposed(by: self.disposeBag)
        }
    }
    
    func fetchMyInfo() {
        self.showLoadingPublisher.onNext(true)
        userService.getUserInfo(token: userDefaults.getUserToken()!) { [weak self] (userObservable) in
            guard let self = self else { return }
            userObservable.subscribe(onNext: { (user) in
                var my2Friend = Friend(user: user)
                my2Friend.receivedCount = 0
                my2Friend.sentCount = 0
                my2Friend.requestState = .WAIT
                self.myInfoPublisher.onNext(my2Friend)
                self.showLoadingPublisher.onNext(false)
            }, onError: { (error) in
                if let error = error as? CommonError {
                    self.showAlertPublisher.onNext(("내정보 조회 오류", error.description))
                } else {
                    self.showAlertPublisher.onNext(("내정보 조회 오류", error.localizedDescription))
                }
                self.showLoadingPublisher.onNext(false)
            }).disposed(by: self.disposeBag)
        }
    }
}
