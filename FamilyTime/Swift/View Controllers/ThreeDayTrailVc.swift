//
//  ThreeDayTrailVc.swift
//  FamilyTime
//
//  Created by Rizwan-Apps on 25/11/2022.
//  Copyright © 2022 YumyApps. All rights reserved.
//

import UIKit



class ThreeDayTrailVc: UIViewController, UIPageViewControllerDelegate {
    
    //MARK: OUTLETS
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var ipadViews: UIView!
    
    //MARK: -  VARIABLES
    var index = 0
    var currentPage = 0
    private var collectionViewFlowLayout : UICollectionViewFlowLayout!
    
    //MARK: - View LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            ipadViews.isHidden = true
            containerView.isHidden = false
        case .pad:
            ipadViews.isHidden = false
            containerView.isHidden = true
         @unknown default:
            print("IPAD")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        startBtn.layer.cornerRadius = 10.0
        startBtn.clipsToBounds = true
    }
    
    //MARK: -  ACTION
    @IBAction func dismissBtn(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: UserDefaultsConstants.DISMISS_TRIAL_SCREEN)
        UserDefaults.standard.synchronize()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func startBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: StoryboardConstants.Storyboards.DASHBOARD, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: StoryboardConstants.Identifiers.PREMIUM_PACKAGE_VC_IDENTIFIER) as! PremiumPackageVC
        vc.isComingFromTrialScreen = true
        let transition = CATransition()
        transition.duration = 0.6
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.moveIn
        transition.subtype = CATransitionSubtype.fromTop
        self.navigationController?.view.layer.add(transition, forKey: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
