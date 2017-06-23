//
//  MyView.swift
//  guitar
//
//  Created by lazycal on 2017/5/26.
//  Copyright © 2017年 lazycal. All rights reserved.
//

import UIKit

@IBDesignable class MyView: UICollectionView,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, BluetoothDelegate {
    //MARK: Properties
    //2,2,1,2,2,2,1
    //大二度: 2
    //大三度: 4
    //四度: 5
    //纯五度: 7
    //大六度: 9
    //八度: 12
/*"0=Stereo Grand|"+
    "1=Bright Grand|"+
    "2=Electric Grand|"+
    "3=Honky-Tonk|"+
    "4=Tine Electric Piano|"+
    "5=FM Electric Piano|"+
    "6=Harpsichord|"+
    "7=Clavinet|"+
    "8=Celeste|"+
    "9=Glockenspiel|"+
    "10=Music Box|"+
    "11=Vibraphone|"+
    "12=Marimba|"+
    "13=Xylophone|"+
    "14=Tubular Bells|"+
    "15=Dulcimer|"+
    "16=Tonewheel Organ|"+
    "17=Percussive Organ|"+
    "18=Rock Organ|"+
    "19=Pipe Organ|"+
    "20=Reed Organ|"+
    "21=Accordian|"+
    "22=Harmonica|"+
    "23=Bandoneon|"+
    "24=Nylon Guitar|"+//soft
    "25=Steel Guitar|"+
    "26=Jazz Guitar|"+//pingfangzhilu
    "27=Clean Guitar|"+
    "28=Muted Guitar|"+
    "29=Overdrive Guitar|"+
    "30=Distortion Guitar|"+
    "31=Guitar Harmonics|"+
    "32=Acoustic Bass|"+
    "33=Finger Bass|"+
    "34=Pick Bass|"+
    "35=Fretless Bass|"+
    "36=Slap Bass 1|"+
    "37=Slap Bass 2|"+
    "38=Synth Bass 1|"+
    "39=Synth Bass 2|"+
    "40=Violin|"+
    "41=Viola|"+
    "42=Cello|"+
    "43=Double Bass|"+
    "44=St. Trem. Strings|"+
    "45=Pizzicato Strings|"+
    "46=Orchestral Harp|"+
    "47=Timpani|"+
    "48=St. Strings Fast|"+
    "49=St. Strings Slow|"+
    "50=Synth Strings 1|"+
    "51=Synth Strings 2|"+
    "52=Concert Choir|"+
    "53=Voice Oohs|"+
    "54=Synth Voice|"+
    "55=Orchestra Hit|"+
    "56=Trumpet|"+
    "57=Trombone|"+
    "58=Tuba|"+
    "59=Muted Trumpet|"+
    "60=French Horns|"+
    "61=Brass Section|"+
    "62=Synth Brass 1|"+
    "63=Synth Brass 2|"+
    "64=Soprano Sax|"+
    "65=Alto Sax|"+
    "66=Tenor Sax|"+
    "67=Baritone Sax|"+
    "68=Oboe|"+
    "69=English Horn|"+
    "70=Bassoon|"+
    "71=Clarinet|"+
    "72=Piccolo|"+
    "73=Flute|"+
    "74=Recorder|"+
    "75=Pan Flute|"+
    "76=Bottle Blow|"+
    "77=Shakuhachi|"+
    "78=Irish Tin Whistle|"+
    "79=Ocarina|"+
    "80=Square Lead|"+
    "81=Saw Lead|"+
    "82=Synth Calliope|"+
    "83=Chiffer Lead|"+
    "84=Charang|"+
    "85=Solo Vox|"+
    "86=5th Saw Wave|"+
    "87=Bass & Lead|"+
    "88=Fantasia|"+
    "89=Warm Pad|"+
    "90=Polysynth|"+
    "91=Space Voice|"+
    "92=Bowed Glass|"+
    "93=Metal Pad|"+
    "94=Halo Pad|"+
    "95=Sweep Pad|"+
    "96=Ice Rain|"+
    "97=Soundtrack|"+
    "98=Crystal|"+
    "99=Atmosphere|"+
    "100=Brightness|"+
    "101=Goblin|"+
    "102=Echo Drops|"+
    "103=Star Theme|"+
    "104=Sitar|"+
    "105=Banjo|"+
    "106=Shamisen|"+
    "107=Koto|"+
    "108=Kalimba|"+
    "109=Bagpipes|"+
    "110=Fiddle|"+
    "111=Shenai|"+
    "112=Tinker Bell|"+
    "113=Agogo|"+
    "114=Steel Drums|"+
    "115=Wood Block|"+
    "116=Taiko Drum|"+
    "117=Melodic Tom|"+
    "118=Synth Drum|"+
    "119=Reverse Cymbal|"+
    "120=Fret Noise|"+
    "121=Breath Noise|"+
    "122=Seashore|"+
    "123=Birds|"+
    "124=Telephone 1|"+
    "125=Helicopter|"+
    "126=Applause|"+
    "127=Gun Shot"*/
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    let cellWidth = UIScreen.main.bounds.width / 6
    let cellHeight = UIScreen.main.bounds.height / 6
    var connected = false
    var hexBytes: [UInt8] = []
    var chn:UInt8 = 0;
    var baseNotes : [UInt8] = [28, 33, 38, 43, 47, 52]
    var capo = 0 {
        didSet {
            print("set capo");
            baseNotes[0] = UInt8(28 + 12 + capo)
            baseNotes[1] = UInt8(33 + 12 + capo)
            baseNotes[2] = UInt8(38 + 12 + capo)
            baseNotes[3] = UInt8(43 + 12 + capo)
            baseNotes[4] = UInt8(47 + 12 + capo)
            baseNotes[5] = UInt8(52 + 12 + capo)
        }
    }
    let reuseIdentifier = "MyTestCollectionViewCell"
    var notes : [UInt8] = [ ]
    var validTouches = [UITouch]()
    var cellcolors = [UIColor]()
    var originalCells = [MyTestCollectionViewCell]()
    var bluetooth = Bluetooth(deviceName: "notecommand")
    var player = MIDISampler()
    var noteCount = Array<Int>(repeating: 0, count: 4000)
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    //MARK: Initialization
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        capo = 0
        setupButtons()
    }
    required init(coder: NSCoder) {
        super.init(coder: coder)!;
        capo = 0
        setupButtons()
    }
    //FGPA->手机：isOn(1 or 0 表示按下还是释放，暂且全部设为1) key(音高0-88) vel(音量0-127) prog(乐器类别0-127, 大于127则认为乐器不变) 8位十六进制 0x01297F19
    //MARK: bluetooth delegate
    func readData(_ newHexBytes: [UInt8]) {
        print("readData: \(newHexBytes)")
        if connected {hexBytes.append(contentsOf: newHexBytes)}
        else {connected = true}
        //while (hexBytes.count > 0 && hexBytes[0] != 1) {hexBytes.removeFirst();}
        while (hexBytes.count > 0 && hexBytes[0] >= 127){hexBytes.removeFirst();}
        print("currentBuffer: \(hexBytes)")
        while (hexBytes.count >= 4) {
            let chn = hexBytes[0]
            let key = hexBytes[1]
            let vel = hexBytes[2]
            let prog = hexBytes[3]
            hexBytes.removeFirst(4)
            print("chn=\(chn),key=\(key),vel=\(vel),prog=\(prog)")
            player.noteChanged(true, key: key, vel: vel, prog: prog, channel: chn)
            //if isOn {
                noteCount[Int(key)*20+Int(chn)] += 1
                Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(noteOff), userInfo: [chn, key, vel, prog, chn], repeats: false)
            //}
            //chn = (chn - 11 + 1) % 100 + 11
        }
        print("readDone");
    }
    func didConnect() {
        print("connected")
        print("currentBuffer: \(hexBytes)")
        hexBytes.removeAll()
    }
    func setupButtons() {
        capo = 0
        delaysContentTouches = false
        bluetooth.delegate = self
        //bluetooth.connect()
        isMultipleTouchEnabled = true
        for _ in 0..<24 {
            let color = UIColor.white
            cellcolors.append(color)
        }

        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: (screenWidth)/6, height: screenHeight/4)
        self.setCollectionViewLayout(layout, animated: true)
        delegate = self
        dataSource = self
        backgroundColor = UIColor.white
        register(MyTestCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    func noteOff(timer: Timer) {
        guard let data = timer.userInfo as? NSArray else{
            fatalError("data error: \(timer.userInfo)")
        }
        print("noteOff: \(data)");
        let key = data[1] as! UInt8
        let chn = data[0] as! UInt8
        noteCount[Int(key)*20+Int(chn)] -= 1
        if noteCount[Int(key)*20+Int(chn)] > 0 {
            return
        }
        player.noteChanged(false, key: data[1] as! UInt8, vel: data[2] as! UInt8, prog: data[3] as! UInt8, channel: chn)
    }
    //MARK: Gesture
    func updateNotes() {
        if !connected {
            bluetooth.connect()
            //connected = true
        }
        print("validTouches.count=\(validTouches.count)")
        let oldColors = cellcolors
        for i in 0..<24 {
            let color = UIColor.white
            cellcolors[i] = color
        }
        print("Touched id:")
        for touch in validTouches {
            let p = touch.location(in: self)
            let indexPath = indexPathForItem(at: p)!
            let id = indexPath.row//Int(floor(p.x / cellHeight) * 6 + floor(p.y / cellWidth))
            print(id)
            cellcolors[id] = UIColor.blue
        }
        reloadData()
        notes = baseNotes;
        for i in 0..<24 {
            if cellcolors[i] == UIColor.blue {
                notes[i % 6] = UInt8(Int(baseNotes[i % 6]) + i / 6 + 1)
            }
        }
        if oldColors != cellcolors {
            bluetooth.sendData(notes)
        }
        //test
//        for i in 0..<24 {
//            if oldColors[i] != cellcolors[i] {
//                let isOn = (cellcolors[i] == UIColor.blue)
//                let key1 = (i / 6) + Int(baseNotes[i % 6]) + 1
//                let key = UInt8(key1)
//                player.noteChanged(isOn, key: key, vel: 127, prog: 255)
//            }
//        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touchesBegan")
        for touch in touches {
            let position = touch.location(in: self)
            print(position)
        }
        validTouches.append(contentsOf: touches)
        updateNotes()
        super.touchesBegan(touches, with: event)
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touchesMoved:")
        for touch in touches {
            let position = touch.location(in: self)
            print(position)
        }
        updateNotes()
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touchesEnded:")
        for touch in touches {
            let position = touch.location(in: self)
            print(position)
            validTouches.remove(at: validTouches.index(of: touch)!)
        }
        updateNotes()
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touchesCancelled:")
        for touch in touches {
            let position = touch.location(in: self)
            print(position)
            validTouches.remove(at: validTouches.index(of: touch)!)
        }
        updateNotes()
    }
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 24
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        cell.backgroundColor = cellcolors[indexPath.row]
        // Configure the cell
        
        return cell
    }
}
/*
 touchesBegan
 (201.0, 184.0)
 2
 6
 9
 startPlay note 45, noteCommand 90 result 0
 touchesEnded:
 (201.0, 184.0)
 1
 6
 stopPlay note 45, noteCommand 80 result 0
*/
