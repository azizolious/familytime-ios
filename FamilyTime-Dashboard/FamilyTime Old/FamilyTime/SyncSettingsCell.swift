//
//  SyncSettingsCell.swift
//  FamilyTime
//
//  Created by Sufyan on 17/04/2024.
//  Copyright © 2024 YumyApps. All rights reserved.
//

import UIKit

protocol SyncSettingsCellDelegate: AnyObject {
    func didSettingsChanged(isActive: Bool, indexPath: IndexPath)
}

class SyncSettingsCell: UITableViewCell {
    var appImageView: UIImageView!
    //    var model: SyncSettingModel!
    //    var featureStatus: Bool = false
    var indexPath: IndexPath!
    weak var delegate: SyncSettingsCellDelegate?
    var switchView: UISwitch!
    var appName: String = ""
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .white
        tintColor = .red
        
        textLabel?.backgroundColor = .clear
        textLabel?.textColor = .darkGray
        textLabel?.textAlignment = .left
        
        appImageView = UIImageView(frame: .zero)
        contentView.addSubview(appImageView)
        
        let switchFrame = CGRect(x: 0, y: 0, width: 51, height: 31)
        switchView = UISwitch(frame: switchFrame)
        switchView.onTintColor = UIColor(red: 24/255, green: 167/255, blue: 225/255, alpha: 1)
        accessoryView = switchView
        switchView.addTarget(self, action: #selector(handleStatusChange(_:)), for: .valueChanged)
        
        clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setModel(appName: String, permission: Bool) {
        print("Setting model with app name: \(appName), permission: \(permission)")
        var displayName = appName.lowercased()
        
        switch displayName {
        case "safari":
            displayName = "Allow Safari"
        case "camera":
            displayName = "Allow Camera"
        case "siri":
            displayName = "Allow Siri & Dictation"
        case "itunesstore":
            displayName = "Allow iTunes Store"
        case "installingapps":
            displayName = "Allow Installing Apps"
        case "inapppurchases":
            displayName = "Allow In-App Purchases"
        case "externalapps":
            displayName = "Allow Other Apps"
        default:
            break
        }
        
        textLabel?.text = displayName
        appImageView.image = UIImage(named: appName)
        switchView.isOn = permission
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
            if SwiftFTUtils.isDeviceiPhoneFamily() {
                appImageView.frame = CGRect(x: contentView.frame.size.width - 32.0 - 15.0, y: contentView.bounds.midY - 15.0, width: 32.0, height: 32.0)
            } else {
                appImageView.frame = CGRect(x: 15.0, y: contentView.bounds.midY - 27.5, width: 55.0, height: 55.0)
            }
            textLabel?.frame = CGRect(x: contentView.frame.size.width - 32.0 - 10.0 - 250.0 - 10.0, y: 0.0, width: 250.0, height: contentView.bounds.height)
            textLabel?.textAlignment = .right
        } else {
            if SwiftFTUtils.isDeviceiPhoneFamily() {
                appImageView.frame = CGRect(x: 15.0, y: contentView.bounds.midY - 15.0, width: 32.0, height: 32.0)
            } else {
                appImageView.frame = CGRect(x: 15.0, y: contentView.bounds.midY - 27.5, width: 55.0, height: 55.0)
            }
            textLabel?.frame = CGRect(x: appImageView.frame.maxX + 10.0, y: 0.0, width: contentView.bounds.maxX - 10 - appImageView.frame.maxX, height: contentView.bounds.height)
            textLabel?.textAlignment = .left
        }
    }
    
    @objc func handleStatusChange(_ switchView: UISwitch) {
        delegate?.didSettingsChanged(isActive: switchView.isOn, indexPath: indexPath)
    }
    
}

//    func setModel(_ model: SyncSettingModel) {
//        self.model = model
//        textLabel?.text = model.display_name
//        appImageView.image = UIImage(named: model.app_name)
//        switchView.isOn = (model.app_status == 1)
//    }
//    func setFeatureStatus(_ featureStatus: Bool) {
//        self.featureStatus = featureStatus
//        switchView.isEnabled = featureStatus
//    }
//func setModel(appName: String, permission: Bool) {
//        print("Setting model with app name: \(appName), permission: \(permission)")
////        let displayName = "Allow \(appName.replacingOccurrences(of: "([A-Z])", with: " $1", options: .regularExpression, range: nil).capitalized)"
//        textLabel?.text = appName
//        appImageView.image = UIImage(named: appName)
//        switchView.isOn = permission
//    }
