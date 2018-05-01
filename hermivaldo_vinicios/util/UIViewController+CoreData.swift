//
//  UIViewController+CoreData.swift
//  hermivaldo_vinicios
//
//  Created by hermivaldo braga on 01/05/2018.
//  Copyright © 2018 fiap. All rights reserved.
//

import Foundation
import CoreData
import UIKit

extension UIViewController {
    
    var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    var context: NSManagedObjectContext {
        return appDelegate.persistentContainer.viewContext
    }
    
}
