import UIKit

class LetterCell: BaseTableViewCell {
    
    static let registerId = "\(LetterCell.self)"
    
    private let profileImage: UIImageView = {
        let image = UIImageView()
        
        image.layer.cornerRadius = 25
        image.backgroundColor = .black
        return image
    }()
    
    private let fromLabel: UILabel = {
        let label = UILabel()
        
        label.text = "from. 김민경"
        label.font = UIFont.init(name: "SpoqaHanSans-Bold", size: 18)
        label.textColor = UIColor.init(r: 30, g: 30, b: 30)
        label.textAlignment = .left
        return label
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        
        label.text = "경기 광주시 오포읍 새말길167번길 68"
        label.font = UIFont.init(name: "SpoqaHanSans-Regular", size: 14)
        label.textColor = UIColor.init(r: 114, g: 95, b: 95)
        return label
    }()
    
    private let cardImage: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage.init(named: "image_card")
        return imageView
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        
        label.text = "2019-06-11"
        label.font = UIFont.init(name: "FrankRuhlLibre-Black", size: 16)
        label.textColor = UIColor.init(r: 30, g: 30, b: 30)
        label.transform = CGAffineTransform(rotationAngle: CGFloat.pi * -90 / 180.0)
        return label
    }()
    
    
    override func setup() {
        backgroundColor = .clear
        addSubViews(profileImage, fromLabel, addressLabel,
                    cardImage, dateLabel)
    }
    
    override func bindConstraints() {
        profileImage.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(65)
            make.top.equalToSuperview().offset(40)
            make.width.height.equalTo(50)
        }
        
        fromLabel.snp.makeConstraints { (make) in
            make.top.equalTo(profileImage.snp.top)
            make.left.equalTo(profileImage.snp.right).offset(10)
        }
        
        addressLabel.snp.makeConstraints { (make) in
            make.top.equalTo(fromLabel.snp.bottom).offset(5)
            make.left.equalTo(fromLabel.snp.left)
            make.right.equalToSuperview().offset(50)
        }
        
        cardImage.snp.makeConstraints { (make) in
            make.top.equalTo(profileImage.snp.bottom).offset(20)
            make.right.equalToSuperview()
            make.left.equalTo(profileImage.snp.left)
            make.height.equalTo(230)
            make.bottom.equalToSuperview().offset(-70)
        }
        
        dateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(cardImage.snp.top).offset(30)
            make.left.equalToSuperview()
        }
    }
}

