//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Andrew Jackson on 20/08/2017.
//  Copyright © 2017 Jacko1972. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder!
    
    @IBOutlet var recordingLabel: UILabel!
    @IBOutlet var recordButton: UIButton!
    @IBOutlet var stopRecordingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButton.isEnabled = false
    }
    // MARK: - Record Audio
    @IBAction func recordAudio(_ sender: Any) {
        
        configureUI(recording: true)
        // create file and filepath
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        // start session
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        // Create audio recorder, set delegate and start recording
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    // MARK: - Stop Recording
    @IBAction func stopRecording(_ sender: Any) {
        configureUI(recording: false)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    // MARK: - Configure UI
    func configureUI(recording flag: Bool) {
            recordingLabel.text = flag ? "Recording In Progress!" : "Tap to Record"
            stopRecordingButton.isEnabled = flag
            recordButton.isEnabled = !flag
    }
    // MARK: - Recording Finished
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        guard flag else {
            let alert = UIAlertController(title: "Error", message: "Recording Failed! Try Again!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default))
            self.present(alert, animated: true, completion: nil)
            return
        }
        performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        
    }
    // MARK: - Prepare For Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Confirm the correct segue is called
        if segue.identifier == "stopRecording" {
            // get next view controller and assign audio file url to its recordedAudioURL variable
            let platSoundsVC = segue.destination as! PlaySoundsViewController
            let recordAudioURL = sender as! URL
            platSoundsVC.recordedAudioURL = recordAudioURL
        }
    }
}






