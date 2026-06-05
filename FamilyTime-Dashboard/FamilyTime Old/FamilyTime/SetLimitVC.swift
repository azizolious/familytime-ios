//
//  SetLimitVC.swift
//  FamilyTime
//
//  Created by Sufyan on 17/10/2023.
//  Copyright © 2023 YumyApps. All rights reserved.
//

import UIKit

class SetLimitVC: UIViewController {
    
    @IBOutlet weak var segmentControl: OYSegmentControl!
    @IBOutlet weak var tblVu: UITableView!
    
    var vm = SetLimitVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.vm.selectedApps = vm.selectedApps.map({ apps in
            if apps.appLimit == "0" {
                var app = apps
                app.sunday = nil
                app.monday = nil
                app.wednesday = nil
                app.tuesday = nil
                app.thursday = nil
                app.friday = nil
                app.saturday = nil
                return app
            } else {
                return apps
            }
        })
        tblVu.delegate = self
        tblVu.dataSource = self
        tblVu.register(UINib(nibName: "SetLimitCell", bundle: nil), forCellReuseIdentifier: "SetLimitCell")
        tblVu.register(UINib(nibName: "AppLimitTableCell", bundle: nil), forCellReuseIdentifier: "AppLimitTableCell")
        tblVu.register(UINib(nibName: "CustomDayLimitCell", bundle: nil), forCellReuseIdentifier: "CustomDayLimitCell")
        self.title = "individual_app_limit".localized
        segmentControl.setTitle("everyday".localized, forSegmentAt: 0)
        segmentControl.setTitle("custom".localized, forSegmentAt: 1)
    }

    @IBAction func segmentChange(_ sender: UISegmentedControl) {
        vm.customSelection = sender.selectedSegmentIndex.boolValue
        let index = IndexSet(integer: 0)
        tblVu.reloadSections(index, with: .automatic)
    }
    
    @IBAction func applyBtnTapped(_ sender: Any) {
        if !vm.customSelection {
            if !vm.selectedhours.isEmpty || !vm.selectedMinutes.isEmpty {
                print("OK")
            } else {
                return
            }
        } else {
            if !vm.isValid {
                if !vm.boolArr.contains(true){
                    return
                }
            } else {
                for obj in vm.selectedApps {
                    if obj.sunday == 0 || obj.sunday == nil, obj.monday == 0 || obj.monday == nil,
                       obj.tuesday == 0 || obj.tuesday == nil, obj.wednesday == 0 || obj.wednesday == nil,
                       obj.thursday == 0 || obj.thursday == nil, obj.friday == 0 || obj.friday == nil,
                       obj.saturday == 0 || obj.saturday == nil {
                        return
                    }
                }
            }
        }
        SwiftFTUtils.showHUDAdded(to: self.view, withText: "", animated: true)
        vm.applyTapped(callback: { [weak self] in
            SwiftFTUtils.hideHUDAdded(to: self?.view, animated: true)
            let vc = ApplimitSuccessPopup(nibName: "ApplimitSuccessPopup", bundle: nil)
            vc.tapped = { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self?.navigationController?.present(vc, animated: true, completion: nil)
        })
    }
    
    @objc func imgTapped(_ sender: UITapGestureRecognizer) {
        let index = (sender.view?.tag)!
        let vc = DeleteChildVC(nibName: "DeleteChildVC", bundle: nil)
        vc.limitApps = [vm.selectedApps[index]]
        vc.deleteLimit = true
        vc.deleteLimitCallback = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.navigationController?.present(vc, animated: true, completion: nil)

    }
}

