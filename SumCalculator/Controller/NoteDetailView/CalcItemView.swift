//
//  CalcItemView.swift
//  SumCalculator
//
//  Created by 若江照仁 on 2020/11/14.
//

import UIKit

protocol CalcItemViewDelegate: AnyObject {
    func tappedCalcItem(calcItem: CalcItem)
}

class CalcItemView: UIView {
    var calcItem: CalcItem?
    weak var delegate: CalcItemViewDelegate?
    @IBOutlet weak var calcItemNameLabel: UILabel!
    // -------------------------------------------------
    // IBOutlet unitPrice
    // -------------------------------------------------
    @IBOutlet weak var unitPriceIntegerPartLabel: UILabel!
    @IBOutlet weak var unitPriceAfterDotLabel: UILabel!
    @IBOutlet weak var unitPriceUnitLabel: UILabel!
    
    // -------------------------------------------------
    // IBOutlet quantity
    // -------------------------------------------------
    @IBOutlet weak var quantityIntegerPartLabel: UILabel!
    @IBOutlet weak var quantityAfterDotLabel: UILabel!
    @IBOutlet weak var quantityUnitLabel: UILabel!
    
    // -------------------------------------------------
    // IBOutlet subTotal
    // -------------------------------------------------
    @IBOutlet weak var subTotalIntegerPartLabel: UILabel!
    @IBOutlet weak var subTotalAfterDotLabel: UILabel!
    @IBOutlet weak var itemOverView: ItemOverView!
    
    // -------------------------------------------------
    // ライフサイクル
    // -------------------------------------------------
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
    }
    func setTarget() {
        itemOverView.setTarget(self, selector: #selector(tappedItemOverView))
    }
    @objc func tappedItemOverView(){
        delegate?.tappedCalcItem(calcItem: calcItem!)
    }
    
}

class ItemOverView: UIView {
    private weak var target : AnyObject?
        private var selector : Selector?
        private var clickHandler: (() -> Void)?
    var highlightedColor: UIColor = .label
        
        var highlighted : Bool = false {
            didSet{
                if (highlighted != oldValue){ reloadButtonColors() }
            }
        }

        required init?(coder: NSCoder) {
            super.init(coder: coder)
            
        }
        
        func reloadButtonColors(){
            print(highlighted)
            if highlighted {
                backgroundColor = highlightedColor
            } else {
                backgroundColor = .clear
            }
        }
        
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            highlighted = true
        }
        
        override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
            let touch = touches.first

            var touchPoint : CGPoint = CGPoint.zero
            if let _touch = touch{
                touchPoint = _touch.location(in: self)
            }

            //タッチ領域から外れた場合はキャンセル扱いにする
            if(touchPoint.x > self.bounds.width || touchPoint.x < 0 || touchPoint.y > self.bounds.height || touchPoint.y < 0){
                touchesCancelled(touches, with: event)
            }
        }
        
        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            if (!highlighted){
                return
            }

            if (target != nil && selector != nil && target!.responds(to: selector!)){
                let control : UIControl = UIControl()
                control.sendAction(selector!, to: target, for: nil)
            }

            if (clickHandler != nil){
                clickHandler!()
            }

            highlighted = false
        }
        
        override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
            highlighted = false
        }
        
        func setTarget(_ target: AnyObject, selector: Selector){
            self.target = target;
            self.selector = selector
        }
        
        func setClickHandler(handler : @escaping () -> Void){
            self.clickHandler = handler
        }
}
