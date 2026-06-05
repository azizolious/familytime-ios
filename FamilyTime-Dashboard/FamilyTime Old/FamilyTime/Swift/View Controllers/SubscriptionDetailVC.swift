//
//  SubscriptionDetailVC.swift
//  FamilyTime
//
//  Created by Sana Ullah on 24/01/2019.
//  Copyright © 2019 YumyApps. All rights reserved.
//

import UIKit
import StoreKit

class SubscriptionDetailVC: UIViewController {

    
    @IBOutlet weak var tableVu: UITableView!
    @IBOutlet weak var backVu: UIView!
    
    @IBOutlet weak var tableVuHeightConst: NSLayoutConstraint!
    
    @IBOutlet weak var groupImageVu:        UIImageView!
    @IBOutlet weak var groupNameLbl:        UILabel!
    @IBOutlet weak var groupDescLbl:        UILabel!
    @IBOutlet weak var selectedPlanLbl:     UILabel!
    @IBOutlet weak var pleaseUpgradeLbl:    UILabel!
    @IBOutlet weak var yourPlanLbl:         UILabel!
    
    @IBOutlet weak var upgradeBtn:          UIButton!
    
    
//    var selectedGroup       = IAP_Groups()
//    var productsArr         = [IAP_Products]()
//    var selectedProduct     = IAP_Products()
    
    var selectedColor = UIColor()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        initilaization()
    }
    
    
    //MARK: - CUSTOM METHODS
    
    func initilaization(){
        uiSetup()
//        MultilingualUtility.shared.lingualForIAPDetail(vc: self)
        
        var idsSet = Set<String>()
        
//        if let products = selectedGroup.group_products, products.count>0{
//            let groupProducts = products as! [IAP_Products]
//
//            for prod in groupProducts{
////                let iapProduct = prod as! IAP_Products
//                idsSet.insert(prod.apple_product_id)
//            }
//        }
        
//        for prod in selectedGroup.group_products{
//            let iapProduct = prod as! IAP_Products
//            idsSet.insert(iapProduct.apple_product_id)
//        }
        
        print("products IDS set = \(idsSet)")
        self.verifyProducts(prodIds: idsSet)
    }
    
    
    func verifyProducts(prodIds:Set<String>){
        SwiftFTUtils.showHUDAdded(to: self.view, withText: "", animated: true)
        IAPUtility.shared.getAllProducts(prodIds: prodIds) { (array) in
            SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
            
            self.mapStoreProductsIntoIAPProducts(arr: array)
//            self.productsArr = array
//            self.tableVu.reloadData()
        }
    }
    
    func mapStoreProductsIntoIAPProducts(arr : [SKProduct]){
        
        for storeProd in arr{
//            let prod = IAP_Products()
//
//            prod.prod_title         = storeProd.localizedTitle
//            prod.prod_description   = storeProd.localizedDescription //---DESCRIPTION---//
//
//            prod.prod_price         = storeProd.localizedPrice
//            prod.apple_product_id   = storeProd.productIdentifier
//            prod.is_default         = selectedProduct.apple_product_id == storeProd.productIdentifier ? true : false
//
//            self.productsArr.append(prod)
        }
        tableVu.reloadData()
    }
    
    func uiSetup(){
        
//        tableVuHeightConst.constant = CGFloat(SwiftTableVuConstants.kIAP_Detail_Cell_Height * selectedGroup.group_products.count)
        
//        selectedCheckImage = #imageLiteral(resourceName: "ic_check_green")
        
//        if selectedGroup.group_color == Colors.kTheme_red{
//            groupImageVu.image = #imageLiteral(resourceName: "ic_red")
//            selectedColor      = CommonModel.color(fromHexString: Colors.kTheme_red)
//
//            upgradeBtn.backgroundColor = CommonModel.color(fromHexString: Colors.kTheme_red)
//        }
//        else if selectedGroup.group_color == Colors.kTheme_green{
//            groupImageVu.image = #imageLiteral(resourceName: "ic_green")
//            selectedColor      = CommonModel.color(fromHexString: Colors.kTheme_green)
//            upgradeBtn.backgroundColor = CommonModel.color(fromHexString: Colors.kTheme_green)
//        }
//        else if selectedGroup.group_color == Colors.kTheme_orange{
//            groupImageVu.image = #imageLiteral(resourceName: "ic_orange")
//            selectedColor      = CommonModel.color(fromHexString: Colors.kTheme_yellow)
//            upgradeBtn.backgroundColor = CommonModel.color(fromHexString: Colors.kTheme_yellow)
//        }
//
//        groupNameLbl.text = selectedGroup.group_name
//        groupDescLbl.text = selectedGroup.group_description
        
        //---SERVER PRODUCTS REPLACED BY ITUNES PRODUCTS---//
        
//        let serverArr = selectedGroup.group_products as! [IAP_Products]
//        _ = serverArr.map{ if $0.is_default{selectedProduct = $0}} //---INITIALIZE DEFAULT PRODUCT---//
    }
    
    func selectProductAt(indexpath:IndexPath){
        //---DON'T RELOAD IF SELECTED---//
        
//        print("selected apple id = \(String(describing: selectedProduct.apple_product_id)) indexpath appleid = \(String(describing: productsArr[indexpath.row].apple_product_id))")
//
//        if selectedProduct.apple_product_id != productsArr[indexpath.row].apple_product_id{
//            for (index,_) in productsArr.enumerated(){
//                if index == indexpath.row{
//                    productsArr[index].is_default = true
//                    selectedProduct = productsArr[index]
//                }
//                else{
//                    productsArr[index].is_default = false
//                }
//            }
//            self.tableVu.reloadData()
//        }
    }//---END SELECT PRODUCT---//

    
    
    //MARK: - UI ACTIONS
    
    @IBAction func upgradeAction(_ sender: Any) {
//        print("selected prod id = \(String(describing: selectedProduct.apple_product_id)) and title = \(String(describing: selectedProduct.prod_title)) )")
//        IAPUtility.shared.autoRenewablePurchase(prodId: selectedProduct.apple_product_id ?? "", vc: self)
    }
    
}


