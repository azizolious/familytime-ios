//
//  SwiftParentsViewControllerAllViewController.swift
//  FamilyTime
//
//  Created by YumyApps on 14/10/2021.
//  Copyright © 2021 YumyApps. All rights reserved.
//

import UIKit
import MBProgressHUD
import Alamofire

class SwiftParentsAllViewController: BaseViewController, UIAlertViewDelegate, UIActionSheetDelegate, UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate {
    
    let delegate = UIApplication.shared.delegate as? AppDelegate
    var refreshControl: UIRefreshControl?
    var canRefresh = true
    var checkpermissionInviteParent: Int = -1
    var IndexOfDate: Int = -1
    var imgView = UIImageView()
    var contentLbl = UILabel()
    var expandedCells: [IndexPath: Bool] = [:]
    
    var rowDic: [AnyHashable] = []
    var Array: [[String: Any]] = []
    var Array1: [[AnyHashable: Any]] = []
    var rowArr = [AnyHashable]()
    var arrOfBasicInfoImages = [AnyHashable]()
    var arrOfBasicInfoData = [AnyHashable]()
    
    var topView = UIView()
    var lblTotalMinutes = UILabel()
    var view1 = UIView()
    var view2 = UIView()
    
    @IBOutlet weak var noParentsImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshTableView()
        tableView.isHidden = true
        self.checkpermissionInviteParent = 0
        
        topView.layer.borderColor = UIColor.lightGray.cgColor
        topView.layer.borderWidth = 1.0
        
        lblTotalMinutes.adjustsFontSizeToFitWidth = true
        
        self.IndexOfDate = 0
        
        self.title = "parent_title".localized
        
        if UI_USER_INTERFACE_IDIOM() == .pad {
            imgView = UIImageView(frame: CGRect(x: 236, y: 229, width: 296, height: 212))
            imgView.contentMode = .scaleAspectFill
            imgView.image = UIImage(named: "ipad_empty")
            imgView.isHidden = true
            view.addSubview(imgView)
            view.bringSubviewToFront(imgView)
            
            contentLbl = UILabel(frame: CGRect(x: 203, y: 489, width: 362, height: 45))
            contentLbl.textColor = UIColor.lightGray
            contentLbl.text = "It seems like there is no record to\n display.".localized
            contentLbl.font = UIFont.systemFont(ofSize: 16)
            contentLbl.lineBreakMode = .byWordWrapping
            contentLbl.numberOfLines = 2
            contentLbl.textAlignment = .center
            contentLbl.isHidden = true
            view.addSubview(contentLbl)
            view.bringSubviewToFront(contentLbl)
            
        } else if UIDevice.current.userInterfaceIdiom == .phone {
            
            imgView = UIImageView(frame: CGRect(x: 115, y: 152, width: 145, height: 104))
            imgView.contentMode = .scaleAspectFill
            imgView.image = UIImage(named: "ic_empty")
            imgView.isHidden = true
            view.addSubview(imgView)
            view.bringSubviewToFront(imgView)
            contentLbl = UILabel(frame: CGRect(x: 30, y: 279, width: 315, height: 41))
            contentLbl.textColor = UIColor.lightGray
            contentLbl.text = "It seems like there is no record to\n display.".myModification()
            contentLbl.font = UIFont.systemFont(ofSize: 17)
            contentLbl.lineBreakMode = .byWordWrapping
            contentLbl.numberOfLines = 2
            contentLbl.textAlignment = .center
            contentLbl.isHidden = true
            view.addSubview(contentLbl)
            view.bringSubviewToFront(contentLbl)
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        LiveVisitorManager.shared.updateScreen(
            "Co-Parent"
        )
        ZendeskChatManager.trackEvent("Parents Screen")
        arrOfBasicInfoImages = [AnyHashable]()
        arrOfBasicInfoData = [AnyHashable]()
        arrOfBasicInfoImages.append("p_name")
        arrOfBasicInfoImages.append("p_email")
        arrOfBasicInfoImages.append("p_phone")
        arrOfBasicInfoImages.append("p_relation")
        viewParentdata()
       
    }
    
