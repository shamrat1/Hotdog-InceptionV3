//
//  ViewController.swift
//  HotdogOrNot
//
//  Created by Yasin Shamrat on 25/2/20.
//  Copyright © 2020 Yasin Shamrat. All rights reserved.
//

import UIKit
import Vision
import CoreML

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var imagePickerController = UIImagePickerController()
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = true
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = userPickedImage
            imageView.contentMode = .scaleAspectFit
            
            guard let convertedImage = CIImage(image: userPickedImage) else {
                fatalError("Failed converting User Picked Image.")
            }
            detect(image: convertedImage)
        }
        imagePickerController.dismiss(animated: true, completion: nil)
    }
    
    func detect(image: CIImage){
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("Failed initializing CoreML model.")
        }
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("Failed initializing model request results.")
            }
            print("================================================================================")
            print(results.first)
            
            if let firstResult = results.first {
                if firstResult.identifier.contains("hotdog"){
                    self.navigationItem.title = "HotDog"
                    self.navigationController?.navigationBar.backgroundColor = .green
                }else{
                    self.navigationItem.title = "Not HotDog"
                    self.navigationController?.navigationBar.backgroundColor = .red
                }
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try handler.perform([request])
        } catch  {
            print(error)
        }
    }
    
    
    @IBAction func onClickImagePickerBarBtn(_ sender: UIBarButtonItem) {
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
}

