//
//  BillPickerItem.swift
//  BankAccountPicker
//
//  Created by Sherzod Khashimov on 7/5/18.
//

/// Bank Account Picker Item Model.
public struct BankAccountPickerItem {
    public var accountName: String?
    public var account: String?
    public var balance: Double?
    public var currency: String?
    public var isSelected: Bool

    public init(accountName: String?, account: String?, balance: Double?, currency: String?, isSelected: Bool = false) {
        self.accountName = accountName
        self.account = account
        self.balance = balance
        self.currency = currency
        self.isSelected = isSelected
    }
}
