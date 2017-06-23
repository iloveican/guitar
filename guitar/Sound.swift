//
//  Sound.swift
//  AVFoundationMIDIPlay
//
//  Created by Gene De Lisa on 1/12/16.
//  Copyright © 2016 Gene De Lisa. All rights reserved.
//

import Foundation
import AVFoundation

class Sound {
    
    var midiPlayer:AVMIDIPlayer!
    
    var timer:Timer?
    
    init() {
        createAVMIDIPlayerFromMIDIFIle()
    }
    
    func createAVMIDIPlayerFromMIDIFIle() {
        
        guard let midiFileURL = Bundle.main.url(forResource: "sibeliusGMajor", withExtension: "mid") else {
            fatalError("\"sibeliusGMajor.mid\" file not found.")
        }
        
        guard let bankURL = Bundle.main.url(forResource: "GeneralUser GS MuseScore v1.442", withExtension: "sf2") else {
            fatalError("\"GeneralUser GS MuseScore v1.442.sf2\" file not found.")
        }
        
        do {
            try self.midiPlayer = AVMIDIPlayer(contentsOf: midiFileURL, soundBankURL: bankURL)
            print("created midi player with sound bank url \(bankURL)")
        } catch let error as NSError {
            print("Error \(error.localizedDescription)")
        }
        
        self.midiPlayer.prepareToPlay()
        self.midiPlayer.rate = 1.0 // default
        
        print("Duration: \(midiPlayer.duration)")
    }
    
    func createAVMIDIPlayerFromMIDIFIleDLS() {
        
        guard let midiFileURL = Bundle.main.url(forResource: "sibeliusGMajor", withExtension: "mid") else {
            fatalError("\"sibeliusGMajor.mid\" file not found.")
        }
        
        guard let bankURL = Bundle.main.url(forResource: "gs_instruments", withExtension: "dls") else {
            fatalError("\"gs_instruments.dls\" file not found.")
        }
        
        do {
            try self.midiPlayer = AVMIDIPlayer(contentsOf: midiFileURL, soundBankURL: bankURL)
            print("created midi player with sound bank url \(bankURL)")
        } catch let error as NSError {
            print("Error \(error.localizedDescription)")
        }
        
        self.midiPlayer.prepareToPlay()

    }
    
    func play() {
        startTimer()
        self.midiPlayer.play({
            print("finished")
            self.midiPlayer.currentPosition = 0
            self.timer?.invalidate()
        })
    }
    
    func stopPlaying() {
        if midiPlayer.isPlaying {
            midiPlayer.stop()
            self.timer?.invalidate()
        }
    }
    
    func togglePlaying() {
        if midiPlayer.isPlaying {
            stopPlaying()
        } else {
            play()
        }
    }
    
    @objc func updateTime() {
        print("\(midiPlayer.currentPosition)")
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.1,
            target:self,
            selector: #selector(Sound.updateTime),
            userInfo:nil,
            repeats:true)
    }
    
}

