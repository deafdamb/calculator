//
//  ViewController.swift
//  Calculator
//
//  Created by Дмитрий on 14.11.15.
//  Copyright © 2015 DeafCode. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var inputInProcess = false
    var operandStack = [Double]()
    var lastOperation: String = "="
    var displayValue: Double? {
        set {
            display.text = "\(newValue)"
            addNumber()
        }
        get {
            if let numberInText = display.text {
                return decimalFormatter().numberFromString(numberInText)?.doubleValue
            }
            return nil
        }
    }
    
    func decimalFormatter() -> NSNumberFormatter {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .DecimalStyle
        formatter.locale = NSLocale.currentLocale()
        formatter.maximumFractionDigits = 10
        return formatter
    }

    @IBOutlet weak var display: UILabel!

    @IBAction func inputDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if inputInProcess {
            display.text! += digit
        } else {
            display.text = digit
            inputInProcess = true
        }
    }

    @IBAction func doOperation(sender: UIButton) {
        addNumber()
        if lastOperation != "=" {
            switch lastOperation {
            case "+":  if operandStack.count >= 2 {
                displayValue = operandStack.removeLast() + operandStack.removeLast()
                addNumber()
                }
            case "−":  if operandStack.count >= 2 {
                displayValue = operandStack.removeFirst() - operandStack.removeLast()
                addNumber()
                }
            case "×":  if operandStack.count >= 2 {
                displayValue = operandStack.removeLast() * operandStack.removeLast()
                addNumber()
                }
            case "÷":  if operandStack.count >= 2 {
                displayValue = operandStack.removeFirst() / operandStack.removeLast()
                addNumber()
                }
            default: break
            }
        }
        lastOperation = sender.currentTitle!
        if sender.currentTitle == "="{
            displayValue = operandStack.last!
        }
    }
    
    
    
    
    //.numberStyle = NSNumberFormatterStyle.CurrencyStyle
    //
    //    for identifier in ["en_US", "fr_FR", "ja_JP"] {
    //    formatter.locale = NSLocale(localeIdentifier: identifier)
    //    print("\(identifier) \(formatter.stringFromNumber(1234.5678))")
    //    }
    
    //    formatter.numberStyle = formatter.decimalStyle
    //    formatter.numberStyle = formatter.dDecimalStyle
    //    formatter.locale = NSLocale.currentLocale()
    //    formatter.maximumFractionDigits = 10

    
    func addNumber() {
        operandStack.append(displayValue!)
        inputInProcess = false
    }

    @IBAction func clearValues(sender: UIButton) {
        displayValue = 0
        inputInProcess = false
        lastOperation = ""
    }
}

