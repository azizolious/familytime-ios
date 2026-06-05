//
//  AppLimitPickerVC.swift
//  FamilyTime
//
//  Created by Sufyan on 17/10/2023.
//  Copyright © 2023 YumyApps. All rights reserved.
//

import UIKit

class AppLimitPickerVC: UIViewController {

    @IBOutlet weak var bottomConstant: NSLayoutConstraint!
    @IBOutlet weak var picker: UIPickerView!
    let minutessArray = (0...60).map { String(format: "%02d", $0) }
    let hourArray = (0...23).map { String(format: "%02d", $0) }
    var selectedHour = ""
    var selectedMinute = ""
    var callback: ((String, String)->())?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        picker.dataSource = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.bottomConstant.constant = 16
            self.view.layoutIfNeeded()
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.bottomConstant.constant = -500
            self.view.layoutIfNeeded()
        }
    }

    @IBAction func cancelPress(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func donePress(_ sender: Any) {
        if !selectedHour.isEmpty || !selectedMinute.isEmpty {
            callback?(selectedHour, selectedMinute)
            self.dismiss(animated: true)
        }
    }
    
}
extension AppLimitPickerVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        if component == 0 {
            return hourArray.count
        }else {
            return minutessArray.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return hourArray[row]
        } else {
            return minutessArray[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        if component == 0 {
            self.selectedHour = hourArray[row]
        } else {
            self.selectedMinute = minutessArray[row]
        }
    }
}
