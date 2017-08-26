//
//  RecordSoundsVC.swift
//  PitchPerfect
//
//  Created by Jarvis on 8/22/17.
//  Copyright © 2017 Steven Santiago. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsVC: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder!
    //Used for configureUI
    let RECORDING = true
    let NOT_RECORDING = false
    
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordButton.isEnabled = false
    }
    
    
    @IBAction func recordAudio(_ sender: UIButton) {
        configureUI(RECORDING)
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        print(filePath!)
        
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    @IBAction func stopRecording(_ sender: UIButton) {
        configureUI(NOT_RECORDING)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
        performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            // Will add alert to user(Code snippet modified from PlaySoundsVC+Audio.swift
            let alert = UIAlertController(title: "Alert", message: "Recording not succesful", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Click", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    func configureUI(_ recordState: Bool) {
        recordButton.isEnabled = !recordState //if recordState is true then recordButton.isEnabled = false(!true)
        stopRecordButton.isEnabled = recordState
        recordingLabel.text = recordState ? "Recording in Progress" : "Tap to Record"
    }
    

    // Prepares to pass URL to next view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundVC = segue.destination as! PlaySoundsVC
            let recordedAudioURL = sender as! URL
            playSoundVC.recorderAudioURL = recordedAudioURL
        }
    }
}

