//
//  SignInHeaderView.swift
//  PenguinsDiary
//
//  Created by Ruoxuan Wang on 8/4/21.
//

import UIKit

class SignInHeaderView: UIView {
    
    private let headerImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "sun.min"))
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit
        // imageView.backgroundColor = .systemTeal
        return imageView
    }()
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Get in touch with REAL penguins!"
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 20, weight: .medium)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        addSubview(headerImageView)
        addSubview(headerLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let size:CGFloat = width/4
        headerImageView.frame = CGRect(x: (width - size)/2, y: 10, width: size, height: size)
        headerLabel.frame = CGRect(x: 20, y: headerImageView.bottom + 10, width: width - 40, height: height - size - 30)
    }

}
