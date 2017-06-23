//
//  MIDISampler.swift
//  AVFoundationMIDIPlay
//
//  Created by Gene De Lisa on 1/12/16.
//  Copyright © 2016 Gene De Lisa. All rights reserved.
//

import Foundation
import AVFoundation

class MIDISampler {
    
    var soundbank:URL!
    var engine:AVAudioEngine!
    var sampler:AVAudioUnitMIDISynth!//AVAudioUnitSampler!
    
    let melodicBank = UInt8(kAUSampler_DefaultMelodicBankMSB)
    let defaultBankLSB = UInt8(kAUSampler_DefaultBankLSB)
    
    /// general midi number for marimba
    let gmMarimba = UInt8(12)
    let gmHarpsichord = UInt8(1)
    
    init() {
        initAudioEngine()
        print("melodicBank=\(melodicBank)")
        print("defaultBankLSB=\(defaultBankLSB)")
    }
    
    func initAudioEngine () {
//        
//        engine = AVAudioEngine()
//
//        sampler = AVAudioUnitSampler()
//        engine.attach(sampler)
//        
//        engine.connect(sampler, to: engine.mainMixerNode, format: nil)
//        
//        startEngine()
//        loadPatch(gmHarpsichord)
        
        engine = AVAudioEngine()
        
        
        sampler = AVAudioUnitMIDISynth()
        
        if let bankURL = Bundle.main.url(forResource: "FluidR3 GM2-2", withExtension: "SF2", subdirectory: "sound resources")  {
            sampler.loadMIDISynthSoundFont(bankURL)
            print("loading from url")
        } else {
            sampler.loadMIDISynthSoundFont()
        }
        
        engine.attach(sampler)
        engine.connect(sampler, to: engine.mainMixerNode, format: nil)
        startEngine()
        do {
            try sampler.loadPatches()
        } catch AVAudioUnitMIDISynthError.engineNotStarted {
            print("Start the engine first!")
            fatalError("setting patches")
        } catch let e as NSError {
            print("\(e)")
            print("\(e.localizedDescription)")
            fatalError("setting patches")
        }
    }
    
    func startEngine() {
        
        if engine.isRunning {
            print("audio engine already started")
            return
        }
        
        do {
            try engine.start()
            print("audio engine started")
        } catch {
            print("oops \(error)")
            print("could not start audio engine")
        }
    }
    
   
    func loadPatch(_ gmpatch:UInt8, channel:UInt8 = 0) {
        
//        soundbank =
//            Bundle.main.url(forResource: "FluidR3 GM2-2", withExtension: "SF2", subdirectory: "sound resources")
//        
//        do {
//            try sampler.loadSoundBankInstrument(at: soundbank, program:gmpatch,
//                bankMSB: melodicBank, bankLSB: defaultBankLSB)
//            
//        } catch let error as NSError {
//            print("\(error.localizedDescription)")
//            return
//        }
    }
    
    func noteChanged(_ isOn:Bool, key:UInt8, vel:UInt8, prog:UInt8, channel:UInt8 = 0) {
        if prog <= 127 {
//            do {
//                try sampler.loadSoundBankInstrument(at: soundbank, program:prog,
//                                                    bankMSB: melodicBank, bankLSB: defaultBankLSB)
//                
//            } catch let error as NSError {
//                print("\(error.localizedDescription)")
//                return
//            }
            self.sampler.sendProgramChange(UInt8(prog), onChannel: channel)
        }
        if (isOn) {sampler.startNote(key, withVelocity: vel, onChannel: channel)}
        else {sampler.stopNote(key, onChannel: channel)}
    }
    
    func hstop() {
        self.sampler.stopNote(65, onChannel: 0)
    }
    
    func mstart() {
        loadPatch(gmMarimba, channel:1)
        self.sampler.startNote(65, withVelocity: 64, onChannel: 1)
    }
    
    func mstop() {
        self.sampler.stopNote(65, onChannel: 1)
    }
    
}

