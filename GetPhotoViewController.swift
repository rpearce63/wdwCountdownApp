//
//  GetPhotoViewController.swift
//  WDWCountdownTimer
//
//  Created by Rick on 8/1/17.
//  Copyright © 2017 Apple Inc. All rights reserved.
//

import UIKit



class GetPhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    var isParks : Bool = false
    var backgroundImage : UIImage?
    var iconImage : UIImage?
    var tappedImageIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = iconImage
        backgroundImageView.image = backgroundImage
        
        // Do any additional setup after loading the view.
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
        
        let backgroundTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(backgroundImageTapped(backgroundTapGestureRecognizer:)))
        backgroundImageView.isUserInteractionEnabled = true
        backgroundImageView.addGestureRecognizer(backgroundTapGestureRecognizer)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            if tappedImageIndex == 0 {
                imageView.image = editedImage
                iconImage = editedImage
            } else {
                backgroundImageView.image = editedImage
                backgroundImage = editedImage
            }
        }
        picker.dismiss(animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func showPhotoPicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        present(imagePicker, animated: true, completion: nil)
    }

     func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        tappedImageIndex = 0
        showPhotoPicker()
        
    }
    
    func backgroundImageTapped(backgroundTapGestureRecognizer: UITapGestureRecognizer) {
        tappedImageIndex = 1
        showPhotoPicker()
    }

    @IBAction func ResetButtonTapped(_ sender: UIButton) {
        imageView.image = (isParks ? UIImage(named:"WDWCastle") : UIImage(named:"dcl-logo"))!
        iconImage = imageView.image
        backgroundImageView.image = (isParks ? UIImage(named:"wdw-row-background") : UIImage(named:"dcl-row-background"))!
        backgroundImage = backgroundImageView.image
    }
}
