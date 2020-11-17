//
//  InputCalcItemViewController.swift
//  SumCalculator
//
//  Created by 若江照仁 on 2020/11/15.
//

import UIKit


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
    
    @IBOutlet weak var itemNameLabel: UIStackView!
    @IBOutlet weak var unitLabel: UITextField!
    @IBOutlet weak var unitPriceButton: UIButton!
    @IBOutlet weak var quantityButton: UIButton!
    
    @IBOutlet weak var quantityStepper: UIStepper!
    @IBAction func tappedUnitPriceButton(_ sender: Any) {
    }
    @IBAction func tappedQuantityButton(_ sender: Any) {
    }
    @IBAction func changedValueStepper(_ sender: Any) {
        calcItem?.quantity += Float(quantityStepper.value)
        quantityStepper.value = 0
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "詳細情報"
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func itemNameEdited(_ sender: Any) {
        view.endEditing(true)
    }
    
    
    // 表示処理シリーズ
    private func unitPriceRedisplay() {
        unitPriceButton.titleLabel?.text = (calcItem?.unitPrice ?? 0).currency
    }
    
    private func quantityRedisplay() {
        quantityButton.titleLabel?.text = String(calcItem?.quantity ?? 0)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
