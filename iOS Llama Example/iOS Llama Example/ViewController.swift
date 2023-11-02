//
//  ViewController.swift
//  iOS Llama Example
//
//  Created by david Chiu on 10/30/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var topicsText: UITextField!
    let modelName = "mistral-7b-instruct-v0.1.Q4_K_M.gguf"
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        topicsText.delegate = self
        
        copyModel(modelName)
    }
    
    func copyModel(_ name: String) {
        //let fileUrl: URL = Bundle.main.url(forResource: "models/" + name, withExtension: ".gguf")!
        copyFilesFromBundleToDocumentsFolderWith(fileExtension: ".gguf")
    }

    @IBAction func topicsTextReady(_ sender: Any) {
    }
    @IBAction func submit(_ sender: Any) {
        //if topicsText.hasText {
            LlamaCpp.start(UnsafePointer<Int8>(topicsText.text!))
        //}
    }
    
}


extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        /*self.scrollEnabled = true
         self.athenaEyeControl.enableAutoScrolling(true)
         self.eyeTrackingDisabled = false*/
        
        topicsText.resignFirstResponder()
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //if topicsText.hasText {
            submit(topicsText!)
        //}

    }
}
