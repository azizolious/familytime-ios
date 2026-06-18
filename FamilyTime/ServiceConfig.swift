////
////  ServiceConfig.swift
////  FamilyTime
////
////  Created by Rizwan-Apps on 06/02/2023.
////  Copyright © 2023 YumyApps. All rights reserved.
////
//
//import Foundation
//enum BASE_URL_LOCAL: String {
//    case LOCAL_MESH = "https://mesh2.familytime.io/"
//    case LOCAL_CORE = "https://core2.familytime.io/"
//}
//
//enum BASE_URL_STAGGING: String {
//    case STAGGING_CORE = "https://stgcore2.familytime.io/"
//    case STAGGING_MESH = "https://meshstg.familytime.io/"
//}
//
//@objc class ServiceConfig: NSObject {
//    @objc static let share: ServiceConfig = ServiceConfig()
//    var baseUrlMesh2 : String?
//    var baseUrlCore2 : String?
//    @objc func setupConfig(){
//#if PROD
//        self.baseUrlCore2 = BASE_URL_LOCAL.LOCAL_CORE.rawValue
//        self.baseUrlMesh2 = BASE_URL_LOCAL.LOCAL_MESH.rawValue
//#elseif STAGGING
//        self.baseUrlCore2 = BASE_URL_STAGGING.STAGGING_CORE.rawValue
//        self.baseUrlMesh2 = BASE_URL_STAGGING.STAGGING_MESH.rawValue
//#endif
//    }
//}
