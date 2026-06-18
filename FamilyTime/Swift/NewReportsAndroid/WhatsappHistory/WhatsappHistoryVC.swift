//
//  WhatsappHistoryVC.swift
//  FamilyTime
//
//  Created by Sufyan on 21/12/2023.
//  Copyright © 2023 YumyApps. All rights reserved.
//

import UIKit

class WhatsappHistoryVC: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var tblVu: UITableView!
    
    @IBOutlet weak var searchTbl: UITableView!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var searchView: UIView!
    
    private lazy var emptyStateView: EmptyVu = {
            let view = Bundle.main.loadNibNamed("EmptyVu", owner: self, options: nil)?.first as! EmptyVu
            return view
        }()
    
    var vm = SocialHistoryVM()
    var searchHandler: SocialSearchHandler!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
        vm.initMethod()
        tbleReloader()
        searchHandler = SocialSearchHandler(searchBar: self.searchTF, 
                                            array: vm.keys, tbl: searchTbl,
                                            searchText: "", controller: self,
                                            data: vm.groupe)
        searchHandler.initMethod()
        handleUI()
    }

    private func initTableView() {
        tblVu.delegate = self
        tblVu.dataSource = self
        tblVu.register(UINib(nibName: "DateSegmentTblCell", bundle: nil), 
                       forCellReuseIdentifier: "DateSegmentTblCell")
        tblVu.register(UINib(nibName: "SearchBarCell", bundle: nil), 
                       forCellReuseIdentifier: "SearchBarCell")
        tblVu.register(UINib(nibName: "InboxCell", bundle: nil), 
                       forCellReuseIdentifier: "InboxCell")
        searchTbl.register(UINib(nibName: "InboxCell", bundle: nil),
                           forCellReuseIdentifier: "InboxCell")
    }
    
    private func handleUI() {
        switch vm.isFrom {
        case .bwhatsapp:
            titleLbl.text = "Business Whatsapp"
        case .whatsapp:
            titleLbl.text = "Whatsapp"
        case .bip:
            titleLbl.text = "Bip"
        case .instagram:
            titleLbl.text = "Instagram"
        case .imo:
            titleLbl.text = "Imo"
        case .signal:
            titleLbl.text = "Signal"
        case .twitch:
            titleLbl.text = "Twitch"
        case .tiktok:
            titleLbl.text = "Tiktok Messenger History"
        }
    }
    
    private func tbleReloader() {
        vm.tbleReloader = { [weak self] in
            self?.tblVu.reloadData()
        }
    }
    
    @IBAction func reloadBtn(_ sender: Any) {
        SwiftFTUtils.showHUDAdded(to: self.view, withText: "", animated: true)
        vm.callApiToReloadHistory { [weak self] in
            DispatchQueue.main.async {
                SwiftFTUtils.hideHUDAdded(to: self?.view, animated: true)
            }
        }
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @objc func nextBtnSelected() {
        vm.buttonSelected = 1
        vm.currentIndex += 1
        vm.callMethodsBySegments()
    }
    
    //MARK: - Handle Segments change
    @objc func segmentChanged(_ sender: UISegmentedControl) {
        let selectedIndex = sender.selectedSegmentIndex
        vm.currentDate = Date()
        vm.buttonSelected = 0
        vm.currentIndex = 0
        switch selectedIndex {
        case 0:
            vm.selectedSgment = .day
        case 1:
            vm.selectedSgment = .week
        case 2:
            vm.selectedSgment = .month
        default:
            vm.selectedSgment = .day
        }
        vm.callMethodsBySegments()
    }
    @objc func previosBtnSelected() {
        vm.buttonSelected = -1
        vm.currentIndex -= 1
        vm.callMethodsBySegments()
    }
}

