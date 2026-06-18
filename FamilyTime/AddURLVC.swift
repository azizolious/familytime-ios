//
//  AddURLVC.swift
//  FamilyTime
//
//  Created by Sufyan on 15/01/2024.
//  Copyright © 2024 YumyApps. All rights reserved.
//

import UIKit

class AddURLVC: UIViewController {
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var addUrlTF: UITextField!
    @IBOutlet weak var domainView: UIView!
    @IBOutlet weak var urlView: UIView!
    
    var isDomainSelected = true
    var vm = AddURLViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableInitializer()
        domainSelected()
        self.title = "web_blocker".localized
    }

    @IBAction func addBtnTapped(_ sender: UIButton) {
        guard var text = addUrlTF.text else {return}
        if isDomainSelected {
            let validDomain = text.isValidURL()
            let domaiName = text.getDomainName()
            text = domaiName ?? ""
            if !validDomain {
                let vc = ApplimitSuccessPopup(nibName: "ApplimitSuccessPopup", bundle: nil)
                vc.desc = "add_vaid_domain".localized
                vc.imgName = "oopsIcons"
                vc.titleStr = "notification_content_1".localized
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .overFullScreen
                self.navigationController?.present(vc, animated: true, completion: nil)
                return
            }
        } else {
            let validUrl = text.isValidURL()
            if !validUrl {
                let vc = ApplimitSuccessPopup(nibName: "ApplimitSuccessPopup", bundle: nil)
                vc.desc = "add_vaid_url".localized
                vc.imgName = "oopsIcons"
                vc.titleStr = "notification_content_1".localized
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .overFullScreen
                self.navigationController?.present(vc, animated: true, completion: nil)
                return
            }
        }
        let id = UserDefaults.standard.integer(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
        let obj = WebBlockerObj(id: nil, superUserID: nil, 
                                childID: id, url: text,
                                type: isDomainSelected ? "domain" : "url",
                                isBlocked: 1)
        vm.newURLArr.append(obj)
        addUrlTF.text = isDomainSelected ? "https://" : ""
        self.tblView.reloadData()
    }
    
    @IBAction func domainTapped(_ sender: UIButton) {
        domainSelected()
    }
    @IBAction func saveTapped(_ sender: UIButton) {
        if vm.newURLArr.count != 0 {
            SwiftFTUtils.showHUDAdded(to: self.view, withText: "", animated: true)
            vm.postData { [weak self] msg in
                SwiftFTUtils.hideHUDAdded(to: self?.view, animated: true)
                if msg == nil {
                    let vc = ApplimitSuccessPopup(nibName: "ApplimitSuccessPopup", bundle: nil)
                    vc.desc = "domain_successfully_blocked".localized
                    vc.tapped = { [weak self] in
                        self?.navigationController?.popViewController(animated: true)
                    }
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .overFullScreen
                    self?.navigationController?.present(vc, animated: true, completion: nil)
                } else {
                    let vc = ApplimitSuccessPopup(nibName: "ApplimitSuccessPopup", bundle: nil)
                    vc.desc = msg
                    vc.imgName = "oopsIcons"
                    vc.titleStr = "notification_content_1".localized
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .overFullScreen
                    self?.navigationController?.present(vc, animated: true, completion: nil)
                }
            }
        }
    }
    func presentPopUp() {
        
    }
    @IBAction func urlTapped(_ sender: UIButton) {
        urlSelected()
    }
    
    @objc func removeUrlTapped(_ sender: UIButton) {
        vm.newURLArr.remove(at: sender.tag)
        tblView.reloadData()
    }
    
    func domainSelected() {
        isDomainSelected = true
        domainView.borderWidth = 1
        domainView.borderColor = UIColor(hexString: "#156CF7")
        urlView.borderWidth = 1
        urlView.borderColor = UIColor(hexString: "#CCCCCC")
        addUrlTF.text = "https://"
    }
    func urlSelected() {
        isDomainSelected = false
        urlView.borderWidth = 1
        urlView.borderColor = UIColor(hexString: "#156CF7")
        domainView.borderWidth = 1
        domainView.borderColor = UIColor(hexString: "#CCCCCC")
        addUrlTF.text = ""
    }
    func tableInitializer() {
        tblView.register(UINib(nibName: "WebBlockerCell", bundle: nil), forCellReuseIdentifier: "WebBlockerCell")
        tblView.register(UINib(nibName: "AddDomainCell", bundle: nil), forCellReuseIdentifier: "AddDomainCell")
        tblView.dataSource = self
    }
}
extension AddURLVC:UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.newURLArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WebBlockerCell", for: indexPath) as! WebBlockerCell
        cell.swicth.isHidden = true
        cell.checkImg.isHidden = true
        cell.deleteBtn.tag = indexPath.row
        cell.deleteBtn.addTarget(self, action: #selector(removeUrlTapped(_:)), for: .touchUpInside)
        cell.title.text = vm.newURLArr[indexPath.row].url
        cell.desc.text = vm.newURLArr[indexPath.row].type
        return cell
    }
}


extension String {
    func getDomainName() -> String? {
        if let urlObject = URL(string: self) {
            if let host = urlObject.host {
                var domain = host.lowercased()
                if domain.hasPrefix("www.") {
                    domain = domain.replacingOccurrences(of: "www.", with: "")
                }
                return domain
            }
        }
        return nil
    }

    func isValidURL() -> Bool {
        let urlRegex = #"^(https?|ftp):\/\/[^\s\/$.?#].[^\s]*$"#
        //let urlRegex = "(?:www\\.)?(.*?)\\.(com|co\\..+|\\w{2})"
        //let urlRegex = "(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+"
        let predicate = NSPredicate(format: "SELF MATCHES %@", urlRegex)
        return predicate.evaluate(with: self)
    }
}
