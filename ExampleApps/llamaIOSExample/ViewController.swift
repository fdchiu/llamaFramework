//
//  ViewController.swift
//  iOS Llama Example
//
//  Created by david Chiu on 10/30/23.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers

class ViewController: UIViewController {
    

    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var chatText: UITextView!
    @IBOutlet weak var topicsText: UITextField!
    @IBOutlet weak var modelNameText: UILabel!
    var modelName: String? {
        didSet {
            UserDefaults.standard.setValue(modelName, forKey: "modelPath")
        }
    } //= "mistral-7b-instruct-v0.1.Q4_K_M.gguf"
    var llamaWrapper: LlamaCppWrapper!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        modelName = UserDefaults.standard.string(forKey: "modelPath")

        // Do any additional setup after loading the view.
        llamaWrapper = LlamaCppWrapper()
        if modelName != nil {            
            llamaWrapper.loadModel(modelName)
            if let fileUrl = NSURL(string: modelName!) , fileUrl.lastPathComponent != nil {
                self.modelNameText.text = fileUrl.lastPathComponent!
            }
            submitButton.isEnabled = true
        } else {
            submitButton.isEnabled = false
        }
        llamaWrapper.delegate = self
    topicsText.delegate = self
        
        //copyModel(modelName)
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
        let question = self.topicsText.text //UnsafePointer<Int8>(self.topicsText.text!)
        self.submitButton.isEnabled = false
        DispatchQueue.global(qos: .userInitiated).async {
            self.llamaWrapper.chat(question, response: self.llamaCallback(_:))
        }
    }
    
    @IBAction func selectModel(_ sender: Any) {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.item], asCopy: false)
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .formSheet

        self.present(documentPicker, animated: true, completion: nil)
    }
    @IBAction func download(_ sender: Any) {
        if let url = URL(string: "https://huggingface.co/TheBloke/Mistral-7B-v0.1-GGUF/blob/main/mistral-7b-v0.1.Q4_K_M.gguf") {
            UIApplication.shared.open(url)
        }

    }
    @IBAction func showCreataAIHelp(_ sender: Any) {
        if let url = URL(string: "https://creataai.com/llamaframework") {
            UIApplication.shared.open(url)
        }

    }

    @IBAction func showLlamaCppSite(_ sender: Any) {
        if let url = URL(string: "https://github.com/ggerganov/llama.cpp") {
            UIApplication.shared.open(url)
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

extension ViewController: LlamaCppWrapperDelegate {
    func replyEnd() {
        DispatchQueue.main.async {
            self.submitButton.isEnabled = true
        }
    }
}

extension ViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        if (!urls.isEmpty) {
            let path: String = urls[0].absoluteString
            self.modelName = path
            llamaWrapper.loadModel(self.modelName)
            self.submitButton.isEnabled = true
            self.modelNameText.text = urls[0].lastPathComponent
        }
     }
}

