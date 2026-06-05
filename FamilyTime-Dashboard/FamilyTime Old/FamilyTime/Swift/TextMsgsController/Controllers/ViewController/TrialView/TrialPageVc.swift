//
//  TrialPageVc.swift
//  FamilyTime
//
//  Created by Rizwan-Apps on 29/11/2022.
//  Copyright © 2022 YumyApps. All rights reserved.
//

import UIKit

class TrialPageVc: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    lazy var subViewControllers: [UIViewController] = {
        return [
            UIStoryboard(name: "MyStoryboard", bundle: nil).instantiateViewController(withIdentifier: "TrialFirstvc") as! TrialFirstvc,
            UIStoryboard(name: "MyStoryboard", bundle: nil).instantiateViewController(withIdentifier: "TrialSecondVc") as! TrialSecondVc
        ]
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
        self.dataSource = self
        setViewControllers([subViewControllers[0]], direction: .forward, animated: true, completion: nil)
        // Do any additional setup after loading the view.
    }
    required init?(coder: NSCoder) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return subViewControllers.count
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentIndex: Int = subViewControllers.index(of: viewController) ?? 0
        if (currentIndex <= 0){
            return nil
        }
        
        print("Phla VC\(currentIndex)")
        return subViewControllers[currentIndex - 1]
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentIndex: Int = subViewControllers.index(of: viewController) ?? 0
        if (currentIndex >= subViewControllers.count - 1){
            return nil
        }
        print("dosra VC\(currentIndex)")
        return subViewControllers[currentIndex + 1]
    }
}
