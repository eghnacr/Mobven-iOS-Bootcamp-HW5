//
//  KeychainManager.swift
//  UIComponents
//
//  Created by Semih Emre ÜNLÜ on 16.01.2022.
//

import Foundation
import Security

enum KeychainManagerError: Error {
    case encoding
    case write
}

//class KeychainManager {
//    private let serverAttribute = Bundle.main.bundleIdentifier
//
//    func save(key: String, value: String) -> KeychainManagerError {
//        guard let data = value.data(using: .utf8) else {
//            return .encoding
//        }
//
//        let query = [
//            kSecValueData : data,
//            kSecAttrAccount : key,
//            kSecAttrServer : serverAttribute,
//            kSecClass : kSecClassInternetPassword
//        ] as CFDictionary
//
//        let status = SecItemAdd(query, nil)
//
//        if status == .noErr {
//            return .success
//        } else {
//            return .write
//        }
//
//    }
//}