    func refreshTableView() {
        refreshControl = UIRefreshControl()
        tableView.addSubview(refreshControl!)
        refreshControl?.addTarget(self, action: #selector(viewParentdata), for: .valueChanged)
    }
    @objc func viewParentdata() {
        SwiftFTUtils.showHUDAdded(to: view, withText: "Loading...", animated: true)
        
            if let coParents = DBManager.shared.fetchCoParents() {
                DispatchQueue.main.async {
                    self.rowDic.removeAll()
                    self.Array.removeAll()
                    self.Array1.removeAll()
                    
                    self.Array.append(contentsOf: coParents)
                    
                    self.tableView.isHidden = false
                    self.refreshControl?.endRefreshing()
                    self.canRefresh = true
                    self.checkCoparent()
                    if coParents.isEmpty == true {
                        self.tableView.isHidden = true
                        self.noParentsImageView.isHidden = false
                        } else {
                            self.tableView.isHidden = false
                            self.noParentsImageView.isHidden = true
                        }
                    self.tableView.reloadData()
                    SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
                }
            } else {
                DispatchQueue.main.async {
                    SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
                    CommonModel.showAlert("Error!", msg: "Failed to fetch CoParents data.")
                }
            }
        
    }

//    @objc func viewParentdata() {
//        SwiftFTUtils.showHUDAdded(to: view, withText: "loading...".myModification(), animated: true)
//        let url = HLConstants.BASE_URL_CORE_2 + "co-parents"
//        let token = UserDefaults.standard.value(forKey: kHeaderToken) as? String ?? ""
//        let tokenWithBear = "Bearer \(token)"
//        var lang = UserDefaults.standard.string(forKey: "userlanguage") ?? NSLocale.current.languageCode ?? "en"
//
//        let headers = getHeader()
//
//        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
//            DispatchQueue.main.async {
//                SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
//
//                switch response.result {
//                case .success(let json):
//                    switch response.response?.statusCode {
//                    case 200, 201, 202, 204, 206:
//                        if let jsonResponse = json as? [String: Any], let coparents = jsonResponse["data"] as? [[String: Any]] {
//                            self.rowDic.removeAll()
//                            self.Array.removeAll()
//                            self.Array1.removeAll()
//
//                            for item in coparents {
//                                //                                if let active = item["active"] as? Int, active == 1 {
//                                self.Array.append(item)
//                                //                                } else {
//                                //                                    self.Array1.append(item)
//                                //                                }
//                            }
//
//                            self.tableView.isHidden = false
//                            self.refreshControl?.endRefreshing()
//                            self.canRefresh = true
//                            self.checkCoparent()
//                            self.tableView.reloadData()
//                        } else {
//                            CommonModel.showAlert("", msg: "Response")
//                        }
//                    case 404, 429, 400:
//                        if let dict = json as? [String: Any], let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String {
//                            CommonModel.showAlert("Error!", msg: message.myModification())
//                        }
//                    default:
//                        if let dict = json as? [String: Any], let message = dict[StringConstants.ResponseKeys.MESSAGE] as? String {
//                            CommonModel.showAlert("Error!", msg: message.myModification())
//                        }
//                    }
//                case .failure(let error):
//                    print(error.localizedDescription)
//                    CommonModel.showAlert("Error!", msg: kErrorGeneral.myModification())
//                }
//            }
//        }
//    }
    
    func checkCoparent() {
        self.checkpermissionInviteParent = 5
    }
    
    //MARK: - TableView Data Source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell? = nil
        
        //---DEPRICATED---MESH2---HIDE SUPER PARENT INFO---ONLY SHOW CO PARENTS---//---1/4---//
        ///*
        let dic = Array[indexPath.row]
        let simpleTableIdentifier = "ActiveParent"
        
        cell = tableView.dequeueReusableCell(withIdentifier: simpleTableIdentifier)
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: simpleTableIdentifier)
        }
        
        let LabelTitle = cell?.viewWithTag(1) as? UILabel
        let LabelSubTitle = cell?.viewWithTag(2) as? UILabel
        let LabelRelation = cell?.viewWithTag(199) as? UILabel
        let Label31 = cell?.viewWithTag(31) as? UILabel
        let Label32 = cell?.viewWithTag(32) as? UILabel
        let Label33 = cell?.viewWithTag(33) as? UILabel
        let Label34 = cell?.viewWithTag(34) as? UILabel
        
        Label31?.text = Label31?.text?.myModification()
        Label32?.text = Label32?.text?.myModification()
        Label33?.text = Label33?.text?.myModification()
        Label34?.text = Label34?.text?.myModification()
        
        let btnRemoveFromfamily = cell?.viewWithTag(5) as? UIButton
        
        let expandableView = cell?.viewWithTag(100) as? UIView
        let expandButton = cell?.viewWithTag(20000) as? UIButton
        
        let switch1 = cell?.viewWithTag(6) as? UISwitch
        let switch2 = cell?.viewWithTag(7) as? UISwitch
        let switch3 = cell?.viewWithTag(8) as? UISwitch
        let switch4 = cell?.viewWithTag(9) as? UISwitch
        
        switch1?.isOn = false
        switch2?.isOn = false
        switch3?.isOn = false
        switch4?.isOn = false
