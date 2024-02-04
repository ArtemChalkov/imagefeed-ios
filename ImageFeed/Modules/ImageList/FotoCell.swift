//
//  FotoCell.swift
//  ImageFeed
//
//  Created by Артем Чалков on 13.11.2023.
//

import UIKit

final class FotoCell: UITableViewCell {
    static let reused = "FotoCell"
    
    var onLikeButtonTapped: ((String) -> ())?
    
    var photo: Photo?
    
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
    
    var dateContainerView: UIView = {
        var view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.2)
        view.translatesAutoresizingMaskIntoConstraints = false
    
        return view
    }()
    
    func convertDateToString(_ date: Date?) -> String {
        guard let currentDate = date else { return "" }
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "d LLLL YYYY"
        let stringDate = dateFormatter.string(from: currentDate)
        return stringDate
    }
    
    var dateLabel: PaddingLabel = {
        var label = PaddingLabel()
      
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "d LLLL YYYY"
        let stringDate = dateFormatter.string(from: currentDate)
        print(stringDate)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        
        label.font = UIFont(name: "SFPro-Regular", size: 13)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.16
        label.attributedText = NSMutableAttributedString(string: "\(stringDate)", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])

        
        return label
    }()
    
    var likeButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setImage(UIImage(named: "LikeNo"), for: .normal)
        button.setImage(UIImage(named: "Like"), for: .selected)
        
        button.addTarget(nil, action: #selector(likeButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    @objc func likeButtonTapped() {
        
        guard let photo else { return }
        onLikeButtonTapped?(photo.id)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        // Отменяем загрузку, чтобы избежать багов при переиспользовании ячеек
        photoImageView.kf.cancelDownloadTask()
    }
    
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
    func update(_ photo: Photo) {
        
        self.photo = photo
        
        let url = URL.init(string: photo.thumbImageURL)
        photoImageView.kf.setImage(with: url)
        
        dateLabel.text =  convertDateToString(photo.createdAt)
   
        likeButton.isSelected = photo.isLiked
    }
}

//MARK: - Layout
extension FotoCell {
    func setupViews() {
        contentView.addSubview(photoImageView)
        contentView.addSubview(likeButton)
        photoImageView.addSubview(dateContainerView)
        dateContainerView.addSubview(dateLabel)
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
        
        
        dateContainerView.leftAnchor.constraint(equalTo: photoImageView.leftAnchor, constant: 0).isActive = true
        dateContainerView.rightAnchor.constraint(equalTo: photoImageView.rightAnchor, constant: 0).isActive = true
        dateContainerView.bottomAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 0).isActive = true
        dateContainerView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        dateLabel.leftAnchor.constraint(equalTo: dateContainerView.leftAnchor, constant: 8).isActive = true
        dateLabel.rightAnchor.constraint(equalTo: dateContainerView.rightAnchor, constant: -183).isActive = true
        dateLabel.bottomAnchor.constraint(equalTo: dateContainerView.bottomAnchor, constant: -8).isActive = true
        dateLabel.topAnchor.constraint(equalTo: dateContainerView.topAnchor, constant: 4).isActive = true

    }
}

final class PaddingLabel: UILabel {

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

