//
//  YoutubeHistroyVC.swift
//  FamilyTime
//
//  Created by Sufyan on 27/11/2023.
//  Copyright © 2023 YumyApps. All rights reserved.
//

import UIKit

class YoutubeHistroyVC: UIViewController {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var tableVu: UITableView!
    //MARK: - ViewModel
    var vm = YoutubeHistoryVM()
    //MARK: - Ooops no record to show view
    private lazy var emptyStateView: EmptyVu = {
            let view = Bundle.main.loadNibNamed("EmptyVu", owner: self, options: nil)?.first as! EmptyVu
            return view
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        tbleReloader()
        titleLbl.text = vm.isFrom == .youtube ? "yt_history".localized : vm.isFrom == .tiktok ? "tiktok_history".localized : "settings_card_1_android_7".localized
        vm.initMethod()
    }

    private func setTableView() {
        tableVu.delegate = self
        tableVu.dataSource = self
        tableVu.register(UINib(nibName: "DateSegmentTblCell", bundle: nil), forCellReuseIdentifier: "DateSegmentTblCell")
        tableVu.register(UINib(nibName: "YoutubeSummaryCell", bundle: nil), forCellReuseIdentifier: "YoutubeSummaryCell")
        tableVu.register(UINib(nibName: "YTHistoryCell", bundle: nil), forCellReuseIdentifier: "YTHistoryCell")
    }
    private func tbleReloader() {
        vm.tbleReloader = { [weak self] in
            self?.tableVu.reloadData()
        }
    }
    
    @IBAction func refreshTapped(_ sender: UIButton) {
        SwiftFTUtils.showHUDAdded(to: self.view, withText: "", animated: true)
        vm.callApiToReloadHistory { [weak self] in
            DispatchQueue.main.async {
                SwiftFTUtils.hideHUDAdded(to: self?.view, animated: true)
                self?.vm.selectedSgment = .day
                self?.vm.currentDate = Date()
                self?.vm.currentIndex = 0
                self?.vm.initMethod()
            }
        }
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    //MARK: - Previous button in cell for date change to previous
    @objc func previosBtnSelected() {
        vm.buttonSelected = -1
        vm.currentIndex -= 1
        vm.callMethodsBySegments()
    }
    
    //MARK: - Play button in cell for redirect to Safari
    @objc func playBtnTapped(_ sender: UIButton) {
        let index = sender.tag
        print(index)
        if vm.isFrom == .youtube {
            let youtubeData = vm.youtubeHistoryArr[index]
            let escapedYoutubeQuery = youtubeData.url?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            var youtubeUrl = NSURL(string: "youtube://www.youtube.com/results?search_query=\(escapedYoutubeQuery ?? "")")!
            if UIApplication.shared.canOpenURL(youtubeUrl as URL){
                UIApplication.shared.open(youtubeUrl as URL)
            } else {
                youtubeUrl = NSURL(string: "youtube://www.youtube.com/results?search_query=\(escapedYoutubeQuery ?? "")")!
                UIApplication.shared.open(youtubeUrl as URL)
            }
        }else if vm.isFrom == .tiktok {
            let urlStr = vm.youtubeHistoryArr[index].title ?? ""
            let modifiedUrl = urlStr.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            if let tikTokUrl = URL(string: "https://www.tiktok.com/search/user?q=\(modifiedUrl ?? "")") {
                UIApplication.shared.open(tikTokUrl, options: [:], completionHandler: nil)
            } else {
                print("Invalid TikTok URL.")
            }
        } else {
            var ur = vm.webHistoryArr[index].url ?? ""
            ur = ur.replacingOccurrences(of: "\u{200e}", with: "")
            if let webUrl = URL(string: ur) {
                UIApplication.shared.open(webUrl, options: [:], completionHandler: nil)
            } else {
                print("Invalid web URL.")
            }
        }
    }
    
    //MARK: - Next button in cell for date change to next
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
   
}
//MARK: - Handle TableView
extension YoutubeHistroyVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if vm.isFrom == .web {
            if vm.webHistoryArr.count == 0 {
                emptyStateView.frame = tableView.bounds
                tableVu.backgroundView = emptyStateView
                return 1
            } else {
                tableVu.backgroundView = nil
                return 3
            }
        }else {
            if vm.youtubeHistoryArr.count == 0 {
                emptyStateView.frame = tableView.bounds
                tableVu.backgroundView = emptyStateView
                return 1
            } else {
                tableVu.backgroundView = nil
                return 3
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return vm.isFrom == .web ? vm.webHistoryArr.count : vm.youtubeHistoryArr.count
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "YoutubeSummaryCell") as! YoutubeSummaryCell
            cell.videoWatchCountLbl.text = vm.isFrom == .web ? "\(vm.webHistoryArr.count)" : "\(vm.youtubeHistoryArr.count)"
            cell.videoWatchCountLbl.textColor = UIColor(hexString: vm.isFrom == .youtube ? "#12C5A4" : "#7333E3")
            cell.img.image = UIImage(named: vm.isFrom == .youtube ? "videoCount" : "tiktokico")
            if vm.isFrom == .web {
                cell.titleLbl.text = "Total Site Visits"
            }
            cell.vu.backgroundColor = UIColor(hexString: vm.isFrom == .youtube ? "#DBF6F1" : "#EAE0FB")
            cell.selectionStyle = .none
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "YTHistoryCell") as! YTHistoryCell
            switch vm.isFrom {
            case .youtube:
                cell.titleLbl.text = vm.youtubeHistoryArr[indexPath.row].url
                cell.img.image = UIImage(named: "yControl")
                let shortTimeString = vm.convertToShortTimeString(vm.youtubeHistoryArr[indexPath.row].timeVisit ?? "2023-12-05 12:28:15", dateFormat: "yyyy-MM-dd HH:mm:ss", timeFormat: "h:mm a")
                cell.descLbl.text = shortTimeString
                break
            case.tiktok:
                cell.titleLbl.text = vm.youtubeHistoryArr[indexPath.row].title
                cell.img.image = UIImage(named: "tiktokhistory")
                let shortTimeString = vm.convertToShortTimeString(vm.youtubeHistoryArr[indexPath.row].timeVisit ?? "2023-12-05 12:28:15", dateFormat: "yyyy-MM-dd HH:mm:ss", timeFormat: "h:mm a")
                cell.descLbl.text = shortTimeString
                break
            case .web:
                cell.titleLbl.text = vm.webHistoryArr[indexPath.row].url
                cell.img.image = UIImage(named: "webIcon")
                let shortTimeStr = vm.convertToShortTimeString(vm.webHistoryArr[indexPath.row].timeVisit ?? "2023-12-05 12:28:15", dateFormat: "yyyy-MM-dd HH:mm:ss", timeFormat: "h:mm a")
                cell.descLbl.text = shortTimeStr
                cell.playBtn.setImage(UIImage(named: "redirect"), for: .normal)
                break
            }
            cell.playBtn.tag = indexPath.row
            cell.playBtn.addTarget(self, action: #selector(playBtnTapped(_:)), for: .touchUpInside)
            cell.selectionStyle = .none
            return cell
        default:
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 2 {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: section == 2 ? 30 : 0))
            let lbl = UILabel(frame: CGRect(x: 0, y: -10, width: 300, height: section == 2 ? 30 : 0))
            lbl.font = UIFont(name: "SFProDisplay-Semibold", size: 18)
            lbl.text = "history".localized
            view.backgroundColor = .clear
            lbl.backgroundColor = .clear
            view.addSubview(lbl)
            return view
        } else {
            return UIView()
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 2 {
            return 30
        } else  {
            return 2
        }
    }
}
