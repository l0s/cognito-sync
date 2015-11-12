//
//  ViewController.swift
//  Cognito
//
//  Created by Carlos Macasaet on 11/11/15.
//  Copyright © 2015 Carlos Macasaet. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    lazy var service = CognitoService.instance

    // MARK: model
    var rows:[(String, String)] = [ ( "Cognito ID", "" ),
                                    ( "Count", "" ),
                                    ( "Computed Value", "" ) ]

    // MARK: view
    @IBOutlet weak var tableView: UITableView!

    // MARK: controller
    @IBAction func increment( sender: UIBarButtonItem )
    {
        service.increment( updateProfile )
    }

    @IBAction func refresh( sender: UIBarButtonItem )
    {
        service.refresh( updateProfile )
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()

        service.refresh( updateProfile )
    }

    func updateProfile( profile:CognitoProfile )
    {
        let computedString:String
        if let computedInt = profile.computedValue
        {
            computedString = "\(computedInt)"
        }
        else
        {
            computedString = ""
        }
        rows[ 0 ] = ( "Cognito ID", profile.cognitoId )
        rows[ 1 ] = ( "Count", "\(profile.counter)" )
        rows[ 2 ] = ( "Computed Value", computedString )
        dispatch_async( dispatch_get_main_queue(), tableView.reloadData )
    }

    // MARK: UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return rows.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let index = indexPath.row
        let cell = tableView.dequeueReusableCellWithIdentifier( "prototypeCell" ) as! CognitoCell
        cell.tuple = rows[ index ]
        return cell
    }

}