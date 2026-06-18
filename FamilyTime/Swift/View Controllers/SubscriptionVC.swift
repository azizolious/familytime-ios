//
//  SubscriptionPopupVC.swift
//  FamilyTime
//
//  Created by Sana Ullah on 17/01/2019.
//  Copyright © 2019 YumyApps. All rights reserved.
//

import UIKit
import StoreKit
import ActiveLabel

class SubscriptionVC: UIViewController {

    
    @IBOutlet weak var chooseLbl: UILabel!
    @IBOutlet weak var tableVu: UITableView!
    
    
    @IBOutlet weak var chooseLbl_topConst:      NSLayoutConstraint!
    @IBOutlet weak var chooseLbl_bottomConst:   NSLayoutConstraint!
    @IBOutlet weak var chooseLbl_leadConst:     NSLayoutConstraint!
    @IBOutlet weak var tableVuHeightConst:      NSLayoutConstraint!
    
    @IBOutlet weak var moreInfoLbl: ActiveLabel!
    
    
    @IBOutlet weak var groupImageVu:        UIImageView!
    @IBOutlet weak var groupNameLbl:        UILabel!
    @IBOutlet weak var groupDescLbl:        UILabel!
    @IBOutlet weak var renewLbl:            UILabel!
    
    @IBOutlet weak var upgradeBtn:          UIButton!
    
    
    var productsArray   = [IAP_Product]()
    var selectedProduct = IAP_Product()
    var isIpad          = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        tableVu.rowHeight = UITableView.automaticDimension
//        tableVu.estimatedRowHeight = 90
        
//        self.tableVu.estimatedRowHeight = 0
        
        initilaization()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    //MARK: - CUSTOM METHODS
    
    func initilaization(){
        uiSetup()
        apiCallToGetProducts()
    }
    
    func getProductIds(){
        var idsSet = Set<String>()
        
        let idsArray = productsArray.map{$0.apple_product_id}
        
        for idd in idsArray{
            idsSet.insert(idd ?? "")
        }
        
        print("products IDS set = \(idsSet)")
        self.verifyProducts(prodIds: idsSet)
    }
    
    func uiSetup(){
        self.navigationItem.title = "in_app_purchase_title".localized
        chooseLbl.text = "in_app_purchase_content_1".localized
        self.groupDescLbl.text = "in_app_purchase_content_5".localized
        self.renewLbl.text = "in_app_purchase_content_6".localized
        self.moreInfoLbl.text = "in_app_purchase_content_7".localized
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "in_app_purchase_content_2".myModification(), style: .plain, target: self, action: #selector(restorePurchases))]
        
        if SwiftFTUtils.isDeviceiPhoneFamily(){
            isIpad = false
            //---BY DEFAULT IMAGEVU WIDTH HEIGHT SET FOR IPAD 116---// FOR IPHONE IT DIFFERS---//
        }
        else{
            isIpad = true
        }
        
        CommonUtility.shared.showTermsPolicy(label: moreInfoLbl, vc: self)
        MultilingualUtility.shared.lingualForIAPDetail(vc: self)
    }
    
    
    @objc func restorePurchases(){
        IAPUtility.shared.restorePurchases(vc: self)
    }
    
    func apiCallToGetProducts(){
        
        SwiftFTUtils.showHUDAdded(to: view, withText: "Loading...", animated: true)
        
        ApiManager.shared().getIAProductsApi(withVC: self) { (iap_dashboardModel, message, statusCode) in
            
            DispatchQueue.main.async {
                if(statusCode == 1)//---1 MEAN DATA IS NIL---//
                {
                    SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
                    CommonModel.showAlert("alert_error".myModification(), msg: message)
                }
                else if iap_dashboardModel.status == 200{
                    print("iap products response = \(iap_dashboardModel)")
                    
                    self.productsArray = iap_dashboardModel.products as! [IAP_Product]
                    let height = self.isIpad ? (SwiftTableVuConstants.kIAP_Cell_Height_ipad * self.productsArray.count) : (SwiftTableVuConstants.kIAP_Cell_Height * self.productsArray.count)
                    self.tableVuHeightConst.constant = CGFloat(height)
                    self.getProductIds()
                }
                else{
                    SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
                    print("IAP products api failed with code = \(iap_dashboardModel.status) and message = \(String(describing: iap_dashboardModel.message))")
                    CommonModel.showAlert("alert_error".myModification(), msg: iap_dashboardModel.message)
                }
            }
            
        }
    }//---END GET PRODUCTS API CALL---//
    
    
    
