//
//   .swift
//  CryptoCoin
//
//  Created by 권현석 on 2/26/24.
//

import UIKit

//TODO: 빌더 패턴
//TODO: 높이 44

//final class CustomNavigationBar: BaseView {
//    
//    let backButtonImage = {
//        let view = UIImageView()
//        view.image = UIImage(systemName: ImageAsset.backButton.name)
//        view.contentMode = .scaleAspectFit
//        view.tintColor = UIColor(hexCode: ColorHexCode.purple.colorCode)
//        return view
//    }()
//    
//    let backButton = UIButton()
//    
//    let profileImage = {
//        let view = UIImageView()
//        view.clipsToBounds = true
//        view.layer.borderColor = UIColor(hexCode: ColorHexCode.purple.colorCode).cgColor
//        view.layer.borderWidth = 2
//        //TODO: 코너 레디우스
//        return view
//    }()
//    
//    let likeButtonImage = {
//        let view = UIImageView()
//        view.image = UIImage(systemName: ImageAsset.starFill.name)
//        view.contentMode = .scaleAspectFit
//        view.tintColor = UIColor(hexCode: ColorHexCode.purple.colorCode)
//        return view
//    }()
//    
//    let likeButton = UIButton()
//    
//    init(backButtonImage: UIImageView? = nil, 
//         backbutton: UIButton? = nil,
//         profileImageView: UIImageView? = nil,
//         likeButtonImageView: UIImageView? = nil,
//         likeButton: UIButton? = nil) {
//        
//    }
//    
//    
//    override func configure() {
//        super.configure()
//        [
//        backButtonImage,
//        backButton,
//        profileImage,
//        likeButtonImage,
//        likeButton
//        ].forEach { addSubview($0) }
//    }
//    
//    override func setConstrinats() {
//        backButtonImage.snp.makeConstraints {
//            $0.height.equalTo(17)
//            $0.width.equalTo(23)
//            $0.leading.equalToSuperview().offset(12)
//            $0.centerY.equalToSuperview()
//        }
//        
//        backButton.snp.makeConstraints {
//            $0.verticalEdges.equalTo(backButtonImage)
//            $0.horizontalEdges.equalTo(backButtonImage).inset(-4)
//        }
//        
//        profileImage.snp.makeConstraints {
//            $0.size.equalTo(32)
//            $0.centerY.equalToSuperview()
//            $0.trailing.equalToSuperview().inset(16)
//        }
//        
//        likeButtonImage.snp.makeConstraints {
//            $0.centerY.equalToSuperview()
//            $0.trailing.equalToSuperview().inset(16)
//            $0.size.equalTo(20)
//        }
//        
//        likeButton.snp.makeConstraints {
//            $0.edges.equalTo(likeButtonImage).inset(-4)
//        }
//    }
//}
