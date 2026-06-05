//
//  RemoveURLVC.swift
//  FamilyTime
//
//  Created by Sufyan on 17/01/2024.
//  Copyright © 2024 YumyApps. All rights reserved.
//

import UIKit

class RemoveURLVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var searchView: UIView!
    
    var vm = RemoveURLVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
        searchTF.delegate = self
        searchTF.placeholder = "search_site".localized
        title = "web_blocker".localized
        // Do any additional setup after loading the view.
    }

    @IBAction func saveTapped(_ sender: Any) {
        let check = vm.isSearching ? vm.searchArr.contains(where: {$0.isSelectd == true}) : vm.webBlockerArr.contains(where: {$0.isSelectd == true})
        if check {
            let vc = WebBlockerPopUp()
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            vc.responseBack = { [weak self] in
                SwiftFTUtils.showHUDAdded(to: self?.view, withText: "", animated: true)
                self?.vm.deleteData { [weak self] in
                    SwiftFTUtils.hideHUDAdded(to: self?.view, animated: true)
                    self?.navigationController?.popViewController(animated: true)
                }
            }
            self.navigationController?.present(vc, animated: true)
        }
    }
    
    private func initTableView() {
        tblView.delegate = self
        tblView.dataSource = self
        tblView.register(UINib(nibName: "WebBlockerCell", bundle: nil), forCellReuseIdentifier: "WebBlockerCell")
        tblView.register(UINib(nibName: "AppLimitTableCell", bundle: nil), forCellReuseIdentifier: "AppLimitTableCell")

    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text else {
            return true
        }
        vm.isSearching = true
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        vm.searchArr = vm.webBlockerArr.filter{$0.url?.range(of: updatedText, options: .caseInsensitive) != nil}
        if updatedText == "" {
            vm.searchArr = vm.webBlockerArr
        }
        tblView.reloadData()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        vm.isSearching = false
        tblView.reloadData()
    }

}
extension RemoveURLVC:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = vm.isSearching ? vm.searchArr.count : vm.webBlockerArr.count + 1
        return count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if vm.isSearching {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WebBlockerCell", for: indexPath) as! WebBlockerCell
            cell.deleteBtn.isHidden = true
            cell.swicth.isHidden = true
            cell.title.text = vm.searchArr[indexPath.row].url ?? ""
            cell.desc.text = vm.searchArr[indexPath.row].type ?? ""
            cell.checkImg.image = UIImage(named: vm.searchArr[indexPath.row].isSelectd ?? false ? "checkBox" : "uncheck" )
            return cell
        } else {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AppLimitTableCell") as! AppLimitTableCell
                cell.iconImg.isHidden = true
                cell.titleLbl.text = "select_all".localized
                cell.selectionImg.image = UIImage(named: vm.selectAll ? "checkBox" : "uncheck")
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "WebBlockerCell", for: indexPath) as! WebBlockerCell
                cell.deleteBtn.isHidden = true
                cell.swicth.isHidden = true
                cell.title.text = vm.webBlockerArr[indexPath.row - 1].url ?? ""
                cell.desc.text = vm.webBlockerArr[indexPath.row - 1].type ?? ""
                cell.checkImg.image = UIImage(named: vm.webBlockerArr[indexPath.row - 1].isSelectd ?? false ? "checkBox" : "uncheck" )
                return cell
            }
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if vm.isSearching {
           vm.searchArr[indexPath.row].isSelectd?.toggle()
            let index = IndexPath(row: indexPath.row, section: 0)
                tblView.reloadRows(at: [index], with: .automatic)
        } else {
            if indexPath.row == 0 {
                vm.selectAll.toggle()
                vm.selection()
                tblView.reloadSections(IndexSet(integer: 0), with: .automatic)
            } else {
                vm.webBlockerArr[indexPath.row - 1].isSelectd?.toggle()
                let index = IndexPath(row: indexPath.row, section: 0)
                if vm.webBlockerArr.allSatisfy({$0.isSelectd == true}) {
                    vm.selectAll = true
                    tblView.reloadSections(IndexSet(integer: 0), with: .automatic)
                } else if vm.webBlockerArr.contains(where: {$0.isSelectd == false}) {
                    vm.selectAll = false
                    tblView.reloadSections(IndexSet(integer: 0), with: .automatic)
                } else {
                    tblView.reloadRows(at: [index], with: .automatic)
                }
            }
        }
    }
}
