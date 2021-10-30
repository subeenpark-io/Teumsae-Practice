//
//  RecordingViewController.swift
//  Teumsae
//
//  Created by Subeen Park on 2021/10/30.
//
// Reference: https://blckbirds.com/post/voice-recorder-app-in-swiftui-1/

import UIKit
import AVFoundation
import RxCocoa
import RxSwift

class RecordingViewController: UIViewController {
    
    var recordings = [Recording]()
    var recording = false
    
    // AVFoundation
    var audioRecorder: AVAudioRecorder!
    
    // RxSwift
    let disposeBag = DisposeBag()
    
    // UI
    @IBOutlet weak var recordButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        bindButtonRx()
    }
    
    
    func startRecording() {
        
        let recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
        } catch {
            print("Failed to set up recording session")
        }

        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let audioFilename = documentPath.appendingPathComponent("\(Date().toString(dateFormat: "dd-MM-YY_'at'_HH:mm:ss")).m4a")
        
        let settings = [
//                    AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
//                    AVFormatIDKey: Int(kAudioFormatFLAC),
                    AVFormatIDKey: Int(kAudioFormatLinearPCM),
                    AVSampleRateKey: 12000,
                    AVNumberOfChannelsKey: 1,
                    AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
                ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.record()
            recording = true
        } catch {
            print("Could not start recording")
        }
        
    }
    
    func stopRecording() {
        audioRecorder.stop()
        recording = false
        fetchRecordings()
    }

    func fetchRecordings() {
        recordings.removeAll()
        
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryContents = try! fileManager.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil)
        for audio in directoryContents {
            let recording = Recording(fileURL: audio, createdAt: getCreationDate(for: audio))
            recordings.append(recording)
        }
        
        recordings.sort(by: { $0.createdAt.compare($1.createdAt) == .orderedAscending})
    }
    
    func getCreationDate(for file: URL) -> Date {
        if let attributes = try? FileManager.default.attributesOfItem(atPath: file.path) as [FileAttributeKey: Any],
            let creationDate = attributes[FileAttributeKey.creationDate] as? Date {
            return creationDate
        } else {
            return Date()
        }
    }
    
    // MARK - UI/RX
    func bindButtonRx() {
        recordButton.rx.tap.bind { [weak self] in
            
            guard let `self` = self else { return }
            
            if self.recording {
                print("Stop Recording")
                self.stopRecording()
                self.recordButton.setImage(UIImage(systemName: "circle.fill"), for: .normal)
            }
            else {
                print("Start Recording")
                self.startRecording()
                self.recordButton.setImage(UIImage(systemName: "stop.fill"), for: .normal)
            }
            
        }.disposed(by: disposeBag)
        

        
    }

}
