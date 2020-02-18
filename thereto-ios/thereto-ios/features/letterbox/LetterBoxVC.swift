import UIKit

class LetterBoxVC: BaseVC {
    
    private lazy var letterBoxView: LetterBoxView = {
        let view = LetterBoxView(frame: self.view.bounds)
        
        view.isUserInteractionEnabled = true
        return view
    }()
    
    
    static func instance() -> UINavigationController {
        let controller = LetterBoxVC(nibName: nil, bundle: nil)
        
        controller.tabBarItem = UITabBarItem.init(title: "수신함", image: UIImage.init(named: "ic_letter_box_off"), selectedImage: UIImage.init(named: "ic_letter_box_on"))
        return UINavigationController(rootViewController: controller)
    }
    
    
    override func viewDidLoad() {
        navigationController?.isNavigationBarHidden = true
        view.addSubview(letterBoxView)
        letterBoxView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        letterBoxView.topBar.setLetterBoxMode()
        
        letterBoxView.tableView.separatorStyle = .none
        letterBoxView.tableView.delegate = self
        letterBoxView.tableView.dataSource = self
        letterBoxView.tableView.register(LetterCell.self, forCellReuseIdentifier: LetterCell.registerId)
    }
    
    override func bindViewModel() {
        
    }
}

extension LetterBoxVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.letterBoxView.tableView.dequeueReusableCell(withIdentifier: LetterCell.registerId, for: indexPath) as? LetterCell else {
            return UITableViewCell()
        }
        
        return cell
    }
}
