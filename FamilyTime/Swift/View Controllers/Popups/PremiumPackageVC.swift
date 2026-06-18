//
//  PremiumPackageVC.swift
//  FamilyTime
//
//  Created by Usama-Apps on 08/09/2022.
//  Copyright © 2022 YumyApps. All rights reserved.
//

import UIKit
import SwiftUI

class PremiumPackageVC: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var cancelButtonOutlet: UIButton!
    @IBOutlet weak var familyTimeLabel: UILabel!
    @IBOutlet weak var upgradeNowLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var restoreButtonOutlet: UIButton!
    
    //MARK: - Variables
    private var upgradeExternalArray = [UpgradeExternalData]()
    private var upgradeInternalArray = [UpgradeInternalData]()
    private var appleTrialInternalArray = [AppleInternalTrialData]()
    private var fastSpringTrailExternalArray = [FastSpringExternalTrialData]()
    private var isShoppingFunnelOn : Bool = false
    private var lastTimeClickedUpgrade : String?
    private var lastTimeClickedTrial : String?
    private var productArr = [String]()
    private var profileObject :  Profile?
    private var subscriptionData : [SubscriptionsData]?
    var isComingFromTrialScreen : Bool = false
    var isCommingFromDrwa: Bool = false
    var isCommingFromOtherScreens : Bool = false
    var delegate = UIApplication.shared.delegate as? AppDelegate
    let bottomView = UIView()

    //MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        addBottomViewAsFooter()
    }
        
    func addBottomViewAsFooter() {
        // Create the footer view
        let footerView = UIView()
        footerView.backgroundColor = .white
        
        // Create and configure labels
        let titleLabel = createLabel(
            withText: "FamilyTime Subscription Terms",
            font: UIFont.boldSystemFont(ofSize: 18)
        )
        
        let descriptionLabel = createLabel(
            withText: """
            Subscriptions purchased through FamilyTime will be billed to your Apple App Store account and are governed by the Apple App Store refund policies.\n\nThe subscription will renew automatically after the free trial ends for subsequent periods. You can cancel the subscription anytime during the trial or after it renews. To manage your subscription, please check your subscriptions under Apple ID.
            """,
            font: UIFont.systemFont(ofSize: 14),
            numberOfLines: 0
        )
        
        // Create horizontal stack for links
        let termsButton = createUnderlinedButton(title: "Terms of Use")
        let separatorLabel = createLabel(withText: "|", font: UIFont.LightFont())
        let privacyButton = createUnderlinedButton(title: "Privacy Policy")
        
        let linkStackView = UIStackView(arrangedSubviews: [termsButton, separatorLabel, privacyButton])
        linkStackView.axis = .horizontal
        linkStackView.alignment = .center
        linkStackView.spacing = 2
        
        // Add all views to the footer view
        footerView.addSubview(titleLabel)
        footerView.addSubview(descriptionLabel)
        footerView.addSubview(linkStackView)
        
        // Enable Auto Layout
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        linkStackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Set constraints
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -16),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -16),
            
            linkStackView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 5),
            linkStackView.centerXAnchor.constraint(equalTo: footerView.centerXAnchor),
            linkStackView.bottomAnchor.constraint(equalTo: footerView.bottomAnchor, constant: -16)
        ])
        
        // Set dynamic height
        footerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 300)
        tableView.tableFooterView = footerView
    }

    // Helper function to create labels
    private func createLabel(withText text: String, font: UIFont, numberOfLines: Int = 1) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = .black
        label.font = font
        label.textAlignment = .center
        label.numberOfLines = numberOfLines
        return label
    }
    
    private func createUnderlinedButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        let attributedTitle = NSAttributedString(string: title, attributes: attributes)
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.setTitle(title, for: .normal)  // Ensure this line is present
        button.addTarget(self, action: #selector(linkTapped(_:)), for: .touchUpInside)
        return button
    }


    // Action for link buttons
    @objc private func linkTapped(_ sender: UIButton) {
        if sender.currentTitle == "Terms of Use" {
            openWebPage(urlString: "https://familytime.io/legal/terms-conditions.html")
        } else if sender.currentTitle == "Privacy Policy" {
            openWebPage(urlString: "https://familytime.io/legal/app-privacy-policy.html")
        }
    }

    // Helper function to open web pages
    private func openWebPage(urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }

    
    override func viewWillAppear(_ animated: Bool) {
        fetechPremiumPackgeDetails()
        setUpAndControlUI()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    //MARK: - IBActions
    @IBAction func restoreButtonPressed(_ sender: Any) {
        IAPUtility.shared.restorePurchases(vc: self)
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        //        delegate?.drawerCont.contName       = "Drawer"
        //        delegate?.setupDrawer(0)
        let isComingFromBrowserUpgrade = UserDefaults.standard.bool(forKey: UserDefaultsConstants.IS_COMING_FROM_BROWSER_UPGRADE)
        let isComingFromBrowserTrial = UserDefaults.standard.bool(forKey: UserDefaultsConstants.IS_COMING_FROM_BROWSER_TRIAL)
        let isComingFromDataUseVC = UserDefaults.standard.bool(forKey: UserDefaultsConstants.FROM_DATA_USE_SCREEN)
        let token = UserDefaultsManager.bearerTokenCore2 ?? ""
        if isComingFromTrialScreen {
            if isComingFromBrowserTrial {
                ///Un Comment the following code when you have to switch between payment methods
                //                let lastTimeClicked = UserDefaults.standard.string(forKey: UserDefaultsConstants.LAST_TIME_CLICKED_TRIAL)
                //                if lastTimeClicked != nil, let lastTimeClicked = lastTimeClicked {
                //                    if lastTimeClicked == StringConstants.Constants.APPLE_TRIAL_INT {
                //                        UserDefaults.standard.set(StringConstants.Constants.FAST_SPRING_TRIAL_EXT, forKey: UserDefaultsConstants.LAST_TIME_CLICKED_TRIAL)
                //                        UserDefaults.standard.synchronize()
                //                    } else if lastTimeClicked == StringConstants.Constants.FAST_SPRING_TRIAL_EXT {
                //                        UserDefaults.standard.set(StringConstants.Constants.APPLE_TRIAL_INT, forKey: UserDefaultsConstants.LAST_TIME_CLICKED_TRIAL)
                //                        UserDefaults.standard.synchronize()
                //                    }
                //                }
                UserDefaults.standard.removeObject(forKey: UserDefaultsConstants.IS_COMING_FROM_BROWSER_TRIAL)
                UserDefaults.standard.synchronize()
                accountApiData(token: token)
            } else {
                dismissBack()
            }
        } else if isComingFromBrowserUpgrade {
            ///Un Comment the following code when you have to switch between payment methods
            //            let lastTimeClicked = UserDefaults.standard.string(forKey: UserDefaultsConstants.LAST_TIME_CLICKED_UPGRADE)
            //            if lastTimeClicked != nil, let lastTimeClicked = lastTimeClicked {
            //                if lastTimeClicked == StringConstants.Constants.INTERNAL {
            //                    UserDefaults.standard.set(StringConstants.Constants.EXTERNAL, forKey: UserDefaultsConstants.LAST_TIME_CLICKED_UPGRADE)
            //                    UserDefaults.standard.synchronize()
            //                } else if lastTimeClicked == StringConstants.Constants.EXTERNAL {
            //                    UserDefaults.standard.set(StringConstants.Constants.INTERNAL, forKey: UserDefaultsConstants.LAST_TIME_CLICKED_UPGRADE)
            //                    UserDefaults.standard.synchronize()
            //                }
            //            }
            UserDefaults.standard.removeObject(forKey: UserDefaultsConstants.IS_COMING_FROM_BROWSER_UPGRADE)
            UserDefaults.standard.synchronize()
            accountApiData(token: token)
        } else if isCommingFromDrwa {
            AppDelegateShared().setupDrawer(0)
            delegate?.drawerCont.contName = StringConstants.Constants.DRAWER
            UserDefaults.standard.set("Settings", forKey: UserDefaultsConstants.DRAWER_TYPE)
        } else if isComingFromDataUseVC {
            UserDefaults.standard.removeObject(forKey: UserDefaultsConstants.FROM_DATA_USE_SCREEN)
            UserDefaults.standard.synchronize()
            dismissBack()
        } else if isCommingFromOtherScreens {
            dismissBack()
        }
    }
    
    //MARK: - UI & Helper Functions
    private func setUpAndControlUI() {
        let value = UserDefaults.standard.bool(forKey: UserDefaultsConstants.SHOPPING_FUNNEL_VALUE)
        let lastTimeClicked = UserDefaults.standard.string(forKey: UserDefaultsConstants.LAST_TIME_CLICKED_UPGRADE)
        let clickedTrail = UserDefaults.standard.string(forKey: UserDefaultsConstants.LAST_TIME_CLICKED_TRIAL)
        self.isShoppingFunnelOn = value
        self.lastTimeClickedTrial = clickedTrail
        self.lastTimeClickedUpgrade = lastTimeClicked
        if isShoppingFunnelOn {
            restoreButtonOutlet.isHidden = false
        } else {
            restoreButtonOutlet.isHidden = true
        }
        
        if isComingFromTrialScreen {
            ///Un Comment the Following code When you have to switch between Payment methods
            //            if lastTimeClickedTrial != nil, let lastTimeClickedTrial = lastTimeClickedTrial {
            //                if lastTimeClickedTrial == StringConstants.Constants.APPLE_TRIAL_INT {
            //                    let userCurrentLanguage = SwiftCommonUtility.shared.getCurrentLanguageCode()
            //                    for upgradeData in appleTrialInternalArray {
            //                        let language = upgradeData.languages ?? [AppleInternalLanguage]()
            //                        for lang in language {
            //                            if userCurrentLanguage == lang.language {
            //                                familyTimeLabel.text = lang.title ?? ""
            //                                upgradeNowLabel.text = lang.languageDescription ?? ""
            //                            } else {
            //                                if lang.language == "en" {
            //                                    familyTimeLabel.text = lang.title ?? ""
            //                                    upgradeNowLabel.text = lang.languageDescription ?? ""
            //                                }
            //                            }
            //                        }
            //                    }
            //                } else if lastTimeClickedTrial == StringConstants.Constants.FAST_SPRING_TRIAL_EXT {
            //                    let userCurrentLanguage = SwiftCommonUtility.shared.getCurrentLanguageCode()
            //                    for upgradeData in fastSpringTrailExternalArray {
            //                        let language = upgradeData.languages ?? [FastSpringExternalLanguage]()
            //                        for lang in language {
            //                            if userCurrentLanguage == lang.language {
            //                                familyTimeLabel.text = lang.title ?? ""
            //                                upgradeNowLabel.text = lang.languageDescription ?? ""
            //                            } else {
            //                                if lang.language == "en" {
            //                                    familyTimeLabel.text = lang.title ?? ""
            //                                    upgradeNowLabel.text = lang.languageDescription ?? ""
            //                                }
            //                            }
            //                        }
            //                    }
            //                }
            //            } else {
            if isShoppingFunnelOn {
                let userCurrentLanguage = SwiftCommonUtility.shared.getCurrentLanguageCode()
                for upgradeData in appleTrialInternalArray {
                    let language = upgradeData.languages ?? [AppleInternalLanguage]()
                    for lang in language {
                        if userCurrentLanguage == lang.language {
                            familyTimeLabel.text = lang.title ?? ""
                            upgradeNowLabel.text = lang.languageDescription ?? ""
                        } else {
                            if lang.language == "en" {
                                familyTimeLabel.text = lang.title ?? ""
                                upgradeNowLabel.text = lang.languageDescription ?? ""
                            }
                        }
                    }
                }
            } else {
                let userCurrentLanguage = SwiftCommonUtility.shared.getCurrentLanguageCode()
                for upgradeData in fastSpringTrailExternalArray {
                    let language = upgradeData.languages ?? [FastSpringExternalLanguage]()
                    for lang in language {
                        if userCurrentLanguage == lang.language {
                            familyTimeLabel.text = lang.title ?? ""
                            upgradeNowLabel.text = lang.languageDescription ?? ""
                        } else {
                            if lang.language == "en" {
                                familyTimeLabel.text = lang.title ?? ""
                                upgradeNowLabel.text = lang.languageDescription ?? ""
                            }
                        }
                    }
                }
            }
            //            }
        } else {
            ///Un Comment the following code when you have to switch between payment methods
            //            if lastTimeClicked != nil, let lastTimeClicked = lastTimeClicked {
            //                if lastTimeClicked == StringConstants.Constants.INTERNAL {
            //                    let userCurrentLanguage = SwiftCommonUtility.shared.getCurrentLanguageCode()
            //                    for upgradeData in upgradeInternalArray {
            //                        let language = upgradeData.languages ?? [UserLanguageInt]()
            //                        for lang in language {
            //                            if userCurrentLanguage == lang.language {
            //                                familyTimeLabel.text = lang.title ?? ""
            //                                upgradeNowLabel.text = lang.packageDescription ?? ""
            //                            } else {
            //                                if lang.language == "en" {
            //                                    familyTimeLabel.text = lang.title ?? ""
            //                                    upgradeNowLabel.text = lang.packageDescription ?? ""
            //                                }
            //                            }
            //                        }
            //                    }
            //                } else if lastTimeClicked == StringConstants.Constants.EXTERNAL {
            //                    let userCurrentLanguage = SwiftCommonUtility.shared.getCurrentLanguageCode()
            //                    for upgradeData in upgradeExternalArray {
            //                        let language = upgradeData.languages ?? [UserLanguageExt]()
            //                        for lang in language {
            //                            if userCurrentLanguage == lang.language {
            //                                familyTimeLabel.text = lang.title ?? ""
            //                                upgradeNowLabel.text = lang.packageDescription ?? ""
            //                            } else {
            //                                if lang.language == "en" {
            //                                    familyTimeLabel.text = lang.title ?? ""
            //                                    upgradeNowLabel.text = lang.packageDescription ?? ""
            //                                }
            //                            }
            //                        }
            //                    }
            //                }
            //            } else {
            if isShoppingFunnelOn {
                let userCurrentLanguage = SwiftCommonUtility.shared.getCurrentLanguageCode()
                for upgradeData in upgradeInternalArray {
                    let language = upgradeData.languages ?? [UserLanguageInt]()
                    for lang in language {
                        if userCurrentLanguage == lang.language {
                            familyTimeLabel.text = lang.title ?? ""
                            upgradeNowLabel.text = lang.packageDescription ?? ""
                        } else {
                            if lang.language == "en" {
                                familyTimeLabel.text = lang.title ?? ""
                                upgradeNowLabel.text = lang.packageDescription ?? ""
                            }
                        }
                    }
                }
            } else {
                let userCurrentLanguage = SwiftCommonUtility.shared.getCurrentLanguageCode()
                for upgradeData in upgradeExternalArray {
                    let language = upgradeData.languages ?? [UserLanguageExt]()
                    for lang in language {
                        if userCurrentLanguage == lang.language {
                            familyTimeLabel.text = lang.title ?? ""
                            upgradeNowLabel.text = lang.packageDescription ?? ""
                        } else {
                            if lang.language == "en" {
                                familyTimeLabel.text = lang.title ?? ""
                                upgradeNowLabel.text = lang.packageDescription ?? ""
                            }
                        }
                    }
                }
            }
            //            }
        }
    }
    
    private func fetechPremiumPackgeDetails() {
        tableView.register(UINib(nibName: NibConstants.Names.PREMIUM_PACKAGE_CELL, bundle: nil), forCellReuseIdentifier: NibConstants.Identifiers.PREMIUM_PACKAGE_CELL)
        tableView.delegate = self
        tableView.dataSource = self
        let upgrade_sub_internal = UserDefaults.standard.string(forKey: UserDefaultsConstants.UPGRADE_SUB_INTERNAL)
        let upgrade_sub_external = UserDefaults.standard.string(forKey: UserDefaultsConstants.UPDRADE_SUB_EXTERNAL)
        let apple_internal_trial = UserDefaults.standard.string(forKey: UserDefaultsConstants.APPLE_TRIAL_INT)
        let fast_spring_external_trial = UserDefaults.standard.string(forKey: UserDefaultsConstants.FAST_SPRING_TRIAL_EXT)
        if upgrade_sub_internal != nil && upgrade_sub_internal == PremiumPackageKeys.UPGRADE_SUB_INT.rawValue {
            let data = CoreDataUtility.fetchPremiumPackageDetailsFor(config_Name: PremiumPackageKeys.UPGRADE_SUB_INT.rawValue)
            decodeInternalSubscription(data: data)
        }
        if upgrade_sub_external != nil && upgrade_sub_external == PremiumPackageKeys.UPGRADE_SUB_EXT.rawValue {
            let data = CoreDataUtility.fetchPremiumPackageDetailsFor(config_Name: PremiumPackageKeys.UPGRADE_SUB_EXT.rawValue)
            decodeExternalSubscription(data: data)
        }
        
        if apple_internal_trial != nil && apple_internal_trial == PremiumPackageKeys.APPLE_TRIAL_SUB.rawValue {
            let data = CoreDataUtility.fetchPremiumPackageDetailsFor(config_Name: PremiumPackageKeys.APPLE_TRIAL_SUB.rawValue)
            decodeAppleTrialInternal(data: data)
        }
        
        if fast_spring_external_trial != nil && fast_spring_external_trial == PremiumPackageKeys.FAST_SPRING_TRIAL_EXT.rawValue {
            let data = CoreDataUtility.fetchPremiumPackageDetailsFor(config_Name: PremiumPackageKeys.FAST_SPRING_TRIAL_EXT.rawValue)
            decodeFastSpringTrialExternal(data: data)
        }
    }
    
    private func decodeExternalSubscription(data:ConfigurationsDBModel) {
        let keyValueString = data.keyValue
        if let keyValue = keyValueString {
            let data = keyValue.data(using: .utf8)!
            do {
                let decodedExternal = try JSONDecoder().decode([UpgradeExternalData].self, from: data)
                self.upgradeExternalArray = decodedExternal
                self.tableView.reloadData()
            } catch let error as NSError {
                print(error)
            }
        }
    }
    
    private func decodeInternalSubscription(data:ConfigurationsDBModel) {
        let keyValueString = data.keyValue
        if let keyValue = keyValueString {
            let data = keyValue.data(using: .utf8)!
            do {
                let decodedData = try JSONDecoder().decode([UpgradeInternalData].self, from: data)
                self.upgradeInternalArray = decodedData
                self.upgradeInternalArray = upgradeInternalArray.sorted(by: {$0.price ?? "" < $1.price ?? ""})
                self.tableView.reloadData()
            } catch let error as NSError {
                print(error)
            }
        }
    }
    
    private func decodeAppleTrialInternal(data:ConfigurationsDBModel) {
        let keyValueString = data.keyValue
        if let keyValue = keyValueString {
            let data = keyValue.data(using: .utf8)!
            do {
                let decodedData = try JSONDecoder().decode([AppleInternalTrialData].self, from: data)
                self.appleTrialInternalArray = decodedData
                self.appleTrialInternalArray = appleTrialInternalArray.sorted(by: {$0.price ?? "" < $1.price ?? ""})
                self.tableView.reloadData()
            } catch let error as NSError {
                print(error)
            }
        }
    }
    
    private func decodeFastSpringTrialExternal(data:ConfigurationsDBModel) {
        let keyValueString = data.keyValue
        if let keyValue = keyValueString {
            let data = keyValue.data(using: .utf8)!
            do {
                let decodedData = try JSONDecoder().decode([FastSpringExternalTrialData].self, from: data)
                self.fastSpringTrailExternalArray = decodedData
                self.fastSpringTrailExternalArray = fastSpringTrailExternalArray.sorted(by: {$0.price ?? "" < $1.price ?? ""})
                self.tableView.reloadData()
            } catch let error as NSError {
                print(error)
            }
        }
    }
    
    private func goToNextScreenWith(indexPath:IndexPath) {
        if isComingFromTrialScreen {
            ///Un Comment the following code when you have to switch between payment methods
            //            if lastTimeClickedTrial != nil, let lastTimeClicked = lastTimeClickedTrial {
            //                if lastTimeClicked == StringConstants.Constants.FAST_SPRING_TRIAL_EXT {
            //                    self.goToFastSpringTrailExternalPurchase(indexPath: indexPath)
            //                } else if lastTimeClicked == StringConstants.Constants.APPLE_TRIAL_INT {
            //                    self.goToAppleTrialInternalPurchase(indexPath: indexPath)
            //                }
            //            } else {
            if isShoppingFunnelOn {
                self.goToAppleTrialInternalPurchase(indexPath: indexPath)
            } else {
                self.goToFastSpringTrailExternalPurchase(indexPath: indexPath)
            }
            //            }
        } else {
            ///Un Comment the following code when you have to switch between payment methods
            //            if lastTimeClickedUpgrade != nil, let lastTimeClicked = lastTimeClickedUpgrade {
            //                if lastTimeClicked == StringConstants.Constants.EXTERNAL {
            //                    self.goToExternalPurchase(indexPath: indexPath)
            //                } else if lastTimeClicked == StringConstants.Constants.INTERNAL {
            //                    self.goToInternalPurchase(indexPath: indexPath)
            //                }
            //            } else {
            if isShoppingFunnelOn {
                self.goToInternalPurchase(indexPath: indexPath)
            } else {
                self.goToExternalPurchase(indexPath: indexPath)
            }
            //            }
        }
    }
    
    private func goToInternalPurchase(indexPath:IndexPath) {
        let data = self.upgradeInternalArray[indexPath.row]
        if let productID = data.subID {
            let currentLanguage = SwiftCommonUtility.shared.getCurrentLanguageCode()
            let language = data.languages ?? [UserLanguageInt]()
            for lang in language {
                if currentLanguage == lang.language {
                    let name = lang.name ?? ""
                    UserDefaults.standard.set(name, forKey: UserDefaultsConstants.PRODUCT_NAME_INTERNAL)
                    UserDefaults.standard.synchronize()
                }
            }
            UserDefaults.standard.set(StringConstants.Constants.INTERNAL, forKey: UserDefaultsConstants.LAST_TIME_CLICKED_UPGRADE)
            UserDefaults.standard.setValue(data.price, forKey: UserDefaultsConstants.PRODUCT_PRICE_INTERNAL)
            UserDefaults.standard.synchronize()
//            let storyboard = UIStoryboard(name: StoryboardConstants.Storyboards.DASHBOARD, bundle: nil)
            if #available(iOS 13.0, *) {
                navigateToDataUseView(subId: productID, isComingFromDrawer: false)
            } else {
                // Handle older iOS versions if needed
            }
//            let vc = storyboard.instantiateViewController(withIdentifier: StoryboardConstants.Identifiers.DATA_USE_VC_IDENTIFIER) as! DataUseVC
//            vc.subId = productID
//            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @available(iOS 13.0, *)
    func navigateToDataUseView(subId: String, isComingFromDrawer: Bool) {
        // Declare the hosting controller
        var hosting_Controller: UIHostingController<DataUseView>?
        
        // Initialize the hosting controller with the view
        let hostingController = UIHostingController(rootView: DataUseView(
            subId: subId,
            isComingFromDrawer: isComingFromDrawer,
            onDismiss: { [weak self] isComingFromDrawer in
                
                guard let self = self, let hosting_Controller else {
                    print("not getting hosting controller")
                    return
                }
                
                // Remove from parent and hierarchy on the main thread
                DispatchQueue.main.async {
                    hosting_Controller.willMove(toParent: nil)
                    hosting_Controller.view.removeFromSuperview()
                    hosting_Controller.removeFromParent()
                }
            },
            onshowingLoader: { value in
                DispatchQueue.main.async {
                    if value == "1" {
                        SwiftFTUtils.showHUDAdded(to: self.view, withText: "", animated: true)
                    } else {
                        SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
                    }
                }
            },
            onshowingAlert: {
                DispatchQueue.main.async {
                    self.showAlert(vc: self)
                }
            }
        ))
        
        // Add the hosting controller to the view hierarchy
        hosting_Controller = hostingController
        addChild(hostingController)
        hostingController.view.frame = view.bounds
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
    }
    
    private func showAlert(vc: UIViewController) {
        UserDefaults.standard.removeObject(forKey: UserDefaultsConstants.PRODUCT_NAME_INTERNAL)
        UserDefaults.standard.removeObject(forKey: UserDefaultsConstants.PRODUCT_PRICE_INTERNAL)
        UserDefaults.standard.synchronize()
        let alert = UIAlertController(title: "Alert!", message: "Subscription is cancelled!", preferredStyle: .alert)
        let action = UIAlertAction(title: "ok", style: .default) {_ in
            let showNotification = UserDefaults.standard.bool(forKey: UserDefaultsConstants.SHOW_SUB_INT_NOTIFICATION)
            if showNotification == false {
                UserDefaults.standard.setValue(true, forKey: UserDefaultsConstants.SHOW_SUB_INT_NOTIFICATION)
                UserDefaults.standard.setValue(true, forKey: UserDefaultsConstants.SUBSCRIPTION_CHECK_KEY)
                UserDefaults.standard.synchronize()
            }
            self.delegate?.drawerCont.contName = "Drawer"
            UserDefaults.standard.set("Settings", forKey: UserDefaultsConstants.DRAWER_TYPE)
            AppDelegateShared().setupDrawer(0)
        }
        alert.addAction(action)
        vc.showAlert(alert)
    }
    
    private func goToExternalPurchase(indexPath:IndexPath) {
        let data = self.upgradeExternalArray[indexPath.row]
        if let productURL = data.subURL {
            let currentLanguage = SwiftCommonUtility.shared.getCurrentLanguageCode()
            let language = data.languages ?? [UserLanguageExt]()
            for lang in language {
                if currentLanguage == lang.language {
                    let name = lang.name ?? ""
                    UserDefaults.standard.set(name, forKey: UserDefaultsConstants.PRODUCT_NAME_EXTERNAL)
                    UserDefaults.standard.synchronize()
                }
            }
            UserDefaults.standard.set(StringConstants.Constants.EXTERNAL, forKey: UserDefaultsConstants.LAST_TIME_CLICKED_UPGRADE)
            UserDefaults.standard.set(data.price, forKey: UserDefaultsConstants.PRODUCT_PRICE_EXTERNAL)
            UserDefaults.standard.set(data.subURL, forKey: UserDefaultsConstants.PRODUCT_SUB_URL_EXTERNAL)
            UserDefaults.standard.synchronize()
            let storyboard = UIStoryboard(name: StoryboardConstants.Storyboards.DASHBOARD, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: StoryboardConstants.Identifiers.BROWSER_VC_IDENTIFIER) as! BrowserViewController
            vc.strUrl = productURL
            vc.isComingFromUpgrade = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func goToAppleTrialInternalPurchase(indexPath:IndexPath) {
        let data = self.appleTrialInternalArray[indexPath.row]
        if let productID = data.subID {
            let currentLanguage = SwiftCommonUtility.shared.getCurrentLanguageCode()
            let language = data.languages ?? [AppleInternalLanguage]()
            for lang in language {
                if currentLanguage == lang.language {
                    let name = lang.name ?? ""
                    UserDefaults.standard.set(name, forKey: UserDefaultsConstants.PRODUCT_NAME_INTERNAL)
                    UserDefaults.standard.synchronize()
                }
            }
            UserDefaults.standard.set(StringConstants.Constants.APPLE_TRIAL_INT, forKey: UserDefaultsConstants.LAST_TIME_CLICKED_TRIAL)
            UserDefaults.standard.setValue(data.price, forKey: UserDefaultsConstants.PRODUCT_PRICE_INTERNAL)
            UserDefaults.standard.synchronize()
//            let storyboard = UIStoryboard(name: StoryboardConstants.Storyboards.DASHBOARD, bundle: nil)
            if #available(iOS 13.0, *) {
                navigateToDataUseView(subId: productID, isComingFromDrawer: true)
            } else {
                // Handle older iOS versions if needed
            }
//            let vc = storyboard.instantiateViewController(withIdentifier: StoryboardConstants.Identifiers.DATA_USE_VC_IDENTIFIER) as! DataUseVC
//            if isCommingFromDrwa {
//                vc.isComingFromDrawer = true
//            }
//            vc.subId = productID
//            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func goToFastSpringTrailExternalPurchase(indexPath:IndexPath) {
        let data = self.fastSpringTrailExternalArray[indexPath.row]
        if let productURL = data.subURL {
            let currentLanguage = SwiftCommonUtility.shared.getCurrentLanguageCode()
            let language = data.languages ?? [FastSpringExternalLanguage]()
            for lang in language {
                if currentLanguage == lang.language {
                    let name = lang.name ?? ""
                    UserDefaults.standard.set(name, forKey: UserDefaultsConstants.PRODUCT_NAME_EXTERNAL)
                    UserDefaults.standard.synchronize()
                }
            }
            UserDefaults.standard.set(StringConstants.Constants.FAST_SPRING_TRIAL_EXT, forKey: UserDefaultsConstants.LAST_TIME_CLICKED_TRIAL)
            UserDefaults.standard.setValue(data.price, forKey: UserDefaultsConstants.PRODUCT_PRICE_EXTERNAL)
            UserDefaults.standard.set(data.subURL, forKey: UserDefaultsConstants.PRODUCT_SUB_URL_EXTERNAL)
            UserDefaults.standard.synchronize()
            let storyboard = UIStoryboard(name: StoryboardConstants.Storyboards.DASHBOARD, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: StoryboardConstants.Identifiers.BROWSER_VC_IDENTIFIER) as! BrowserViewController
            vc.strUrl = productURL
            vc.isComingFromTrial = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func dismissBack() {
        let transition = CATransition()
        transition.duration = 0.6
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromBottom
        self.navigationController?.view.layer.add(transition, forKey: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    private func subscriptionCancelled() {
        let productName = UserDefaults.standard.string(forKey: UserDefaultsConstants.PRODUCT_NAME_EXTERNAL) ?? ""
        let productPrice = UserDefaults.standard.string(forKey: UserDefaultsConstants.PRODUCT_PRICE_EXTERNAL) ?? ""
        let subURL = UserDefaults.standard.string(forKey: UserDefaultsConstants.PRODUCT_SUB_URL_EXTERNAL) ?? ""
        let params = [ "sub_url" : subURL,
                       "product_name" : productName,
                       "product_price" : productPrice
        ] as! [String :Any]
        SwiftFTUtils.showHUDAdded(to: view, withText: "Loading...", animated: true)
        HLApiManager.networkCallSubscriptionCancelled(params: params) { response, error in
            if let result = response {
                SwiftFTUtils.hideHUDAdded(to: self.view, animated: false)
                if result {
                    UserDefaults.standard.removeObject(forKey: UserDefaultsConstants.PRODUCT_NAME_EXTERNAL)
                    UserDefaults.standard.removeObject(forKey: UserDefaultsConstants.PRODUCT_PRICE_EXTERNAL)
                    UserDefaults.standard.removeObject(forKey: UserDefaultsConstants.PRODUCT_SUB_URL_EXTERNAL)
                    UserDefaults.standard.synchronize()
                    let alert = UIAlertController(title: "Alert!", message: "Subscription is cancelled!", preferredStyle: .alert)
                    let action = UIAlertAction(title: "ok", style: .default) {_ in
                        let showNotification = UserDefaults.standard.bool(forKey: UserDefaultsConstants.SHOW_SUB_EXT_NOTIFICATION)
                        if showNotification == false {
                            UserDefaults.standard.set(true, forKey: UserDefaultsConstants.SUBSCRIPTION_CHECK_KEY)
                            UserDefaults.standard.set(true, forKey: UserDefaultsConstants.SHOW_SUB_EXT_NOTIFICATION)
                            UserDefaults.standard.synchronize()
                        }
                        self.dismissBack()
                    }
                    alert.addAction(action)
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    //MARK: ACOUNT API CALL
    private func accountApiData(token: String){
        SwiftFTUtils.showHUDAdded(to: view, withText: "Loading...", animated: true)
        HLApiManager.accountApiFunc(token: token) { response, error in
            if response != nil{
                SwiftFTUtils.hideHUDAdded(to: self.view, animated: false)
                UserDefaults.standard.removeObject(forKey: UserDefaultsConstants.PRODUCT_ACCOUNT_ARRAY)
                UserDefaults.standard.synchronize()
                self.productArr.removeAll()
                self.profileObject = response?.profile
                self.subscriptionData = response?.billing?.subscriptions
                if let emailVerifiedAt = response?.profile?.emailVerifiedAt {
                    UserDefaults.standard.setValue(emailVerifiedAt, forKey: UserDefaultsConstants.EMAIL_VERIFIED_AT_ACCOUNT)
                    UserDefaults.standard.synchronize()
                } else {
                    UserDefaults.standard.setValue(nil, forKey: UserDefaultsConstants.EMAIL_VERIFIED_AT_ACCOUNT)
                    UserDefaults.standard.synchronize()
                }
                
                if let emailBounce = response?.profile?.emailBounce {
                    UserDefaults.standard.set(emailBounce, forKey: UserDefaultsConstants.EMAIL_BOUNCE_ACCOUNT)
                    UserDefaults.standard.synchronize()
                } else {
                    UserDefaults.standard.setValue(nil, forKey: UserDefaultsConstants.EMAIL_BOUNCE_ACCOUNT)
                    UserDefaults.standard.synchronize()
                }
                
                if let emailComplaint = response?.profile?.emailComplaint {
                    UserDefaults.standard.setValue(emailComplaint, forKey: UserDefaultsConstants.EMAIL_COMPLAINT_ACCOUNT)
                    UserDefaults.standard.synchronize()
                } else {
                    UserDefaults.standard.setValue(nil, forKey: UserDefaultsConstants.EMAIL_COMPLAINT_ACCOUNT)
                    UserDefaults.standard.synchronize()
                }
                
                let userLanguage = response?.profile?.language
                if(userLanguage != nil){
                    UserDefaults.standard.set(userLanguage, forKey: UserDefaultsConstants.USER_LANGUAGE)
                } else {
                    UserDefaults.standard.set(NSLocale.current.languageCode, forKey: UserDefaultsConstants.USER_LANGUAGE)
                }
                let id = response?.profile?.id
                if (id != nil){
                    AppDelegateShared().userDefault.set(id, forKey: UserDefaultsConstants.USER_ID)
                    AppDelegateShared().userDefault.synchronize()
                } else {
                    AppDelegateShared().userDefault.set(StringConstants.Constants.EMPTY_STRING, forKey: UserDefaultsConstants.USER_ID)
                    AppDelegateShared().userDefault.synchronize()
                }
                
                let name = response?.profile?.name
                if (name != nil){
                    UserDefaults.standard.set(name, forKey: UserDefaultsConstants.USER_NAME)
                } else {
                    UserDefaults.standard.set(StringConstants.Constants.EMPTY_STRING, forKey: UserDefaultsConstants.USER_NAME)
                }
                
                let email = response?.profile?.email
                if (email != nil){
                    UserDefaults.standard.set(email, forKey: UserDefaultsConstants.USER_EMAIL)
                    AppDelegateShared().userDefault.set(email, forKey: UserDefaultsConstants.USER_EMAIL)
                    AppDelegateShared().userDefault.synchronize()
                } else {
                    UserDefaults.standard.set(StringConstants.Constants.EMPTY_STRING, forKey: UserDefaultsConstants.USER_EMAIL)
                    AppDelegateShared().userDefault.set(StringConstants.Constants.EMPTY_STRING, forKey: UserDefaultsConstants.USER_EMAIL)
                    AppDelegateShared().userDefault.synchronize()
                }
                
                let phone = response?.profile?.phone
                if (phone != nil){
                    UserDefaults.standard.set(phone, forKey: UserDefaultsConstants.USER_PHONE)
                } else {
                    UserDefaults.standard.set(StringConstants.Constants.EMPTY_STRING, forKey: UserDefaultsConstants.USER_PHONE)
                }
                
                let package = response?.profile?.package
                if package != nil {
                    UserDefaults.standard.set(package, forKey: UserDefaultsConstants.BILLING_STATUS)
                } else {
                    UserDefaults.standard.set(StringConstants.Constants.EMPTY_STRING, forKey: UserDefaultsConstants.BILLING_STATUS)
                }
                
                let gender = response?.profile?.gender
                if (gender != nil) {
                    UserDefaults.standard.set(gender, forKey: UserDefaultsConstants.USER_GENDER)
                    if gender == StringConstants.Constants.MALE {
                        UserDefaults.standard.set(StringConstants.Constants.FATHER, forKey: UserDefaultsConstants.USER_RELATION)
                    } else {
                        UserDefaults.standard.set(StringConstants.Constants.MOTHER, forKey: UserDefaultsConstants.USER_RELATION)
                    }
                } else {
                    UserDefaults.standard.set(StringConstants.Constants.FATHER, forKey: UserDefaultsConstants.USER_RELATION)
                    UserDefaults.standard.set(StringConstants.Constants.EMPTY_STRING, forKey: UserDefaultsConstants.USER_GENDER)
                }
                
                let type = response?.profile?.type
                if (type != nil) {
                    UserDefaults.standard.set(type, forKey: UserDefaultsConstants.USER_TYPE)
                } else {
                    UserDefaults.standard.set(StringConstants.Constants.EMPTY_STRING, forKey: UserDefaultsConstants.USER_TYPE)
                }
                if let subs = response?.billing?.subscriptions {
                    for value in subs {
                        let product = value.psp ?? StringConstants.Constants.EMPTY_STRING
                        self.productArr.append(product)
                        UserDefaults.standard.set(self.productArr, forKey: UserDefaultsConstants.PRODUCT_ACCOUNT_ARRAY)
                        UserDefaults.standard.synchronize()
                        //                        CoreDataUtility.saveSubscriptionData(subs: value)
                    }
                }
                UserDefaults.standard.synchronize()
                let billingStatus = UserDefaults.standard.string(forKey: UserDefaultsConstants.BILLING_STATUS)
                if (billingStatus != StringConstants.Subscriptions.PREMIUM_CAPITAL || billingStatus != StringConstants.Subscriptions.PREMIUM_SMALL) {
                    self.subscriptionCancelled()
                } else {
                    UserDefaults.standard.set(true, forKey: UserDefaultsConstants.UPDATE_HOME_DATA_WHILE_UPGRADE)
                    UserDefaults.standard.synchronize()
                    self.dismissBack()
                }
            } else {
                print(StringConstants.Errors.APP_CONFIG_NOT_FOUND,error ?? StringConstants.Constants.NIL_VALUE)
            }
        }
    }
}

//MARK: - TableView Delegates & DataSource
extension PremiumPackageVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isComingFromTrialScreen {
            ///Un Comment the following code when you have to switch between payment methods
            //            if lastTimeClickedTrial != nil, let lastTimeClicked = lastTimeClickedTrial {
            //                if lastTimeClicked == StringConstants.Constants.APPLE_TRIAL_INT {
            //                    return self.appleTrialInternalArray.count
            //                } else {
            //                    return self.fastSpringTrailExternalArray.count
            //                }
            //            } else {
            if isShoppingFunnelOn {
                return self.appleTrialInternalArray.count
            } else {
                return self.fastSpringTrailExternalArray.count
            }
            //            }
        } else {
            ///Un Comment the following code when you have to switch between payment methods
            //            if lastTimeClickedUpgrade != nil, let lastTimeClicked = lastTimeClickedUpgrade {
            //                if lastTimeClicked == StringConstants.Constants.INTERNAL {
            //                    return self.upgradeInternalArray.count
            //                } else {
            //                    return self.upgradeExternalArray.count
            //                }
            //            } else {
            if isShoppingFunnelOn {
                return self.upgradeInternalArray.count
            } else {
                return self.upgradeExternalArray.count
            }
            //            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NibConstants.Identifiers.PREMIUM_PACKAGE_CELL, for: indexPath) as! PremiumPackageCell
        
        if isComingFromTrialScreen {
            ///Un Comment the following code when you have to switch between payment methods
            //            if lastTimeClickedTrial != nil , let lastTimeClicked = lastTimeClickedTrial {
            //                if lastTimeClicked == StringConstants.Constants.APPLE_TRIAL_INT {
            //                    cell.setUpCellForAppleTrialInternal(data: appleTrialInternalArray[indexPath.row])
            //                    cell.indexPath = indexPath
            //                    cell.premiumDelegate = self
            //                } else if lastTimeClicked == StringConstants.Constants.FAST_SPRING_TRIAL_EXT {
            //                    cell.setUpCellForFastSpringExternal(data: fastSpringTrailExternalArray[indexPath.row])
            //                    cell.indexPath = indexPath
            //                    cell.premiumDelegate = self
            //                }
            //            } else {
            if isShoppingFunnelOn {
                cell.setUpCellForAppleTrialInternal(data: appleTrialInternalArray[indexPath.row])
                cell.indexPath = indexPath
                cell.premiumDelegate = self
            } else {
                cell.setUpCellForFastSpringExternal(data: fastSpringTrailExternalArray[indexPath.row])
                cell.indexPath = indexPath
                cell.premiumDelegate = self
            }
            //            }
        } else {
            ///Un Comment the following code when you have to switch between payment methods
            //            if lastTimeClickedUpgrade != nil , let lastTimeClicked = lastTimeClickedUpgrade {
            //                if lastTimeClicked == StringConstants.Constants.INTERNAL {
            //                    cell.setUpCellForInternal(data: upgradeInternalArray[indexPath.row])
            //                    cell.indexPath = indexPath
            //                    cell.premiumDelegate = self
            //                } else if lastTimeClicked == StringConstants.Constants.EXTERNAL {
            //                    cell.setUpCellForExternal(data: upgradeExternalArray[indexPath.row])
            //                    cell.indexPath = indexPath
            //                    cell.premiumDelegate = self
            //                }
            //            } else {
            if isShoppingFunnelOn {
                cell.setUpCellForInternal(data: upgradeInternalArray[indexPath.row])
                cell.indexPath = indexPath
                cell.premiumDelegate = self
            } else {
                cell.setUpCellForExternal(data: upgradeExternalArray[indexPath.row])
                cell.indexPath = indexPath
                cell.premiumDelegate = self
            }
            //            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

//MARK: - PremiumCell Delegates
extension PremiumPackageVC : PremiumPackageCellDelegates {
    func upgradePackage(at indexPath: IndexPath) {
        self.goToNextScreenWith(indexPath: indexPath)
    }
}
