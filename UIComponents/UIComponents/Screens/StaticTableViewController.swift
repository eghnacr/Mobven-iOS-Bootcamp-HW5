//
//  StaticTableViewController.swift
//  UIComponents
//
//  Created by Semih Emre ÜNLÜ on 8.01.2022.
//

import UIKit

class StaticTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem


//        self.title = dataManager.hasUserLaunchedApp ? "Welcome Back!" : "Welcome!"
//        dataManager.hasUserLaunchedApp = true

//        let synchronize = UserDefaults.standard.synchronize()
//        print(synchronize)

        let myClass = MyClass()
        guard let encodedData = try? JSONEncoder().encode(myClass) else { return }
        UserDefaults.standard.set(encodedData, forKey: "someKey")

        guard let shouldDecodeData = UserDefaults.standard.data(forKey: "someKey") else { return }
        guard let decodedData =  try? JSONDecoder().decode(MyClass.self, from: shouldDecodeData) else { return }

    }

    private var dataManager: LocalDataProtocol!

}
