//
//  SwiftTimeZonesViewController.swift
//  FamilyTime
//
//  Created by YumyApps on 08/11/2021.
//  Copyright © 2021 YumyApps. All rights reserved.
//

import UIKit

protocol SwiftTimeZonesViewControllerDelegate {
    func didTimeZoneChanged(to selectedIndex: Int)
}

class SwiftTimeZonesViewController: UITableViewController {
    
    //MARK: - VARIABLES
    var selectedIndex = 0
    var timezones = [AnyHashable]()
    var controllerDelegate: SwiftTimeZonesViewControllerDelegate?
    var isFromPopup = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Child Timezone".localized

        if isFromPopup {
            if IS_IPHONE_4() {
                view.frame = CGRect(x: 0.0, y: 0.0, width: 270.0, height: 420.0)
            } else if IS_IPHONE_5() {
                view.frame = CGRect(x: 0.0, y: 0.0, width: 270.0, height: 420.0)
            } else if IS_IPHONE_6() {
                view.frame = CGRect(x: 0.0, y: 0.0, width: 317.0, height: 450.0)
            } else if IS_IPHONE_6_PLUS() {
                view.frame = CGRect(x: 0.0, y: 0.0, width: 350.0, height: 500.0)
            } else if IS_IPHONE_X() {
                view.frame = CGRect(x: 0.0, y: 0.0, width: 350.0, height: 500.0)
            } else {
                view.frame = CGRect(x: 0.0, y: 0.0, width: 525.0, height: 715.0)
            }
        }
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDone(_:)))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handlecancel(_:)))
        
        if isFromPopup {
            view.backgroundColor = UIColor.white
            tableView.backgroundColor = UIColor.white
        } else {
            view.backgroundColor = RGBCOLOR(172, 206, 58, 1)
            tableView.backgroundColor = RGBCOLOR(172, 206, 58, 1)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.scrollToRow(at: IndexPath(row: selectedIndex, section: 0), at: .middle, animated: true)
    }
    
    @objc func handleDone(_ sender: Any?) {
        dismiss(animated: true) { [self] in
            controllerDelegate?.didTimeZoneChanged(to: selectedIndex)
        }
    }
    
    @objc func handlecancel(_ sender: Any?) {
        dismiss(animated: true)
    }
    
    func setupUI() {
        
        if IS_IPHONE_4() {
            tableView.rowHeight = 37.0
        } else if IS_IPHONE_5() {
            tableView.rowHeight = 37.0
        } else if IS_IPHONE_6() {
            tableView.rowHeight = 43.0
        } else if IS_IPHONE_6_PLUS() {
            tableView.rowHeight = 47.0
        } else if IS_IPHONE_X() {
            tableView.rowHeight = 47.0
        } else {
            tableView.rowHeight = 68.0
        }

        tableView.tintColor = UIColor.white
        tableView.separatorStyle = .none
    }
    
//MARK: - TableView data Sourse and Delegate
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timezones.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "FILTER_CELL")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "FILTER_CELL")
        }
        cell?.backgroundColor = UIColor.clear
        cell?.contentView.backgroundColor = UIColor.clear
        
        if isFromPopup {
            cell?.textLabel?.textColor = RGBCOLOR(83, 83, 83, 1)
        } else {
            cell?.textLabel?.textColor = UIColor.white
        }
        let tz = timezones[indexPath.row] as! GMTTimezone
        cell?.textLabel?.text = tz.strRep
        
        if isFromPopup {
            if selectedIndex == indexPath.row {
                cell?.backgroundColor = RGBCOLOR(22, 151, 191, 1)
                cell?.contentView.backgroundColor = RGBCOLOR(22, 151, 191, 1)
                cell?.textLabel?.textColor = UIColor.white
            } else {
                cell?.backgroundColor = UIColor.clear
                cell?.contentView.backgroundColor = UIColor.clear
                cell?.textLabel?.textColor = RGBCOLOR(83, 83, 83, 1)
            }
            
        } else {
            
            if selectedIndex == indexPath.row {
                cell?.accessoryType = .checkmark
            } else {
                cell?.accessoryType = .none
            }
        }
        
        if IS_IPHONE_4() {
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 15)
        } else if IS_IPHONE_5() {
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 15)
        } else if IS_IPHONE_6() {
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 16)
        } else if IS_IPHONE_6_PLUS() {
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 17)
        } else if IS_IPHONE_X() {
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 17)
        } else {
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 19)
        }
        
        cell?.tintColor = UIColor.white
        cell?.selectionStyle = .none
        return cell ?? UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedIndex = indexPath.row
        tableView.reloadSections(NSIndexSet(index: 0) as IndexSet, with: .fade)
    }
}

class SwiftGMTTimezone: NSObject {
    var gmtDiff = 0
    var strRep: String?
    var name: String?
}
