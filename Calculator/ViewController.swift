//
//  ViewController.swift
//  Calculator
//
//  Created by Дмитрий on 14.11.15.
//  Copyright © 2015 DeafCode. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var brain = CalculatorBrain()
    
    var inputInProcess = false
    
    @IBOutlet weak var display: UILabel!
    
    var displayValue: Double? {
        set {
            if newValue != nil {
                display.text = decimalFormatter().stringFromNumber(newValue!)
            } else {
                display.text = ""
            }
            inputInProcess = false
        }
        
        get {
            if let number = display.text {
                return decimalFormatter().numberFromString(number)?.doubleValue
            }
            return nil
        }
    }
    
    @IBOutlet weak var delimeter: UIButton! {
        didSet {
            delimeter.setTitle(decimalFormatter().decimalSeparator, forState: UIControlState.Normal)
        }
    }
    
    func decimalFormatter() -> NSNumberFormatter {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .DecimalStyle
        formatter.locale = NSLocale.currentLocale()
        formatter.maximumFractionDigits = 10
        return formatter
    }
    
    @IBAction func inputDigit(sender: UIButton) {
        if let digit = sender.currentTitle {
            if inputInProcess {
                display.text! += digit
            } else {
                display.text! = digit
                inputInProcess = true
            }
        }
    }
    
    @IBAction func inputSymbol(sender: UIButton) {
        if let symbol = sender.currentTitle {
            switch symbol {
            case "±":
                if inputInProcess && displayValue != 0 {
                    if displayValue > 0 {
                        display.text?.insert("-", atIndex: (display.text?.startIndex)!)
                    } else {
                        display.text?.removeAtIndex((display.text?.startIndex)!)
                    }
                }
            case delimeter.currentTitle!:
                if inputInProcess {
                    if display.text?.rangeOfString(symbol) == nil {
                        display.text! += delimeter.currentTitle!
                    }
                } else {
                    display.text = "0" + delimeter.currentTitle!
                    inputInProcess = true
                }
            default: break
            }
        }
    }
    
    @IBAction func enter() {
        if let value = displayValue {
            displayValue = brain.pushOperand(value)
        }
    }

    @IBAction func doOperation(sender: UIButton) {
        if inputInProcess {
            enter()
        }
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                displayValue = result
            } else {
                displayValue = 0
            }
        }
    }
    
    @IBAction func clearValues(sender: UIButton) {
        displayValue = 0
        inputInProcess = false
    }
}
