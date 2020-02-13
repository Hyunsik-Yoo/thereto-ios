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
        selectionStyle = .none
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
    
    func bind(juso: Juso, keyword: String) {
        let roadAddr = juso.roadAddr!
        let attributedText1 = NSMutableAttributedString(string: roadAddr)
        
        attributedText1.addAttribute(.foregroundColor, value: UIColor.orangeRed, range: (roadAddr as NSString).range(of: keyword))
        attributedText1.addAttribute(.font, value: UIFont.init(name: "SpoqaHanSans-Bold", size: 14)!, range: (roadAddr as NSString).range(of: keyword))
        roadAddress.attributedText = attributedText1
        
        let jibunAddr = juso.jibunAddr!
        let attributedText2 = NSMutableAttributedString(string: jibunAddr)
        
        attributedText2.addAttribute(.foregroundColor, value: UIColor.orangeRed, range: (jibunAddr as NSString).range(of: keyword))
        attributedText2.addAttribute(.font, value: UIFont.init(name: "SpoqaHanSans-Bold", size: 14)!, range: (jibunAddr as NSString).range(of: keyword))
        jibunAddress.attributedText = attributedText2
    }
    
    
}