//        switch1?.addTarget(self, action: #selector(self.Switch1(_:)), for: .valueChanged)
//        switch2?.addTarget(self, action: #selector(self.Switch2(_:)), for: .valueChanged)
//        switch3?.addTarget(self, action: #selector(self.Switch3(_:)), for: .valueChanged)
//        switch4?.addTarget(self, action: #selector(self.Switch4(_:)), for: .valueChanged)
        
        expandButton?.addTarget(self, action: #selector(toggleExpand(_:)), for: .touchUpInside)
        
        btnRemoveFromfamily?.addTarget(self, action: #selector(removeActiveFamily(_:)), for: .touchUpInside)
        
        //        btnRemoveFromfamily?.setTitle("parent_card_button_content_2".localized, for: .normal)
        
        let btnResendInvitation = cell?.viewWithTag(11) as? UIButton
        btnResendInvitation?.addTarget(self, action: #selector(resendInvitationFamily(_:)), for: .touchUpInside)
        
        if let dict = dic["settings"] as? [AnyHashable] {
            
            if dict.count == 0 {
                
                switch1?.isOn = false
                switch2?.isOn = false
                switch3?.isOn = false
                switch4?.isOn = false
                
            }else {
                
                if let settingItem = dict[0] as? [AnyHashable: Any] {
                    
                    let settingStatus = settingItem["status"] as? Int
                    
                    if settingStatus == 1 {
                        
                        switch1?.isOn = true
                        
                    } else {
                        
                        switch1?.isOn = false
                        
                    }
                    
                }
                
                if let settingItem = dict[1] as? [AnyHashable: Any] {
                    
                    let settingStatus = settingItem["status"] as? Int
                    
                    if settingStatus == 1 {
                        
                        switch2?.isOn = true
                        
                    } else {
                        
                        switch2?.isOn = false
                        
                    }
                }
                if let settingItem = dict[2] as? [AnyHashable: Any] {
                    
                    let settingStatus = settingItem["status"] as? Int
                    
                    if settingStatus == 1 {
                        
                        switch3?.isOn = true
                        
                    } else {
                        
                        switch3?.isOn = false
                        
                    }
                }
                if let settingItem = dict[3] as? [AnyHashable: Any] {
                    
                    let settingStatus = settingItem["status"] as? Int
                    
                    if settingStatus == 1 {
                        
                        switch4?.isOn = true
                        
                    } else {
                        
                        switch4?.isOn = false
                        
                    }
                }
                
            }
        }
        
        LabelTitle?.text = dic["name"] as? String
        
        LabelSubTitle?.text = dic["email"] as? String
        LabelRelation?.text = dic["relationship"] as? String
        let strgender = dic["gender"] as? String
        
        let imgview = cell?.viewWithTag(10) as? UIImageView
        if strgender == "female" {
            imgview?.image = UIImage(named: "in_parent_f")
        } else {
            imgview?.image = UIImage(named: "in_parent_m 1")
        }
        let isExpanded = expandedCells[indexPath] ?? false
        
        expandableView?.isHidden = !isExpanded
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let isExpanded = expandedCells[indexPath] ?? false
        return isExpanded ? 390 : 210
    }
    
    func dataShowAll() {
        imgView.isHidden = true
        contentLbl.isHidden = true
        self.view1.isHidden = false
        self.view2.isHidden = false
        self.tableView.isHidden = false
    }
    
    func nodataShow() {
        self.imgView.isHidden = false
        self.contentLbl.isHidden = false
        self.view1.isHidden = true
        self.view2.isHidden = true
        self.view.backgroundColor = UIColor.white
        self.tableView.isHidden = true
    }
    
    func nodataShowNew() {
        self.imgView.isHidden = false
        self.view1.isHidden = false
        self.view2.isHidden = true
        self.view.backgroundColor = UIColor.white
        self.tableView.isHidden = true
    }
    
    @IBAction func buttonInviteParent(_ sender: UIButton) {
        
        if UI_USER_INTERFACE_IDIOM() == .pad {
            
            let vc = SwiftInviteCoparentViewController(nibName: "inviteViewControllerIPAD", bundle: Bundle.main)
            navigationController?.pushViewController(vc, animated: true)
            
        } else {
            
            let vc = SwiftInviteCoparentViewController(nibName: "inviteViewController", bundle: Bundle.main)
            navigationController?.pushViewController(vc, animated: true)
            
        }
        
    }
    
    @objc func toggleExpand(_ sender: UIButton) {
        var view = sender as UIView
        while let superview = view.superview {
            if let cell = superview as? UITableViewCell,
               let indexPath = tableView.indexPath(for: cell) {
                
                let isExpanded = expandedCells[indexPath] ?? false
                expandedCells[indexPath] = !isExpanded
                
                if let expandableView = cell.viewWithTag(100) {
                    UIView.animate(withDuration: 0.3) {
                        expandableView.isHidden = !expandableView.isHidden
                        // Call to update cell height
                        self.tableView.beginUpdates()
                        self.tableView.endUpdates()
                    }
                }
                
                // Update the expand button image
                let newImage = isExpanded ? UIImage(named: "down") : UIImage(named: "up")
                sender.setImage(newImage, for: .normal)
                
                return // Exit function once we find the cell
            }
            view = superview
        }
        
        print("Failed to get indexPath for cell containing button.")
    }
    
//    @objc func Switch1(_ sender: UISwitch) {
//        
//        let button = sender
//        let k = button.isOn
//        var SwitchState: String = "0"
//        
//        if k {
//            
//            SwitchState = "1"
//            
//        }
//        
//        let buttonPosition = sender.convert(CGPoint.zero, to: tableView)
//        let indexPath = tableView.indexPathForRow(at: buttonPosition)
//        
//        if (indexPath != nil) {
//            print(String(format: "Row= \(String(describing: indexPath?.row))  Section= \(String(describing: indexPath?.row))"))
//            
//            let dic = Array[indexPath!.row]
//            let strUser_Id = String(dic["user_id"] as? Int ?? -1)
//            var switch_Id: String = ""
//            
//            if let settingData = dic["settings"] as? [AnyHashable] {
//                
//                if let settingItem = settingData[0] as? [AnyHashable: Any] {
//                    
//                    switch_Id = String(settingItem["id"] as? Int ?? -1)
//                    
//                }
//            }
//            
//            SwiftFTUtils.showHUDAdded(to: view, withText: "loading...".myModification(), animated: true)
//            //        NSString *url = [NSString stringWithFormat:@"https://mesh.familytime.io/v2/ftd/user/invite"];
//            let url = "\(kBasUrlNew_mesh2)/dashboard/settings/notifications/preferences/\(String(describing: strUser_Id))"
//            let arr = [[
//                "id": switch_Id,
//                "status": SwitchState
//            ]]
//            
//            let params = [
//                "notifications": arr
//            ]
//            
//            var jsonString: String? = nil
//            var jsonData: Data? = nil
//            do {
//                jsonData = try JSONSerialization.data(
//                    withJSONObject: params,
//                    options: .prettyPrinted /* Pass 0 if you don't  care about the readability of the generated string */)
//            } catch {
//            }
//            
//            if (jsonData == nil) {
//                print("Got an error")
//            } else {
//                jsonString = String(data: jsonData!, encoding: .utf8)
//                print("\(String(describing: jsonString))")
//            }
//            print("url = \(url) and bodyString = \(String(describing: jsonString))")
//            ApiManager.shared().mesh_putApiNoti(withParamString: jsonString!, withApi: url) { json, errorCode, message in
//                
//                DispatchQueue.main.async {
//                    
//                    MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
//                    print("Native patch api json response == \(json)")
//                    if (json["status"] as? NSNumber)?.intValue ?? 0 == 200 {
//                        CommonModel.showAlert("", msg: json["message"] as? String)
//                    } else {
//                        CommonModel.showAlert("", msg: json["message"] as? String)
//                    }
//                }
//            }
//        }
//    }
    
//    @objc func Switch2(_ sender: UISwitch) {
//        let button = sender
//        let k = button.isOn
//        var SwitchState: String = "0"
//        if k {
//            SwitchState = "1"
//        }
//        let buttonPosition = sender.convert(CGPoint.zero, to: tableView)
//        let indexPath = tableView.indexPathForRow(at: buttonPosition)
//        
//        if (indexPath != nil) {
//            print(String(format: "Row=\(String(describing: indexPath?.row))  Section=\(String(describing: indexPath?.section))"))
//            let dic = Array[indexPath!.row]
//            print(dic)
//            let strUser_Id = String(dic["user_id"] as? Int ?? -1)
//            var switch_Id: String = ""
//            
//            if let settingData = dic["settings"] as? [AnyHashable] {
//                
//                if let settingItem = settingData[1] as? [AnyHashable: Any] {
//                    
//                    switch_Id = String(settingItem["id"] as? Int ?? -1)
//                }
//            }
//            
//            SwiftFTUtils.showHUDAdded(to: view, withText: "loading...".myModification(), animated: true)
//            
//            let url = "\(kBasUrlNew_mesh2)/dashboard/settings/notifications/preferences/\(String(describing: strUser_Id))"
//            let arr = [[
//                "id": switch_Id,
//                "status": SwitchState
//            ]]
//            
//            let params = [
//                "notifications": arr
//            ]
//            
//            var jsonString: String? = nil
//            var jsonData: Data? = nil
//            do {
//                jsonData = try JSONSerialization.data(
//                    withJSONObject: params,
//                    options: .prettyPrinted /* Pass 0 if you don't  care about the readability of the generated string */)
//            } catch {
//            }
//            
//            if (jsonData == nil) {
//                print("Got an error")
//            } else {
//                jsonString = String(data: jsonData!, encoding: .utf8)
//                print("\(String(describing: jsonString))")
//            }
//            
//            print("url = \(url) and bodyString = \(String(describing: jsonString))")
//            
//            ApiManager.shared().mesh_putApiNoti(withParamString: jsonString!, withApi: url) { json, errorCode, message in
//                
//                DispatchQueue.main.async {
//                    
//                    MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
//                    
//                    print("Native patch api json response == \(json)")
//                    if (json["status"] as? NSNumber)?.intValue ?? 0 == 200 {
//                        CommonModel.showAlert("", msg: json["message"] as? String)
//                    } else {
//                        CommonModel.showAlert("", msg: json["message"] as? String)
//                    }
//                    
//                }
//            }
//        }
//    }
    
//    @objc func Switch3(_ sender: UISwitch) {
//        
//        let button = sender
//        let k = button.isOn
//        var SwitchState: String = "0"
//        
//        if k {
//            
//            SwitchState = "1"
//            
//        }
//        
//        let buttonPosition = sender.convert(CGPoint.zero, to: tableView)
//        let indexPath = tableView.indexPathForRow(at: buttonPosition)
//        
//        if (indexPath != nil) {
//            
//            print(String(format: "Row=\(String(describing: indexPath?.row))  Section=\(String(describing: indexPath?.section))"))
//            
//            let dic = Array[indexPath!.row]
//            let strUser_Id = String(dic["user_id"] as? Int ?? -1)
//            var switch_Id: String = ""
//            
//            if let settingData = dic["settings"] as? [AnyHashable] {
//                
//                if let settingItem = settingData[2] as? [AnyHashable: Any] {
//                    
//                    switch_Id = String(settingItem["id"] as? Int ?? -1)
//                    
//                }
//            }
//            
//            SwiftFTUtils.showHUDAdded(to: view, withText: "loading...".myModification(), animated: true)
//            //        NSString *url = [NSString stringWithFormat:@"https://mesh.familytime.io/v2/ftd/user/invite"];
//            let url = "\(kBasUrlNew_mesh2)/dashboard/settings/notifications/preferences/\(String(describing: strUser_Id))"
//            let arr = [[
//                "id": switch_Id,
//                "status": SwitchState
//            ]]
//            
//            let params = [
//                "notifications": arr
//            ]
//            
//            var jsonString: String? = nil
//            var jsonData: Data? = nil
//            do {
//                jsonData = try JSONSerialization.data(
//                    withJSONObject: params,
//                    options: .prettyPrinted /* Pass 0 if you don't  care about the readability of the generated string */)
//            } catch {
//            }
//            
//            if (jsonData == nil) {
//                print("Got an error")
//            } else {
//                jsonString = String(data: jsonData!, encoding: .utf8)
//                print("\(String(describing: jsonString))")
//            }
//            
//            print("url = \(url) and bodyString = \(String(describing: jsonString))")
//            
//            ApiManager.shared().mesh_putApiNoti(withParamString: jsonString!, withApi: url) { json, errorCode, message in
//                
//                DispatchQueue.main.async {
//                    
//                    MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
//                    
//                    
//                    print("Native patch api json response == \(json)")
//                    if (json["status"] as? NSNumber)?.intValue ?? 0 == 200 {
//                        CommonModel.showAlert("", msg: json["message"] as? String)
//                    } else {
//                        CommonModel.showAlert("", msg: json["message"] as? String)
//                    }
//                }
//            }
//        }
//    }
    
//    @objc func Switch4(_ sender: UISwitch) {
//        
//        let button = sender
//        let k = button.isOn
//        var SwitchState: String = "0"
//        if k {
//            SwitchState = "1"
//        }
//        let buttonPosition = sender.convert(CGPoint.zero, to: tableView)
//        let indexPath = tableView.indexPathForRow(at: buttonPosition)
//        if (indexPath != nil) {
//            print(String(format: "Row=\(String(describing: indexPath?.row))  Section=\(String(describing: indexPath?.section))"))
//            let dic = Array[indexPath!.row]
//            let strUser_Id = String(dic["user_id"] as? Int ?? -1)
//            var switch_Id: String = ""
//            if let settingData = dic["settings"] as? [AnyHashable] {
//                if let settingItem = settingData[3] as? [AnyHashable: Any] {
//                    switch_Id = String(settingItem["id"] as? Int ?? -1)
//                }
//            }
//            SwiftFTUtils.showHUDAdded(to: view, withText: "loading...".myModification(), animated: true)
//            //        NSString *url = [NSString stringWithFormat:@"https://mesh.familytime.io/v2/ftd/user/invite"];
//            let url = "\(kBasUrlNew_mesh2)/dashboard/settings/notifications/preferences/\(String(describing: strUser_Id))"
//            let arr = [[
//                "id": switch_Id,
//                "status": SwitchState
//            ]]
//            
//            let params: NSDictionary = [
//                "notifications": arr
//            ]
//            
//            print(params)
//            
//            var jsonString: String? = nil
//            var jsonData: Data? = nil
//            do {
//                jsonData = try JSONSerialization.data(
//                    withJSONObject: params,
//                    options: .prettyPrinted /* Pass 0 if you don't  care about the readability of the generated string */)
//            } catch {
//            }
//            
//            if (jsonData == nil) {
//                print("Got an error")
//            } else {
//                jsonString = String(data: jsonData!, encoding: .utf8)
//                print("\(String(describing: jsonString))")
//            }
//            
//            print("url = \(url) and bodyString = \(String(describing: jsonString))")
//            
//            ApiManager.shared().mesh_putApiNoti(withParamString: jsonString!, withApi: url) { json, errorCode, message in
//                
//                DispatchQueue.main.async {
//                    
//                    MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
//                    
//                    print("Native patch api json response == \(json)")
//                    if (json["status"] as? NSNumber)?.intValue ?? 0 == 200 {
//                        CommonModel.showAlert("", msg: json["message"] as? String)
//                    } else {
//                        CommonModel.showAlert("", msg: json["message"] as? String)
//                    }
//                }
//            }
//        }
//    }
    
    @objc func removeActiveFamily(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "", message: "parent_alert_1_content_1".localized, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "cancel_button".localized, style: .default, handler: { action in
            
            print("Cancel")
            
        }))
        
        alert.addAction(UIAlertAction(title: "ok_button".localized, style: .default, handler: { [self] action in
            
            let buttonPosition = sender.convert(CGPoint.zero, to: tableView)
            let indexPath = tableView.indexPathForRow(at: buttonPosition)
            
            if (indexPath != nil) {
                print(String(format: "Row=\(String(describing: indexPath?.row))  Section=\(String(describing: indexPath?.section))"))
                
                print(Array[indexPath!.row])
                
                let item = Array[indexPath!.row ]
                let coParentId = item["user_id"] as? Int ?? 0
                let params: [String: Any] = [
                    "user_id": coParentId as Any
                ]
                
                SwiftFTUtils.showHUDAdded(to: view, withText: "loading...".myModification(), animated: true)
                let url = HLConstants.BASE_URL_CORE_2 + "cancel-co-parent-invitation"
                CoreManager.networkRequest(url: url, method: .post, params: params) { (response: EmptyResponseModel?, statusCode, errorMessage) in
                    SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
                    if let statusCode = statusCode {
                        if (200...206).contains(statusCode) {
                            DBManager.shared.deleteCoParent(withId: coParentId)
                            let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
                              
                              // Instantiate the view controller with identifier
                              if let VC = storyboard.instantiateViewController(withIdentifier: "SuccessPopViewController") as? SuccessPopViewController {
                                  VC.image = UIImage(named: "tick")
                                  VC.titleText = "successfull".localized
                                  VC.subtitleText = "parent_alert_2_content_1".localized
                                  VC.modalPresentationStyle = .overCurrentContext
                                  VC.modalTransitionStyle = .crossDissolve
                                  self.present(VC, animated: true, completion: nil)
                              } else {
                                  print("Error: Could not instantiate view controller with identifier 'SuccessPopViewController'")
                              }
                            
//                            CommonModel.showAlert("alert_title".localized, msg: "parent_alert_2_content_1".localized)
                            self.refreshScreen()
                        } else {
//                            CommonModel.showAlert("", msg: errorMessage)
                            let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
                            if let VC = storyboard.instantiateViewController(withIdentifier: "SuccessPopViewController") as? SuccessPopViewController {
                                VC.image = UIImage(named: "oopsIcons")
                                VC.titleText = "oops_title".localized
                                VC.subtitleText = errorMessage?.localized ?? ""
                                VC.modalPresentationStyle = .overCurrentContext
                                VC.modalTransitionStyle = .crossDissolve
                                   
                                self.present(VC, animated: true, completion: nil)
                            } else {
                                print("Error: Could not instantiate view controller with identifier 'SuccessPopViewController'")
                            }
                        }
                        
                    }
                }
                
                
                //                SwiftFTUtils.showHUDAdded(to: view, withText: "loading...".myModification(), animated: true)
                //
                //                let params: [AnyHashable : Any] = [
                //                    "co_parent_user_id": coParentId as Any,
                //                    "_method": "DELETE" //---HACK TO WORK DELETE API AS POST API---//
                //                ]
                //                print("remove coparent params = \(params) and url = \(kDelete_Coparent_mesh2)")
                //
                //                ApiManager.shared().postApi(withVC: self, isPresentedCont: false, andParams: params, withApi: kDelete_Coparent_mesh2) { message, code in
                //
                //                    DispatchQueue.main.async {
                //
                //                        SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
                //
                //                        print(String(format: "delete coparent response message = %@ and code = %ld", message, Int(code)))
                //
                //                        if code == 200 {
                //                            CommonModel.showAlert("alert_title".localized, msg: "parent_alert_2_content_1".localized)
                //                            self.refreshScreen()
                //                        }else{
                //
                //                            CommonModel.showAlert("alert_title".localized, msg: message)
                //                        }
                //                    }
                //                }
            }
        }))
        
        self.present(alert, animated: true)
    }
    
    func refreshScreen() {
        self.viewParentdata()
    }
    
    @objc func resendInvitationFamily(_ sender: UIButton) {
        
        let buttonPosition = sender.convert(CGPoint.zero, to: tableView)
        let indexPath = tableView.indexPathForRow(at: buttonPosition)
        
        if (indexPath != nil) {
            
            print(String(format: "Row=\(String(describing: indexPath?.row))  Section=\(String(describing: indexPath?.section))"))
            
            let dic = Array[indexPath?.row ?? 0]
            let strUser_Email = dic["email"] as? String
            //            let strUser_Name = dic["name"] as? String
            let userId = dic["user_id"] as? Int
            
            let params: [String: Any] = [
                "user_id": userId as Any
            ]
            SwiftFTUtils.showHUDAdded(to: view, withText: "loading...".myModification(), animated: true)
            let url = HLConstants.BASE_URL_CORE_2 + "resend-co-parent-invitation"
            CoreManager.networkRequest(url: url, method: .post, params: params) { (response: EmptyResponseModel?, statusCode, errorMessage) in
                SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
                if let statusCode = statusCode {
                    if (200...206).contains(statusCode) {
                        let str = "invite_parent_text_content_2".localized
                        let replaced = str.replacingOccurrences(of: "xyz@gmail.com", with: strUser_Email ?? "your provided email")
                        let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
                          
                          // Instantiate the view controller with identifier
                          if let VC = storyboard.instantiateViewController(withIdentifier: "SuccessPopViewController") as? SuccessPopViewController {
                              VC.image = UIImage(named: "tick")
                              VC.titleText = "successfull".localized
                              VC.subtitleText = "invite_parent_text_success".localized
                              VC.modalPresentationStyle = .overCurrentContext
                              VC.modalTransitionStyle = .crossDissolve
                              self.present(VC, animated: true, completion: nil)
                          } else {
                              print("Error: Could not instantiate view controller with identifier 'SuccessPopViewController'")
                          }
                        
                    } else {
                        let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
                        if let VC = storyboard.instantiateViewController(withIdentifier: "SuccessPopViewController") as? SuccessPopViewController {
                            VC.image = UIImage(named: "oopsIcons")
                            VC.titleText = "oops_title".localized
                            VC.subtitleText = errorMessage?.localized ?? ""
                            VC.modalPresentationStyle = .overCurrentContext
                            VC.modalTransitionStyle = .crossDissolve
                            self.present(VC, animated: true, completion: nil)
                        } else {
                            print("Error: Could not instantiate view controller with identifier 'SuccessPopViewController'")
                        }
//                        CommonModel.showAlert("", msg: errorMessage)
                    }
                    
                }
                
                
                //                SwiftFTUtils.showHUDAdded(to: view, withText: "loading...".myModification(), animated: true)
                //                //        NSString *url = [NSString stringWithFormat:@"https://mesh.familytime.io/v2/ftd/user/invite"];
                //                let url = "\(kBasUrlNew_mesh2)/dashboard/coparent/invite"
                //
                //                //{"type":"reinvite","user_id":7373}
                //                let params = [
                //                    "email": strUser_Email,
                //                    "name": strUser_Name
                //                ]
                //
                //                var jsonString: String? = nil
                //                var jsonData: Data? = nil
                //                do {
                //                    jsonData = try JSONSerialization.data(
                //                        withJSONObject: params,
                //                        options: .prettyPrinted /* Pass 0 if you don't  care about the readability of the generated string */)
                //                } catch {
                //                }
                //
                //                if (jsonData == nil) {
                //                    print("Got an error")
                //                } else {
                //                    jsonString = String(data: jsonData!, encoding: .utf8)
                //                    print("\(String(describing: jsonString))")
                //                }
                //
                //                print("url = \(url) and bodyString = \(String(describing: jsonString))")
                //
                //                ApiManager.shared().mesh_postApi(withParamString: jsonString!, withApi: url) { json, errorCode, message in
                //
                //                    DispatchQueue.main.async {
                //
                //                        MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                //                        print("Native patch api json response == \(json)")
                //                        if (json["status"] as? NSNumber)?.intValue ?? 0 == 200 {
                //                            let str = "invite_parent_text_content_2".localized
                //                            let replaced = str.replacingOccurrences(of: "xyz@gmail.com", with: strUser_Email ?? "your provided email")
                //                            CommonModel.showAlert("", msg: replaced)
                //                        } else {
                //                            CommonModel.showAlert("", msg: json["message"] as? String)
                //                        }
                //                    }
                //                }
            }
        }
        
        //    @objc func revokeInvitation(_ sender: UIButton) {
        //
        //        let alert = UIAlertController(title: "parent_card_button_content_3".localized, message: "parent_alert_1_content_1".localized, preferredStyle: .alert)
        //
        //        alert.addAction(UIAlertAction(title: "cancel_button".localized, style: .default, handler: { action in
        //
        //            print("Cancel")
        //
        //        }))
        //
        //        alert.addAction(UIAlertAction(title: "ok_button".localized, style: .default, handler: { [self] action in
        //
        //            let buttonPosition = sender.convert(CGPoint.zero, to: tableView)
        //            let indexPath = tableView.indexPathForRow(at: buttonPosition)
        //
        //            if (indexPath != nil) {
        //
        //                print(String(format: "Row=\(String(describing: indexPath?.row))  Section=\(String(describing: indexPath?.section))"))
        //
        //                let dic = Array1[indexPath!.row]
        //                let strUser_Id = String(dic["user_id"] as? Int ?? -1)
        //
        //                SwiftFTUtils.showHUDAdded(to: view, withText: "loading...".localized, animated: true)
        //                //        NSString *url = [NSString stringWithFormat:@"https://mesh.familytime.io/v2/ftd/user/invite"];
        //                let url = "\(kBasUrlNew_mesh2)/dashboard/coparent"
        //
        //                //{"type":"reinvite","user_id":7373}
        //                let params = [
        //                    "co_parent_user_id": strUser_Id
        //                ]
        //
        //                var jsonString: String? = nil
        //                var jsonData: Data? = nil
        //                do {
        //                    jsonData = try JSONSerialization.data(
        //                        withJSONObject: params,
        //                        options: .prettyPrinted /* Pass 0 if you don't  care about the readability of the generated string */)
        //                } catch {
        //                }
        //
        //                if (jsonData == nil) {
        //                    print("Got an error")
        //                } else {
        //                    jsonString = String(data: jsonData!, encoding: .utf8)
        //                    print("\(String(describing: jsonString))")
        //                }
        //
        //                print("url = \(url) and bodyString = \(String(describing: jsonString))")
        //
        //                ApiManager.shared().mesh_deleteApi(withStringParam: jsonString!, withApi: url) { json, errorCode, message in
        //
        //                    DispatchQueue.main.async {
        //
        //                        MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
        //                        print("Native patch api json response == \(json)")
        //                        if (json["status"] as? NSNumber)?.intValue ?? 0 == 200 {
        //                            CommonModel.showAlert("", msg: "parent_alert_2_content_1".localized)
        //                        } else {
        //                            CommonModel.showAlert("", msg: "alert_something_wrong".localized)
        //                        }
        //
        //                        self.viewParentdata()
        //                    }
        //                }
        //            }
        //
        //        }))
        //
        //        self.present(alert, animated: true)
        //    }
        
        func CheckCoparent() {
            self.checkpermissionInviteParent = 5
        }
        
        func refreshTable() {
            refreshControl?.endRefreshing()
            tableView.reloadData()
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            print("Offset: \(scrollView.contentOffset.y)")
            if scrollView.contentOffset.y < -150 {
                if canRefresh && !refreshControl!.isRefreshing {
                    canRefresh = false
                    refreshControl?.beginRefreshing()
                    viewParentdata()
                }
            } else if scrollView.contentOffset.y >= 0 {
                canRefresh = true
            }
        }
    }
}
