//
//  QRCodeCell.swift
//  FamilyTime
//
//  Created by Usama-Apps on 10/11/2022.
//  Copyright © 2022 YumyApps. All rights reserved.
//

import UIKit

protocol QRCodeCellDelegates {
    func viewDetailsInstructions()
    func cantScan()
}

class QRCodeCell: UITableViewCell {
    
    //MARK: - IBOutlets
    @IBOutlet weak var connectChildLabel: UILabel!
    @IBOutlet weak var scanQRCodeLabel: UILabel!
    @IBOutlet weak var step1Label: UILabel!
    @IBOutlet weak var step2Label: UILabel!
    @IBOutlet weak var step3Label: UILabel!
    @IBOutlet weak var step1DescriptionLabel: UILabel!
    @IBOutlet weak var step2DescriptionLabel: UILabel!
    @IBOutlet weak var step3DescriptionLabel: UILabel!
    
    @IBOutlet weak var qrCodeImageView : UIImageView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var cantScanButtonOutlet: UIButton!
    
    @IBOutlet weak var viewDetailsButtonOutlet: UIButton! {
        didSet {
            viewDetailsButtonOutlet.layer.cornerRadius = 22.5
            viewDetailsButtonOutlet.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var homeView: UIView! {
        didSet {
            homeView.layer.cornerRadius = 16.0
            homeView.layer.masksToBounds = true
        }
    }
    
    
    //MARK: - Variables
    var qrCellDelegate : QRCodeCellDelegates?
    var buttonTitle : String = ""
    var shareTapp: ()->() = {}
    //MARK: - View LifeCycles
    override func awakeFromNib() {
        super.awakeFromNib()
        let isGeneratingQR = UserDefaults.standard.bool(forKey: UserDefaultsConstants.GENERATE_QR_CODE)
        if isGeneratingQR {
            getQRCodeString()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            let qrString = UserDefaults.standard.string(forKey: UserDefaultsConstants.QR_CODE_STRING_VALUE)
            let images = self.generateQRCode(from: qrString ?? "")
            self.qrCodeImageView.image = images
            self.activityIndicatorView.isHidden = true
        }
    }
    
    //MARK: - IBActions
    @IBAction func ViewDetailsButtonPressed(_ sender: Any) {
        viewDetailsButtonOutlet.setTitle(buttonTitle, for: .normal)
        qrCellDelegate?.viewDetailsInstructions()
    }
    
    @IBAction func cantScanButtonPressed(_ sender: Any) {
        qrCellDelegate?.cantScan()
    }
    
    @IBAction func shareTapped(_ sender: Any) {
        shareTapp()
    }
    //MARK: - Helper Functions
    func setUpUI(title:String) {
        let localizedString = "step_1_getstarted_bullet_1".localized
        let attributedString = NSMutableAttributedString(string: localizedString)
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.init(hexString: "#F96512"), // Change this color to your desired color
        ]

        let coloredTextRange = (localizedString as NSString).range(of: "get.familytime.io")

        attributedString.addAttributes(attributes, range: coloredTextRange)
        step1DescriptionLabel.attributedText = attributedString
        self.viewDetailsButtonOutlet.setTitle(title, for: .normal)
    }
    
    private func getQRCodeString() {
        self.activityIndicatorView.isHidden = false
        self.activityIndicatorView.startAnimating()
        HLApiManager.generateQRCodeNetworkCallCore2 { response, error in
            if response != nil {
                //Getting the QR Code here...
                UserDefaults.standard.set(response ?? "", forKey: UserDefaultsConstants.QR_CODE_STRING_VALUE)
                UserDefaults.standard.set(false, forKey: UserDefaultsConstants.GENERATE_QR_CODE)
                UserDefaults.standard.synchronize()
                self.activityIndicatorView.stopAnimating()
                self.activityIndicatorView.isHidden = true
            } else {
                print(StringConstants.Errors.QR_CODE_STRING_NOT_FOUND, error ?? "")
            }
        }
    }
    
    private func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.utf8)
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        return nil
    }
}
