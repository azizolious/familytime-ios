//
//  WebBlockerVC.swift
//  FamilyTime
//
//  Created by Sufyan on 12/01/2024.
//  Copyright © 2024 YumyApps. All rights reserved.
//

import UIKit

class WebBlockerVC: UIViewController, WebSearchHandlerProtocol {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTbl: UITableView!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var searchVu: UIView!
    private lazy var emptyStateView: EmptyVu = {
            let view = Bundle.main.loadNibNamed("EmptyVu", owner: self, options: nil)?.first as! EmptyVu
            return view
        }()

    var vm = WebBlockerViewModel()
    var searchHandler: WebSearchHandler!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LiveVisitorManager.shared.updateScreen(
            "Web Blocker"
        )
        
        tableView.dataSource = self
        tableView.delegate = self
        searchVu.isHidden = true
        title = "web_blocker".localized
        searchTF.placeholder = "search_site".localized
        tableInitializer()
        searchHandler = WebSearchHandler(searchBar: searchTF, array: vm.webBlockerArr, tbl: searchTbl, searchText: "")
        searchHandler.initMethod()
        searchHandler.delegate = self
        vm.reload = {[weak self] in
            self?.tableView.reloadData()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        vm.initMethod()
    }
    func tableInitializer() {
        tableView.register(UINib(nibName: "ToggleWebBlockerCell", bundle: nil), forCellReuseIdentifier: "ToggleWebBlockerCell")
        tableView.register(UINib(nibName: "AddSiteCell", bundle: nil), forCellReuseIdentifier: "AddSiteCell")
        tableView.register(UINib(nibName: "WebBlockerCell", bundle: nil), forCellReuseIdentifier: "WebBlockerCell")
        searchTbl.register(UINib(nibName: "WebBlockerCell", bundle: nil), forCellReuseIdentifier: "WebBlockerCell")
        tableView.register(UINib(nibName: "AddOrRemoveUrlCell", bundle: nil), forCellReuseIdentifier: "AddOrRemoveUrlCell")
        tableView.register(UINib(nibName: "SearchBarCell", bundle: nil), forCellReuseIdentifier: "SearchBarCell")
        tableView.register(UINib(nibName: "SocialMediaCell", bundle: nil), forCellReuseIdentifier: "SocialMediaCell")
    }
    @IBAction func saveBtnTapped(_ sender: UIButton) {
        if vm.control.identifier == nil || vm.control.identifier == "" {return}
        let controlDb = DBManager.shared.fetchAppBlockControl(identifier: "web_blocker")
        if controlDb.state == vm.control.state {
            if self.vm.webBlockerArr.count == 0 {
                SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
                self.searchVu.isHidden = true
                return
            }
            SwiftFTUtils.showHUDAdded(to: self.view, withText: "", animated: true)
            self.vm.patchData { [weak self] in
                SwiftFTUtils.hideHUDAdded(to: self?.view, animated: true)
                self?.searchVu.isHidden = true
            }
        } else {
            SwiftFTUtils.showHUDAdded(to: self.view, withText: "", animated: true)
            vm.changeControl(state: vm.control.state ?? 0) { [weak self] in
                if self?.vm.webBlockerArr.count == 0 {
                    SwiftFTUtils.hideHUDAdded(to: self?.view, animated: true)
                    self?.searchVu.isHidden = true
                    return
                }
                self?.vm.patchData { [weak self] in
                    SwiftFTUtils.hideHUDAdded(to: self?.view, animated: true)
                    self?.searchVu.isHidden = true
                }
            }
        }
    }
    @objc func addUrlTapped(_ sender: UIButton) {
        let vc = AddURLVC()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc func removeUrlTapped(_ sender: UIButton) {
        let vc = RemoveURLVC()
        vc.vm.webBlockerArr = vm.webBlockerArr
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc func mainToggle(_ sender: UISwitch) {
        vm.control.state = sender.isOn.boolToInt()
        tableView.reloadData()
    }
    @objc func selectAllToggle(_ sender: UISwitch) {
        vm.selectedAll = sender.isOn
        vm.selection()
        tableView.reloadSections(IndexSet(integer: 2), with: .automatic)
    }
    @objc func webToggle(_ sender: UISwitch) {
        let index = sender.tag
        vm.webBlockerArr[index].isBlocked = sender.isOn.boolToInt()
        vm.selectAllTogle()
        tableView.reloadSections(IndexSet(integer: 2), with: .automatic)
    }
    func endEditing() {
        searchVu.isHidden = true
    }
    
    func changeToggle(obj: WebBlockerObj, state: Bool) {
        if let index = vm.webBlockerArr.firstIndex(where: {$0.id == obj.id}) {
            vm.webBlockerArr[index].isBlocked = state.boolToInt()
            tableView.reloadData()
        }
    }
}
extension WebBlockerVC: UITableViewDataSource,UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        if vm.webBlockerArr.count == 0 {
            emptyStateView.frame = tableView.bounds
            emptyStateView.imgVu.image = UIImage(named: "noSite")
            emptyStateView.titleLbl.text = "no_Websites_to_show".localized
            emptyStateView.descLbl.text = "empty_web_msg".localized
            emptyStateView.centerContraints.constant = 40
            self.tableView.backgroundView = emptyStateView
            return 2
        }else {
            self.tableView.backgroundView = nil
            return 3
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return vm.webBlockerArr.count + 2
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let isOn = vm.control.state?.boolValue ?? false
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ToggleWebBlockerCell", for: indexPath) as! ToggleWebBlockerCell
            cell.mainSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
            cell.mainSwitch.isOn = isOn
            cell.mainSwitch.addTarget(self, action: #selector(mainToggle(_:)), for: .valueChanged)
            cell.selectionStyle = .none
            return cell
        case 1:
            if vm.webBlockerArr.count == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddSiteCell", for: indexPath) as! AddSiteCell
                cell.selectionStyle = .none
                cell.addUrlBtn.addTarget(self, action: #selector(addUrlTapped(_:)), for: .touchUpInside)
                cell.addUrlBtn.isEnabled = isOn
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddOrRemoveUrlCell", for: indexPath) as! AddOrRemoveUrlCell
                cell.addUrlBtn.addTarget(self, action: #selector(addUrlTapped(_:)), for: .touchUpInside)
                cell.removeBtn.addTarget(self, action: #selector(removeUrlTapped(_:)), for: .touchUpInside)
                cell.removeBtn.isEnabled = isOn
                cell.addUrlBtn.isEnabled = isOn
                cell.selectionStyle = .none
                return cell
            }
        case 2:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SearchBarCell", for: indexPath) as! SearchBarCell
                cell.searchBar.delegate = self
                cell.searchBar.placeholder = "search_site".localized
                cell.selectionStyle = .none
                return cell
            } else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SocialMediaCell") as! SocialMediaCell
                cell.socialSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
                cell.selectionStyle = .none
                cell.socialImg.isHidden = true
                cell.socialTitle.text = "select_all".localized
                cell.uninstalledView.isHidden = true
                cell.socialSwitch.isOn = vm.selectedAll
                cell.socialSwitch.addTarget(self, action: #selector(selectAllToggle(_:)), for: .valueChanged)
                cell.socialSwitch.isEnabled = isOn
                return cell
            } else {
                let ind = indexPath.row - 2
                let cell = tableView.dequeueReusableCell(withIdentifier: "WebBlockerCell", for: indexPath) as! WebBlockerCell
                cell.deleteBtn.isHidden = true
                cell.checkImg.isHidden = true
                cell.swicth.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
                cell.swicth.isOn = vm.webBlockerArr[ind].isBlocked?.boolValue ?? false
                cell.title.text = vm.webBlockerArr[ind].url
                cell.desc.text = vm.webBlockerArr[ind].type
                cell.swicth.tag = ind
                cell.swicth.addTarget(self, action: #selector(webToggle(_:)), for: .valueChanged)
                cell.swicth.isEnabled = isOn
                cell.selectionStyle = .none
                return cell
            }
        default:
            return UITableViewCell()
        }
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        2
    }
}
extension WebBlockerVC: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchVu.isHidden = false
        searchBar.endEditing(true)
        searchBar.resignFirstResponder()
        searchHandler.array = vm.webBlockerArr
        searchHandler.tblReloader()
    }
}
