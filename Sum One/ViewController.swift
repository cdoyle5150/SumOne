//
//  ViewController.swift
//  Sum One
//
//  Created by CHAD DOYLE on 6/8/17.
//  Copyright © 2017 CHAD DOYLE. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var IsNewMember: UISegmentedControl!
    @IBOutlet var AmountDue: UILabel!
    @IBOutlet var MemberMonth: [UIButton]!
    
    let dues = MemberDues()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func NewMemberChanged(_ sender: UISegmentedControl) {
        
        let currencyFormatter = NumberFormatter()
        
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = NumberFormatter.Style.currency
        currencyFormatter.locale = Locale.current
        
        if let amountDouble = currencyFormatter.number(from: AmountDue.text!)?.doubleValue
        {
            var amount = amountDouble
            if sender.selectedSegmentIndex == 0 {
                amount += dues.newMemberFee
                dues.isNewMember = true
            }
            else {
                amount -= dues.newMemberFee
                dues.isNewMember = false
            }
            
            AmountDue.text = currencyFormatter.string(from: NSNumber(value: amount))
            
        }
        
    }
    @IBAction func CalculateMonth(_ sender: UIButton) {
        
        let monthsInGroup = sender.tag % 10
        let group = (sender.tag - monthsInGroup) / 10
        let currencyFormatter = NumberFormatter()
        var includeFee = dues.newMemberFee
        
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = NumberFormatter.Style.currency
        currencyFormatter.locale = Locale.current
        
        for month in MemberMonth
        {
            if ((month.tag % 10) <= monthsInGroup) && (((month.tag - (month.tag % 10)) / 10) == group)
            {
                //show button as pressed
                month.backgroundColor = UIColorFromHex(rgbValue: 0x33CC33, alpha: 1.0)
            }
            else
            {
                //show button as not pressed
                month.backgroundColor = UIColorFromHex(rgbValue: 0x0066FF, alpha: 1.0)
            }
        }
        if dues.isNewMember == false{
            includeFee = 0
        }
        let totalDue = includeFee + Double(monthsInGroup) * (dues.localDueMonthly + dues.nationalDueMonthly)
        AmountDue.text = currencyFormatter.string(from: NSNumber(value: totalDue))
        
    }
    
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
}

