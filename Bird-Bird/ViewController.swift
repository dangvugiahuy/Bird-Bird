//
//  ViewController.swift
//  Bird-Bird
//
//  Created by Gia Huy on 08/04/2022.
//

import UIKit

class ViewController: UIViewController {
    
    var MuteSound: Bool  = false
    var BestScoresBefore: Int = Int()
    
    //LẤY HEIGHT AND WIDTH CỦA THIẾT BỊ
    static let screenSize: CGRect = UIScreen.main.bounds
    static let screenWidth = screenSize.width
    static let screenHeight = screenSize.height
    
    let Width: CGFloat = screenWidth
    let Height: CGFloat = screenHeight
    
    //TẠO CÁC ĐỐI TƯỢNG
    private let backGroundView: UIImageView = {
        let backGroundView: UIImageView = UIImageView()
        backGroundView.image = UIImage(named: "BackGround.png")
        backGroundView.contentMode = .scaleAspectFill
        backGroundView.translatesAutoresizingMaskIntoConstraints = false
        return backGroundView
    }()
    
    private let playButton: UIButton = {
        let playButton: UIButton = UIButton()
        playButton.setBackgroundImage(UIImage(named: "playButton.png"), for: .normal)
        playButton.contentMode = .scaleAspectFill
        playButton.translatesAutoresizingMaskIntoConstraints = false
        return playButton
    }()
    
    private let chartButton: UIButton = {
        let chartButton: UIButton = UIButton()
        chartButton.setBackgroundImage(UIImage(named: "chartButton.png"), for: .normal)
        chartButton.contentMode = .scaleAspectFill
        chartButton.translatesAutoresizingMaskIntoConstraints = false
        return chartButton
    }()
    
    private let soundButton: UIButton = {
        let soundButton: UIButton = UIButton()
        soundButton.setBackgroundImage(UIImage(named: "soundON.png"), for: .normal)
        soundButton.contentMode = .scaleToFill
        soundButton.translatesAutoresizingMaskIntoConstraints = false
        return soundButton
    }()
    
    private let imgLogoFlappy: UIImageView = {
        let imgLogoFlappy: UIImageView = UIImageView()
        imgLogoFlappy.image = UIImage(named: "logoFlappyBird.png")
        imgLogoFlappy.contentMode = .scaleAspectFill
        imgLogoFlappy.translatesAutoresizingMaskIntoConstraints = false
        return imgLogoFlappy
    }()
    
    private let bird: UIImageView = {
        let bird: UIImageView = UIImageView()
        bird.image = UIImage(named: "Bird.png")
        bird.contentMode = .scaleAspectFill
        bird.translatesAutoresizingMaskIntoConstraints = false
        return bird
    }()
    
    private let platform: UIImageView = {
        let platform: UIImageView = UIImageView()
        platform.image = UIImage(named: "platform.png")
        platform.contentMode = .scaleAspectFill
        platform.translatesAutoresizingMaskIntoConstraints = false
        return platform
    }()
    
    private let medalBoard: UIImageView = {
        let medalBoard: UIImageView = UIImageView()
        medalBoard.image = UIImage(named: "medalBoard.png")
        medalBoard.contentMode = .scaleAspectFill
        medalBoard.isHidden = true
        medalBoard.translatesAutoresizingMaskIntoConstraints = false
        return medalBoard
    }()
    private let medal: UIImageView = {
        let medal: UIImageView = UIImageView()
        medal.image = UIImage(named: "BronzeMedal.png")
        medal.contentMode = .scaleAspectFill
        medal.isHidden = true
        medal.translatesAutoresizingMaskIntoConstraints = false
        return medal
    }()
    private let okButton: UIButton = {
        let okButton: UIButton = UIButton()
        okButton.setBackgroundImage(UIImage(named: "okButton.png"), for: .normal)
        okButton.contentMode = .scaleAspectFit
        okButton.isHidden = true
        okButton.isEnabled = false
        okButton.translatesAutoresizingMaskIntoConstraints = false
        return okButton
    }()
    
    private let number1StBestScore: UIImageView = {
        let number1StBestScore: UIImageView = UIImageView()
        number1StBestScore.image = UIImage(named: "small0.png")
        number1StBestScore.contentMode = .scaleAspectFit
        number1StBestScore.isHidden = true
        number1StBestScore.frame = CGRect(x: screenWidth/2.0 + screenWidth/5.0 + 8.0, y: screenHeight/2.0 + 5.0, width: screenWidth/12.0, height: screenWidth/12.0)
        return number1StBestScore
    }()
    
    private let number2NdBestScore: UIImageView = {
        let number2NdBestScore: UIImageView = UIImageView()
        number2NdBestScore.image = UIImage(named: "small0.png")
        number2NdBestScore.contentMode = .scaleAspectFit
        number2NdBestScore.isHidden = true
        number2NdBestScore.frame = CGRect(x: screenWidth/2.0 + screenWidth/5.0 + 8.0, y: screenHeight/2.0 + 5.0, width: screenWidth/12.0, height: screenWidth/12.0)
        return number2NdBestScore
    }()
    
