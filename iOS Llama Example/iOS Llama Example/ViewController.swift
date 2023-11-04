//
//  ViewController.swift
//  iOS Llama Example
//
//  Created by david Chiu on 10/30/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var chatText: UITextView!
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
    
    @objc
    func llamaCallback(_ chatReply: UnsafePointer<CChar>?) -> Void {
        DispatchQueue.main.async {
            if let reply = chatReply {
                print("- \(String( cString: reply))")
                self.chatText.text = String( cString: reply)
            }
        }
    }

    @IBAction func submit(_ sender: Any)  {
        let question = UnsafePointer<Int8>(self.topicsText.text!)
        //submitButton.isEnabled = false
        //if topicsText.hasText {
        DispatchQueue.global(qos: .userInitiated).async {
            LlamaCpp.start(question, completion: self.llamaCallback(_:))
        }
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
