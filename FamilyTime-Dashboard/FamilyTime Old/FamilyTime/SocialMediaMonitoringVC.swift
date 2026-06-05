//
//  SocialMediaMonitoringVC.swift
//  FamilyTime
//
//  Created by Sufyan on 31/10/2023.
//  Copyright © 2023 YumyApps. All rights reserved.
//

import UIKit

class SocialMediaMonitoringVC: UIViewController {

    @IBOutlet weak var tableVu: UITableView!
    var vm = SocialMediaVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vm.getReady()
        vm.control = DBManager.shared.fetchAppBlockControl(identifier: "social_monitoring")
        vm.state = vm.control.state?.boolValue ?? false
        tableVu.dataSource = self
        tableVu.delegate = self
        tableVu.register(UINib(nibName: "SocialMediaMainToggleCell", bundle: nil), forCellReuseIdentifier: "SocialMediaMainToggleCell")
        tableVu.register(UINib(nibName: "SocialMediaCell", bundle: nil), forCellReuseIdentifier: "SocialMediaCell")
        self.title = "social_title".localized
        vm.tblReloader = {
            self.tableVu.reloadData()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        LiveVisitorManager.shared.updateScreen(
            "Social Media Monitor"
        )
    }
    
    @objc func socialSwitchTapped(_ sender: UISwitch?) {
        let index = sender?.tag ?? 0
        if index == 0 {
            if vm.apps.allSatisfy({$0.isSelected == false}) {
                sender?.isOn = false
                return
            }
            vm.apps = vm.apps.map({ SocialMonitoringApp in
                var app = SocialMonitoringApp
                if app.isSelected || app.pkgName == "" {
                    app.isMonitor = sender?.isOn ?? false
                }else{
                    app.isMonitor = false
                }
                return app
            })
            tableVu.reloadSections(IndexSet(integer: 1), with: .automatic)
        } else {
            vm.apps[index].isMonitor = sender?.isOn ?? false
            if !(sender?.isOn ?? false)  {
                vm.apps[0].isMonitor = false
                tableVu.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .automatic)
            } else {
                
                let ap = vm.apps.filter({$0.isSelected == true})
                if ap.allSatisfy({$0.isMonitor == true}) {
                    vm.apps[0].isMonitor = true
                    tableVu.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .automatic)
                }
            }
        }
    }
    @objc func mainSwitchTapped(_ sender: UISwitch?) {
        vm.state.toggle()
        tableVu.reloadSections(IndexSet(integer: 1), with: .none)
    }
    
    @IBAction func savePress(_ sender: Any) {
        if !vm.state {
            vm.apps = vm.apps.map({obj in
                var app = obj
                app.isMonitor = false
                return app
            })
        }
        
        vm.sendSocialMonitorRequest(vu: self.view, navigation: self.navigationController)
    }
}

extension SocialMediaMonitoringVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return vm.apps.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SocialMediaMainToggleCell") as! SocialMediaMainToggleCell
            cell.mainSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
            print("state:", vm.state)
            cell.mainSwitch.isOn = vm.state
            cell.mainSwitch.addTarget(self, action: #selector(mainSwitchTapped(_:)),
                                      for: .valueChanged)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SocialMediaCell") as! SocialMediaCell
            cell.socialSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
            cell.socialTitle.text = vm.apps[indexPath.row].name
            cell.socialImg.isHidden = vm.apps[indexPath.row].hideImg
            if !vm.state {
                cell.socialSwitch.isEnabled = false
                cell.socialSwitch.isOn = false
            } else {
                cell.socialSwitch.isOn = vm.apps[indexPath.row].isMonitor
                cell.socialSwitch.isEnabled = indexPath.row == 0 ? true : vm.apps[indexPath.row].isSelected
            }
            cell.socialImg.alpha = indexPath.row == 0 || vm.apps[indexPath.row].isSelected ? 1 : 0.3
            cell.socialTitle.alpha = indexPath.row == 0 || vm.apps[indexPath.row].isSelected ? 1 : 0.3
            cell.uninstalledView.isHidden =  indexPath.row == 0 ? true : vm.apps[indexPath.row].isSelected
            cell.socialImg.image = UIImage(named: vm.apps[indexPath.row].imgName)
            cell.socialSwitch.tag = indexPath.row
            cell.socialSwitch.addTarget(self, action: #selector(socialSwitchTapped(_:)),
                                        for: .valueChanged)
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
