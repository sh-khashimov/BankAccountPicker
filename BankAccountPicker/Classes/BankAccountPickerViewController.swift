//
//  BillPickerViewController.swift
//  BankAccountPicker
//
//  Created by Sherzod Khashimov on 7/4/18.
//

import UIKit

/// Bank Account Picker View Controller could be initialized and shown as a modal controller.
public class BankAccountPickerViewController: UIViewController {

    // MARK: - Dimensions
    enum Dimension {
        static var width: CGFloat {
            return (UIScreen.main.bounds.width <= 414.0) ? (UIScreen.main.bounds.width - 60) : 280
        }
        static let wrapperContentBottomOffset: CGFloat = 50
        static let wrapperContentHeight: CGFloat = BankAccountPickerViewController.Dimension.wrapperContentBottomOffset + UIScreen.main.bounds.height / 2
        static let actionButtonHeight: CGFloat = 52
        static let wrapperViewCornerRadius: CGFloat = 18
    }

    // MARK: - Private Properties
    private var theme: BankAccountPickerTheme = DefaultBankAccountPickerTheme()

    private static let tableViewCellBillIdentifier = "BankAccountPickerTableViewCell"
    private static let tableViewHeaderIdentifier = "BankAccountPickerHeaderTableViewCell"

    private var bankAccounts: [BankAccountPickerItem] = [BankAccountPickerItem]()
    private var pickerName: String = ""
    private var pickerDescription: String = ""

    /// If bankAccounts has at least one selected items, the different layout could be applied.
    private var hasSelectedItem: Bool = false

    /// Show or Dismiss Picker View Controller.
    private var isOpen: Bool? {
        didSet {
            if oldValue != isOpen {
                self.view.setNeedsUpdateConstraints()
//                self.view.setNeedsLayout()
                let duration = isOpen ?? true ? 1 : 0.5
                if #available(iOS 10.0, *) {
                    let layoutAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 0.7) {
                        //animation block
                        self.view.layoutIfNeeded()
                    }
                    layoutAnimator.addCompletion { [weak self] _ in
                        if let isOpen = self?.isOpen, !isOpen {
                            self?.dismiss(animated: false, completion: nil)
                        }
                    }
                    layoutAnimator.startAnimation()
                } else {
                    // Fallback on earlier versions
                    UIView.animate(withDuration: 0.3, animations: {
                        self.view.layoutIfNeeded()
                    }) { (success) in
                        if let isOpen = self.isOpen, !isOpen {
                            self.dismiss(animated: false, completion: nil)
                        }
                    }
                }
            }
        }
    }

    private var wrapperViewHeight: NSLayoutConstraint?
    private var wrapperViewBottomAnchor: NSLayoutConstraint?


    // MARK: - Open Properties
    /// Callback used when Item is selected
    public var selection: ((_ selectedItem: BankAccountPickerItem, _ selectedIndex: Int) -> Void)?

    // MARK: - Views
    lazy private var wrapperView: UIView = {
        let wrapperView = UIView(frame: CGRect.zero)
        wrapperView.translatesAutoresizingMaskIntoConstraints = false
        wrapperView.backgroundColor = theme.backgroundColor
        wrapperView.layer.cornerRadius = BankAccountPickerViewController.Dimension.wrapperViewCornerRadius
        wrapperView.clipsToBounds = true
        return wrapperView
    }()

    lazy private var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorColor = theme.seporatorColor
        tableView.tableFooterView = UIView()
        tableView.showsVerticalScrollIndicator = false
        tableView.estimatedRowHeight = 72
        tableView.estimatedSectionHeaderHeight = 120

        let bundle = Bundle(for: BankAccountPickerTableViewCell.self)
        let cellNib = UINib(nibName: BankAccountPickerViewController.tableViewCellBillIdentifier, bundle: bundle)
        let headerNib = UINib(nibName: BankAccountPickerViewController.tableViewHeaderIdentifier, bundle: bundle)
        tableView.register(cellNib, forCellReuseIdentifier: BankAccountPickerViewController.tableViewCellBillIdentifier)
        tableView.register(headerNib, forCellReuseIdentifier: BankAccountPickerViewController.tableViewHeaderIdentifier)

        return tableView
    }()

    lazy private var closeButton: UIButton = {

        let closeButton = UIButton(type: .system)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(closeAction(sender:)), for: .touchUpInside)
        if let image = UIImage(named: "close", in: Bundle(for: BankAccountPickerViewController.self), compatibleWith: nil) {
            closeButton.setImage(image, for: .normal)
        }
        closeButton.tintColor = UIColor.white

        return closeButton
    }()

    lazy private var backgroundView: UIView = {
        let bgView = UIView()
        bgView.translatesAutoresizingMaskIntoConstraints = false
        bgView.backgroundColor = UIColor.init(white: 0, alpha: 1)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapBehind(_:)))
        bgView.addGestureRecognizer(tap)

        return bgView
    }()


    // MARK: - Open APIs
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public init(name: String, description: String, bankAccounts: [BankAccountPickerItem], theme: BankAccountPickerTheme = DefaultBankAccountPickerTheme(),
                selection: ((_ selecteditem: BankAccountPickerItem, _ selectedIndex: Int) -> Void)? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.theme = theme
        self.bankAccounts = bankAccounts
        self.pickerName = name
        self.pickerDescription = description
        self.selection = selection
        hasSelectedItem = bankAccounts.contains(where: { (bill) -> Bool in
            return bill.isSelected
        })
        setUp()
    }


    /// Change Picker Name
    /// - Parameter string: pickerName
    public func changeName(_ string: String) {
        pickerName = string
        tableView.reloadData()
    }

}

