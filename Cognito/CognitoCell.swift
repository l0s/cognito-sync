//
//  CognitoCell.swift
//  Cognito
//
//  Created by Carlos Macasaet on 11/11/15.
//  Copyright © 2015 Carlos Macasaet. All rights reserved.
//

import Foundation
import UIKit

public class CognitoCell : UITableViewCell
{

    // MARK: model
    var tuple:(String, String) = ( "", "" ) {
        didSet {
            label.text = "\(tuple.0):"
            value.text = tuple.1
        }
    }

    // MARK: view
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var value: UILabel!

}