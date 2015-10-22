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
    private var state:State = State.Count
    private var inputs:[UIButton] = []
    private var curValue:Double = 0.0

    @IBOutlet weak var window: UILabel!
    
    
    @IBAction func count(sender: UIButton) {
        numCount++;
        if state != State.Count {
            state = State.Count
        }
    }
    
    @IBAction func operandButtonPressed(sender: UIButton) {
        inputs.append(sender)
    }
    
    //Event handler for buttons
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
            case "count":
                numCount++
            case "avg":
                avgSum += amount
                avgCount++
            case "fact":
                var total = 1.0;
                for var i = amount; i > 1; i-- {
                    total *= i
                }
                curValue = total
            default:
                curValue = curValue % amount
        }
        updateWindow("\(curValue)")
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

