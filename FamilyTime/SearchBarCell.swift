//
//  SearchBarCell.swift
//  FamilyTime
//
//  Created by Sufyan on 17/10/2023.
//  Copyright © 2023 YumyApps. All rights reserved.
//

import UIKit

class SearchBarCell: UITableViewCell {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        searchBar.placeholder = "search_app".localized
        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = UIColor.white.cgColor
        
        if #available(iOS 13.0, *) {
            searchBar.searchTextField.backgroundColor = UIColor.init(hexString: "#F8F8F8")
        } else {
            for subview in searchBar.subviews.first?.subviews ?? [] {
                if let textField = subview as? UITextField {
                    textField.backgroundColor = UIColor.init(hexString: "#F8F8F8")
                }
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
