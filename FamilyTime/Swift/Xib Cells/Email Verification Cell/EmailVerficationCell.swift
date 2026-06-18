//
//  EmailVerficationCell.swift
//  FamilyTime
//
//  Created by Usama-Apps on 30/12/2022.
//  Copyright © 2022 YumyApps. All rights reserved.
//

import UIKit

//MARK: Protocols
protocol EmailVerificationCellDelegates {
    func changeEmailButtonPressed()
    func verifyEmailButtonPressed()
}

//MARK: Classes
class EmailVerficationCell: UITableViewCell {

    //MARK: - IBOutlets
    @IBOutlet weak var messageImageView: UIImageView!
    @IBOutlet weak var unverifiedEmailLabel: UILabel!
    @IBOutlet weak var yourEmailAddressLabel: UILabel!
    
    @IBOutlet weak var changeEmailButtonOutlet: UIButton! {
        didSet {
            changeEmailButtonOutlet.layer.cornerRadius = 10.0
            changeEmailButtonOutlet.layer.borderColor = UIColor.white.cgColor
            changeEmailButtonOutlet.layer.borderWidth = 1.0
            changeEmailButtonOutlet.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var verifyEmailButtonOutlet: UIButton! {
        didSet {
            verifyEmailButtonOutlet.layer.cornerRadius = 10.0
            verifyEmailButtonOutlet.layer.borderColor = UIColor.white.cgColor
            verifyEmailButtonOutlet.layer.borderWidth = 1.0
            verifyEmailButtonOutlet.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var parentViewContainer: UIView! {
        didSet {
            parentViewContainer.layer.cornerRadius = 5.0
            parentViewContainer.layer.masksToBounds = true
        }
    }
    
    //MARK: - Variables
    var delegate : EmailVerificationCellDelegates?
    
    //MARK: - View Lifecyles
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
    }
    
    //MARK: - IBActions
    @IBAction func changeEmailButtonPressed(_ sender: Any) {
        delegate?.changeEmailButtonPressed()
    }
    
    
    @IBAction func verifyEmailButtonPressed(_ sender: Any) {
        delegate?.verifyEmailButtonPressed()
    }
    
    //MARK: - Helper Functions
    private func setUpUI() {
        let emailVerified = UserDefaults.standard.string(forKey: UserDefaultsConstants.EMAIL_VERIFIED_AT_ACCOUNT)
        let emailBounce = UserDefaults.standard.integer(forKey: UserDefaultsConstants.EMAIL_BOUNCE_ACCOUNT)
        let emailComplaint = UserDefaults.standard.integer(forKey: UserDefaultsConstants.EMAIL_COMPLAINT_ACCOUNT)
        let userEmail = UserDefaults.standard.string(forKey: UserDefaultsConstants.USER_EMAIL)
        if userEmail == nil || userEmail == "" {
            changeEmailButtonOutlet.isHidden = true
            verifyEmailButtonOutlet.setTitle(StringConstants.Constants.FIX_NOW, for: .normal)
            messageImageView.image = ImageConstants.EMAIL_MISSING
            unverifiedEmailLabel.text = StringConstants.Constants.EMAIL_MISSING
            yourEmailAddressLabel.text = StringConstants.Constants.YOU_HAVE_NOT_ADDED_EMAIL
            parentViewContainer.backgroundColor = ColorConstants.EMAIL_VERIFICATION_CELL_RED
        } else if emailVerified == nil || emailVerified == "" {
            changeEmailButtonOutlet.isHidden = false
            changeEmailButtonOutlet.setTitle(StringConstants.Constants.CHANGE_EMAIL, for: .normal)
            verifyEmailButtonOutlet.setTitle(StringConstants.Constants.VERIFIY_EMAIL, for: .normal)
            messageImageView.image = ImageConstants.EMAIL_MISSING
            unverifiedEmailLabel.text = userEmail
            yourEmailAddressLabel.text = StringConstants.Constants.EMAIL_ADDRESS_NOT_VERIFIED
            parentViewContainer.backgroundColor = ColorConstants.EMAIL_VERIFICATION_CELL_RED
        } else if emailBounce == 1 {
            changeEmailButtonOutlet.isHidden = true
            verifyEmailButtonOutlet.setTitle(StringConstants.Constants.FIX_NOW, for: .normal)
            messageImageView.image = ImageConstants.EMAIL_NOT_DELIVERED
            unverifiedEmailLabel.text = StringConstants.Constants.NOT_DELIVERED
            yourEmailAddressLabel.text = StringConstants.Constants.EMAILS_ARE_NOT_DELIVERED
            parentViewContainer.backgroundColor = ColorConstants.EMAIL_VERIFICATION_CELL_BLUE
        } else if emailComplaint == 1 {
            changeEmailButtonOutlet.isHidden = true
            verifyEmailButtonOutlet.setTitle(StringConstants.Constants.FIX_NOW, for: .normal)
            messageImageView.image = ImageConstants.UNMARK_SPAM
            unverifiedEmailLabel.text = StringConstants.Constants.UNMARK_SPAM
            yourEmailAddressLabel.text = StringConstants.Constants.EMAILS_ARE_MARKED_AS_SPAM
            parentViewContainer.backgroundColor = ColorConstants.EMAIL_VERIFICATION_CELL_ORANGE
        }
    }
}
