//
//  FotoCell.swift
//  ImageFeed
//
//  Created by Артем Чалков on 13.11.2023.
//

import UIKit

class FotoCell: UITableViewCell {
    static let reused = "FotoCell"
    
    //Closure init
    var photoImageView: UIImageView = {
        let imageView = UIImageView()
        
        let screenWidth = UIScreen.main.bounds.width - 16 - 16
        imageView.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: screenWidth).isActive = true
        imageView.layer.cornerRadius = 16
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    var dateLabel: PaddingLabel = {
        var label = PaddingLabel()
        label.edgeInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "d LLLL YYYY"
        let stringDate = dateFormatter.string(from: currentDate)
        print(stringDate)
        
        label.text = stringDate
        //label.font = UIFont.boldSystemFont(ofSize: 25)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        label.textColor = .white
        label.backgroundColor = .black.withAlphaComponent(0.2)
        
        return label
    }()
    
    var likeButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setImage(UIImage(named: "LikeNo"), for: .normal)
        button.setImage(UIImage(named: "Like"), for: .selected)
        
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
}

//MARK: - Public
extension FotoCell {
    func update(_ imageName: String) {
        
        let image = UIImage(named: imageName)
        
        photoImageView.image = image
    }
}

//MARK: - Layout
extension FotoCell {
    func setupViews() {
        contentView.addSubview(photoImageView)
        contentView.addSubview(likeButton)
        photoImageView.addSubview(dateLabel)
    }
    
    func setupConstraints() {
        
        photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4).isActive = true
        photoImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
        photoImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16).isActive = true
        photoImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4).isActive = true
        
        
        likeButton.topAnchor.constraint(equalTo: photoImageView.topAnchor, constant: 0).isActive = true
        likeButton.rightAnchor.constraint(equalTo: photoImageView.rightAnchor, constant: -0).isActive = true
        likeButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        likeButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        
        dateLabel.leftAnchor.constraint(equalTo: photoImageView.leftAnchor, constant: 0).isActive = true
        dateLabel.rightAnchor.constraint(equalTo: photoImageView.rightAnchor, constant: 0).isActive = true
        dateLabel.bottomAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 0).isActive = true
        
    }
}

class PaddingLabel: UILabel {

    var edgeInset: UIEdgeInsets = .zero

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: edgeInset.top, left: edgeInset.left, bottom: edgeInset.bottom, right: edgeInset.right)
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + edgeInset.left + edgeInset.right, height: size.height + edgeInset.top + edgeInset.bottom)
    }
}