    func verifyProducts(prodIds:Set<String>){
        IAPUtility.shared.getAllProducts(prodIds: prodIds) { (array) in
            SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
            self.mapStoreProductsIntoIAPProducts(arr: array)
        }
    }
    
    func mapStoreProductsIntoIAPProducts(arr : [SKProduct]){
        //---NEW LOGIC FOR SORTING---//
        
        for serverProd in productsArray{
            
            for appleProd in arr{
                if appleProd.productIdentifier == serverProd.apple_product_id{
                    serverProd.apple_title     = appleProd.localizedTitle
                    serverProd.apple_desc      = appleProd.localizedDescription //---DESCRIPTION---//
                    serverProd.apple_price     = appleProd.localizedPriceString
                }
            }
            
            if serverProd.is_default{
                selectedProduct = serverProd
            }
        }
        tableVu.reloadData()
        
    }

    
    
    
    func getImageForGroup(prod:IAP_Product) -> (UIImage, UIColor){
        if prod.apple_product_id == SwiftConstants.MyFamilyYearly{
            return (#imageLiteral(resourceName: "ic_green"), CommonModel.color(fromHexString: Colors.kTheme_green))
        }
        else if prod.apple_product_id == SwiftConstants.MyFamily3Yearly{
            return (#imageLiteral(resourceName: "ic_orange"), CommonModel.color(fromHexString: Colors.kTheme_yellow))
        }
        else if prod.apple_product_id == SwiftConstants.MyFamily5Yearly{
            return (#imageLiteral(resourceName: "ic_red"), CommonModel.color(fromHexString: Colors.kTheme_red))
        }
        
        return (#imageLiteral(resourceName: "ic_red"), CommonModel.color(fromHexString: Colors.kTheme_red))
    }
    
    
    func selectProductAt(indexpath:IndexPath){
        //---DON'T RELOAD IF SELECTED---//
        
        if selectedProduct.apple_product_id != productsArray[indexpath.row].apple_product_id{
            for (index,_) in productsArray.enumerated(){
                if index == indexpath.row{
                    productsArray[index].is_default = true
                    selectedProduct = productsArray[index]
                }
                else{
                    productsArray[index].is_default = false
                }
            }
            self.tableVu.reloadData()
        }
    }//---END SELECT PRODUCT---//
    
    //MARK: - UI ACTIONS
    
    @IBAction func upgradeAction(_ sender: Any) {
        print("selected prod id = \(String(describing: selectedProduct.apple_product_id)) and title = \(String(describing: selectedProduct.apple_title)) )")
        IAPUtility.shared.autoRenewablePurchase(prodId: selectedProduct.apple_product_id ?? "", vc: self)
    }
    
    
    
}//---END SUBSCRIPTION VC---//


extension SubscriptionVC : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
  
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell()

        let imageVu         = cell.viewWithTag(1) as! UIImageView
        let titleLbl        = cell.viewWithTag(2) as! UILabel
        let descLbl         = cell.viewWithTag(3) as! UILabel
        let priceLbl        = cell.viewWithTag(4) as! UILabel
        let tickImgVu       = cell.viewWithTag(5) as! UIImageView

        let prod            = productsArray[indexPath.row]
//
        let imageColor      = getImageForGroup(prod: prod)
        
        imageVu.image       = imageColor.0 //getImageForGroup(prod: prod)
        tickImgVu.tintColor = imageColor.1 //getTickColor(prod: prod)
        
        
        titleLbl.text       = prod.apple_title
        descLbl.text        = prod.apple_desc
        priceLbl.text       = prod.apple_price
        
        tickImgVu.isHidden  = !prod.is_default
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        let vc           = SwiftConstants.SwiftStoryBoard.instantiateViewController(withIdentifier: "SubscriptionDetailVC") as! SubscriptionDetailVC
//        vc.selectedGroup = groupsArray[indexPath.row]
//        self.navigationController?.pushViewController(vc, animated:true)
        
        tableView.deselectRow(at: indexPath, animated: true)
        selectProductAt(indexpath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(SwiftTableVuConstants.kIAP_Cell_Height)
    }
}
