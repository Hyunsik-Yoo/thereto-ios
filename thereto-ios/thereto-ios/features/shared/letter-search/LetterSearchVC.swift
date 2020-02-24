import UIKit
import RxSwift

class LetterSearchVC: BaseVC {
    
    private lazy var letterSearchView = LetterSearchView.init(frame: self.view.frame)
    
    private var viewModel = LetterSearchViewModel.init()
    
    var type: String!
    
    
    static func instance(type: String) -> LetterSearchVC {
        return LetterSearchVC.init(nibName: nil, bundle: nil).then {
            $0.type = type
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = letterSearchView
        setupTableView()
    }
    
    override func bindViewModel() {
        viewModel.letters.bind(to: letterSearchView.tableView.rx.items(cellIdentifier: LetterCell.registerId, cellType: LetterCell.self)) { [weak self] row, letter, cell in
            if let type = self?.type {
                cell.bind(letter: letter, isSentLetter: type == "from" ? true : false)
            }
            
        }.disposed(by: disposeBag)
    }
    
    override func bindEvent() {
        letterSearchView.backBtn.rx.tap.bind { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }.disposed(by: disposeBag)
        
        letterSearchView.nicknameField.rx.controlEvent(.editingDidEndOnExit).subscribe(onNext: { [weak self] (_) in
            if let vc = self,
                let keyword = vc.letterSearchView.nicknameField.text {
                vc.searchLetter(keyworkd: keyword)
            }
        }).disposed(by: disposeBag)
    }
    
    private func setupTableView() {
        letterSearchView.tableView.delegate = self
        letterSearchView.tableView.register(LetterCell.self, forCellReuseIdentifier: LetterCell.registerId)
    }
    
    private func searchLetter(keyworkd: String) {
        letterSearchView.startLoading()
        LetterSerivce.searchLetters(keyword: keyworkd, type: type) { [weak self] (result) in
            switch result {
            case .success(let letters):
                self?.letterSearchView.setEmpty(isEmpty: letters.isEmpty)
                self?.viewModel.letters.onNext(letters)
            case .failure(let error):
                if let vc = self {
                    AlertUtil.show(controller: vc, title: "검색 오류", message: error.localizedDescription)
                }
            }
            self?.letterSearchView.stopLoading()
        }
    }
}

extension LetterSearchVC: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset.y
        
        if 129 - contentOffset > 0 && contentOffset > 0  {
            letterSearchView.backBtn.snp.remakeConstraints { (make) in
                make.left.equalToSuperview().offset(24)
                make.top.equalTo(view.safeAreaLayoutGuide).offset(16 - contentOffset)
                make.width.height.equalTo(24)
            }
            
            letterSearchView.backBtn.alpha = (129 - contentOffset) / 129
            letterSearchView.titleLabel.alpha = (129 - contentOffset) / 129
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let letters = try! self.viewModel.letters.value()
        
        self.navigationController?.pushViewController(LetterDetailVC.instance(letter: letters[indexPath.row]), animated: true)
    }
}
