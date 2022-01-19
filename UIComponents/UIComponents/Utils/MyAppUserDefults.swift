//
//  MyAppUserDefults.swift
//  UIComponents
//
//  Created by Semih Emre ÜNLÜ on 16.01.2022.
//

import Foundation

fileprivate enum MyAppUserDefultKeys: String {
    case hasUserLaunchedApp
}

protocol LocalDataProtocol {
    var hasUserLaunchedApp: Bool { get set }
}

class MyAppUserDefults: LocalDataProtocol {
    var hasUserLaunchedApp: Bool {
        get {
            return UserDefaults.standard.bool(forKey: MyAppUserDefultKeys.hasUserLaunchedApp.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: MyAppUserDefultKeys.hasUserLaunchedApp.rawValue)
        }
    }
}
