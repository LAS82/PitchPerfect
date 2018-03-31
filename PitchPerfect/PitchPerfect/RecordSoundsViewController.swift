//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Leandro Alves Santos on 26/03/18.
//  Copyright © 2018 Leandro Alves Santos. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    // MARK: - Outlet properties
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    // MARK: - Other properties
    var audioRecorder: AVAudioRecorder!
    
    // MARK: - Controller Overrides
    
    //Sets screen's initial state
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureScreen(initialState: true)
    }
    
    // MARK: - Navigation functions
    
    //Navigates to PlaySoundsViewController
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }
    }
    
    //Prepares to navigate to PlaySoundsViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    
    // MARK: - Action functions
    
    //Records an audio
    @IBAction func recordAudio(_ sender: Any) {
        
        let filePath = configureAudioPath()
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
        configureScreen(initialState: false)
    }
    
    //Stops the recording
    @IBAction func stopRecording(_ sender: Any) {
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
        configureScreen(initialState: true)
    }
    
    
    // MARK: - Configuration Functions
    
    //Configures the screen to it's initial state or recording state
    func configureScreen(initialState: Bool) {
        recordButton.isEnabled = initialState
        stopRecordingButton.isEnabled = !initialState
        
        recordingLabel.text = initialState ? "Tap to Record" : "Recording in Progress"
    }
    
    //Returns the audio file path
    func configureAudioPath() -> URL {
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        
        return URL(fileURLWithPath: pathArray.joined(separator: "/"))
    }
    
}

