//
//  SwiftInviteCoparentViewController.swift
//  FamilyTime
//
//  Created by YumyApps on 18/10/2021.
//  Copyright © 2021 YumyApps. All rights reserved.
//

import UIKit
import DropDown
class SwiftInviteCoparentViewController: BaseViewController, UITextFieldDelegate {
    
    //MARK: - IBOUTLETS
    @IBOutlet weak var imgViewNew: UIImageView!
    @IBOutlet weak var lblSubtitle: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var selectRelationBtn: UIButton!
    @IBOutlet weak var relationTextField: UITextField!
    
    @IBOutlet weak var dropDownView: UIView!
    var lblTitle = UILabel()
    var check = -1
    var dropDown = DropDown()
    //MARK: - VIEWS LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        submitButton.setTitle("invite_parent_button_content_1".myModification(), for: .normal)
        submitButton.layer.cornerRadius = submitButton.frame.size.height / 2
        submitButton.layer.masksToBounds = true

        txtEmail.placeholder = NSLocalizedString("invite_parent_input_content_2", comment: "")
        txtName.placeholder = NSLocalizedString("invite_parent_input_content_1", comment: "")

        check = 0
        self.navigationItem.title = "invite_parent_title".localized
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(
            title: "",
            style: .plain,
            target: nil,
            action: nil)
        configureDropDown()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ZendeskChatManager.trackEvent("Invite Coparent Screen")
        navigationController?.navigationBar.isHidden = false
        self.lblSubtitle.text = "invite_parent_text_content_1".localized
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        CommonModel.removeKeyBoardObserver(self)
    }
    
    @IBAction func selectRelationBtn(_ sender: UIButton) {
        dropDown.show()
    }
    @IBAction func sendInvitationButton(_ sender: UIButton) {
        
        if check == 0 {
            handleSave()
        } else {
            unHideAll()
        }
    }
    
//MARK: - TextField Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    func validateEmail(with checkString: String?) -> Bool {
        let stricterFilter = false // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
        let stricterFilterString = "[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}"
        let laxString = ".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*"
        let emailRegex = stricterFilter ? stricterFilterString : laxString
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: checkString)
    }
    
    func autoLayoutHeight(withPoints position: CGFloat) -> CGFloat {
        let pointsPerPercent: CGFloat = 2208.0 / 100.0
        let positionInPercent = position / pointsPerPercent

        let height = view.bounds.height
        return (height / 100.0) * positionInPercent
    }
    
    func gradient() {
        let gradient = CAGradientLayer()
        gradient.frame = submitButton.bounds
        gradient.colors = [UIColor.white.cgColor, UIColor.black.cgColor].compactMap { $0 }
    }
    func configureDropDown() {
           dropDown.anchorView = selectRelationBtn
           dropDown.dataSource = ["Guardian", "Spouse"]
           dropDown.selectionAction = { [weak self] (index: Int, item: String) in
               guard let self = self else { return }
               self.relationTextField.text = item
           }
       }
    func handleSave() {
        if txtName.text?.count == 0 {
            CommonModel.showAlert("", msg: "invite_parent_validation_1".localized)
        } else if txtEmail.text?.count == 0 {
            CommonModel.showAlert("", msg: "invite_parent_validation_1".localized)
        } else if !validateEmail(with: txtEmail.text) {
            CommonModel.showAlert("", msg: "invite_parent_validation_2".localized)
        } else {
            let params: [String: Any] = [
                "email": txtEmail.text as Any,
                "name": txtName.text as Any,
                "type": relationTextField.text as Any
            ]
            SwiftFTUtils.showHUDAdded(to: view, withText: "loading...".myModification(), animated: true)
            let url = HLConstants.BASE_URL_CORE_2 + "invite-co-parent"
            CoreManager.networkRequest(url: url, method: .post, params: params) { (response: EmptyResponseModel?, statusCode, errorMessage) in
                SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
                if let statusCode = statusCode {
                    if (200...206).contains(statusCode) {
                        CoreManager.getCoParents()
                        self.hideAll()
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
                        if statusCode == 409, errorMessage == "You cannot send invitation to super parent." {
//                            CommonModel.showAlert("", msg: "invite_parent_alert_content_1".localized)
                            let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
                            if let VC = storyboard.instantiateViewController(withIdentifier: "SuccessPopViewController") as? SuccessPopViewController {
                                VC.image = UIImage(named: "oopsIcons")
                                VC.titleText = "oops_title".localized
                                VC.subtitleText = "invite_parent_alert_content_1".localized
                                VC.modalPresentationStyle = .overCurrentContext
                                VC.modalTransitionStyle = .crossDissolve
                                   
                                self.present(VC, animated: true, completion: nil)
                            } else {
                                print("Error: Could not instantiate view controller with identifier 'SuccessPopViewController'")
                            }
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
                } else {
                    // Handle the case where statusCode is nil, if needed
                    CommonModel.showAlert("", msg: "Unknown error occurred.")
                }

            }
            
//            SwiftFTUtils.showHUDAdded(to: view, withText: "loading...".myModification(), animated: true)
//
//            let params: [AnyHashable: Any] = [
//                "email": txtEmail.text as Any,
//                "name": txtName.text as Any,
//                "type": "Guardian" as Any
//            ]
//            let url = HLConstants.BASE_URL_CORE_2 + "invite-co-parent"
//            print("params = \(params) and url = \(kInvite_Coparent_mesh2)")
//            ApiManager.shared().postApi(withVC: self, isPresentedCont: false, andParams: params, withApi: url) { message, statusCode in
//                DispatchQueue.main.async {
//                    SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
//                    print(String(format: "invite coparent msg = %@ and status code = %ld", message, Int(statusCode)))
//                    if statusCode == 200 {
//                        self.hideAll()
//                    } else {
//                        if statusCode == 409, message == "You cannot send invitation to super parent."{
//                            CommonModel.showAlert("", msg: "invite_parent_alert_content_1".localized)
//                        } else {
//                            CommonModel.showAlert("", msg: message)
//                        }
//                    }
//                }
//            }
        }
    }
    
    func hideAll() {
        txtEmail.resignFirstResponder()
        txtName.resignFirstResponder()
        check = 1
        lblSubtitle.textColor = UIColor.darkText
        let str = "invite_parent_text_content_2".localized
        let replaced = str.replacingOccurrences(of: "xyz@gmail.com", with: txtEmail.text ?? "your provided email")
        lblSubtitle.text = replaced
        submitButton.setTitle("invite_parent_button_content_2".localized, for: .normal)
        lblTitle.isHidden = true
        txtEmail.isHidden = true
        txtName.isHidden = true
        lblSubtitle.isHidden = false
        submitButton.isHidden = false
        dropDownView.isHidden = true
    }
    
    func unHideAll() {
        lblSubtitle.textColor = UIColor.darkText
        txtName.isHidden = false
        txtName.text = ""

        txtEmail.text = ""
        
        check = 0
        lblSubtitle.text = "invite_parent_text_content_1".localized
        submitButton.setTitle("invite_parent_button_content_1".localized, for: .normal)

        lblTitle.isHidden = false
        lblSubtitle.isHidden = false
        //    _imgview.hidden=NO;
        txtEmail.isHidden = false
        submitButton.isHidden = false
        dropDownView.isHidden = false
    }
}
