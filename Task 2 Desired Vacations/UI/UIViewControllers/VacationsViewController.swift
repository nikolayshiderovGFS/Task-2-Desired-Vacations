//
//  ViewController.swift
//  Task 2 Desired Vacations
//
//  Created by Nikolay Shiderov on 27.10.21.
//

import UIKit
import CoreData

var VacationsVC = VacationsViewController()
class VacationsViewController: UITableViewController, AddVacationTableViewControllerDelegate {
    func addVacationTableViewControllerDidCancel(_ controller: AddVacationTableViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func addVacationTableViewController(_ controller: AddVacationTableViewController, didFinishAdding item: DesiredVacation) {
        let newRowIndex = items.count
        items.append(item)
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        navigationController?.popViewController(animated: true)
    }
    
    func addVacationTableViewController(_ controller: AddVacationTableViewController, didFinishEditing item: DesiredVacation) {
        if let index = items.firstIndex(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                let labelVacationName = cell.viewWithTag(1000) as! UILabel
                labelVacationName.text = item.name
                let labelHotelName = cell.viewWithTag(2000) as! UILabel
                labelHotelName.text = item.hotelName
            }
            navigationController?.popViewController(animated: true)
        }
    }
    
    var items = [DesiredVacation]()
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
//        tableView.delegate = self
//        tableView.dataSource = self
        fetchVacations()
    }
        
    func fetchVacations() {
        do {
            self.items = try context.fetch(DesiredVacation.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch let error {
            print(error)
        }
    }
    
    @IBAction func addVacation(_ sender: Any) {
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let vc = AddVacationTableViewController()
//        vc.isEdit = true
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "vacationsCell", for: indexPath) as! VacationCell
        let desiredVacation = self.items[indexPath.row]
        let labelVacationName = cell.viewWithTag(1000) as! UILabel
        labelVacationName.text = desiredVacation.name
        let labelHotelName = cell.viewWithTag(2000) as! UILabel
        labelHotelName.text = desiredVacation.hotelName
        let vacationImage = cell.viewWithTag(3000) as! UIImageView
        if let img = desiredVacation.image {
            vacationImage.image = UIImage(data: img, scale:1.0)
        }
        cell.setData()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            let vacationToRemove = self.items[indexPath.row]
            self.context.delete(vacationToRemove)
            do {
                try self.context.save()
            } catch let error {
                print(error)
            }
            self.fetchVacations()
        }
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addVacation" {
            let controller = segue.destination as! AddVacationTableViewController
            controller.delegate = self
        } else if segue.identifier == "editVacation" {
            let controller = segue.destination as! AddVacationTableViewController
            controller.delegate = self
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.itemToEdit = items[indexPath.row]
            }
        }

    }

}

