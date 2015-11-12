//
//  CognitoService.swift
//  Cognito
//
//  Created by Carlos Macasaet on 11/11/15.
//  Copyright © 2015 Carlos Macasaet. All rights reserved.
//

import Foundation

public class CognitoService
{

    public static let instance = CognitoService()

    lazy var syncClient = AWSCognito.defaultCognito()
    lazy var serviceManager = AWSServiceManager.defaultServiceManager()

    var credentialsProvider:AWSCognitoCredentialsProvider

    init()
    {
        let path = NSBundle.mainBundle().pathForResource("private", ofType: "plist")!
        let dict = NSDictionary( contentsOfFile: path )!
        credentialsProvider =
            AWSCognitoCredentialsProvider( regionType: .USEast1,
                identityPoolId: dict[ "identityPoolId" ] as! String )
        let configuration =
            AWSServiceConfiguration( region: .USEast1, credentialsProvider: credentialsProvider )
        serviceManager.defaultServiceConfiguration = configuration
    }

    func getCognitoId( callback:String -> Void )
    {
        credentialsProvider.getIdentityId().continueWithSuccessBlock()
        {
            task in
            callback( task.result as! String )
            return task
        }
    }

    func refresh( callback:CognitoProfile -> Void )
    {
        let profile = syncClient.openOrCreateDataset( "profile" )
        profile.synchronize().continueWithSuccessBlock()
        {
            task in
            print( "refresh result: \(task)" )
            callback( self.createProfile( profile ) )
            return task
        }
    }

    func createProfile( dataSet:AWSCognitoDataset ) -> CognitoProfile
    {
        let computedValue:Int?
        if let computedValueString = dataSet.stringForKey( "computedValue" )
        {
            computedValue = Int( computedValueString )!
        }
        else
        {
            computedValue = nil
        }
        let count:Int
        if let countString = dataSet.stringForKey( "count" )
        {
            count = Int( countString )!
        }
        else
        {
            count = 0
        }
        return CognitoProfile( cognitoId:self.credentialsProvider.identityId,
            counter: count,
            computedValue: computedValue )
    }

    func increment( callback:( CognitoProfile -> Void )? )
    {
        let profile = syncClient.openOrCreateDataset( "profile" )
        let previousCount:Int = getCount( profile )
        profile.setString( "\(previousCount + 1)", forKey: "count" )
        let task = profile.synchronize()
        if let callback = callback {
            task.continueWithSuccessBlock()
            {
                subTask in
                callback( self.createProfile( profile ) )
                return subTask
            }
        }
    }

    func getCount( profile:AWSCognitoDataset ) -> Int
    {
        if let countString = profile.stringForKey( "count" )
        {
            return Int( countString )!
        }
        return 0
    }

}