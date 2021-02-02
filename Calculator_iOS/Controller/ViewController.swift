//
//  ViewController.swift
//  Calculator_iOS
//
//  Created by Meruyert Tastandiyeva on 2/1/21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var operationsScrollView: UIScrollView!
    @IBOutlet weak var operationsLabel: UILabel!
    @IBOutlet weak var displayLabel: UILabel!
    @IBOutlet weak var clearButton: UIButton!
    
    var calculator = Calculator()
    
    var number = ""
    var isTyping = false
    var numberExists = false
    var operatorExists = false
    var finishedCalculating = false
    var negativeNumberEvaluator = false
    var isDecimal = false
    var isAlreadyZero = false
    
    var isClearAll: Bool = true {
        didSet{
            if !isClearAll {
                clearButton.setTitle("C", for: .normal)
                
            } else {
                clearButton.setTitle("AC", for: .normal)
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    @IBAction func operationButtonPressed(_ sender: Any) {
        
        guard let operation = (sender as! UIButton).titleLabel else {
            return
        }
        
        if finishedCalculating {
            operationsLabel.text = calculator.result
            displayLabel.text = calculator.result
            finishedCalculating.toggle()
        }
        
        if isTyping {
            calculator.setOperand(operand: Double(number) ?? 0.0)
            numberExists = true
            operatorExists = false
        }
        
        if operatorExists {
            print("cannot perform recursive operations")
        } else {
            
            calculator.performOperation(symbol: operation.text!)
            
            operatorExists = true
            
            if operation.text != "=" && operation.text != "+/-" && operation.text != "%" {
                
                if operation.text == "÷" {
                    operationsLabel.text! += " / "
                } else {
                    operationsLabel.text! += " \(operation.text!) "
                }

                isTyping = false
                displayLabel.text = calculator.result
                
            } else if operation.text == "+/-" {
                
                negativeNumberEvaluator = true
                
                if numberExists {
                    
                    if Double(calculator.result) ?? 0.0 < 0.0 {
                        operationsLabel.text = String((operationsLabel.text?.dropLast(calculator.result.count - 1))!)
                        operationsLabel.text! += ("(\(calculator.result))")
                    } else {
                        operationsLabel.text = String((operationsLabel.text?.dropLast(calculator.result.count + 3))!)
                        operationsLabel.text! += calculator.result
                    }
                    
                    number = calculator.result
                    displayLabel.text = calculator.result
                    
                } else {
                    print("choose number first")
                }
                
            } else if operation.text == "%" {
                
                if numberExists {
                    operationsLabel.text = String((operationsLabel.text?.dropLast())!)
                    operationsLabel.text! += calculator.result
                    number = calculator.result
                    displayLabel.text = calculator.result
                } else {
                    print("choose number first")
                }
                
            } else {
                
                negativeNumberEvaluator.toggle()
                finishedCalculating.toggle()
                
                if !isClearAll {
                    isClearAll.toggle()
                }
                
                isTyping = false
                displayLabel.text = calculator.result
                operatorExists = false
            }
        }
        numberExists = false
        isDecimal = false
    }
    
    
    @IBAction func numberButtonPressed(_ sender: Any) {
        
        if displayLabel.text == "0" {
            displayLabel.text = ""
        }
        
        if isClearAll {
            isClearAll.toggle()
        }
        
        guard let buttonContent = (sender as! UIButton).titleLabel else {
            return
        }
    
        if finishedCalculating {
            operationsLabel.text = ""
            displayLabel.text = ""
            finishedCalculating.toggle()
        }
        
        if !isTyping {
            if buttonContent.text == "." && !isDecimal {
                isDecimal = true
                operationsLabel.text! += "0."
                displayLabel.text! += "0."
                number = "0" + buttonContent.text!
                print("here")
            } else {
                displayLabel.text = ""
                operationsLabel.text! += buttonContent.text!
                displayLabel.text! += buttonContent.text!
                number = buttonContent.text ?? "0"
            }
            isTyping.toggle()
            print("here3")
        } else {
            if buttonContent.text == "." {
                if isDecimal {
                    operationsLabel.text = operationsLabel.text!
                    displayLabel.text = displayLabel.text!
                } else {
                    isDecimal = true
                    operationsLabel.text! += "."
                    displayLabel.text! += "."
                    number += buttonContent.text!
                    print("here2")
                }
            } else {
                operationsLabel.text = operationsLabel.text! + buttonContent.text!
                displayLabel.text = displayLabel.text! + buttonContent.text!
                number += buttonContent.text!
                print("here4")
            }
        }
        
    }
    
    
    @IBAction func clearButtonPressed(_ sender: Any) {
        guard let buttonContent = (sender as! UIButton).titleLabel else {
            return
        }
        
        if buttonContent.text == "C" {
            if isTyping {
                if operationsLabel.text?.delete() == "" {
                    operationsLabel.text = ""
                    displayLabel.text = "0"
                } else {
                    operationsLabel.text = operationsLabel.text?.delete()
                    displayLabel.text = ""
                }
                number = "0"
            } else {
                calculator.undo()
                operatorExists = false
                operationsLabel.text = String((operationsLabel.text?.dropLast())!)
            }
            
            if operationsLabel.text == "" {
                if !isClearAll {
                    isClearAll.toggle()
                }
            }
            
            if displayLabel.text == "" {
                if !isClearAll {
                    isClearAll.toggle()
                }
            }
            
            isTyping = false
            isDecimal = false
            numberExists.toggle()
            
        } else {
            number = ""
            operationsLabel.text = ""
            finishedCalculating = false
            displayLabel.text = "0"
            calculator.clearHistory()
            operatorExists = false
            isTyping = false
            numberExists = false
            isDecimal = false
        }
    }
}

extension String {
    func delete() -> String {
        let sequence = self
        var lastWhitespaceIndex = 0
        var offset = 0
        for char in sequence {
            if char == " " {
                lastWhitespaceIndex = offset
            }
            offset += 1
        }

        if lastWhitespaceIndex == 0 {
            return ""
        } else {
            let index = sequence.index(sequence.startIndex, offsetBy: lastWhitespaceIndex)

            let newString = String(sequence[...index])
            return newString
        }
    }
}

