//
//  MenuItemModel.swift
//  OwnerApp
//
//  Created by Star Developer on 5/11/16.
//  Copyright © 2016 Adam. All rights reserved.
//

import UIKit

class MenuItemModel: NSObject {
    var title: String
    var icon: String
    init(title: String, icon: String)
    {
        self.title = title
        self.icon = icon
    }
}
