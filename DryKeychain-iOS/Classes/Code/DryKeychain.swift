//
//  DryKeychain.swift
//  DryKeychain-iOS
//
//  Created by Ruiying Duan on 2019/8/31.
//

import UIKit
import Security

//MARK: - 钥匙串操作
public class DryKeychain: NSObject {
    
    /// @说明 创建默认的描述字典
    /// @参数 key:    写入的键
    /// @返回 NSMutableDictionary
    @discardableResult
    private static func defaultKeychainItem(withKey key: String) -> NSMutableDictionary {
        
        let keychainItem: NSMutableDictionary = NSMutableDictionary()
        keychainItem.setValue(kSecClassGenericPassword as String, forKey: kSecClass as String)
        keychainItem.setValue(kSecAttrAccessibleAfterFirstUnlock as String, forKey: kSecAttrAccessible as String)
        keychainItem.setValue(key, forKey: kSecAttrService as String)
        keychainItem.setValue(key, forKey: kSecAttrAccount as String)
        
        return keychainItem
    }
    
    /// @说明 写入keychain
    /// @参数 key:    写入的键
    /// @参数 value:  写入的值
    /// @返回 void
    public static func write(withKey key: String, value: String) {
        
        /// 存在则删除
        let keychainItem: NSMutableDictionary = DryKeychain.defaultKeychainItem(withKey: key)
        if SecItemCopyMatching(keychainItem, nil) == noErr {
            SecItemDelete(keychainItem)
        }
        
        /// 创建
        let dataFromString = value.data(using: String.Encoding.utf8, allowLossyConversion: true)
        keychainItem.setValue(dataFromString, forKey: kSecValueData as String)
        SecItemAdd(keychainItem, nil)
    }
    
    /// @说明 读取keychain
    /// @参数 key:    读取的键
    /// @返回 Sting?s
    @discardableResult
    public static func read(withKey key: String) -> String? {
        
        let keychainItem: NSMutableDictionary = DryKeychain.defaultKeychainItem(withKey: key)
        keychainItem.setValue(kCFBooleanTrue, forKey: kSecReturnData as String)
        keychainItem.setValue(kSecMatchLimitOne as String, forKey: kSecMatchLimit as String)
        var dataTypeRef :AnyObject?
        if SecItemCopyMatching(keychainItem, &dataTypeRef) == errSecSuccess {
            
            if let data = dataTypeRef as? Data {
                
                if let value = String(data: data, encoding: String.Encoding.utf8) {
                    return value
                }
            }
        }
        
        return nil
    }
    
    /// @说明 删除keychain
    /// @参数 key:    删除的键
    /// @返回 void
    public static func delete(withKey key: String) {
        
        /// 存在则删除
        let keychainItem: NSMutableDictionary = DryKeychain.defaultKeychainItem(withKey: key)
        if SecItemCopyMatching(keychainItem, nil) == noErr {
            SecItemDelete(keychainItem)
        }
    }
}
