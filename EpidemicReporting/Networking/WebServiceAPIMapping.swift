//
//  WebServiceAPIMapping.swift
//  EpidemicReporting
//
//  Created by eleven on 2017/11/9.
//  Copyright © 2017年 epidemicreporting.com. All rights reserved.
//

import Foundation

enum WebServiceAPIMapping: String {
    
    //login
    case UserRegistraion   = "/api/users/register/"
    case UserLogin         = "/api/auth/login"
    case PasswordChange    = "/api/password/change"
    case GetProfile        = "/api/profile/get"
    
    //upload media
    case UploadMedia       = "/api/media/upload"
    
    //report
    case DutyReport        = "/api/duty/report"
    case DutyProcess       = "/api/duty/process"
    case DutyConfirm       = "/api/duty/confirm"
    case DutyLatestStatus  = "/api/duty/status/latest"
    case DutyAllReports    = "/api/duty/status/latestall"
    case DutyAllStatus     = "/api/duty/status"
    
    //admin
    case DutyAssign        = "/api/duty/assign"
    case GetStuff          = "/api/duty/getstuff"
    case GetStuffOwns      = "/api/duty/getstuffowns/get"
}
