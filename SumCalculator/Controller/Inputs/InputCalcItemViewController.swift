//
//  InputCalcItemViewController.swift
//  SumCalculator
//
//  Created by 若江照仁 on 2020/11/15.
//

import UIKit
import BottomHalfModal

protocol InputCalcItemViewControllerDelegate: class {
    func inputData(calcItem: CalcItem, inputType: InputType)
}

class InputCalcItemViewController: UIViewController {
    
    weak var delegate: InputCalcItemViewControllerDelegate?
    var calcItem = CalcItem()
    var inputType:InputType = .AddNew
    var before: CalcItem?
    var isTemplate = false
    
    // -------------------------------------------------
    // IBOutlet
    // -------------------------------------------------
    @IBOutlet weak var itemNameTextField: UITextField!
    @IBOutlet weak var unitTextField: UITextField!
    @IBOutlet weak var unitPriceButton: UIButton!
    @IBOutlet weak var quantityButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var quantityStepper: UIStepper!
    @IBOutlet weak var subtotalLabel: UILabel!
    @IBOutlet weak var quantityStackView: UIStackView!
    
    // -------------------------------------------------
    // IBAction
    // -------------------------------------------------
    @IBAction func tappedUnitPriceButton(_ sender: Any) {
        modalCalculator(type: .unitPrice, firstNumber: calcItem.unitPrice.description)
    }
    @IBAction func tappedQuantityButton(_ sender: Any) {
        modalCalculator(type: .quantity, firstNumber: calcItem.quantity.description)
    }
    @IBAction func changedQuantityStepperValue(_ sender: Any) {
        calcItem.quantity += Decimal(quantityStepper.value)
        quantityStepper.value = 0
        quantityRedisplay()
        sumRedisplay()
    }
    
    @IBAction func itemNameEdited(_ sender: Any) {
        view.endEditing(true)
    }
    @IBAction func unitEdited(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func tappedConfirmButton(_ sender: Any) {
        calcItem.unit = unitTextField.text ?? ""
        calcItem.name = itemNameTextField.text ?? ""
        
        delegate?.inputData(calcItem: calcItem, inputType: inputType)
        dismiss(animated: true, completion: nil)
    }
    
    
    // -------------------------------------------------
    // ライフサイクル
    // -------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        confirmButton.layer.cornerRadius = 8
        confirmButton.layer.borderWidth = 0.5
        confirmButton.layer.borderColor = UIColor.systemGray3.cgColor
        
        quantityButton.layer.cornerRadius = 5
        quantityButton.layer.borderWidth = 0.5
        quantityButton.layer.borderColor = UIColor.systemGray3.cgColor
        
        unitPriceButton.layer.cornerRadius = 5
        unitPriceButton.layer.borderWidth = 0.5
        unitPriceButton.layer.borderColor = UIColor.systemGray3.cgColor
        if before == nil {
            navigationItem.title = "新しい項目を追加します"
        } else {
            inputType = .Update
            guard let beforeItem = before else {
                return
            }
            calcItem.id = beforeItem.id
            calcItem.name = beforeItem.name
            calcItem.quantity = beforeItem.quantity
            calcItem.unit = beforeItem.unit
            calcItem.unitPrice = beforeItem.unitPrice
            
            unitTextField.text = calcItem.unit
            itemNameTextField.text = calcItem.name
            navigationItem.title = "この項目修正します。"
        }
        if isTemplate {
            quantityStackView.isHidden = true
            subtotalLabel.isHidden = true
        }
        reDisplay()
    }
    
    
    
    // -------------------------------------------------
    // 表示処理シリーズ
    // -------------------------------------------------
    private func reDisplay() {
        unitPriceRedisplay()
        quantityRedisplay()
        sumRedisplay()
    }
    private func unitPriceRedisplay() {
        unitPriceButton.setTitle("  " + calcItem.unitPrice.unitCurrencyWithMyDigit, for: .normal)
    }
    private func quantityRedisplay() {
        quantityButton.setTitle("  " + calcItem.quantity.quantityWithMyDigit,for: .normal)
    }
    private func sumRedisplay() {
        subtotalLabel.text = "合計：\(calcItem.subtotal.totalCurrencyWithMyDigit)"
    }
    
    // -------------------------------------------------
    // 遷移
    // -------------------------------------------------
    private func modalCalculator(type: AmountType, firstNumber: String){
        let storyboard = UIStoryboard.init(name: "InputCalculatorView", bundle: nil)
        let inputCalculatorViewController = storyboard.instantiateViewController(withIdentifier: "InputCalculatorViewController") as! InputCalculatorViewController
        inputCalculatorViewController.firstNumber = firstNumber
        inputCalculatorViewController.inputCalculatorViewControllerDelegate = self
        inputCalculatorViewController.type = type
        let nav = BottomHalfModalNavigationController(rootViewController: inputCalculatorViewController)
        presentBottomHalfModal(nav, animated: true, completion: nil)
    }
    

}


extension InputCalcItemViewController: InputCalculatorViewControllerDelegate {
    func fixAmount(_ amount: Decimal, _ type: AmountType) {
        switch type {
        case .quantity:
            calcItem.quantity = amount
            quantityRedisplay()
            sumRedisplay()
        case .unitPrice:
            calcItem.unitPrice = amount
            unitPriceRedisplay()
            sumRedisplay()
        }
    }
    
    
}
