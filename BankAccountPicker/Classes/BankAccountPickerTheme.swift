//
//  BillPickerTheme.swift
//  firstpod
//
//  Created by Sherzod Khashimov on 6/5/19.
//

import UIKit

/// Picker Theme can be used to change picker colors.
public protocol BankAccountPickerTheme {
    var backgroundColor: UIColor { get }
    var seporatorColor: UIColor { get }
    var selectedBankAccountBackgroundColor: UIColor { get }
    var balancePositiveColor: UIColor { get }
    var balanceNegativeColor: UIColor { get }

    var pickerNameTextColor: UIColor { get }
    var pickerDescriptionTextColor: UIColor { get }
    var bankAccountNameTextColor: UIColor { get }
    var bankAccountTextColor: UIColor { get }
}

/// Default Picker Theme.
public struct DefaultBankAccountPickerTheme: BankAccountPickerTheme {

    public init() { }

    public var backgroundColor: UIColor {
        return UIColor.white
    }
    public var seporatorColor: UIColor {
        return UIColor.init(red: 243/255, green: 243/255, blue: 245/255, alpha: 1)
    }
    public var selectedBankAccountBackgroundColor: UIColor {
        return UIColor.init(red: 246/255, green: 248/255, blue: 249/255, alpha: 1)
    }

    
    public var balancePositiveColor: UIColor {
        return UIColor.init(red: 64/255, green: 196/255, blue: 100/255, alpha: 1)
    }
    public var balanceNegativeColor: UIColor {
        return UIColor.init(red: 236/255, green: 104/255, blue: 104/255, alpha: 1)
    }


    public var pickerNameTextColor: UIColor {
        return UIColor.black
    }
    public var pickerDescriptionTextColor: UIColor {
        return UIColor.init(red: 180/255, green: 182/255, blue: 196/255, alpha: 1)
    }
    public var bankAccountNameTextColor: UIColor {
        return UIColor.black
    }
    public var bankAccountTextColor: UIColor {
        return UIColor.init(red: 180/255, green: 182/255, blue: 196/255, alpha: 1)
    }
}
