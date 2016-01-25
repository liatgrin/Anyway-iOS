//
//  main.swift
//  Anyway
//
//  Created by Aviel Gross on 1/25/16.
//  Copyright © 2016 Hasadna. All rights reserved.
//

import Foundation

autoreleasepool {
    
    ManualLocalizationWorker.overrideCurrentLocal()
    
    UIApplicationMain(Process.argc, Process.unsafeArgv, nil, NSStringFromClass(AppDelegate))
}