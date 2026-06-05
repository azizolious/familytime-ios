//
//  SwiftParentDrawerTableViewCell.swift
//  FamilyTime
//
//  Created by YumyApps on 14/10/2021.
//  Copyright © 2021 YumyApps. All rights reserved.
//

import UIKit

class SwiftParentDrawerTableViewCell: UITableViewCell {
    
    let drawerImage: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    let drawerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SFProDisplay-Regular", size: 16)!
        return label
    }()
    
    let labelImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit // Adjust content mode as per your requirement
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(drawerLabel)
        contentView.addSubview(drawerImage)
        contentView.addSubview(labelImageView) // Add the new image view
        
        // Adjust constraints or frames as needed
        drawerImage.translatesAutoresizingMaskIntoConstraints = false
        drawerLabel.translatesAutoresizingMaskIntoConstraints = false
        labelImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            drawerImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            drawerImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            drawerImage.widthAnchor.constraint(equalToConstant: 25),
            drawerImage.heightAnchor.constraint(equalToConstant: 25),
            
            drawerLabel.leadingAnchor.constraint(equalTo: drawerImage.trailingAnchor, constant: 10),
            drawerLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            labelImageView.leadingAnchor.constraint(equalTo: drawerLabel.trailingAnchor, constant: 10),
            labelImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            labelImageView.widthAnchor.constraint(equalToConstant: 15), // Adjust width as needed
            labelImageView.heightAnchor.constraint(equalToConstant: 15) // Adjust height as needed
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Additional layout adjustments if needed
    }
}
