import UIKit

class FriendTableVC: BaseVC {
    
    private lazy var friendTableView = FriendTableView.init(frame: self.view.frame)
    
    static func instance() -> FriendTableVC {
        return FriendTableVC.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = friendTableView
        friendTableView.tableView.delegate = self
        friendTableView.tableView.dataSource = self
        friendTableView.tableView.register(FriendControlCell.self, forCellReuseIdentifier: FriendControlCell.registerId)
    }
    
    override func bindViewModel() {
        
    }
}

extension FriendTableVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FriendControlCell.registerId, for: indexPath) as? FriendControlCell else {
            return BaseTableViewCell()
        }
        
        return cell
    }
}
