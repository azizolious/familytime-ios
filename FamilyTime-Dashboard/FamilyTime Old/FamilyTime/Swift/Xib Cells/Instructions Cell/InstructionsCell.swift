//
//  InstructionsCell.swift
//  FamilyTime
//
//  Created by Usama-Apps on 11/11/2022.
//  Copyright © 2022 YumyApps. All rights reserved.
//

import UIKit

protocol InstructionCellDelegates {
    func detailedButtonPressed()
    func cantLoginButtonPressed()
}

class InstructionsCell: UITableViewCell {
    //MARK: - IBOutlets
    @IBOutlet weak var setUpKidLabel: UILabel!
    @IBOutlet weak var yourFamilyLabel: UILabel!
    @IBOutlet weak var step1Label: UILabel!
    @IBOutlet weak var step2Label: UILabel!
    @IBOutlet weak var step3Label: UILabel!
    @IBOutlet weak var step4Label: UILabel!
    @IBOutlet weak var step5Label: UILabel!
    @IBOutlet weak var cantScanButtonOutlet: UIButton!
    
    @IBOutlet weak var opengetfamilyLbl: UILabel!
    @IBOutlet weak var homeView: UIView! {
        didSet {
            homeView.layer.cornerRadius = 16.0
            homeView.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var detailsButtonOutlet: UIButton! {
        didSet {
            detailsButtonOutlet.layer.cornerRadius = 22.5
            detailsButtonOutlet.layer.masksToBounds = true
        }
    }
    
    //MARK: - Variables
    var instructionDelegate : InstructionCellDelegates?
    var buttonTitle : String = ""
    var shareTapp: ()->() = {}

    //MARK: - View Life Cycles
    override func awakeFromNib() {
        super.awakeFromNib()
        let localizedString = "step_1_getstarted_bullet_1".localized

        // Create a mutable attributed string
        let attributedString = NSMutableAttributedString(string: localizedString)

        // Define the text attributes for the colored part
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.init(hexString: "#F96512"), // Change this color to your desired color
        ]

        // Specify the range where you want to apply the attributes (e.g., for the word "colored")
        let coloredTextRange = (localizedString as NSString).range(of: "get.familytime.io")

        // Apply the attributes to the specified range
        attributedString.addAttributes(attributes, range: coloredTextRange)
        opengetfamilyLbl.attributedText = attributedString
    }
    
    
    //MARK: - IBActions
    @IBAction func detailsButtonPressed(_ sender: Any) {
        instructionDelegate?.detailedButtonPressed()
        detailsButtonOutlet.setTitle(buttonTitle, for: .normal)
    }
    
    
    @IBAction func cantScanButtonPressed(_ sender: Any) {
        instructionDelegate?.cantLoginButtonPressed()
    }
    
    
    @IBAction func shareBtn(_ sender: Any) {
        shareTapp()
    }
    //MARK: - Helper Functions
    func setUpUI(title:String) {
        detailsButtonOutlet.setTitle(title, for: .normal)
    }
}


    
     
