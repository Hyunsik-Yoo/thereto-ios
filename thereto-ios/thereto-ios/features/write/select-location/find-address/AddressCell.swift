import UIKit

class AddressCell: BaseTableViewCell {
    
    static let registerId = "\(AddressCell.self)"
    
    let roadAddress = UILabel().then {
        $0.font = UIFont.init(name: "SpoqaHanSans-Regular", size: 14)
        $0.textColor = .greyishBrown
    }
    
    let jibunAddress = UILabel().then {
        $0.font = UIFont.init(name: "SpoqaHanSans-Regular", size: 14)
        $0.textColor = .brownishGrey
    }
    
    override func setup() {
        backgroundColor = .clear
        addSubViews(roadAddress, jibunAddress)
    }
    
    override func bindConstraints() {
        roadAddress.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(24)
            make.top.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-24)
        }
        
        jibunAddress.snp.makeConstraints { (make) in
            make.left.right.equalTo(roadAddress)
            make.top.equalTo(roadAddress.snp.bottom)
            make.bottom.equalToSuperview().offset(-16)
        }
    }
    
    func bind(juso: Juso) {
        roadAddress.text = juso.roadAddr
        jibunAddress.text = juso.jibunAddr
    }
}
