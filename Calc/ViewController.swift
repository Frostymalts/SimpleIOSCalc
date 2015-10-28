//
//  ViewController.swift
//  Calc
//
//  Created by Joshua Malters on 10/21/15.
//  Copyright © 2015 Joshua Malters. All rights reserved.
//

import UIKit

enum State {
    case Count
    case Avg
}

class ViewController: UIViewController {
    private var numCount:Int = 0
    private var avgSum:Double = 0.0
    private var avgCount:Int = 0
    private var state:State? = nil
    private var inputs:[UIButton] = []
    private var curValue:Double = 0.0

    @IBOutlet weak var window: UILabel!
    
    // Event handler for the equals button
    @IBAction func equalsButtonPressed(sender: UIButton) {
        if state == State.Count
        {
            state = nil
            updateWindow("\(numCount)")
            numCount = 0
        } else if state == State.Avg
        {
            state = nil
            let avg = avgSum / Double(avgCount)
            updateWindow("\(avg)")
            avgSum = 0
            avgCount = 0
        } else {
            updateWindow("\(curValue)")
            curValue = 0.0
        }
        inputs.removeAll()
    }
    
    // Event handler for normal operands
    @IBAction func operandButtonPressed(sender: UIButton) {
        inputs.append(sender)
    }
    
    // Event handler for special the operands
    @IBAction func specialOperandButtonPressed(sender: UIButton) {
        let inputTitle = sender.titleLabel!.text!
       
        if inputs.count > 0 {
            let amount = inputs[inputs.count - 1]
            let doubleCheck = Double(amount.titleLabel!.text!)
            
            if doubleCheck != nil {
                switch inputTitle {
                case "count":
                    numCount++
                    state = State.Count
                case "avg":
                    avgSum += doubleCheck!
                    avgCount++
                    state = State.Avg
                default:
                    var total = 1;
                    for var i = Int(curValue); i > 1; i-- {
                        total *= i
                    }
                    curValue = Double(total)
                }
            }
        }
        inputs.append(sender)
    }

    //Event handler for numeric buttons
    @IBAction func buttonPressed(sender: UIButton) {
        let val = sender.titleLabel!.text!
        inputs.append(sender)
        let amount = Double(val)
        
        if inputs.count > 1 {
            let lastInput = inputs[inputs.count - 2]
            let title = lastInput.titleLabel!.text
            let intCheck = Int(title!)
            let doubleCheck = Double(title!)
            
            if intCheck == nil && doubleCheck == nil {
                updateCurValue(amount!, lastInputTitle: title!);
               // title == "%" ? updateWindow("\(curValue)") : updateWindow("\(amount!)")
                updateWindow("\(amount!)")
            } else {
                curValue = (curValue * 10) + amount!
                updateWindow("\(curValue)")
            }
        } else {
            curValue = (curValue * 10) + amount!
            updateWindow("\(curValue)")
        }
    }
    
    
    
    // Updates the viewing window with the passed in text
    // Must be numerical
    private func updateWindow(newText:String) -> Void {
        let intCheck = Int(newText)
        let doubleCheck = Double(newText)
        
        if intCheck == nil && doubleCheck == nil {
            let alert = UIAlertController(title: "How?", message: "Somehow you tried to update the window with a non numerical value...", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            window.text = newText
        }
    }
    
    private func updateCurValue(amount: Double, lastInputTitle: String) {
        switch lastInputTitle {
            case "+":
                curValue += amount
            case "-":
                curValue -= amount
            case "*":
                curValue *= amount
            case "/":
                curValue /= amount
            default:
                let inputCount = inputs.count
                let lastNumber = (inputCount > 1) ?
                    Double((inputs[inputCount - 3].titleLabel?.text)!) : 0.0
                curValue = lastNumber! % amount
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

