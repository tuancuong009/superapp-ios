//
//  ManagarError.swift
//  KLNDemo
//
//  Created by QTS_001 on 4/10/18.
//  Copyright © 2018 QTS_001. All rights reserved.
//


import UIKit
import Alamofire

class ErrorManager {
    static func processError(error: AFError? = nil, errorCode: Int? = nil, errorMsg: String? = nil) -> ErrorModel {
        var errorModel: ErrorModel?
        if error == nil {
            errorModel = ErrorModel.error(errorCode: errorCode ?? 99999, errorMessage: errorMsg)
        } else {
            errorModel = ErrorModel.error(error: error!)
        }
        return errorModel!
    }
}

class ErrorModel {
    
    var title: String?
    var code: Int?
    var msg: String?
    static func error(error: AFError) -> ErrorModel {
        
        let code = error._code
        let message = error.localizedDescription
        let title = "CircleCue"
        return ErrorModel(title: title, code: code, msg: message)
    }
    
    /// For custom error
    static func error(errorCode: Int, errorMessage: String?) -> ErrorModel {
        
        let errorModel: ErrorModel?
        
        // For all errors from server
        errorModel = ErrorModel(title: nil, code: errorCode, msg: errorMessage ?? "Something went wrong.")
        
        return errorModel!
        
    }
    
    init(title: String?, code: Int?, msg: String? ) {
        self.title = title
        self.code = code
        self.msg = msg
    }
}