extension SetLimitVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            if vm.customSelection {
                return 7
            } else {
                return   1
            }
        } else {
            return vm.selectedApps.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if vm.customSelection {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CustomDayLimitCell") as! CustomDayLimitCell
                cell.dayNameLbl.text = vm.daysArray[indexPath.row]
                        switch indexPath.row {
                        case 0:
                            if vm.selectedApps[0].sunday != nil && vm.selectedApps[0].appLimit == "1" && vm.selectedApps[0].sunday != 0{
                                cell.switchChanged.isOn = true
                                vm.boolArr[indexPath.row] = true
                                cell.timeBtn.setTitle(vm.getTimeForSpecificDay(seconds: vm.selectedApps[0].sunday ?? 0), for: .normal)
                                cell.timeBtn.tintColor = UIColor.init(hexString: "#156CF7")
                            }else {
                                cell.switchChanged.isOn = false
                                cell.timeBtn.setTitle("0h 0min", for: .normal)
                                cell.timeBtn.tintColor = UIColor.lightGray
                            }
                        case 1:
                            if vm.selectedApps[0].monday != nil && vm.selectedApps[0].appLimit == "1" && vm.selectedApps[0].monday != 0{
                                cell.switchChanged.isOn = true
                                vm.boolArr[indexPath.row] = true
                                cell.timeBtn.setTitle(vm.getTimeForSpecificDay(seconds: vm.selectedApps[0].monday ?? 0), for: .normal)
                                cell.timeBtn.tintColor = UIColor.init(hexString: "#156CF7")
                            }else {
                                cell.switchChanged.isOn = false
                                cell.timeBtn.setTitle("0h 0min", for: .normal)
                                cell.timeBtn.tintColor = UIColor.lightGray
                            }
                        case 2:
                            if vm.selectedApps[0].tuesday != nil && vm.selectedApps[0].appLimit == "1" && vm.selectedApps[0].tuesday != 0{
                                cell.switchChanged.isOn = true
                                vm.boolArr[indexPath.row] = true
                                cell.timeBtn.setTitle(vm.getTimeForSpecificDay(seconds: vm.selectedApps[0].tuesday ?? 0), for: .normal)
                                cell.timeBtn.tintColor = UIColor.init(hexString: "#156CF7")
                            }else {
                                cell.switchChanged.isOn = false
                                
                                cell.timeBtn.setTitle("0h 0min", for: .normal)
                                cell.timeBtn.tintColor = UIColor.lightGray
                            }
                        case 3:
                            if vm.selectedApps[0].wednesday != nil && vm.selectedApps[0].appLimit == "1" && vm.selectedApps[0].wednesday != 0{
                                cell.switchChanged.isOn = true
                                vm.boolArr[indexPath.row] = true
                                cell.timeBtn.setTitle(vm.getTimeForSpecificDay(seconds: vm.selectedApps[0].wednesday ?? 0), for: .normal)
                                cell.timeBtn.tintColor = UIColor.init(hexString: "#156CF7")
                            }else {
                                cell.switchChanged.isOn = false
                                cell.timeBtn.setTitle("0h 0min", for: .normal)
                                cell.timeBtn.tintColor = UIColor.lightGray
                            }
                        case 4:
                            if vm.selectedApps[0].thursday != nil && vm.selectedApps[0].appLimit == "1" && vm.selectedApps[0].thursday != 0{
                                cell.switchChanged.isOn = true
                                vm.boolArr[indexPath.row] = true
                                cell.timeBtn.setTitle(vm.getTimeForSpecificDay(seconds: vm.selectedApps[0].thursday ?? 0), for: .normal)
                                cell.timeBtn.tintColor = UIColor.init(hexString: "#156CF7")
                            }else {
                                cell.switchChanged.isOn = false
                                cell.timeBtn.setTitle("0h 0min", for: .normal)
                                cell.timeBtn.tintColor = UIColor.lightGray
                            }
                        case 5:
                            if vm.selectedApps[0].friday != nil && vm.selectedApps[0].appLimit == "1" && vm.selectedApps[0].friday != 0{
                                cell.switchChanged.isOn = true
                                vm.boolArr[indexPath.row] = true
                                cell.timeBtn.setTitle(vm.getTimeForSpecificDay(seconds: vm.selectedApps[0].friday ?? 0), for: .normal)
                                cell.timeBtn.tintColor = UIColor.init(hexString: "#156CF7")
                            }else {
                                cell.switchChanged.isOn = false
                                cell.timeBtn.setTitle("0h 0min", for: .normal)
                                cell.timeBtn.tintColor = UIColor.lightGray
                            }
                        case 6:
                            if vm.selectedApps[0].saturday != nil && vm.selectedApps[0].appLimit == "1" && vm.selectedApps[0].saturday != 0{
                                cell.switchChanged.isOn = true
                                vm.boolArr[indexPath.row] = true
                                cell.timeBtn.setTitle(vm.getTimeForSpecificDay(seconds: vm.selectedApps[0].saturday ?? 0), for: .normal)
                                cell.timeBtn.tintColor = UIColor.init(hexString: "#156CF7")
                            }else {
                                cell.switchChanged.isOn = false
                                cell.timeBtn.setTitle("0h 0min", for: .normal)
                                cell.timeBtn.tintColor = UIColor.lightGray
                            }
                        default:
                            break
                    }
                cell.switchChanges = { [weak self] in
                    self?.vm.boolArr[indexPath.row] = cell.switchChanged.isOn
                    cell.timeBtn.tintColor = cell.switchChanged.isOn ? UIColor.init(hexString: "#156CF7") : UIColor.lightGray
                    if !cell.switchChanged.isOn {
                        self?.vm.setCustomLimit(index: indexPath.row, hour: "0", minute: "0")
                        self?.vm.isValid = cell.switchChanged.isOn
                    } else {
                        cell.timeBtn.setTitle("0h 0min", for: .normal)
                        self?.vm.isValid = cell.switchChanged.isOn
                    }
                }
                cell.callback = { [weak self] in
                    if cell.switchChanged.isOn {
                        let vc = AppLimitPickerVC(nibName: "AppLimitPickerVC", bundle: nil)
                        vc.callback = { [weak self] hour , minute in
                            self?.vm.isValid = true
                            self?.vm.setCustomLimit(index: indexPath.row, hour: hour, minute: minute)
                            cell.timeBtn.setTitle("\(hour)h \(minute)min", for: .normal)
                            cell.timeBtn.tintColor = cell.switchChanged.isOn ? UIColor.init(hexString: "#156CF7") : UIColor.lightGray
                        }
                        vc.modalPresentationStyle = .overFullScreen
                        vc.modalTransitionStyle = .crossDissolve
                        self?.present(vc, animated: true)
                    }
                }
                cell.selectionStyle = .none
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SetLimitCell") as! SetLimitCell
                cell.pickerVu.delegate = self
                cell.pickerVu.dataSource = self
                if vm.selectedApps.count == 1 {
                    if vm.selectedApps[0].appLimit == "1" {
                        let hours = vm.selectedApps[0].getHours()
                        let minutes = vm.selectedApps[0].getMinutes()
                        self.vm.selectedhours = "\(hours)"
                        self.vm.selectedMinutes = "\(minutes)"
                        cell.pickerVu.selectRow(hours, inComponent: 0, animated: false)
                        cell.pickerVu.selectRow(minutes, inComponent: 1, animated: false)
                    }
                }
                cell.selectionStyle = .none
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AppLimitTableCell") as! AppLimitTableCell
            cell.titleLbl.text = vm.selectedApps[indexPath.row].appName
            if vm.selectedApps[indexPath.row].appLimit == "1" {
                cell.selectionImg.isHidden = false
                cell.selectionImg.image = UIImage(named: "redIcon")
            } else {
                cell.selectionImg.isHidden = true
            }
            cell.selectionImg.tag = indexPath.row
            cell.selectionImg.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imgTapped(_:))))
            cell.selectionImg.isUserInteractionEnabled = true
            cell.selectionStyle = .none
            return cell
        }
    }
}
extension SetLimitVC: UIPickerViewDelegate, UIPickerViewDataSource  {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        if component == 0 {
            return vm.hourArray.count
        }else {
            return vm.minutessArray.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return vm.hourArray[row]
        } else {
            return vm.minutessArray[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        if component == 0 {
            vm.selectedhours = vm.hourArray[pickerView.selectedRow(inComponent: 0)]
            print("hours:", vm.selectedhours)
        } else if component == 1{
            vm.selectedMinutes = vm.minutessArray[pickerView.selectedRow(inComponent: 1)]
            print("minutes:", vm.selectedMinutes)
        }
    }
}
