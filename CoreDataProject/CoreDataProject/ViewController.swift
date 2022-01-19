//
//  ViewController.swift
//  CoreDataProject
//
//  Created by Semih Emre ÜNLÜ on 16.01.2022.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    var entites: [PersonEntitiy] = []

    @IBAction func fetchAllButtonTapped(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let persistantContainer = appDelegate.persistentContainer
        let context = persistantContainer.viewContext

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PersonEntity")

        do {
            entites = try! context.fetch(fetchRequest) as! [PersonEntitiy]
            print(entites.count)
            print(entites.first?.name)
        } catch {
            //handle error
        }
    }

    @IBAction func addButtonTapped(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let persistantContainer = appDelegate.persistentContainer
        let context = persistantContainer.viewContext

        let entity = PersonEntitiy(context: context)
        entity.name = "Semih"

        appDelegate.saveContext()
    }

    @IBAction func deleteButtonTapped(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let persistantContainer = appDelegate.persistentContainer
        let context = persistantContainer.viewContext

        guard let firstEntity = entites.first else { return }
        context.delete(firstEntity)
    }
}