extension BankAccountPickerViewController {

    public override func updateViewConstraints() {
        super.updateViewConstraints()
        guard let isOpen = isOpen else { return }
        if isOpen {
            wrapperViewBottomAnchor?.constant = BankAccountPickerViewController.Dimension.wrapperContentBottomOffset
        } else {
            wrapperViewBottomAnchor?.constant = BankAccountPickerViewController.Dimension.wrapperContentHeight
        }
    }

    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if let isOpen = isOpen {
            if isOpen {
                wrapperView.alpha = 1
                backgroundView.alpha = 0.8
            } else {
                wrapperView.alpha = 0
                backgroundView.alpha = 0
            }
        }
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.isOpen = true
    }

    @objc func closeAction(sender: Any?) {
        self.dissmiss()
    }

    @objc func handleTapBehind(_ sender: Any?) {
        self.dissmiss()
    }

    private func dissmiss() {
        self.isOpen = false
    }

    /// Setup View once on the first load.
    private func setUp() {
        self.modalPresentationStyle = .custom
        self.modalTransitionStyle = .crossDissolve

        self.view.backgroundColor = .clear

        tableView.delegate = self
        tableView.dataSource = self

        self.view.addSubview(backgroundView)
//        self.view.addSubview(closeButton)
        self.view.addSubview(wrapperView)
        self.wrapperView.addSubview(tableView)

        self.addLayouts()

    }

    /// Adds autolayouts once views added.
    private func addLayouts() {
        // backgroundView Constraints
        backgroundView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        // closeButton Constraints
//        closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 45).isActive = true
//        closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5).isActive = true
//        closeButton.widthAnchor.constraint(equalToConstant: BillPickerViewController.Dimension.actionButtonHeight).isActive = true
//        closeButton.heightAnchor.constraint(equalToConstant: BillPickerViewController.Dimension.actionButtonHeight).isActive = true

        // wrapper Constraints
        wrapperViewHeight = wrapperView.heightAnchor.constraint(equalToConstant: BankAccountPickerViewController.Dimension.wrapperContentHeight)
        wrapperViewHeight?.isActive = true
        wrapperView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        wrapperView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        wrapperViewBottomAnchor = wrapperView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: BankAccountPickerViewController.Dimension.wrapperContentHeight)
        wrapperViewBottomAnchor?.isActive = true

        // tableView Constraints
        tableView.topAnchor.constraint(equalTo: wrapperView.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: wrapperView.bottomAnchor, constant: -BankAccountPickerViewController.Dimension.wrapperContentBottomOffset).isActive = true

        self.view.layoutIfNeeded()
    }
}

extension BankAccountPickerViewController: UITableViewDelegate, UITableViewDataSource {

    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bankAccounts.count
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableCell(withIdentifier: BankAccountPickerViewController.tableViewHeaderIdentifier) as? BankAccountPickerHeaderTableViewCell else { return nil }

        headerView.configure(name: self.pickerName, description: self.pickerDescription, theme: theme)

        return headerView
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BankAccountPickerViewController.tableViewCellBillIdentifier, for: indexPath) as? BankAccountPickerTableViewCell,
        bankAccounts.count > indexPath.row else { return UITableViewCell() }

        let bill = bankAccounts[indexPath.row]

        cell.configure((bankAccount: bill, parentHasSelectedItem: hasSelectedItem, theme: theme))

        return cell
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let handler = selection {
            handler(bankAccounts[indexPath.row], indexPath.row)
        }
        self.dissmiss()
    }
}
