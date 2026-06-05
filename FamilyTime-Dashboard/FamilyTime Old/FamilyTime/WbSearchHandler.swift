//
//  WbSearchHandler.swift
//  FamilyTime
//
//  Created by Sufyan on 17/01/2024.
//  Copyright © 2024 YumyApps. All rights reserved.
//

import Foundation
import IQKeyboardManager

protocol WebSearchHandlerProtocol:NSObject {
    func endEditing()
    func changeToggle(obj: WebBlockerObj, state: Bool)
}

class WebSearchHandler: NSObject, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var searchTbl: UITableView!
    var searchBar: UITextField!
    var array: [WebBlockerObj]!
    var searchArray = [WebBlockerObj]()
    var text = ""
    weak var delegate: WebSearchHandlerProtocol?
    
    init(searchBar: UITextField,array: [WebBlockerObj], tbl: UITableView, searchText:String) {
        self.searchBar = searchBar
        self.searchTbl = tbl
        self.array = array
        self.text = searchText
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
    @objc func webToggle(_ sender: UISwitch) {
        let index = sender.tag
        delegate?.changeToggle(obj: searchArray[index], state: sender.isOn)
        if let index = array.firstIndex(where: {$0.id == searchArray[index].id}) {
          array[index].isBlocked = sender.isOn.boolToInt()
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WebBlockerCell", for: indexPath) as! WebBlockerCell
        cell.deleteBtn.isHidden = true
        cell.checkImg.isHidden = true
        cell.swicth.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        cell.swicth.isOn = searchArray[indexPath.row].isBlocked?.boolValue ?? false
        cell.title.text = searchArray[indexPath.row].url
        cell.swicth.tag = indexPath.row
        cell.swicth.addTarget(self, action: #selector(webToggle(_:)), for: .valueChanged)
        cell.selectionStyle = .none
        return cell
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
        searchArray = array.filter{$0.url?.range(of: updatedText, options: .caseInsensitive) != nil}
        if updatedText == "" {
            searchArray = array
        }
        searchTbl.reloadData()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.endEditing()
    }
}
