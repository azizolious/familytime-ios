//
//  SearchTableHandler.swift
//  FamilyTime
//
//  Created by Sufyan on 17/10/2023.
//  Copyright © 2023 YumyApps. All rights reserved.
//

import Foundation
import IQKeyboardManager
class SearchTableHandler: NSObject, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var searchTbl: UITableView!
    var searchBar: UITextField!
    var array: [InstalledApp]!
    var searchArray = [InstalledApp]()
    var text = ""
    var controller: UIViewController!
    
    init(searchBar: UITextField,array: [InstalledApp], tbl: UITableView, searchText:String, controller: UIViewController) {
        self.searchBar = searchBar
        self.searchTbl = tbl
        self.array = array
        self.searchArray = array
        self.text = searchText
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "AppLimitTableCell") as! AppLimitTableCell
        cell.titleLbl.text = searchArray[indexPath.row].appName
        cell.selectionImg.isHidden = true
        cell.iconImg.isHidden = false
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = SetLimitVC(nibName: "SetLimitVC", bundle: nil)
        vc.vm.selectedApps = [searchArray[indexPath.row]]
        controller.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        controller.navigationController?.pushViewController(vc, animated: true)
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
        searchArray = array.filter{$0.appName?.range(of: updatedText, options: .caseInsensitive) != nil}
        if updatedText == "" {
            searchArray = array
        }
        searchTbl.reloadData()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        let con = controller as! IndividualAppLimit
        con.searchView.isHidden = true
        con.applyBtn.isHidden = false
    }
}
