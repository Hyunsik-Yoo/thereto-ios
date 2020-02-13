import UIKit

protocol FindAddressDelegate {
    func onSelectAddress(juso: Juso)
}
class FindAddressVC: BaseVC {
    
    private lazy var findAddressView = FindAddressView.init(frame: self.view.frame)
    
    private var viewModel = FindAddressViewModel.init()
    
    private var currentPage = 1
    
    private var keyword = ""
    
    private var totalPage = 0
    
    var delegate: FindAddressDelegate?
    
    
    static func instance() -> FindAddressVC {
        return FindAddressVC.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = findAddressView
        setupTableView()
    }
    
    override func bindViewModel() {
        viewModel.jusoList.bind(to: findAddressView.tableView.rx.items(cellIdentifier: AddressCell.registerId, cellType: AddressCell.self)) { [weak self] row, juso, cell in
            if let vc = self {
                cell.bind(juso: juso, keyword: vc.findAddressView.addressField.text!)
            }
        }.disposed(by: disposeBag)
    }
    
    override func bindEvent() {
        findAddressView.backBtn.rx.tap.bind {[weak self] in
            self?.navigationController?.popViewController(animated: true)
        }.disposed(by: disposeBag)
        
        findAddressView.searchBtn.rx.tap.bind {[weak self] in
            if let vc = self {
                let keyword = vc.findAddressView.addressField.text!
                vc.keyword = keyword
                vc.findAddress(keyword: vc.keyword)
            }
        }.disposed(by: disposeBag)
        
        findAddressView.addressField.rx.controlEvent(.editingDidEndOnExit).subscribe {[weak self] (_) in
            if let vc = self {
                let keyword = vc.findAddressView.addressField.text!
                vc.keyword = keyword
                vc.findAddress(keyword: vc.keyword)
            }
        }.disposed(by: disposeBag)
    }
    
    private func findAddress(keyword: String) {
        AddressService.searchAddress(keyword: keyword, page: currentPage) { [weak self] (jusoResults) in
            if let vc = self {
                vc.totalPage = Int(jusoResults.common.totalCount)!
                if jusoResults.juso != nil {
                    vc.viewModel.jusoList.onNext(jusoResults.juso)
                } else {
                    AlertUtil.show(controller: vc, title:"error", message: jusoResults.common.errorMessage)
                }
            }
        }
    }
    
    private func setupTableView() {
        findAddressView.tableView.delegate = self
        findAddressView.tableView.register(AddressCell.self, forCellReuseIdentifier: AddressCell.registerId)
    }
    
    private func loadMore() {
        currentPage += 1
        AddressService.searchAddress(keyword: keyword, page: currentPage) { [weak self] (jusoResults) in
            if let vc = self {
                var newJusoList = try! vc.viewModel.jusoList.value()
                newJusoList.append(contentsOf: jusoResults.juso)
                vc.viewModel.jusoList.onNext(newJusoList)
            }
        }
    }
}

extension FindAddressVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let numberOfItems = try! self.viewModel.jusoList.value().count
        if indexPath.row == numberOfItems - 1 && self.currentPage < self.totalPage {
            self.loadMore()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let jusoList = try! self.viewModel.jusoList.value()
        
        delegate?.onSelectAddress(juso: jusoList[indexPath.row])
        self.navigationController?.popViewController(animated: true)
    }
}
