//
//  IndividualAppLimit.swift
//  FamilyTime
//
//  Created by Sufyan on 17/10/2023.
//  Copyright © 2023 YumyApps. All rights reserved.
//

import UIKit

class IndividualAppLimit: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var segmentControl: OYSegmentControl!
    @IBOutlet weak var applyBtn: UIButton!
    @IBOutlet weak var searchTbl: UITableView!
    @IBOutlet weak var tblVu: UITableView!
    @IBOutlet weak var searchTf: UITextField!
    @IBOutlet weak var searchView: UIView!
    
    var noContentImageView: UIImageView?
    var noContentLabel: UILabel?
    //MARK: Search Handler
    var searchHandler: SearchTableHandler!
    
    //MARK: ViewModel
    var vm = IndividualLimitVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LiveVisitorManager.shared.updateScreen(
            "App Limits"
        )
        
        initUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let reload = UserDefaults.standard.bool(forKey: "reloadDB")
        if reload {
            vm.getApps()
        }
    }
    
    func registerCells() {
        tblVu.register(UINib(nibName: "AppLimitTableCell", bundle: nil), forCellReuseIdentifier: "AppLimitTableCell")
        tblVu.register(UINib(nibName: "SearchBarCell", bundle: nil), forCellReuseIdentifier: "SearchBarCell")
        tblVu.register(UINib(nibName: "LimitedAppsCell", bundle: nil), forCellReuseIdentifier: "LimitedAppsCell")
        searchTbl.register(UINib(nibName: "AppLimitTableCell", bundle: nil), forCellReuseIdentifier: "AppLimitTableCell")
        searchTbl.register(UINib(nibName: "SearchBarCell", bundle: nil), forCellReuseIdentifier: "SearchBarCell")
    }
    
    func initUI() {
        searchTf.placeholder = "search_app".localized
        searchHandler = SearchTableHandler(searchBar: self.searchTf, array: vm.unlimitApp, tbl: searchTbl, searchText: "", controller: self)
        searchHandler.initMethod()
        applyBtn.setTitle("apply".localized, for: .normal)
        tblVu.delegate = self
        tblVu.dataSource = self
        registerCells()
        self.title = "individual_app_limit".localized
        segmentControl.setTitle("all_apps".localized, forSegmentAt: 0)
        segmentControl.setTitle("limited_apps".localized, forSegmentAt: 1)
        DispatchQueue.main.async {
            self.vm.getApps()
        }
        vm.tblReloader = {
            
            if self.vm.unlimitApp.count == 0 {
                self.updateUIForElseCase()
                self.addLableAndImage()
                self.addContentLabelAndImage()
            } else {
                if self.vm.limitedApp.count == 0 {
                    if self.vm.isLimitedSelected {
                        self.updateUIForElseCase()
                        self.addLableAndImage()
                        self.addContentLabelAndImage()
                        return
                    }
                } else {
                    if self.vm.selection == true {
                        self.vm.limitedApp.insert(InstalledApp(appName: "", isSelected: false), at: 0)
                    }
                    self.updateUIForElseCase()
                }
            }
            self.tblVu.reloadData()
        }
    }
    
    func updateUIForElseCase(){
        self.tblVu?.isHidden = false
        self.noContentImageView?.removeFromSuperview()
        self.noContentImageView = nil
        self.noContentLabel?.removeFromSuperview()
        self.noContentLabel = nil
        self.applyBtn.isHidden = false
    }
    
    func addContentLabelAndImage(){
        if SwiftFTUtils.isDeviceiPhoneFamily() {
            self.noContentImageView?.frame = CGRect(x: (self.view.bounds.width - 225.0) / 2.0, y: self.view.bounds.midY - 101.0, width: 225, height: 101)
            self.noContentImageView?.image = UIImage(named: "notask")
            self.noContentImageView?.contentMode = .scaleAspectFit
            self.noContentLabel?.frame = CGRect(x: (self.view.bounds.width - 225.0) / 2.0, y: self.noContentImageView?.frame.maxY ?? 20 + 20, width: 225, height: 150)
        } else {
            self.noContentImageView?.frame = CGRect(x: 236, y: 229, width: 296, height: 212)
            self.noContentImageView?.image = UIImage(named: "notask")
            self.noContentImageView?.contentMode = .scaleAspectFit
            self.noContentLabel?.frame = CGRect(x: 236, y: self.noContentImageView?.frame.maxY ?? 20 + 20, width: 296, height: 212)
        }
    }
    
    @IBAction func segmentTap(_ sender: UISegmentedControl) {
        self.vm.isLimitedSelected = sender.selectedSegmentIndex.boolValue
        if vm.selection {
            vm.selection = false
            if vm.limitedApp.count > 1 {
                vm.limitedApp.remove(at: 0)
            }
        }
        if vm.isLimitedSelected {
            if vm.limitedApp.count == 0 {
                updateUIForElseCase()
                self.addLableAndImage()
                self.addContentLabelAndImage()
            }else {
                updateUIForElseCase()
            }
        } else {
            if vm.unlimitApp.count == 0 {
                updateUIForElseCase()
                self.addLableAndImage()
                self.addContentLabelAndImage()
            }else {
                updateUIForElseCase()
            }
        }
        self.applyBtn.setTitle(vm.isLimitedSelected ? "remove_limit".localized : "set_App_Limit".localized, for: .normal)
        self.tblVu.reloadData()
    }
    
    @IBAction func applyBtnTap(_ sender: Any) {
        if vm.isLimitedSelected {
            if applyBtn.titleLabel?.text  == "remove_limit".localized {
                applyBtn.setTitle("delete".localized, for: .normal)
                vm.selection = true
                vm.limitedApp.insert(InstalledApp(appName: "", isSelected: false), at: 0)
                tblVu.reloadSections(IndexSet(integer: 0), with: .automatic)
            } else if applyBtn.titleLabel?.text  == "delete".localized{
                let objects = vm.limitedApp.filter({$0.isSelected ?? false && $0.appName != ""})
                if objects.count != 0 {
                    let vc = DeleteChildVC(nibName: "DeleteChildVC", bundle: nil)
                    vc.limitApps = objects
                    vc.deleteLimitCallback = { [weak self] in
                        self?.vm.getApps()
                    }
                    vc.deleteLimit = true
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .overFullScreen
                    self.navigationController?.present(vc, animated: true, completion: nil)
                    
                }
            }
        } else {
            let objects = vm.recentApp.filter({$0.isSelected ?? false && $0.appName != "recently_installed_apps".localized})
            let obje = vm.unlimitApp.filter({$0.isSelected ?? false && $0.appName != "all_apps".localized})
            if obje.count != 0 || objects.count != 0 {
                let vc = SetLimitVC(nibName: "SetLimitVC", bundle: nil)
                vc.vm.selectedApps = objects + obje
                navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    func addLableAndImage(){
        self.noContentImageView = UIImageView(frame: CGRect(x: 236, y: 229, width: 190, height: 190))
        self.noContentImageView?.image = UIImage(named: "notask")
        self.noContentImageView?.contentMode = .scaleAspectFit
        self.view.addSubview(self.noContentImageView ?? UIImageView())
        self.noContentLabel = UILabel(frame: CGRect.zero)
        self.noContentLabel?.textColor = UIColor.lightGray
        self.noContentLabel?.textAlignment = .center
        self.noContentLabel?.numberOfLines = 0
        self.noContentLabel?.font = UIFont(name: "SFProDisplay-Regular", size: 16)
        let oops = "oops_title".localized
        let sec = "empty_record".localized
        self.noContentLabel?.text = "\(oops) \n\(sec)"
        self.view.addSubview(self.noContentLabel ?? UILabel())
        self.tblVu.isHidden = true
        self.applyBtn.isHidden = true
    }
}

extension IndividualAppLimit: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if vm.isLimitedSelected {
            return 1
        } else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if vm.isLimitedSelected {
            return vm.limitedApp.count + 1
        } else {
            if section == 0 {
                return vm.recentApp.count
            } else {
                return vm.unlimitApp.count + 1
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if vm.isLimitedSelected  {
            let indecs = indexPath.row - 1
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SearchBarCell") as! SearchBarCell
                cell.searchBar.delegate = self
                return cell
            }else if vm.selection && indexPath.row == 1{
                let cell = tableView.dequeueReusableCell(withIdentifier: "AppLimitTableCell") as! AppLimitTableCell
                cell.iconImg.isHidden = true
                cell.titleLbl.text = "all_apps".localized
                cell.selectionImg.image = UIImage(named: vm.limitedApp[indexPath.row - 1].isSelected ?? false ? "checkBox" : "uncheck" )
                return cell
            }else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "LimitedAppsCell") as? LimitedAppsCell
                cell?.titleLbl.text = vm.limitedApp[indecs].appName
                cell?.limitTime.text = vm.limitedApp[indecs].getLimitedTime()
                cell?.selectionImg.image = UIImage(named: vm.limitedApp[indecs].isSelected ?? false ? "checkBox" : "uncheck" )
                cell?.selectionImg.isHidden = !vm.selection
                
                return cell ?? UITableViewCell()
            }
        } else {
            if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AppLimitTableCell") as! AppLimitTableCell
                cell.iconImg.isHidden = indexPath.row == 0 ? true : false
                print("selection:", vm.recentApp[indexPath.row].isSelected ?? false)
                cell.selectionImg.image = UIImage(named: vm.recentApp[indexPath.row].isSelected ?? false ? "checkBox" : "uncheck" )
                cell.titleLbl.text = vm.recentApp[indexPath.row].appName
                return cell
            } else {
                if indexPath.row == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "SearchBarCell") as! SearchBarCell
                    cell.searchBar.delegate = self
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "AppLimitTableCell") as! AppLimitTableCell
                    cell.iconImg.isHidden = indexPath.row == 1 ? true : false
                    cell.selectionImg.image = UIImage(named: vm.unlimitApp[indexPath.row - 1].isSelected ?? false ? "checkBox" : "uncheck" )
                    cell.titleLbl.text = vm.unlimitApp[indexPath.row - 1].appName
                    return cell
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !vm.isLimitedSelected {
            if indexPath.section == 0 {
                if indexPath.row == 0 {
                    vm.recentApp = vm.recentApp.map { apps in
                        var allApps = apps
                        allApps.isSelected?.toggle()
                        return allApps
                    }
                    self.tblVu.reloadSections(IndexSet(integer: 0), with: .automatic)
                } else {
                    vm.recentApp[indexPath.row].isSelected?.toggle()
                    self.tblVu.reloadRows(at: [indexPath], with: .automatic)
                }
            } else {
                if indexPath.row == 1 {
                    if vm.unlimitApp[0].isSelected == true {
                        vm.unlimitApp = vm.unlimitApp.map { apps in
                            var allApps = apps
                            allApps.isSelected? = false
                            return allApps
                        }
                    }else {
                        vm.unlimitApp = vm.unlimitApp.map { apps in
                            var allApps = apps
                            allApps.isSelected? = true
                            return allApps
                        }
                    }
                    self.tblVu.reloadSections(IndexSet(integer: 1), with: .automatic)
                } else {
                    vm.unlimitApp[indexPath.row - 1].isSelected?.toggle()
                    self.tblVu.reloadRows(at: [indexPath], with: .automatic)
                }
            }
        } else {
            if vm.selection {
                if indexPath.row == 1 {
                    if vm.limitedApp[0].isSelected == true {
                        vm.limitedApp = vm.limitedApp.map { apps in
                            var allApps = apps
                            allApps.isSelected? = false
                            return allApps
                        }
                    } else {
                        vm.limitedApp = vm.limitedApp.map { apps in
                            var allApps = apps
                            allApps.isSelected? = true
                            return allApps
                        }
                    }
                    self.tblVu.reloadSections(IndexSet(integer: 0), with: .automatic)
                }else {
                    vm.limitedApp[indexPath.row - 1].isSelected?.toggle()
                    self.tblVu.reloadRows(at: [indexPath], with: .automatic)
                    
                }
            } else {
                //Navigate
                let vc = SetLimitVC(nibName: "SetLimitVC", bundle: nil)
                print("index", indexPath.row)
                print("indexName", vm.limitedApp[indexPath.row - 1].appName as Any)
                vc.vm.selectedApps = [vm.limitedApp[indexPath.row - 1]]
                
                navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchView.isHidden = false
        applyBtn.isHidden = true
        var array = [InstalledApp]()
        if vm.isLimitedSelected {
            array = vm.limitedApp
            if vm.selection {
                array.removeFirst()
            }
        } else {
            array = vm.unlimitApp
            array.removeFirst()
        }
        searchBar.endEditing(true)
        searchBar.resignFirstResponder()
        searchHandler.array = array
        searchHandler.tblReloader()
    }
}

