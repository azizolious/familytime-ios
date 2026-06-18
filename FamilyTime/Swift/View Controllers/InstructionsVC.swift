//
//  InstructionsVC.swift
//  FamilyTime
//
//  Created by Usama-Apps on 11/11/2022.
//  Copyright © 2022 YumyApps. All rights reserved.
//

import UIKit

class InstructionsVC: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Variables
    private var isShoppingFunnel : Bool = false
    private var isScanning : Bool = false
    private var viewDetailsTitle : String?

    //MARK: - View LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        didSetTableViewNibAndDelegates()
        self.title = "add_child".localized
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        LiveVisitorManager.shared.updateScreen(
            "Add Device"
        )
    }
    
    //MARK: - Helper Functions
    private func didSetTableViewNibAndDelegates() {
        isShoppingFunnel = UserDefaults.standard.bool(forKey: UserDefaultsConstants.SHOPPING_FUNNEL_VALUE)
        isScanning = UserDefaults.standard.bool(forKey: UserDefaultsConstants.SHOPPING_FUNNEL_VALUE)
        tableView.register(UINib(nibName: NibConstants.Names.INSTRUCTIONS_CELL, bundle: nil), forCellReuseIdentifier: NibConstants.Identifiers.INSTRUCTIONS_CELL)
        tableView.register(UINib(nibName: NibConstants.Names.QR_CODE_CELL, bundle: nil), forCellReuseIdentifier: NibConstants.Identifiers.QR_CODE_CELL)
        tableView.delegate = self
        tableView.dataSource = self
        viewDetailsTitle = StringConstants.Constants.VIEW_DETAILED_GUIDE
        UserDefaults.standard.set(StringConstants.Constants.VIEW_DETAILED_GUIDE, forKey: UserDefaultsConstants.RELOAD_DASHBOARD_VIA_INSTRUCTION)
        UserDefaults.standard.synchronize()
    }
    
    private func handleHowToInstall() {
        //userlanguage
        let prefs = UserDefaults.standard
        // getting an NSString
        let userlanguage = prefs.string(forKey: "userlanguage") ?? ""
        var myString: String? = nil
        if userlanguage == "en" || userlanguage == "he" || userlanguage == "tr" {
            myString = "https://familytime.io/how-to-install/familytime-child-app.html?utm_source=dashboard&amp;utm_medium=ios&amp;utm_campaign=ActivateChild"
        } else {
            myString = "https://familytime.io/\(userlanguage)/how-to-install/familytime-child-app.html?utm_source=dashboard&amp;utm_medium=ios&amp;utm_campaign=ActivateChild"
        }
        viewDetailsTitle = StringConstants.Constants.YES_I_HAVE_DONE_IT
        UserDefaults.standard.set(StringConstants.Constants.YES_I_HAVE_DONE_IT, forKey: UserDefaultsConstants.RELOAD_DASHBOARD_VIA_INSTRUCTION)
        UserDefaults.standard.synchronize()
        open(scheme: myString ?? "")
    }

    private func open(scheme: String) {
        if let url = URL(string: scheme) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:],
                                          completionHandler: {
                    (success) in
                    print("Open \(scheme): \(success)")
                })
            } else {
                let success = UIApplication.shared.openURL(url)
                print("Open \(scheme): \(success)")
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.tableView.reloadData()
            }
        }
    }
    
    private func goToDashboard() {
        viewDetailsTitle = StringConstants.Constants.VIEW_DETAILED_GUIDE
        UserDefaults.standard.set(StringConstants.Constants.VIEW_DETAILED_GUIDE, forKey: UserDefaultsConstants.RELOAD_DASHBOARD_VIA_INSTRUCTION)
        UserDefaults.standard.synchronize()
        tableView.reloadData()
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func shareAppLink() {
       // Replace 'yourAppLink' with the actual App Store link to your app.
       let appLink = "https://store.familytime.io/"
       
       let items: [Any] = [appLink]
       
       let activityViewController = UIActivityViewController(
           activityItems: items,
           applicationActivities: nil
       )
       
       // Exclude specific sharing options if needed
       activityViewController.excludedActivityTypes = [
           .addToReadingList,
           .assignToContact,
           .postToVimeo,
           .openInIBooks
       ]
       
       // If you're on an iPad, you'll also need to specify the source view and arrow direction for the popover.
       if let popoverController = activityViewController.popoverPresentationController {
           popoverController.sourceView = self.view
       }
       
        present(activityViewController, animated: true, completion: nil)
   }
}

//MARK: - TableView Delegate and Datasources
extension InstructionsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isShoppingFunnel && isScanning {
            return 970
        } else {
            return 780
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isShoppingFunnel && isScanning {
            let qrCell = tableView.dequeueReusableCell(withIdentifier: NibConstants.Identifiers.QR_CODE_CELL) as! QRCodeCell
            let title = UserDefaults.standard.string(forKey: UserDefaultsConstants.RELOAD_DASHBOARD_VIA_INSTRUCTION)
            qrCell.buttonTitle = title ?? ""
            qrCell.setUpUI(title: title ?? "")
            qrCell.qrCellDelegate = self
            qrCell.shareTapp = {
                self.shareAppLink()
            }
            return qrCell
        } else {
            let instructionsCell = tableView.dequeueReusableCell(withIdentifier: NibConstants.Identifiers.INSTRUCTIONS_CELL) as! InstructionsCell
            let title = UserDefaults.standard.string(forKey: UserDefaultsConstants.RELOAD_DASHBOARD_VIA_INSTRUCTION)
            instructionsCell.buttonTitle = title ?? ""
            instructionsCell.setUpUI(title: title ?? "")
            instructionsCell.instructionDelegate = self
            instructionsCell.shareTapp = {
                self.shareAppLink()
            }
            return instructionsCell
        }
    }
}

//MARK: - QRCodeCell Delegates
extension InstructionsVC: QRCodeCellDelegates {
    func viewDetailsInstructions() {
        if viewDetailsTitle == StringConstants.Constants.VIEW_DETAILED_GUIDE {
            handleHowToInstall()
        } else {
            goToDashboard()
        }
    }
    
    func cantScan() {
        isShoppingFunnel = false
        isScanning = false
        tableView.reloadData()
    }
}

//MARK: - InstructionsCell Delegates
extension InstructionsVC : InstructionCellDelegates {
    func detailedButtonPressed() {
        if viewDetailsTitle == StringConstants.Constants.VIEW_DETAILED_GUIDE {
            handleHowToInstall()
        } else {
            goToDashboard()
        }
    }
    
    func cantLoginButtonPressed() {
        isShoppingFunnel = true
        isScanning = true
        tableView.reloadData()
    }
}