extension WhatsappHistoryVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        switch vm.isFrom {
        case .bwhatsapp, .whatsapp:
            if vm.keys.count == 0{
                emptyStateView.frame = tableView.bounds
                tblVu.backgroundView = emptyStateView
                return 0
            } else {
                tblVu.backgroundView = nil
                return 1
            }
        case .bip, .imo, .instagram, .signal, .twitch, .tiktok:
            if vm.keys.count == 0{
                emptyStateView.frame = tableView.bounds
                tblVu.backgroundView = emptyStateView
                return 1
            } else {
                tblVu.backgroundView = nil
                return 2
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if vm.isFrom == .bwhatsapp || vm.isFrom == .whatsapp {
            return vm.keys.count + 1
        }else {
            if section == 0 {
                return 1
            } else {
                return vm.keys.count + 1
            }
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if vm.isFrom == .whatsapp || vm.isFrom == .bwhatsapp {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SearchBarCell") as! SearchBarCell
                cell.selectionStyle = .none
                cell.searchBar.placeholder = "Search Messsage"
                cell.searchBar.delegate = self
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "InboxCell") as! InboxCell
                let key = vm.keys[indexPath.row - 1]
                let obj = vm.groupe[key]
                cell.nameLbl.text = key
                cell.msgLbl.text = obj?.last?.body ?? ""
                let shortTimeString = vm.convertToShortTimeString(obj?.first?.date ?? "2023-12-05 12:28:15", dateFormat: "yyyy-MM-dd HH:mm:ss", timeFormat: "h:mm a")
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
        } else{
            switch indexPath.section {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "DateSegmentTblCell") as! DateSegmentTblCell
                switch vm.selectedSgment {
                case .day:
                    cell.segmentControl.selectedSegmentIndex = 0
                case .week:
                    cell.segmentControl.selectedSegmentIndex = 1
                case .month:
                    cell.segmentControl.selectedSegmentIndex = 2
                }
                cell.dateLbl.text = vm.lblDate
                cell.rightDateBtn.addTarget(self, action: #selector(nextBtnSelected), for: .touchUpInside)
                cell.leftBtn.addTarget(self, action: #selector(previosBtnSelected), for: .touchUpInside)
                cell.segmentControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
                cell.rightDateBtn.isEnabled = vm.currentIndex == 0 ? false : true
                cell.selectionStyle = .none
                return cell
            case 1:
                if indexPath.row == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "SearchBarCell") as! SearchBarCell
                    cell.searchBar.delegate = self
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "InboxCell") as! InboxCell
                    let key = vm.keys[indexPath.row - 1]
                    let obj = vm.groupe[key]
                    cell.nameLbl.text = key
                    cell.msgLbl.text = obj?.last?.body ?? ""
                    let shortTimeString = vm.convertToShortTimeString(obj?.first?.date ?? "2023-12-05 12:28:15",
                                                                      dateFormat: "yyyy-MM-dd HH:mm:ss",
                                                                      timeFormat: "h:mm a")
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
            default:
                break
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if vm.isFrom == .whatsapp || vm.isFrom == .bwhatsapp {
            return 2
        } else {
            return 10
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch vm.isFrom {
        case .bwhatsapp, .whatsapp:
            if indexPath.row != 0 {
                let obj = vm.keys[indexPath.row - 1]
                let objToSend = vm.groupe[obj]
                let vc = MessagesDetailVC()
                vc.modalPresentationStyle = .fullScreen
                vc.titleStr = obj
                vc.apps = objToSend ?? []
                vc.relaod = { [weak self] in
                    DispatchQueue.main.async {
                        self?.vm.initMethod()
                    }
                }
                self.present(vc, animated: true)
            }
        case .bip, .imo, .instagram, .signal, .twitch, .tiktok:
            if indexPath.section == 1 {
            let obj = vm.keys[indexPath.row - 1]
            let objToSend = vm.getSocialAppMegs(name: obj)
            let vc = MessagesDetailVC()
            vc.modalPresentationStyle = .fullScreen
            vc.titleStr = obj
            vc.apps = objToSend
            vc.relaod = { [weak self] in
                DispatchQueue.main.async {
                    self?.vm.relaoding = true
                    self?.vm.callMethodsBySegments()
                }
            }
            self.present(vc, animated: true)
        }
            break
        }
    }
}
extension WhatsappHistoryVC {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchView.isHidden = false
        searchBar.endEditing(true)
        searchBar.resignFirstResponder()
        searchHandler.array = vm.keys
        searchHandler.dataToShow = vm.groupe
        searchHandler.tblReloader()
    }
}
