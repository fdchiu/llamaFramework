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
    @IBOutlet weak var modelNameText: NSTextField!
    
    var modelName: String? {//mistral-7b-instruct-v0.1.Q4_K_M.gguf"
        didSet {
            UserDefaults.standard.setValue(modelName, forKey: "modelPath")
        }
    }
    
    var llamaWrapper: LlamaCppWrapper!
    
    override func viewDidLoad() {
        modelName = UserDefaults.standard.string(forKey: "modelPath")
        llamaWrapper = LlamaCppWrapper()
        if modelName != nil {
            llamaWrapper.loadModel(modelName)
            if let fileUrl = NSURL(string: modelName!) , fileUrl.lastPathComponent != nil {
                self.modelNameText.stringValue = fileUrl.lastPathComponent!
            }

            submitButton.isEnabled = true
        } else {
            submitButton.isEnabled = false
        }
        llamaWrapper.delegate = self
        super.viewDidLoad()
        //copyFilesFromBundleToDocumentsFolderWith(fileExtension: ".gguf")

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
    @IBAction func selectModel(_ sender: Any) {
        if let modelPath = filePicker(fileExtension: ["gguf"]) {
            self.modelName = modelPath
            if let fileUrl = NSURL(string: modelPath) , fileUrl.lastPathComponent != nil {
                self.modelNameText.stringValue = fileUrl.lastPathComponent!
            }
            
            llamaWrapper.loadModel(modelPath)
            self.submitButton.isEnabled = true
            print("\(modelPath)")
        }
    }
    @IBAction func download(_ sender: Any) {
        if let url = URL(string: "https://huggingface.co/TheBloke/Mistral-7B-v0.1-GGUF/blob/main/mistral-7b-v0.1.Q4_K_M.gguf") {
            NSWorkspace.shared.open(url)
        }
    }
    
    @IBAction func showCreataAIHelp(_ sender: Any) {
        if let url = URL(string: "https://creataai.com/llamaframework") {
            NSWorkspace.shared.open(url)
        }

    }
    @IBAction func llamaCPPHelp(_ sender: Any) {
    }
}

extension ViewController: LlamaCppWrapperDelegate {
    func replyEnd() {
        DispatchQueue.main.async {
            self.submitButton.isEnabled = true
        }
    }
}
