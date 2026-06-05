//
//  premiumImage.swift
//  FamilyTime
//
//  Created by Sufyan on 27/06/2024.
//  Copyright © 2024 YumyApps. All rights reserved.
//

import Foundation
import UIKit

class AddImage {
    static func addImageView(to label: UILabel, imageName: String) -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: imageName)
        imageView.widthAnchor.constraint(equalToConstant: 15).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 15).isActive = true
        imageView.isHidden = true // Start as hidden

        label.superview?.addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 5), // Minimal space between label and image view
            imageView.centerYAnchor.constraint(equalTo: label.centerYAnchor)
        ])

        return imageView
    }
}
