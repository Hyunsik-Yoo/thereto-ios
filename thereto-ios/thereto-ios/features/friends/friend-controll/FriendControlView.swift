import UIKit

class FriendControlView: BaseView {
    
    let backBtn = UIButton().then {
        $0.setImage(UIImage.init(named: "ic_back"), for: .normal)
    }
    
    let receivedBtn = UIButton().then {
        $0.setTitle("받은 친구요청", for: .normal)
        $0.setTitleColor(UIColor.init(r: 60, g: 46, b: 42), for: .selected)
        $0.setTitleColor(UIColor.init(r: 206, g: 176, b: 164), for: .normal)
        $0.titleLabel?.textAlignment = .center
        $0.titleLabel?.font = UIFont.init(name: "SpoqaHanSans-Bold", size: 14)
        $0.isSelected = true
    }
    
    let sentBtn = UIButton().then {
        $0.setTitle("보낸 친구요청", for: .normal)
        $0.setTitleColor(UIColor.init(r: 60, g: 46, b: 42), for: .selected)
        $0.setTitleColor(UIColor.init(r: 206, g: 176, b: 164), for: .normal)
        $0.titleLabel?.font = UIFont.init(name: "SpoqaHanSans-Regular", size: 14)
        $0.titleLabel?.textAlignment = .center
        $0.isSelected = false
    }
    
    let indicatorView = UIView().then {
        $0.backgroundColor = UIColor.init(r: 66, g: 40, b: 15)
    }
    
    let pageView = UIView().then {
        $0.backgroundColor = UIColor.init(r: 255, g: 248, b: 239)
    }
    
    override func setup() {
        backgroundColor = UIColor.themeColor
        addSubViews(backBtn, receivedBtn, sentBtn, indicatorView, pageView)
    }
    
    override func bindConstraints() {
        backBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(24)
            make.top.equalTo(safeAreaLayoutGuide).offset(16)
            make.width.height.equalTo(24)
        }
        
        receivedBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalTo(self.snp.centerX)
            make.top.equalTo(backBtn.snp.bottom)
            make.height.equalTo(58)
        }
        
        sentBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.left.equalTo(self.snp.centerX)
            make.centerY.equalTo(receivedBtn)
            make.height.equalTo(58)
        }
        
        indicatorView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.height.equalTo(1)
            make.width.equalTo(UIScreen.main.bounds.width / 2)
            make.top.equalTo(receivedBtn.snp.bottom)
        }
        
        pageView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(indicatorView.snp.bottom)
        }
    }
    
    func selectTab(index: Int) {
        if index == 0 {
            receivedBtn.isSelected = true
            receivedBtn.titleLabel?.font = UIFont.init(name: "SpoqaHanSans-Bold", size: 14)
            sentBtn.titleLabel?.font = UIFont.init(name: "SpoqaHanSans-Regular", size: 14)
            sentBtn.isSelected = false
            indicatorView.snp.updateConstraints { (make) in
                make.left.equalToSuperview()
            }
        } else {
            receivedBtn.isSelected = false
            sentBtn.titleLabel?.font = UIFont.init(name: "SpoqaHanSans-Bold", size: 14)
            receivedBtn.titleLabel?.font = UIFont.init(name: "SpoqaHanSans-Regular", size: 14)
            sentBtn.isSelected = true
            indicatorView.snp.updateConstraints { (make) in
                make.left.equalToSuperview().offset(frame.width / 2)
            }
        }
    }
}
