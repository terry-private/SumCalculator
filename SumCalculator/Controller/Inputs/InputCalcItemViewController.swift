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
    var calcItem: CalcItem?
    var inputType:InputType = .AddNew
    
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
        calcItem?.quantity += Double(quantityStepper.value)
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
        guard let fixedItem = calcItem else { return }
        fixedItem.unit = unitTextField.text ?? ""
        fixedItem.name = itemNameTextField.text ?? ""
        
        delegate?.inputData(calcItem: fixedItem, inputType: inputType)
        dismiss(animated: true, completion: nil)
    }
    
    
    // -------------------------------------------------
    // ライフサイクル
    // -------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "詳細情報"
        confirmButton.layer.cornerRadius = 8
        confirmButton.layer.borderWidth = 1
        confirmButton.layer.borderColor = UIColor.opaqueSeparator.cgColor
        if calcItem == nil {
            calcItem = CalcItem()
        } else {
            inputType = .Update
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
        unitPriceButton.setTitle((calcItem?.unitPrice ?? 0).currency, for: .normal)
    }
    private func quantityRedisplay() {
        quantityButton.setTitle((calcItem?.quantity ?? 0).quantity,for: .normal)
    }
    
    private func modalCalculator(type: AmountType){
        let storyboard = UIStoryboard.init(name: "InputCalculatorView", bundle: nil)
        let inputCalculatorViewController = storyboard.instantiateViewController(withIdentifier: "InputCalculatorViewController") as! InputCalculatorViewController
        let fN = calcItem?.quantity.quantity ?? "0"
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
            calcItem?.quantity = amount
            quantityRedisplay()
        case .unitPrice:
            calcItem?.unitPrice = amount
            unitPriceRedisplay()
        }
    }
    
    
}