extension SubscriptionDetailVC : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3 //productsArr.count //selectedGroup.group_products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
//        let imageVu  = cell?.viewWithTag(1) as! UIImageView
//        let nameLbl  = cell?.viewWithTag(2) as! UILabel
//        let descrLbl = cell?.viewWithTag(3) as! UILabel
//        let priceLbl = cell?.viewWithTag(4) as! UILabel
        
//        let product  = productsArr[indexPath.row]
        
        //---SERVER PRODUCTS REPLACED BY ITUNES PRODUCTS---//
        
//        imageVu.image = product.is_default ? #imageLiteral(resourceName: "ic_check_green") : #imageLiteral(resourceName: "ic_bullet_green")
        
        //---IN XCASSESTS RENDERING MODE SET TO ALWAYS_TEMPLATE---//
        //---THAT PICS ONLY IMAGE IGNORING COLOR---//
        //---NOW SET MANUALLY DESIRED TINT_COLOR---//
        
//        imageVu.tintColor = selectedColor
//
//        nameLbl.text  = product.prod_title
//        priceLbl.text = product.prod_price
//        descrLbl.text = product.prod_description
//        nameLbl.font  = product.is_default ? UIFont(name: "OpenSans-Semibold", size: 16.0) : UIFont(name: "OpenSans-Regular", size: 14.0)
        
        
        
        //---STOREKIT PRODUCTS IMPLEMENTATION---//
//        nameLbl.text  = product.localizedTitle
//        priceLbl.text = product.localizedPrice
        
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectProductAt(indexpath: indexPath)
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(SwiftTableVuConstants.kIAP_Detail_Cell_Height)
    }
}
