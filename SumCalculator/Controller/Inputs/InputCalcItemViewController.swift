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
enum InputType {
    case AddNew
    case Update
}
class InputCalcItemViewController: UIViewController {
    
    weak var delegate: InputCalcItemViewControllerDelegate?
    var calcItem = CalcItem()
    var inputType:InputType = .AddNew
    var before: CalcItem?
    
    // -------------------------------------------------
    // IBOutlet
    // -------------------------------------------------
    @IBOutlet weak var itemNameTextField: UITextField!
    @IBOutlet weak var unitTextField: UITextField!
    @IBOutlet weak var unitPriceButton: UIButton!
    @IBOutlet weak var quantityButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var quantityStepper: UIStepper!
    
    // -------------------------------------------------
    // IBAction
    // -------------------------------------------------
    @IBAction func tappedUnitPriceButton(_ sender: Any) {
        modalCalculator(type: .unitPrice)
    }
    @IBAction func tappedQuantityButton(_ sender: Any) {
        modalCalculator(type: .quantity)
    }
    @IBAction func changedQuantityStepperValue(_ sender: Any) {
        calcItem.quantity += Double(quantityStepper.value)
        quantityStepper.value = 0
        quantityRedisplay()
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
        reDisplay()
    }
    
    
    
    // -------------------------------------------------
    // 表示処理シリーズ
    // -------------------------------------------------
    private func reDisplay() {
        unitPriceRedisplay()
        quantityRedisplay()
    }
    private func unitPriceRedisplay() {
        unitPriceButton.setTitle("  " + calcItem.unitPrice.currency, for: .normal)
    }
    private func quantityRedisplay() {
        quantityButton.setTitle("  " + calcItem.quantity.quantity,for: .normal)
    }
    
    private func modalCalculator(type: AmountType){
        let storyboard = UIStoryboard.init(name: "InputCalculatorView", bundle: nil)
        let inputCalculatorViewController = storyboard.instantiateViewController(withIdentifier: "InputCalculatorViewController") as! InputCalculatorViewController
        let fN = calcItem.quantity.quantity
        inputCalculatorViewController.firstNumber = fN
        inputCalculatorViewController.inputCalculatorViewControllerDelegate = self
        inputCalculatorViewController.type = type
        let nav = BottomHalfModalNavigationController(rootViewController: inputCalculatorViewController)
        presentBottomHalfModal(nav, animated: true, completion: nil)
    }


}


extension InputCalcItemViewController: InputCalculatorViewControllerDelegate {
    func fixAmount(_ amount: Double, _ type: AmountType) {
        switch type {
        case .quantity:
            calcItem.quantity = amount
            quantityRedisplay()
        case .unitPrice:
            calcItem.unitPrice = amount
            unitPriceRedisplay()
        }
    }
    
    
}
