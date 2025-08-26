//
//  SpeechToTextManager.swift
//  Backpacker
//
//  Created by Mobile on 06/08/25.
//

import Foundation
import Speech
import AVFoundation

class SpeechToTextManager: NSObject {
    
    private let audioEngine = AVAudioEngine()
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    
    var onResult: ((String) -> Void)?
    var onError: ((Error) -> Void)?
    // -Speaking state
      private(set) var isSpeaking: Bool = false {
          didSet {
              onSpeakingChanged?(isSpeaking)
          }
      }
      
      var onSpeakingChanged: ((Bool) -> Void)?
      
      override init() {
          super.init()
          requestPermissions()
      }
      
      func requestPermissions() {
          SFSpeechRecognizer.requestAuthorization { status in
              switch status {
              case .authorized:
                  print("Speech recognition authorized")
              case .denied, .restricted, .notDetermined:
                  print("Speech recognition not available")
              @unknown default:
                  break
              }
          }
          
          AVAudioSession.sharedInstance().requestRecordPermission { granted in
              if !granted {
                  print("Microphone access denied")
              }
          }
      }

      func startRecording() {
          guard SFSpeechRecognizer.authorizationStatus() == .authorized else {
              print("Speech recognition not authorized")
              return
          }

          let audioSession = AVAudioSession.sharedInstance()
          do {
              try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
              try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
          } catch {
              onError?(error)
              return
          }

          recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
          guard let recognitionRequest = recognitionRequest else {
              onError?(NSError(domain: "SpeechError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unable to create recognition request"]))
              return
          }

          let inputNode = audioEngine.inputNode
          recognitionRequest.shouldReportPartialResults = true

          recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { result, error in
              if let result = result {
                  self.onResult?(result.bestTranscription.formattedString)
              }

              if let error = error {
                  self.stopRecording()
                  self.onError?(error)
              }
          }

          let recordingFormat = inputNode.outputFormat(forBus: 0)
          inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
              
              self.recognitionRequest?.append(buffer)
              
              // 🎤 Detect voice activity based on average power
              self.detectSpeaking(buffer: buffer)
          }

          audioEngine.prepare()

          do {
              try audioEngine.start()
          } catch {
              onError?(error)
          }
      }

      private func detectSpeaking(buffer: AVAudioPCMBuffer) {
          guard let channelData = buffer.floatChannelData?[0] else { return }
          let channelDataArray = Array(UnsafeBufferPointer(start: channelData, count: Int(buffer.frameLength)))
          
          let rms = sqrt(channelDataArray.map { $0 * $0 }.reduce(0, +) / Float(buffer.frameLength))
          let avgPower = 20 * log10(rms)
          
          // 🎯 Threshold: Adjust based on environment
          let speakingThreshold: Float = -40.0
          
          let currentlySpeaking = avgPower > speakingThreshold
          if currentlySpeaking != isSpeaking {
              isSpeaking = currentlySpeaking
          }
      }

      func stopRecording() {
          audioEngine.stop()
          recognitionRequest?.endAudio()
          audioEngine.inputNode.removeTap(onBus: 0)
          recognitionTask?.cancel()
          recognitionTask = nil
          isSpeaking = false
      }

      func reset() {
          stopRecording()
          recognitionRequest = nil
          recognitionTask = nil
      }
}
