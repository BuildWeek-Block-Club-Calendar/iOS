//
//  PlantDetailViewController.swift
//  Plants
//
//  Created by Alexander Supe on 01.02.20.
//

import UIKit

class EventDetailViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - IBOutlets
    // FORM
    @IBOutlet weak var eventImageView: CustomImage!
    @IBOutlet weak var eventImageButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleField: StylizedTextField!
    @IBOutlet weak var titleSeperator: UIView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var addressField: StylizedTextField!
    @IBOutlet weak var addressSeperator: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionField: StylizedTextField!
    @IBOutlet weak var descriptionSeperator: UIView!
    @IBOutlet weak var urlField: StylizedTextField!
    
    // BUTTONS
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: CustomButton!
    @IBOutlet weak var deleteButton: CustomButton!
    
    // MARK: - Properies
    var event: Event?
//    var eventController = EventController.shared
    var creating = true
    var currentlyEditing = false
    let imagePC = UIImagePickerController()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleField.delegate = self
        addressField.delegate = self
        descriptionField.delegate = self
        urlField.delegate = self
        imagePC.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
        if let event = event {
//            titleField.text = event.name
//            addressField.text = event.address
//            descriptionField.text = event.description
            //set dates
//            urlField.text = event.url
//            if let image = event.image { imageView.image = UIImage(data: image) }
            creating = false
        }
        
        currentlyEditing = false
        eventImageButton.isHidden = true
        if creating { createMode() }
        else { viewMode() }
    }
    
    // MARK: - Modes
    func createMode() {
        editMode()
        deleteButton.isHidden = true
    }
    
    func editMode() {
        //check for rights before entering
        editButton.isEnabled = false
        editButton.tintColor = .clear
        saveButton.isHidden = false
        eventImageButton.isHidden = false
        deleteButton.isHidden = false
    }
    
    func viewMode() {
        editButton.isEnabled = true
        editButton.tintColor = .systemBlue
        saveButton.isHidden = true
        eventImageButton.isHidden = true
        deleteButton.isHidden = true
    }
    
    // MARK: - IBActions
    @IBAction func edit(_ sender: Any) {
        currentlyEditing = true
        editMode()
    }
    
    
    @IBAction func deletePressed(_ sender: Any) {
        if let event = event {
//            eventController.delete(event)
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func imageButton(_ sender: Any) {
        imagePC.allowsEditing = true
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default , handler: { (sction: UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.imagePC.sourceType = .camera
                self.present(self.imagePC, animated: true, completion: nil) }
            else { print("Camera not available") } }))
        actionSheet.addAction(UIAlertAction(title: "Photo Libary", style: .default , handler: { (sction: UIAlertAction) in
            self.imagePC.sourceType = .photoLibrary
            self.present(self.imagePC, animated: true, completion: nil) }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true)
    }
    
    @IBAction func saveButton(_ sender: Any) {
        save()
    }
    
    // MARK: - ImagePickerController
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        eventImageView.image = image
        dismiss(animated: true, completion: nil)
        eventImageButton.isHidden = true
    }
    
    // MARK: - Helper Methods
    private func save() {
        guard let title = titleField.text, let address = addressField.text, let desc = descriptionField.text else { return }
        guard !title.isEmpty else { titleSeperator.backgroundColor = .systemRed; titleLabel.textColor = .systemRed; return }
        guard !address.isEmpty else { addressSeperator.backgroundColor = .systemRed; addressLabel.textColor = .systemRed; return }
        guard !desc.isEmpty else { descriptionSeperator.backgroundColor = .systemRed; descriptionLabel.textColor = .systemRed; return }
        currentlyEditing = false
        viewMode()
        if creating{
//            newPlantController.create(newPlant: NewPlant(nickname: name, id: UUID(), wateredDate: Date(), image: imageView?.image?.pngData() ?? Data(), location: loc, h2oFrequency: Double(freq) ?? 7)) {_ in
//                self.navigationController?.popViewController(animated: true)
//            }} else {
//            newPlantController.update(newPlant!, nickname: name, location: loc, wateredDate: newPlant?.wateredDate, image: imageView?.image?.pngData() ?? Data(), h2oFrequency: Double(freq) ?? 7)
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if titleField.isFirstResponder || addressField.isFirstResponder || descriptionField.isFirstResponder { return }
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 { self.view.frame.origin.y -= keyboardSize.height }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 { self.view.frame.origin.y = 0 }
    }
    
    // MARK: - TextFieldDelegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if currentlyEditing || creating {
            return true
        } else { return false }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
