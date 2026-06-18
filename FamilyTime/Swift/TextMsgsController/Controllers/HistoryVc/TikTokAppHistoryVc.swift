//
//  TikTokAppHistoryVc.swift
//  FamilyTime
//
//  Created by Rizwan-Apps on 05/12/2022.
//  Copyright © 2022 YumyApps. All rights reserved.
//

import UIKit
import DropDown
import CoreData

class TikTokAppHistoryVc: UIViewController {
    
    //MARK: OUTLETS
    @IBOutlet weak var tikTokTblView: UITableView!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var dateTf: UITextField!
    @IBOutlet weak var dateSlctBtn: UIButton!
    @IBOutlet weak var titleTextLbl: UILabel!
    @IBOutlet weak var currentDataLbl: UILabel!
    
    //MARK: VARIABLES
    var historyArr = [AppHistortDataModel]()
    var youtubeHistoryArr = [youtubeData]()
    var historyType = ""
    var numData: Int = 1
    var dropDown = DropDown()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        let date = Date()
        currentDataLbl.text = date.monthName()
        loadApiData(num: 1)
        dropDownSetup()
        dateTf.text = "date_drop_down_1".localized
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tikTokTblView.separatorColor = .clear
    }
    
    //MARK: ACTIONS
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    @IBAction func dateSlctBtn(_ sender: Any) {
        dropDown.show()
    }
    
    //MARK: - Helper Functions
    func loadApiData(num: Int){
        let child_ID = UserDefaults.standard.integer(forKey: UserDefaultsConstants.SELECTED_CHILD_ID)
        print(child_ID)
        
        if historyType == "WEB"{
            self.titleTextLbl.text = "settings_card_1_android_7".localized
            historyArr.removeAll()
            print(historyArr.count)
            let arr = CoreDataUtility.fetchHistoryData()
            for i in arr{
                let last7Days = Date.getDates(forLastNDays: num)
                for date in last7Days{
                    let dbDate_Str = i.timeVisit
                    let dbDateTrimValue = dbDate_Str?.dropLast(9)
                    print(dbDateTrimValue, dbDate_Str?.dropLast(9))
                    if dbDateTrimValue ?? "" == date{
                        if child_ID == i.childID{
                            self.historyArr.append(i)
                            DispatchQueue.main.async {
                                self.tikTokTblView.reloadData()
                            }
                        }
                    }else{
                        self.tikTokTblView.reloadData()
                    }
                }
            }
        }else if historyType == "YOUTUBE"{
            self.titleTextLbl.text = "youtube_controls".localized
            youtubeHistoryArr.removeAll()
            let arr = CoreDataUtility.fetchYoutubeData()
            for i in arr{
                let last7Days = Date.getDates(forLastNDays: num)
                for date in last7Days{
                    let dbDate_Str = i.timeVisit
                    let dbDateTrimValue = dbDate_Str?.dropLast(9) ?? ""
                    if dbDateTrimValue == date{
                        print(i.childID)
                        if child_ID == i.childID{
                            print(i.childID)
                            self.youtubeHistoryArr.append(i)
                            DispatchQueue.main.async {
                                self.tikTokTblView.reloadData()
                            }
                        }
                    }else{
                        self.tikTokTblView.reloadData()
                    }
                }
            }
        }else if historyType == "TIKTOK"{
            titleTextLbl.text = "tiktok_history".localized
            youtubeHistoryArr.removeAll()
            let arr = CoreDataUtility.fetchTiktokData()
            for i in arr{
                let last7Days = Date.getDates(forLastNDays: num)
                for date in last7Days{
                    let dbDate_Str = i.timeVisit
                    let dbDateTrimValue = dbDate_Str?.dropLast(9) ?? ""
                    print(dbDateTrimValue, dbDate_Str)
                    if dbDateTrimValue == date{
                        if child_ID == i.childID{
                            self.youtubeHistoryArr.append(i)
                            DispatchQueue.main.async {
                                self.tikTokTblView.reloadData()
                            }
                        }
                    }else{
                        self.tikTokTblView.reloadData()
                    }
                }
            }
        }
    }
    
    func dropDownSetup(){
        if UIView.appearance().semanticContentAttribute == .forceLeftToRight {
            dropDown.anchorView = dateView
        } else {
            dropDown.anchorView = dateView
        }
        
        dropDown.dataSource = ["date_drop_down_1".localized, "date_drop_down_3".localized, "date_drop_down_5".localized]
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.dateTf.text = item.localized
            if item == "Today"{
                loadApiData(num: 1)
            }else if item == "Last 7 Days"{
                loadApiData(num: 7)
            }else if item == "Last 30 Days"{
                loadApiData(num: 30)
            }
        }
    }
}