    private let number3RdBestScore: UIImageView = {
        let number3RdBestScore: UIImageView = UIImageView()
        number3RdBestScore.image = UIImage(named: "small0.png")
        number3RdBestScore.contentMode = .scaleAspectFit
        number3RdBestScore.isHidden = true
        number3RdBestScore.frame = CGRect(x: screenWidth/2.0 + screenWidth/5.0 + 8.0, y: screenHeight/2.0 + 5.0, width: screenWidth/12.0, height: screenWidth/12.0)
        return number3RdBestScore
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(backGroundView)
        playButton.addTarget(self, action: #selector(goToPlayScreen), for: .touchUpInside)
        soundButton.addTarget(self, action: #selector(muteOrUnmuteSound), for: .touchUpInside)
        chartButton.addTarget(self, action: #selector(showChartBoard), for: .touchUpInside)
        okButton.addTarget(self, action: #selector(closeChartBoard), for: .touchUpInside)
        view.addSubview(chartButton)
        view.addSubview(playButton)
        view.addSubview(soundButton)
        view.addSubview(imgLogoFlappy)
        view.addSubview(bird)
        view.addSubview(platform)
        view.addSubview(medalBoard)
        view.addSubview(okButton)
        view.addSubview(medal)
        view.addSubview(number1StBestScore)
        view.addSubview(number2NdBestScore)
        view.addSubview(number3RdBestScore)
        
        addConstraints()
    }
    
    private func addConstraints ()
    {
        //[TẠO MẢNG CHỨA CÁC CONSTRAINTS]
        var conStraints = [NSLayoutConstraint]()
        
        //[APPEND CÁC CONSTRAINTS CỦA CÁC ĐỐI TƯỢNG VẢO MẢNG]
        
        
        conStraints.append(backGroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor))
        conStraints.append(backGroundView.centerYAnchor.constraint(equalTo: view.centerYAnchor))
        conStraints.append(backGroundView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1))
        conStraints.append(backGroundView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1))
        
        
        conStraints.append(playButton.centerXAnchor.constraint(equalTo: backGroundView.centerXAnchor))
        conStraints.append(playButton.bottomAnchor.constraint(equalTo: backGroundView.bottomAnchor, constant: -120))
        conStraints.append(playButton.widthAnchor.constraint(equalTo: backGroundView.widthAnchor, multiplier: 1/2))
        conStraints.append(playButton.heightAnchor.constraint(equalTo: playButton.widthAnchor, multiplier: 1/2))
        
        
        conStraints.append(imgLogoFlappy.centerXAnchor.constraint(equalTo: backGroundView.centerXAnchor))
        conStraints.append(imgLogoFlappy.centerYAnchor.constraint(equalTo: bird.centerYAnchor, constant: -130))
        conStraints.append(imgLogoFlappy.widthAnchor.constraint(equalTo: backGroundView.widthAnchor, multiplier: 3/4))
        conStraints.append(imgLogoFlappy.heightAnchor.constraint(equalTo: imgLogoFlappy.widthAnchor, multiplier: 1/3))
        
        
        conStraints.append(bird.centerXAnchor.constraint(equalTo: backGroundView.centerXAnchor))
        conStraints.append(bird.centerYAnchor.constraint(equalTo: backGroundView.centerYAnchor))
        conStraints.append(bird.widthAnchor.constraint(equalTo: backGroundView.widthAnchor, multiplier: 1/5))
        conStraints.append(bird.heightAnchor.constraint(equalTo: bird.widthAnchor, multiplier: 1/2))
        
        
        conStraints.append(platform.centerXAnchor.constraint(equalTo: backGroundView.centerXAnchor))
        conStraints.append(platform.widthAnchor.constraint(equalTo: backGroundView.widthAnchor, multiplier: 1))
        conStraints.append(platform.topAnchor.constraint(equalTo: playButton.bottomAnchor))
        conStraints.append(platform.heightAnchor.constraint(equalTo: platform.widthAnchor, multiplier: 1/2))
        
        
        conStraints.append(soundButton.bottomAnchor.constraint(equalTo: imgLogoFlappy.topAnchor, constant: -30))
        conStraints.append(soundButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30))
        conStraints.append(soundButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/7))
        conStraints.append(soundButton.heightAnchor.constraint(equalTo: soundButton.widthAnchor, multiplier: 1))
        
        
        conStraints.append(chartButton.bottomAnchor.constraint(equalTo: imgLogoFlappy.topAnchor, constant: -30))
        conStraints.append(chartButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30))
        conStraints.append(chartButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/4))
        conStraints.append(chartButton.heightAnchor.constraint(equalTo: chartButton.widthAnchor, multiplier: 1/2))
        
        
        
        conStraints.append(medalBoard.centerXAnchor.constraint(equalTo: view.centerXAnchor))
        conStraints.append(medalBoard.centerYAnchor.constraint(equalTo: view.centerYAnchor))
        conStraints.append(medalBoard.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 3/4))
        conStraints.append(medalBoard.heightAnchor.constraint(equalTo: medalBoard.widthAnchor, multiplier: 1/2))
        
        
        conStraints.append(okButton.topAnchor.constraint(equalTo: medalBoard.bottomAnchor, constant: self.Width/20))
        conStraints.append(okButton.centerXAnchor.constraint(equalTo: view.centerXAnchor))
        conStraints.append(okButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/3))
        conStraints.append(okButton.heightAnchor.constraint(equalTo: okButton.widthAnchor, multiplier: 1/3))
        
        
        conStraints.append(medal.topAnchor.constraint(equalTo: medalBoard.topAnchor, constant: 55))
        conStraints.append(medal.leadingAnchor.constraint(equalTo: medalBoard.leadingAnchor, constant: 35))
        conStraints.append(medal.widthAnchor.constraint(equalTo: medalBoard.widthAnchor, multiplier: 1/5))
        conStraints.append(medal.heightAnchor.constraint(equalTo: medal.widthAnchor, multiplier: 1))

        //[ACTIVE CÁC CONSTRAINT]
        NSLayoutConstraint.activate(conStraints)
    }
    
    //CÁC HÀM SỰ KIỆN CỦA CÁC BUTTON
    
    @objc func goToPlayScreen()
    {
        let vc = storyboard?.instantiateViewController(withIdentifier: "playScreen") as! PlayScreenViewController
        navigationController?.pushViewController(vc, animated: true)
        vc.BestScoreAfter = BestScoresBefore
    }
    
    @objc func muteOrUnmuteSound()
    {
        if MuteSound == false {
            soundButton.setBackgroundImage(UIImage(named: "soundOFF.png"), for: .normal)
            MuteSound = true
        } else
        {
            soundButton.setBackgroundImage(UIImage(named: "soundON.png"), for: .normal)
            MuteSound = false
        }
    }
    
    @objc func showChartBoard()
    {
        if medalBoard.isHidden == true
        {medalBoard.isHidden = false}
        
        if okButton.isHidden == true && okButton.isEnabled == false
        {
            okButton.isHidden = false
            okButton.isEnabled = true
        }
        
        if let storedScore: Int = UserDefaults().value(forKey: "bestScore") as? Int
        {
            let arrayOfNumBestScore = Array(String(storedScore))  //Tạo array chứa từng ký tự đã tách của best score
            if storedScore >= 0 && storedScore <= 9
            {
                if number1StBestScore.isHidden == true
                {
                    number1StBestScore.isHidden = false
                    number1StBestScore.image = UIImage(named: "small\(arrayOfNumBestScore[0]).png")
                }
            }
            else if storedScore >= 10 && storedScore <= 99
            {
                number1StBestScore.isHidden = false
                number1StBestScore.image = UIImage(named: "small\(arrayOfNumBestScore[0]).png")
                if number2NdBestScore.isHidden == true
                {
                    number2NdBestScore.isHidden = false
                    number2NdBestScore.image = UIImage(named: "small\(arrayOfNumBestScore[1]).png")
                    number1StBestScore.frame.origin.x = number2NdBestScore.frame.origin.x - 25.0
                }
                if storedScore >= 20 && storedScore <= 59
                {
                    if medal.isHidden == true
                    {
                        medal.isHidden = false
                        medal.image = UIImage(named: "BronzeMedal.png")
                    } else {
                        medal.image = UIImage(named: "BronzeMedal.png")
                    }
                }
                else if storedScore >= 60 && storedScore <= 99
                {
                    if medal.isHidden == true
                    {
                        medal.isHidden = false
                        medal.image = UIImage(named: "SilverMedal.png")
                    } else {
                        medal.image = UIImage(named: "SilverMedal.png")
                    }
                }
            }
            else if storedScore >= 100 && storedScore <= 999
            {
                number1StBestScore.isHidden = false
                number2NdBestScore.isHidden = false
                number1StBestScore.image = UIImage(named: "small\(arrayOfNumBestScore[0]).png")
                number2NdBestScore.image = UIImage(named: "small\(arrayOfNumBestScore[1]).png")
                if number3RdBestScore.isHidden == true
                {
                    number3RdBestScore.isHidden = false
                    number3RdBestScore.image = UIImage(named: "small\(arrayOfNumBestScore[2]).png")
                    number1StBestScore.frame.origin.x -= 50.0
                    number2NdBestScore.frame.origin.x -= 25.0
                }
                if medal.isHidden == true
                {
                    medal.isHidden = false
                    medal.image = UIImage(named: "GoldMedal.png")
                } else {
                    medal.image = UIImage(named: "GoldMedal.png")
                }
            }
            BestScoresBefore = storedScore
        }
    }
    
    @objc func closeChartBoard()
    {
        if medalBoard.isHidden == false
        {medalBoard.isHidden = true}
        
        if number1StBestScore.isHidden == false
        {number1StBestScore.isHidden = true}
        
        if number2NdBestScore.isHidden == false
        {number2NdBestScore.isHidden = true}
        
        if number3RdBestScore.isHidden == false
        {number3RdBestScore.isHidden = true}
        
        if medal.isHidden == false
        {medal.isHidden = true}
        
        if okButton.isHidden == false && okButton.isEnabled == true
        {
            okButton.isHidden = true
            okButton.isEnabled = false
        }
    }
}

