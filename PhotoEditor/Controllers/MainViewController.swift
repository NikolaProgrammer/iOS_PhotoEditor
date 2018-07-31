//
//  MainViewController.swift
//  PhotoEditor
//
//  Created by Nikolay Sereda on 24.07.2018.
//  Copyright © 2018 Nikolay Sereda. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    //MARK: Properties
    private var image: UIImage?

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let image = image {
            let destination = segue.destination as! PhotoEditorViewController
            destination.imageForEditing = image
        }
    }
    
    //MARK: Actions
    @IBAction func chooseImageButtonTapped(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
}

extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        image = info[UIImagePickerControllerOriginalImage] as? UIImage
        dismiss(animated: true)
        self.performSegue(withIdentifier: "editImage", sender: self)
        
    }
}
