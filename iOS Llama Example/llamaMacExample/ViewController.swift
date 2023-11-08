//
//  ViewController.swift
//  llamaMacExample
//
//  Created by david Chiu on 11/3/23.
//

import Cocoa

class ViewController: NSViewController {
    @IBOutlet weak var topicstext: NSTextField!
    
    @IBOutlet weak var submitButton: NSButton!
    @IBOutlet var answerText: NSTextView!
    @IBOutlet weak var questionText: NSTextField!
    let modelName = "mistral-7b-instruct-v0.1.Q4_K_M.gguf"
    
    var llamaWrapper: LlamaCppWrapper!
    
    override func viewDidLoad() {
        llamaWrapper = LlamaCppWrapper()
        llamaWrapper.loadModel(modelName)
        llamaWrapper.delegate = self
        super.viewDidLoad()
        copyFilesFromBundleToDocumentsFolderWith(fileExtension: ".gguf")

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    @IBAction func submit(_ sender: Any) {
        //self.startChat(sender)
    }
    
    @objc
    func llamaCallback(_ chatReply: UnsafePointer<CChar>?) -> Void {
        DispatchQueue.main.async {
            if let reply = chatReply {
                print("- \(String( cString: reply))")
                self.answerText.string = String( cString: reply)
            }
        }
    }
    //T##((UnsafePointer<CChar>?) -> Void)?##((UnsafePointer<CChar>?) -> Void)?##(UnsafePointer<CChar>?) -> Void
    
    @IBAction func startChat(_ sender: Any) {
        let questionStr = self.questionText.stringValue
        self.submitButton.isEnabled = false
        DispatchQueue.global(qos: .userInitiated).async {
            
            self.llamaWrapper.chat(questionStr, response: self.llamaCallback(_:))
            /*sample parameters:
             const char args_const[6][128]={" ./main", "-m", "models/mistral-7b-instruct-v0.1.Q4_K_M.gguf", "-p", "what date is today", "-e"};
             */
        }
    }
    
}

extension ViewController: LlamaCppWrapperDelegate {
    func replyEnd() {
        DispatchQueue.main.async {
            self.submitButton.isEnabled = true
        }
    }
}