class OYSegmentControl: UISegmentedControl {
  
  override func layoutSubviews(){
    super.layoutSubviews()
    
    let segmentStringSelected: [NSAttributedString.Key : Any] = [
      NSAttributedString.Key.font : UIFont(name: "SFProDisplay-Regular", size: 14)!,
      NSAttributedString.Key.foregroundColor : UIColor.white
    ]
    
    let segmentStringHighlited: [NSAttributedString.Key : Any] = [
        NSAttributedString.Key.font : UIFont(name: "SFProDisplay-Regular", size: 14)!,
      NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.5567105412, green: 0.5807551742, blue: 0.6022000909, alpha: 1)
    ]
    
    setTitleTextAttributes(segmentStringHighlited, for: .normal)
    setTitleTextAttributes(segmentStringSelected, for: .selected)
    setTitleTextAttributes(segmentStringHighlited, for: .highlighted)
    
    layer.masksToBounds = true
    
    if #available(iOS 13.0, *) {
      selectedSegmentTintColor = #colorLiteral(red: 0.08235294118, green: 0.4235294118, blue: 0.968627451, alpha: 1)
    } else {
      tintColor = #colorLiteral(red: 0.08235294118, green: 0.4235294118, blue: 0.968627451, alpha: 1)
    }
    
    backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    
    //corner radius
    let cornerRadius = bounds.height / 2
    let maskedCorners: CACornerMask = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
    //background
    clipsToBounds = true
    layer.cornerRadius = cornerRadius
    layer.maskedCorners = maskedCorners

    let foregroundIndex = numberOfSegments
    if subviews.indices.contains(foregroundIndex),
      let foregroundImageView = subviews[foregroundIndex] as? UIImageView {
      foregroundImageView.image = UIImage()
      foregroundImageView.clipsToBounds = true
      foregroundImageView.layer.masksToBounds = true
      foregroundImageView.backgroundColor = #colorLiteral(red: 0.07872972637, green: 0.5198959708, blue: 0.9763010144, alpha: 1)
      
      foregroundImageView.layer.cornerRadius = bounds.height / 2 + 5
      foregroundImageView.layer.maskedCorners = maskedCorners
    }
  }
  
  override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    return false
  }
  
}
