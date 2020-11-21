//
//  InputCalculatorViewController.swift
//  SumCalculator
//
//  Created by 若江照仁 on 2020/11/18.
//

import UIKit
import BottomHalfModal

protocol InputCalculatorViewControllerDelegate {
    func fixAmount(_ amount: Double, _ type: AmountType)
}
enum AmountType {
    case quantity
    case unitPrice
}
class InputCalculatorViewController: UIViewController, SheetContentHeightModifiable  {
    var sheetContentHeightToModify: CGFloat = 580
    var inputCalculatorViewControllerDelegate : InputCalculatorViewControllerDelegate?
    
    enum CalculateStatus {
        case none, plus, minus, multiplication, division
    }
    
    var firstNumber = ""
    var secondNumber = ""
    var calculateStatus: CalculateStatus = .none
    var type: AmountType = .quantity
    let numbers = [
        ["C","←", "÷"],
        ["7", "8", "9", "×"],
        ["4", "5", "6", "-"],
        ["1", "2", "3", "+"],
        ["0", ".", "="],
    ]
    let cellId = "cellId"
    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var calculatorCollectionView: UICollectionView!
    @IBOutlet weak var calculatorHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        super.viewDidLoad()
        let closeButton = UIBarButtonItem(title: "キャンセル", style: .plain, target: self, action: #selector(close))
        //closeButton.tintColor = .label
        
        let doneButton = UIBarButtonItem(title: "確定", style: .plain, target: self, action: #selector(done))
        //doneButton.tintColor = .label
        
        navigationItem.leftBarButtonItem = closeButton
        navigationItem.rightBarButtonItem = doneButton
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        adjustFrameToSheetContentHeightIfNeeded()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        adjustFrameToSheetContentHeightIfNeeded(with: coordinator)
    }
    
    @objc func close() {
        dismiss(animated: true, completion: nil)
    }
    @objc func done() {
        fixAmount()
    }
    
    func setupViews() {
        calculatorCollectionView?.delegate = self
        calculatorCollectionView?.dataSource = self
        calculatorCollectionView?.register(CalculatorViewCell.self, forCellWithReuseIdentifier: cellId)
        calculatorHeightConstraint?.constant = view.frame.width * 1.2
        calculatorCollectionView?.backgroundColor = .clear
        calculatorCollectionView?.contentInset = .init(top: 0, left: 14, bottom: 0, right: 14)
        
        setAmount(firstNumber)
        
    }
    
    func clear() {
        firstNumber = "0"
        secondNumber = "0"
        setAmount("0")
        calculateStatus = .none
    }
    
    func setAmount(_ amount: String) {
        if amount.contains(".") {
            numberLabel.text = amount
        } else {
            setDecimalString(Double(amount) ?? 0)
        }
    }
    func setDecimalString(_ amountDouble: Double) {
        numberLabel.text = amountDouble.string
    }
    
    func fixAmount(){
        let amount = Double(numberLabel.text ?? "0") ?? 0
        inputCalculatorViewControllerDelegate?.fixAmount(amount, type)
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension InputCalculatorViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numbers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numbers[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: collectionView.frame.width, height: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width: CGFloat = 0
        width = ((collectionView.frame.width - 10) - 14 * 5) / 4
        let height = width
        if (indexPath.section == 0 || indexPath.section == 4) && indexPath.row == 0 {
            width = width * 2 + 14 + 9
        }
        return .init(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 14
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = calculatorCollectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CalculatorViewCell
        cell.numberLabel.text = numbers[indexPath.section][indexPath.row]
        
        numbers[indexPath.section][indexPath.row].forEach { (numberString) in
            if "0"..."9" ~= numberString || numberString.description == "." {
                cell.numberLabel.backgroundColor = .darkGray
            } else if numberString == "C" || numberString == "←" {
                cell.numberLabel.backgroundColor = .lightGray
                cell.numberLabel.textColor = .black
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let number = numbers[indexPath.section][indexPath.row]
        
        switch calculateStatus {
        case .none:
            handleFirstNumberSelected(number: number)
        case .plus, .minus, .multiplication, .division:
            handleSecondNumberSelected(number: number)
        }
    }
    
    private func handleFirstNumberSelected(number: String) {
        switch number {
        case "0"..."9":
            firstNumber += number
            if firstNumber.count > 12 {
                firstNumber = String(firstNumber.dropLast(1))
            }
            setAmount(firstNumber)
            if firstNumber.hasPrefix("0") {
                firstNumber = String(firstNumber.dropFirst(1))
            }
        case "←":
            if firstNumber.count > 0 {
                firstNumber = String(firstNumber.prefix(firstNumber.count - 1))
                setAmount(firstNumber)
            }
        case ".":
            if !confirmIncludeDecimalPoint(numberString: firstNumber) {
                firstNumber += number
                numberLabel.text = firstNumber
            }
        case "+":
            calculateStatus = .plus
            statusLabel.text =  (self.numberLabel?.text ?? "") + " " + number
            setAmount("")
        case "-":
            calculateStatus = .minus
            statusLabel.text = (self.numberLabel?.text ?? "") + " " + number
            setAmount("")
        case "×":
            calculateStatus = .multiplication
            statusLabel.text = (self.numberLabel?.text ?? "") + " " + number
            setAmount("")
        case "÷":
            calculateStatus = .division
            statusLabel.text = (self.numberLabel?.text ?? "") + " " + number
            setAmount("")
        case "=":
            self.fixAmount()
        case "C":
            clear()
            statusLabel.text = ""
        default:
            break
        }
    }
    
    private func handleSecondNumberSelected(number: String) {
        switch number {
        case "0"..."9":
            secondNumber += number
            if secondNumber.count > 12 {
                secondNumber = String(secondNumber.dropLast(1))
            }
            if calculateStatus == .division || calculateStatus == .multiplication{
                numberLabel.text = secondNumber
            } else {
                setAmount(secondNumber)
            }
            
            if secondNumber.hasPrefix("0") {
                secondNumber = ""
            }
        case "←":
            if secondNumber.count > 0 {
                secondNumber = String(secondNumber.prefix(secondNumber.count - 1))
                setAmount(secondNumber)
            }
        case ".":
            if !confirmIncludeDecimalPoint(numberString: secondNumber) {
                secondNumber += number
                numberLabel.text = secondNumber
            }
        case "+":
            calculateResultNumber()
            calculateStatus = .plus
            statusLabel.text =  (self.numberLabel?.text ?? "") + " " + number
            setAmount("")
        case "-":
            calculateResultNumber()
            calculateStatus = .minus
            statusLabel.text = (self.numberLabel?.text ?? "") + " " + number
            setAmount("")
        case "×":
            calculateResultNumber()
            calculateStatus = .multiplication
            statusLabel.text = (self.numberLabel?.text ?? "") + " " + number
            setAmount("")
        case "÷":
            calculateResultNumber()
            calculateStatus = .division
            statusLabel.text = (self.numberLabel?.text ?? "") + " " + number
            setAmount("")
        case "=":
            calculateResultNumber()
            statusLabel.text = ""
        case "C":
            clear()
            statusLabel.text = ""
        default:
            break
        }
    }
    
    private func calculateResultNumber() {
        let firstNum = Double(firstNumber) ?? 0
        let secondNum = Double(secondNumber) ?? 0
        
        var resultString: String?
        switch calculateStatus {
        case .plus:
            resultString = String(firstNum + secondNum)
        case .minus:
            resultString = String(firstNum - secondNum)
        case .multiplication:
            resultString = String(firstNum * secondNum)
        case .division:
            if secondNum == 0 {
                resultString = String(firstNum)
            } else {
                resultString = String(firstNum / secondNum)
            }
        default:
            break
        }
        
        if let result = resultString, result.hasSuffix(".0") {
            resultString = result.replacingOccurrences(of: ".0", with: "")
        }
        setDecimalString(Double(resultString ?? "") ?? 0)
        firstNumber = ""
        secondNumber = ""
        
        firstNumber += resultString ?? ""
        calculateStatus = .none
    }
    
    private func confirmIncludeDecimalPoint(numberString: String) -> Bool {
        if numberString.range(of: ".") != nil || numberString.count == 0 {
            return true
        } else {
            return false
        }
    }
}
