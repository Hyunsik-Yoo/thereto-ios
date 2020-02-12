import UIKit

class FindAddressVC: BaseVC {
    
    private lazy var findAddressView = FindAddressView.init(frame: self.view.frame)
    
    private var viewModel = FindAddressViewModel.init()
    
    static func instance() -> FindAddressVC {
        return FindAddressVC.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = findAddressView
        setupTableView()
        findAddress()
    }
    
    override func bindViewModel() {
        viewModel.jusoList.bind(to: findAddressView.tableView.rx.items(cellIdentifier: AddressCell.registerId, cellType: AddressCell.self)) { row, juso, cell in
            cell.bind(juso: juso)
        }.disposed(by: disposeBag)
    }
    
    override func bindEvent() {
        findAddressView.backBtn.rx.tap.bind {[weak self] in
            self?.navigationController?.popViewController(animated: true)
        }.disposed(by: disposeBag)
    }
    
    private func findAddress() {
        AddressService.searchAddress(keyword: "코엑스", page: 1) { [weak self] (jusoList) in
            self?.viewModel.jusoList.onNext(jusoList)
        }
    }
    
    private func setupTableView() {
        findAddressView.tableView.delegate = self
        findAddressView.tableView.register(AddressCell.self, forCellReuseIdentifier: AddressCell.registerId)
    }
}

extension FindAddressVC: UITableViewDelegate {
    
}
