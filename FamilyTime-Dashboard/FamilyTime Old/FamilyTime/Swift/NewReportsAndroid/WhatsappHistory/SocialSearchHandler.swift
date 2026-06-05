//
//  SocialSearchHandler.swift
//  FamilyTime
//
//  Created by Sufyan on 22/12/2023.
//  Copyright © 2023 YumyApps. All rights reserved.
//

import Foundation
import IQKeyboardManager
class SocialSearchHandler: NSObject, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var searchTbl: UITableView!
    var searchBar: UITextField!
    var array: [String]!
    var searchArray = [String]()
    var arrStr = [String]()
    var text = ""
    var controller: UIViewController!
    var dataToShow : [String: [SocialApp]]!
    
    init(searchBar: UITextField,array: [String], tbl: UITableView, searchText:String, controller: UIViewController, data: [String: [SocialApp]]) {
        self.searchBar = searchBar
        self.searchTbl = tbl
        self.array = array
        self.arrStr = array
        self.text = searchText
        self.dataToShow = data
        self.controller = controller
    }
    func initMethod() {
        self.searchTbl.delegate = self
        self.searchTbl.dataSource = self
        self.searchBar.delegate = self
        self.searchTbl.reloadData()
    }
    func tblReloader () {
        self.searchArray = array
        self.searchTbl.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InboxCell") as! InboxCell
        let key = searchArray[indexPath.row]
        let obj = dataToShow[key]
        cell.nameLbl.text = key
        cell.msgLbl.text = obj?.last?.body ?? ""
        let shortTimeString = convertToShortTimeString(obj?.first?.date ?? "2023-12-05 12:28:15", dateFormat: "yyyy-MM-dd HH:mm:ss", timeFormat: "h:mm a")
        cell.timeLbl.text = shortTimeString
        let filteredObj = obj?.filter({$0.isRead == 0})
        if filteredObj?.count == 0 {
            cell.countLbl.isHidden = true
        } else {
            cell.countLbl.isHidden = false
            cell.countLbl.text = "\(filteredObj?.count ?? 0)"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let con = controller as! WhatsappHistoryVC
        con.searchView.isHidden = true
        let obj = searchArray[indexPath.row]
        let check = con.vm.isFrom != .bwhatsapp || con.vm.isFrom != .whatsapp
        let objToSend = check ? con.vm.getSocialAppMegs(name: obj) : dataToShow[obj]
        let vc = MessagesDetailVC()
        vc.modalPresentationStyle = .fullScreen
        vc.titleStr = obj
        vc.apps = objToSend ?? []
        vc.relaod = { 
            DispatchQueue.main.async {
                if !check {
                    con.vm.initMethod()
                } else {
                    con.vm.relaoding = true
                    con.vm.callMethodsBySegments()
                }
            }
        }
        con.present(vc, animated: true)
       
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true

    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text else {
            return true
        }
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        searchArray = array.filter{$0.range(of: updatedText, options: .caseInsensitive) != nil}
        if updatedText == "" {
            searchArray = array
        }
        searchTbl.reloadData()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        let con = controller as! WhatsappHistoryVC
        con.searchView.isHidden = true
    }
    func convertToShortTimeString(_ dateString: String, dateFormat: String, timeFormat: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        
        if let date = dateFormatter.date(from: dateString) {
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = timeFormat
            let shortTimeString = timeFormatter.string(from: date)
            return shortTimeString
        } else {
            print("Invalid date format or string.")
            return nil
        }
    }
}
