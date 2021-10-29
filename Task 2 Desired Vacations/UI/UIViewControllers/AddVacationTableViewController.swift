//
//  AddVacationTableViewController.swift
//  Task 2 Desired Vacations
//
//  Created by Nikolay Shiderov on 27.10.21.
//

import UIKit
import CoreData
import NotificationCenter

protocol AddVacationTableViewControllerDelegate: AnyObject {
    func addVacationTableViewControllerDidCancel(_ controller: AddVacationTableViewController)
    func addVacationTableViewController(_ controller: AddVacationTableViewController, didFinishAdding item: DesiredVacation)
    func addVacationTableViewController(_ controller: AddVacationTableViewController, didFinishEditing item: DesiredVacation)
}

class AddVacationTableViewController: UITableViewController, UITextFieldDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var textFieldVacationName: UITextField!
    @IBOutlet weak var textFieldHotelName: UITextField!
    @IBOutlet weak var textFieldLocation: UITextField!
    @IBOutlet weak var textFieldMoney: UITextField!
    @IBOutlet weak var textFieldDescription: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBAction func selectImage(_ sender: Any) {
        openImagePicker()
    }
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var imagePicker = UIImagePickerController()
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    weak var delegate: AddVacationTableViewControllerDelegate?
    
    // Necessary for add/edit screen
    var itemToEdit: DesiredVacation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textFieldVacationName.delegate = self
        self.textFieldHotelName.delegate = self
        self.textFieldLocation.delegate = self
        self.textFieldMoney.delegate = self
        self.textFieldDescription.delegate = self
//        self.imageView.delegate
        
        if let item = itemToEdit {
            title = "Edit Vacation"
            textFieldVacationName.text = item.name
            textFieldHotelName.text = item.hotelName
            textFieldLocation.text = item.location
            textFieldMoney.text = item.necessaryMoneyAmount
            textFieldDescription.text = item.hotelDescription
            if let img = item.image {
                imageView.image = UIImage(data: img, scale:1.0)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switchBasedNextTextField(textField)
        return true
    }
    
    func scheduleNotification() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (accessGranted, error) in }
        let content = UNMutableNotificationContent()
        content.title = "HEADS UP!"
        content.body = "This is your conscience speaking. You lose."
        content.sound = UNNotificationSound.default
        let dateComponents = datePicker.calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: datePicker.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    
    // MARK: - Keyboard Next Button functionality
    private func switchBasedNextTextField(_ textField: UITextField) {
        switch textField {
        case self.textFieldVacationName:
            self.textFieldHotelName.becomeFirstResponder()
        case self.textFieldHotelName:
            self.textFieldLocation.becomeFirstResponder()
        case self.textFieldLocation:
            self.textFieldMoney.becomeFirstResponder()
        case self.textFieldMoney:
            self.textFieldDescription.becomeFirstResponder()
        default:
            self.textFieldDescription.resignFirstResponder()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textFieldVacationName.becomeFirstResponder()
    }
    // MARK: -  Cancel Add/Edit Vacation
    @IBAction func cancel(_ sender: Any) {
        delegate?.addVacationTableViewControllerDidCancel(self)
    }
    
    // MARK: - Add/Edit New Vacation Logic
    @IBAction func done(_ sender: Any) {
        if let item = itemToEdit {
            item.name = textFieldVacationName.text
            item.hotelName = textFieldHotelName.text
            item.location = textFieldLocation.text
            item.necessaryMoneyAmount = textFieldMoney.text
            item.hotelDescription = textFieldDescription.text
            let img = self.imageView.image?.pngData()
            item.image = img
            scheduleNotification()

            do {
                try self.context.save()
            } catch let error {
                print(error)
            }
            
            VacationsVC.fetchVacations()
            delegate?.addVacationTableViewController(self, didFinishEditing: item)
        } else {
            let newVacation = DesiredVacation(context: self.context)
            newVacation.name = textFieldVacationName.text
            newVacation.hotelName = textFieldHotelName.text
            newVacation.location = textFieldLocation.text
            newVacation.necessaryMoneyAmount = textFieldMoney.text
            newVacation.hotelDescription = textFieldDescription.text
            let img = self.imageView.image?.pngData()
            newVacation.image = img
            scheduleNotification()
            do {
                try self.context.save()
            } catch let error {
                print(error)
            }
            
            VacationsVC.fetchVacations()
            delegate?.addVacationTableViewController(self, didFinishAdding: newVacation)
        }
    }
}

extension AddVacationTableViewController: UIImagePickerControllerDelegate {
    func openImagePicker() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        if let img = info[.originalImage] as? UIImage {
            self.imageView.image = img
        }
    }
}
