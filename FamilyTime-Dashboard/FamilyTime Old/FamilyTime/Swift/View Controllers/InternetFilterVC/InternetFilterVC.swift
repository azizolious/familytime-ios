//
//  InternetFilterVC.swift
//  FamilyTime
//
//  Created by Sana Ullah on 02/05/2019.
//  Copyright © 2019 YumyApps. All rights reserved.
//

import UIKit

class InternetFilterVC: UIViewController {

    
    @IBOutlet weak var enableFilterLbl: UILabel!
    @IBOutlet weak var enableSwitch: AppBlockerSwitch!
    @IBOutlet weak var tableVu: UITableView!
    var filterArray = [InterFilterModel(title: "safesearch".localized, description: "filters_adult_pornographic".localized, imageName: "safeSearch"),
                       InterFilterModel(title: "pornography".localized, description: "blocks_access_mature".localized, imageName: "pornography"),
                       InterFilterModel(title: "drugs_abortion".localized, description: "blocks_websites_drugs_abortion".localized, imageName: "drugAddiction"),
                       InterFilterModel(title: "dating_gambling".localized, description: "blocks_sites_sexual_relations".localized, imageName: "gambling"),]
    let child_Id = UserDefaults.standard.string(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
    var controlApiData = ControlCodableModel()
    var control = Control()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LiveVisitorManager.shared.updateScreen(
            "Internet Filters"
        )
        
        initialization()
    }
    
    func initialization(){
        tableVu.estimatedRowHeight = 0
        tableVu.rowHeight = UITableView.automaticDimension
        
        navigationItem.title = "settings_card_2_android_5".localized
        enableFilterLbl.text = "internet_filters_switch_1".localized
        tableVu.register(UINib(nibName: "ToggleWebBlockerCell", bundle: nil), forCellReuseIdentifier: "ToggleWebBlockerCell")
        tableVu.register(UINib(nibName: "InternetFilterCell", bundle: nil), forCellReuseIdentifier: "InternetFilterCell")
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(
            title: "",
            style: .plain,
            target: nil,
            action: nil)
        getControlFromDb()
    }
    

    @IBAction func savePress(_ sender: UIButton) {
        getIdentifier()
    }
    func getControlFromDb() {
        let controlObj = DBManager.shared.fetchAppBlockControl(identifier: "internet_filters")
        self.control = controlObj
        self.enableSwitch.isOn = controlObj.state?.boolValue ?? false
    }
    
    
    func getIdentifier() {
        SwiftFTUtils.showHUDAdded(to: self.view, withText: "", animated: true)
        
        if let childId = control.childID,
           let featureId = control.featureID,
           let state = control.state {
            
            HLApiManager.putControlApi(childId: childId,
                                       featureId: featureId,
                                       state: state, identifier: "internet_filters") {err in
                SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
                if err != nil {
                    SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
                    CommonModel.showAlert("alert_error".localized, msg: err ?? "Nothing")
                    return
                }
                DBManager.shared.fetchControlAndUpdate(identifier: "internet_filters", state: self.control.state ?? 0)
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
            CommonModel.showAlert("alert_error".localized, msg: "alert_something_wrong_again")
            print("❌ Missing required params (childId / featureId / identifier)")
        }
    }
    
    @objc func handleSave(){
       
    }
    
    @objc func didSettingsChangedFor(switchVu:AppBlockerSwitch){
    }
    
    //MARK: - UI ACTIONS
    
    @IBAction func enableFilterAction(_ sender: UISwitch) {
        UIView.setAnimationsEnabled(false)
        tableVu.beginUpdates()
        tableVu.reloadSections(NSIndexSet(index: 0) as IndexSet, with: .none)
        tableVu.endUpdates()
        UIView.setAnimationsEnabled(true)
    }
    @objc func mainToggleChanged(_ sender: UISwitch) {
        self.control.state = sender.isOn.boolToInt()
    }
}

extension InternetFilterVC : UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        filterArray.count + 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ToggleWebBlockerCell", for: indexPath) as! ToggleWebBlockerCell
            cell.selectionStyle = .none
            cell.titleLbl.text = "enable_internet_filters".localized
            cell.descLbl.text = "internet_filters_inappropriate_content".localized
            cell.mainSwitch.isOn = control.state?.boolValue ?? false
            cell.mainSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
            cell.mainSwitch.addTarget(self, action: #selector(mainToggleChanged(_ :)), for: .valueChanged)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "InternetFilterCell", for: indexPath) as! InternetFilterCell
            cell.selectionStyle = .none
            cell.titleLbl.text = filterArray[indexPath.section - 1].title
            cell.descLbl.text = filterArray[indexPath.section - 1].description
            cell.img.image = UIImage(named: filterArray[indexPath.section - 1].imageName)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 7
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
struct InterFilterModel {
    var title: String
    var description: String
    var imageName: String
}