//MARK: -  DELEGATES AND DATA SOURCES FUNCTIONS
extension TikTokAppHistoryVc: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if historyType == "WEB"{
            if historyArr.count == 0{
                self.tikTokTblView.setEmptyMessage("no_data_selected_date".localized)
            }else{
                self.tikTokTblView.setEmptyMessage("")
                return historyArr.count
            }
            
        }else if historyType == "YOUTUBE"{
            if youtubeHistoryArr.count == 0{
                self.tikTokTblView.setEmptyMessage("no_data_selected_date".localized)
            }else{
                self.tikTokTblView.setEmptyMessage("")
                return youtubeHistoryArr.count
            }
        }else if historyType == "TIKTOK"{
            if youtubeHistoryArr.count == 0{
                self.tikTokTblView.setEmptyMessage("NO DATA FOR SELECTED DATE")
            }else{
                self.tikTokTblView.setEmptyMessage("")
                return youtubeHistoryArr.count
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TikTokCell") as! TikTokCell
        if historyType == "WEB"{
            let data = historyArr[indexPath.row]
            cell.videoNameLbl.text = data.url
            cell.imgView.image = UIImage(named: "web_history")
            let dateString = data.timeVisit
//            let dateFinalString = String(dateString?.suffix(8))
//            cell.videoDetailLbl.text = String(dateFinalString.dropLast(3))
        }else  if historyType == "YOUTUBE"{
            let data = youtubeHistoryArr[indexPath.row]
            cell.videoNameLbl.text = data.url
            cell.imgView.image = UIImage(named: "youtubeIcon")
            let dateString = data.timeVisit
//            let dateFinalString = String(dateString?.suffix(8))
//            cell.videoDetailLbl.text = String(dateFinalString.dropLast(3))
        }else if historyType == "TIKTOK"{
            let data = youtubeHistoryArr[indexPath.row]
            cell.videoNameLbl.text = data.url
            cell.imgView.image = UIImage(named: "Tiktok_history")
            let dateString = data.timeVisit
//            let dateFinalString = String(dateString?.suffix(8))
//            cell.videoDetailLbl.text = String(dateFinalString.dropLast(3))
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if historyType == "WEB" {
            let data = historyArr[indexPath.row]
            let storyboard = UIStoryboard(name: StoryboardConstants.Storyboards.DASHBOARD, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: StoryboardConstants.Identifiers.HISTORY_BROWSER_VC) as! HistoryBrowserVc
            vc.strUrl = data.url
            self.present(vc, animated: false, completion: nil)
        } else if historyType == "YOUTUBE" {
            let youtubeData = youtubeHistoryArr[indexPath.row]
            let escapedYoutubeQuery = youtubeData.url?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            var youtubeUrl = NSURL(string: "youtube://www.youtube.com/results?search_query=\(escapedYoutubeQuery ?? "")")!
            if UIApplication.shared.canOpenURL(youtubeUrl as URL){
                UIApplication.shared.open(youtubeUrl as URL)
            } else {
                youtubeUrl = NSURL(string: "youtube://www.youtube.com/results?search_query=\(escapedYoutubeQuery ?? "")")!
                UIApplication.shared.open(youtubeUrl as URL)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

//MARK: - Date Extensions
extension Date {
    static func getDates(forLastNDays nDays: Int) -> [String] {
        var today = Date()
        var dateArray = [String]()
        for i in 1...nDays{
            print(i)
            let tomorrow = Calendar.current.date(byAdding: .day, value: -1, to: today)
            let date = DateFormatter()
            date.dateFormat = "yyyy-MM-dd"
            let stringDate : String = date.string(from: today)
            today = tomorrow ?? Date()
            dateArray.append(stringDate)
        }
        return dateArray
    }
}

extension Date {
    func monthName() -> String {
        let df = DateFormatter()
        df.setLocalizedDateFormatFromTemplate("MMMM yyyy")
        return df.string(from: self)
    }
}
