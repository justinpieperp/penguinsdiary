//
//  PayWallHeaderView.swift
//  PenguinsDiary
//
//  Created by Ruoxuan Wang on 8/4/21.
//

import UIKit

class PayWallHeaderView: UIView {
    
    private let headerImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "crown"))
        imageView.frame = CGRect(x: 0, y: 0, width: 110, height: 110)
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        // imageView.backgroundColor = .systemYellow
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        addSubview(headerImageView)
        backgroundColor = .systemPink
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        headerImageView.frame = CGRect(x: (bounds.width - 110)/2, y: (bounds.height - 110)/2, width: 110, height: 110)
    }

}
