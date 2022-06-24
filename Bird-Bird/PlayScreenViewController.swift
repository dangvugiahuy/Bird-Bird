//
//  PlayScreenViewController.swift
//  Bird-Bird
//
//  Created by Gia Huy on 09/04/2022.
//

import UIKit

class PlayScreenViewController: UIViewController{
    
    //LẤY HEIGHT AND WIDTH CỦA THIẾT BỊ
    static let screenSize: CGRect = UIScreen.main.bounds
    static let screenWidth = screenSize.width
    static let screenHeight = screenSize.height
    
    var TimerValue: Timer = Timer()
    var BestScoreAfter: Int = Int()
    
    let Width: CGFloat = screenWidth
    let Height: CGFloat = screenHeight
    
    //Biến giữ giá trị tọa độ cho mỗi 1 lần chuyển động từ phải ---> trái của ống nước phụ thuộc vào width của viewport từng thiết bị
    let ValueXofPerMove: CGFloat = (screenWidth / 100.0) - 0.5
    let ArrayYofPipe: [CGFloat] = CalcRandomYofPipe()
    
    //CÁC BIẾN GIỮ X, Y, WIDTH, HEIGHT BAN ĐẦU CỦA TOP AND BOTTOM PIPE
    //-------------------------BOTTOM PIPE----------------------------
    //---------------------CÁC BIẾN DÙNG CHUNG------------------------
    
    //WIDTH của Pipe 1, 2, 3
    static let widthOfPipe: CGFloat = 0.25 * screenWidth
    
    //X của Pipe 1, 2, 3
    static let xOfPipe1: CGFloat = screenWidth + 200.0
    static let xOfPipe2: CGFloat = screenWidth + 450.0 + widthOfPipe
    static let xOfPipe3: CGFloat = screenWidth + 675.0 + (widthOfPipe*2)
    
    //Y (dùng chung 3 ống cả dưới) <---> HEIGHT của ống = y (dùng chung cả trên - dưới)
    static let yAndHeightOfPipe: CGFloat = screenHeight/2
    
    //TOP PIPE
    //HEIGHT
    static let yOfTopPipe: CGFloat = CalcYOfTopPipe()      //tính toán y dựa vào height của viewport của mỗi iphone
    //-----------------------------------------------------------------
    
    
    //TẠO CÁC LUỒNG ĐỂ CHẠY ỐNG TRÊN - DƯỚI - NỀN ĐẤT - TẠO HIỆU ỨNG LOOP - HIỆU ỨNG VẬT THỂ RƠI
    let queueLoopMoveOfTopPipe = DispatchQueue(label: "queueLoopMoveOfTopPipe")
    let queueLoopMoveOfBottomPipe = DispatchQueue(label: "queueLoopMoveOfBottomPipe")
    let queueLoopMoveOfPlatform = DispatchQueue(label: "queueLoopMoveOfPlatform")
    let queueLoopXofPipe = DispatchQueue(label: "queueLoopXofPipe")
    let queueLoopXofPlatform = DispatchQueue(label: "queueLoopXofPlatform")
    let queueLoopRandomYOfPipe = DispatchQueue(label: "queueLoopRandomYOfPipe")
    let queueMoveObjectToDown = DispatchQueue(label: "queueMoveObjectToDown")
    let queueCheckCollision = DispatchQueue(label: "queueCheckCollision")
    let queueUpdateScore = DispatchQueue(label: "queueUpdateScore")
    
    

    //TẠO CÁC ĐỐI TƯỢNG
    //Background
    private let backGroundView: UIImageView = {
        let backGroundView: UIImageView = UIImageView()
        backGroundView.image = UIImage(named: "BackGround.png")
        backGroundView.contentMode = .scaleAspectFill
        backGroundView.translatesAutoresizingMaskIntoConstraints = false
        return backGroundView
    }()
    //TẠO 3 IMAGE CHỨA MỖI CHỮ SỐ TRONG SCORE (MAX 999 LÀ PHÁ ĐẢO GAME)
    private let number1St: UIImageView = {
        let number1St: UIImageView = UIImageView()
        number1St.image = UIImage(named: "0.png")
        number1St.contentMode = .scaleAspectFit
        number1St.frame = CGRect(x: screenWidth/2-15.0, y: screenHeight-70.0, width: screenWidth/8.0, height: screenWidth/8.0)
        return number1St
    }()
    private let number2Nd: UIImageView = {
        let number2Nd: UIImageView = UIImageView()
        number2Nd.image = UIImage(named: "0.png")
        number2Nd.contentMode = .scaleAspectFit
        number2Nd.isHidden = true
        number2Nd.frame = CGRect(x: screenWidth/2-15.0, y: screenHeight-70.0, width: screenWidth/8.0, height: screenWidth/8.0)
        return number2Nd
    }()
    private let number3Rd: UIImageView = {
        let number3Rd: UIImageView = UIImageView()
        number3Rd.image = UIImage(named: "0.png")
        number3Rd.contentMode = .scaleAspectFit
        number3Rd.isHidden = true
        number3Rd.frame = CGRect(x: screenWidth/2-15.0, y: screenHeight-70.0, width: screenWidth/8.0, height: screenWidth/8.0)
        return number3Rd
    }()
    
    //TẠO 3 IMAGE CHỨA MỖI CHỮ SỐ TRONG SCORE CỦA BẢNG SCORE VÀ 3 IMAGE CHỨA MỖI CHỮ SỐ TRONG BEST SCORE CỦA BẢNG SCORE
    private let number1StScore: UIImageView = {
        let number1StScore: UIImageView = UIImageView()
        number1StScore.image = UIImage(named: "small0.png")
        number1StScore.contentMode = .scaleAspectFit
        number1StScore.isHidden = true
        number1StScore.frame = CGRect(x: screenWidth/2 + screenWidth/25, y: screenHeight/2, width: screenWidth/12.0, height: screenWidth/12.0)
        return number1StScore
    }()
    private let number2NdScore: UIImageView = {
        let number2NdScore: UIImageView = UIImageView()
        number2NdScore.image = UIImage(named: "small0.png")
        number2NdScore.contentMode = .scaleAspectFit
        number2NdScore.isHidden = true
        number2NdScore.frame = CGRect(x: screenWidth/2 + screenWidth/25, y: screenHeight/2, width: screenWidth/12.0, height: screenWidth/12.0)
        return number2NdScore
    }()
    private let number3RdScore: UIImageView = {
        let number3RdScore: UIImageView = UIImageView()
        number3RdScore.image = UIImage(named: "small0.png")
        number3RdScore.contentMode = .scaleAspectFit
        number3RdScore.isHidden = true
        number3RdScore.frame = CGRect(x: screenWidth/2 + screenWidth/25, y: screenHeight/2, width: screenWidth/12.0, height: screenWidth/12.0)
        return number3RdScore
    }()
    //---------------------------------------------3 CHỮ SỐ CỦA BEST SCORE------------------------------------------
    private let number1StBestScore: UIImageView = {
        let number1StBestScore: UIImageView = UIImageView()
        number1StBestScore.image = UIImage(named: "small0.png")
        number1StBestScore.contentMode = .scaleAspectFit
        number1StBestScore.isHidden = true
        number1StBestScore.frame = CGRect(x: screenWidth/2.0 + screenWidth/25.0, y: screenHeight/2.0 + screenWidth/5.5, width: screenWidth/12.0, height: screenWidth/12.0)
        return number1StBestScore
    }()
    
    private let number2NdBestScore: UIImageView = {
        let number2NdBestScore: UIImageView = UIImageView()
        number2NdBestScore.image = UIImage(named: "small0.png")
        number2NdBestScore.contentMode = .scaleAspectFit
        number2NdBestScore.isHidden = true
        number2NdBestScore.frame = CGRect(x: screenWidth/2.0 + screenWidth/25.0, y: screenHeight/2.0 + screenWidth/5.5, width: screenWidth/12.0, height: screenWidth/12.0)
        return number2NdBestScore
    }()
    
    private let number3RdBestScore: UIImageView = {
        let number3RdBestScore: UIImageView = UIImageView()
        number3RdBestScore.image = UIImage(named: "small0.png")
        number3RdBestScore.contentMode = .scaleAspectFit
        number3RdBestScore.isHidden = true
        number3RdBestScore.frame = CGRect(x: screenWidth/2.0 + screenWidth/25.0, y: screenHeight/2 + screenWidth/5.5, width: screenWidth/12.0, height: screenWidth/12.0)
        return number3RdBestScore
    }()
    
    //----------------------------------------------PLATFORM----------------------------------------------------
    private var platform1: UIImageView = {
        var platform1: UIImageView = UIImageView()
        platform1.image = UIImage(named: "platform.png")
        platform1.contentMode = .scaleAspectFill
        platform1.frame = CGRect(x: 0.0, y: screenHeight-120.0, width: screenWidth, height: screenWidth/2)
        return platform1
    }()
    private var platform2: UIImageView = {
        var platform2: UIImageView = UIImageView()
        platform2.image = UIImage(named: "platform.png")
        platform2.contentMode = .scaleAspectFill
        platform2.frame = CGRect(x: screenWidth + (0.5*screenWidth), y: screenHeight-120.0, width: screenWidth, height: screenWidth/2)
        return platform2
    }()
    private var platform3: UIImageView = {
        var platform3: UIImageView = UIImageView()
        platform3.image = UIImage(named: "platform.png")
        platform3.contentMode = .scaleAspectFill
        platform3.frame = CGRect(x: screenWidth*2 + screenWidth, y: screenHeight-120.0, width: screenWidth, height: screenWidth/2)
        return platform3
    }()
    //------------------------------------------------------------------------------------------------------------
    //Nút back về màn hình chính
    private let menuButton: UIButton = {
        let menuButton: UIButton = UIButton()
        menuButton.setBackgroundImage(UIImage(named: "menuButton.png"), for: .normal)
        menuButton.contentMode = .scaleAspectFit
        menuButton.isHidden = true
        menuButton.isEnabled = false
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        return menuButton
    }()
    //Con chim
    private var bird: UIImageView = {
        var bird: UIImageView = UIImageView()
        bird.image = UIImage(named: "Bird.png")
        bird.contentMode = .scaleAspectFill
        bird.frame = CGRect(x: (screenWidth/5) - 20.0 , y: (screenHeight/2) - 20.0, width: screenWidth/8, height: screenWidth/8)
        return bird
    }()
    //Bảng hiển thị điểm
    private let boardScore: UIImageView = {
        let boardScore: UIImageView = UIImageView()
        boardScore.image = UIImage(named: "boardScore.png")
        boardScore.contentMode = .scaleAspectFill
        boardScore.isHidden = true
        boardScore.frame = CGRect(x: screenWidth/2 - screenWidth/6, y: screenHeight/2 - screenWidth/6, width: screenWidth/3 + 20.0, height: screenWidth/2 + 20.0)
        return boardScore
    }()
    //Logo GameOver
    private let gameOverBanner: UIImageView = {
        let gameOverBanner: UIImageView = UIImageView()
        gameOverBanner.image = UIImage(named: "gameOverBanner.png")
        gameOverBanner.contentMode = .scaleAspectFit
        gameOverBanner.isHidden = true
        gameOverBanner.frame = CGRect(x: screenWidth/7, y: screenHeight/2 - screenHeight/5, width: 0.75*screenWidth, height: 0.75*(screenWidth/3))
        return gameOverBanner
    }()
    //---------------------------------------TẠO CÁC ĐỐI TƯỢNG ỐNG NƯỚC--------------------------------------------
    //Tạo 3 ống dưới
    private var bottomPipe1: UIImageView = {
        var bottomPipe1: UIImageView = UIImageView()
        bottomPipe1.image = UIImage(named: "bottomPipe.png")
        bottomPipe1.contentMode = .scaleAspectFill
        bottomPipe1.frame = CGRect(x: xOfPipe1, y: yAndHeightOfPipe, width: widthOfPipe, height: yAndHeightOfPipe)
        let framebottomPipe1: CGRect = bottomPipe1.frame
        return bottomPipe1
    }()
    private var bottomPipe2: UIImageView = {
        var bottomPipe2: UIImageView = UIImageView()
        bottomPipe2.image = UIImage(named: "bottomPipe.png")
        bottomPipe2.contentMode = .scaleAspectFill
        bottomPipe2.frame = CGRect(x: xOfPipe2, y: yAndHeightOfPipe, width: widthOfPipe, height: yAndHeightOfPipe)
        return bottomPipe2
    }()
    private var bottomPipe3: UIImageView = {
        var bottomPipe3: UIImageView = UIImageView()
        bottomPipe3.image = UIImage(named: "bottomPipe.png")
        bottomPipe3.contentMode = .scaleAspectFill
        bottomPipe3.frame = CGRect(x: xOfPipe3, y: yAndHeightOfPipe, width: widthOfPipe, height: yAndHeightOfPipe)
        return bottomPipe3
    }()
    
    //Tạo 3 ống trên
    private var topPipe1: UIImageView = {
        var topPipe1: UIImageView = UIImageView()
        topPipe1.image = UIImage(named: "topPipe.png")
        topPipe1.contentMode = .scaleAspectFill
        topPipe1.frame = CGRect(x: xOfPipe1, y: yOfTopPipe, width: widthOfPipe, height: yAndHeightOfPipe)
        return topPipe1
    }()
    private var topPipe2: UIImageView = {
        var topPipe2: UIImageView = UIImageView()
        topPipe2.image = UIImage(named: "topPipe.png")
        topPipe2.contentMode = .scaleAspectFill
        topPipe2.frame = CGRect(x: xOfPipe2, y: yOfTopPipe, width: widthOfPipe, height: yAndHeightOfPipe)
        return topPipe2
    }()
    private var topPipe3: UIImageView = {
        var topPipe3: UIImageView = UIImageView()
        topPipe3.image = UIImage(named: "topPipe.png")
        topPipe3.contentMode = .scaleAspectFill
        topPipe3.frame = CGRect(x: xOfPipe3, y: yOfTopPipe, width: widthOfPipe, height: yAndHeightOfPipe)
        return topPipe3
    }()
    //------------------------------------------------------------------------------------------------------------
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(backGroundView)
        
        view.addSubview(topPipe1)
        view.addSubview(topPipe2)
        view.addSubview(topPipe3)
        
        view.addSubview(bottomPipe1)
        view.addSubview(bottomPipe2)
        view.addSubview(bottomPipe3)
        
        view.addSubview(bird)
        
        view.addSubview(platform1)
        view.addSubview(platform2)
        view.addSubview(platform3)
        
        view.addSubview(number1St)
        view.addSubview(number2Nd)
        view.addSubview(number3Rd)
                
        menuButton.addTarget(self, action: #selector(moveToMenuScreen), for: .touchUpInside)
        
        
        view.addSubview(gameOverBanner)
        
        view.addSubview(boardScore)
        view.addSubview(menuButton)
        
        view.addSubview(number1StScore)
        view.addSubview(number2NdScore)
        view.addSubview(number3RdScore)
        
        view.addSubview(number1StBestScore)
        view.addSubview(number2NdBestScore)
        view.addSubview(number3RdBestScore)

        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ObjectGoUp(_:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        tapGestureRecognizer.numberOfTouchesRequired = 1
        
        view.addGestureRecognizer(tapGestureRecognizer)
        view.isUserInteractionEnabled = true
        
        //Hàm xử lý autoLayout
        addConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        SaveScore.bestScore = BestScoreAfter
        timerToMovePipe()
    }
    
    //Hàm chứa tất cả các đối tượng được autoLayOut
    private func addConstraints ()
    {
        //[TẠO MẢNG CHỨA CÁC CONSTRAINTS]
        var conStraints = [NSLayoutConstraint]()
        
        //[APPEND CÁC CONSTRAINTS CỦA CÁC ĐỐI TƯỢNG VẢO MẢNG]
        
        //hình nền của trò chơi
        conStraints.append(backGroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor))
        conStraints.append(backGroundView.centerYAnchor.constraint(equalTo: view.centerYAnchor))
        conStraints.append(backGroundView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1))
        conStraints.append(backGroundView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1))
        
        //Nút back về màn hình menu
        conStraints.append(menuButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: self.Width/30.0))
        conStraints.append(menuButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: self.Width/2.25))
        conStraints.append(menuButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/3))
        conStraints.append(menuButton.heightAnchor.constraint(equalTo: menuButton.widthAnchor, multiplier: 1/3))
                
        //[ACTIVE CÁC CONSTRAINT]
        NSLayoutConstraint.activate(conStraints)
    }
    
    //CÁC HÀM SỰ KIỆN CỦA CÁC BUTTON
    
    //Nút menu back về màn hình chính
    @objc func moveToMenuScreen()
    {
        SaveScore.score = 0
        navigationController?.popViewController(animated: true)
    }
    
    func timerToMovePipe()
    {
        TimerValue = Timer.scheduledTimer(timeInterval: 0.025, target: self, selector: #selector(movePipeAndPlatform), userInfo: nil, repeats: true)
    }
    
    @objc func movePipeAndPlatform()
    {
        //Di chuyển 3 ống nước dưới
        queueLoopMoveOfBottomPipe.async {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.025, animations: { [self] in
                    bottomPipe1.frame.origin.x -= ValueXofPerMove
                    bottomPipe2.frame.origin.x -= ValueXofPerMove
                    bottomPipe3.frame.origin.x -= ValueXofPerMove
                }, completion: nil)
            }
        }
        
        
        //Di chuyển 3 ống nước trên
        queueLoopMoveOfTopPipe.async {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.025, animations: { [self] in
                    topPipe1.frame.origin.x -= ValueXofPerMove
                    topPipe2.frame.origin.x -= ValueXofPerMove
                    topPipe3.frame.origin.x -= ValueXofPerMove
                }, completion: nil)
            }
        }
        
        //Di chuyển nền đất
        queueLoopMoveOfPlatform.async {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.025, animations: { [self] in
                    platform1.frame.origin.x -= ValueXofPerMove
                    platform2.frame.origin.x -= ValueXofPerMove
                    platform3.frame.origin.x -= ValueXofPerMove
                }, completion: nil)
            }
        }
        
        //Tạo hiệu ứng quay lại của ống nước
        queueLoopXofPipe.async {
            DispatchQueue.main.async { [self] in
                if bottomPipe1.frame.origin.x <= -(0.25*Width) {
                    CalcScore()
                    bottomPipe1.frame.origin.x = bottomPipe3.frame.origin.x + 225.0 + (0.25*Width)
                    topPipe1.frame.origin.x = topPipe3.frame.origin.x + 225.0 + (0.25*Width)
                }
                
                if bottomPipe2.frame.origin.x <= -(0.25*Width) {
                    CalcScore()
                    bottomPipe2.frame.origin.x = bottomPipe1.frame.origin.x + 225.0 + (0.25*Width)
                    topPipe2.frame.origin.x = topPipe1.frame.origin.x + 225.0 + (0.25*Width)
                }
                
                if bottomPipe3.frame.origin.x <= -(0.25*Width) {
                    CalcScore()
                    bottomPipe3.frame.origin.x = bottomPipe2.frame.origin.x + 225.0 + (0.25*Width)
                    topPipe3.frame.origin.x = topPipe2.frame.origin.x + 225.0 + (0.25*Width)
                }
            }
        }
        
        //Tạo hiệu ứng quay lại của nên đất
        queueLoopXofPlatform.async {
            DispatchQueue.main.async { [self] in
                if platform1.frame.origin.x <= -(Width + (0.5*Width)) {
                    platform1.frame.origin.x = platform3.frame.origin.x + Width + (0.5*Width)
                }
                if platform2.frame.origin.x <= -(Width + (0.5*Width)) {
                    platform2.frame.origin.x = platform1.frame.origin.x + Width + (0.5*Width)
                }
                if platform3.frame.origin.x <= -(Width + (0.5*Width)) {
                    platform3.frame.origin.x = platform2.frame.origin.x + Width + (0.5*Width)
                }
            }
        }
        // Tạo hiệu ứng các ống nước cao thấp ngẫu nhiên
        queueLoopRandomYOfPipe.async {
            DispatchQueue.main.async { [self] in
                if bottomPipe1.frame.origin.x <= -(0.25*Width) {
                    bottomPipe1.frame.origin.y = ArrayYofPipe.randomElement()!
                    switch Height
                    {
                    case 667.0, 736.0:
                        topPipe1.frame.origin.y = bottomPipe1.frame.origin.y - 200.0 - topPipe1.frame.height - topPipe1.frame.height/6
                    default:
                        topPipe1.frame.origin.y = bottomPipe1.frame.origin.y - 200.0 - topPipe1.frame.height
                    }
                }
                
                if bottomPipe2.frame.origin.x <= -(0.25*Width) {
                    bottomPipe2.frame.origin.y = ArrayYofPipe.randomElement()!
                    switch Height
                    {
                    case 667.0, 736.0:
                        topPipe2.frame.origin.y = bottomPipe2.frame.origin.y - 200.0 - topPipe2.frame.height - topPipe2.frame.height/6
                    default:
                        topPipe2.frame.origin.y = bottomPipe2.frame.origin.y - 200.0 - topPipe2.frame.height
                    }
                }
                
                if bottomPipe3.frame.origin.x <= -(0.25*Width) {
                    bottomPipe3.frame.origin.y = ArrayYofPipe.randomElement()!
                    switch Height
                    {
                    case 667.0, 736.0:
                        topPipe3.frame.origin.y = bottomPipe3.frame.origin.y - 200.0 - topPipe3.frame.height - topPipe3.frame.height/6
                    default:
                        topPipe3.frame.origin.y = bottomPipe3.frame.origin.y - 200.0 - topPipe3.frame.height
                    }
                }
            }
        }
        
        queueMoveObjectToDown.async {
            DispatchQueue.main.async { [self] in
                UIView.animate(withDuration: 0.3, animations: { [self] in
                    bird.frame.origin.y += 4
                }, completion: nil)
                
            }
        }
        
        queueCheckCollision.async {
            DispatchQueue.main.async { [self] in
                if checkCollision() == true {
                    TimerValue.invalidate()
                    showScoreAfterGameOver()
                    UIView.animate(withDuration: 0.2, animations: { [self] in
                        bird.frame.origin.y = (Height - 125.0) - bird.frame.height
                    }, completion: nil)
                }
            }
        }
        
        
    }
    
    static func CalcYOfTopPipe() -> CGFloat {
        if screenHeight == 568.0 || screenHeight == 667.0 || screenHeight == 736.0
        {
            return -0.4*screenHeight
        }
        
        return -screenHeight/4
    }
    
    static func CalcRandomYofPipe() -> [CGFloat] {
        var arrayOfY: [CGFloat] = []
        
        switch screenHeight
        {
        case 568.0:
            arrayOfY.append(contentsOf: [210.0, 250.0, 300.0, 350.0, 400.0])
        case 667.0:
            arrayOfY.append(contentsOf: [250.0, 300.0, 350.0, 400.0, 450.0, 500.0])
        case 736.0, 812.0:
            arrayOfY.append(contentsOf: [250.0, 300.0, 350.0, 400.0, 450.0, 500.0, 550.0, 600.0])
        case 844.0, 896.0, 926.0:
            arrayOfY.append(contentsOf: [305.0, 350.0, 400.0, 450.0, 500.0, 550.0, 600.0, 650.0, 690.0])
        default:
            arrayOfY.append(contentsOf: [305.0, 350.0, 400.0, 450.0, 500.0, 550.0, 600.0, 650.0, 690.0])
        }
        return arrayOfY
    }
    
    @objc func ObjectGoUp(_ gesture: UITapGestureRecognizer)
    {
        UIView.animate(withDuration: 0.2, animations: {
            self.bird.frame.origin.y -= self.Width/5
        }, completion: nil)
    }
    
    func checkCollision() -> Bool {
        let boundOfObject: CGRect = bird.convert(bird.bounds, to: nil)
        
        //Tạo các biến chứa các Bound của các vật cản
        let boundOfBottomBarricade1: CGRect = bottomPipe1.convert(bottomPipe1.bounds, to: nil)
        let boundOfBottomBarricade2: CGRect = bottomPipe2.convert(bottomPipe2.bounds, to: nil)
        let boundOfBottomBarricade3: CGRect = bottomPipe3.convert(bottomPipe3.bounds, to: nil)
        
        let boundOfTopBarricade1: CGRect = topPipe1.convert(topPipe1.bounds, to: nil)
        let boundOfTopBarricade2: CGRect = topPipe2.convert(topPipe2.bounds, to: nil)
        let boundOfTopBarricade3: CGRect = topPipe3.convert(topPipe3.bounds, to: nil)
        
        let boundOfPlatfrom1: CGRect = platform1.convert(platform1.bounds, to: nil)
        let boundOfPlatfrom2: CGRect = platform2.convert(platform2.bounds, to: nil)
        let boundOfPlatfrom3: CGRect = platform3.convert(platform3.bounds, to: nil)
        
        //Tạo các biến chứa kết quả va chạm của Object và Barricade
        let collision1: Bool = boundOfBottomBarricade1.intersects(boundOfObject)
        let collision2: Bool = boundOfBottomBarricade2.intersects(boundOfObject)
        let collision3: Bool = boundOfBottomBarricade3.intersects(boundOfObject)
        let collision4: Bool = boundOfTopBarricade1.intersects(boundOfObject)
        let collision5: Bool = boundOfTopBarricade2.intersects(boundOfObject)
        let collision6: Bool = boundOfTopBarricade3.intersects(boundOfObject)
        let collision7: Bool = boundOfPlatfrom1.intersects(boundOfObject)
        let collision8: Bool = boundOfPlatfrom2.intersects(boundOfObject)
        let collision9: Bool = boundOfPlatfrom3.intersects(boundOfObject)
        
        if collision1 || collision2 || collision3 || collision4 || collision5 || collision6 || collision7 || collision8 || collision9
        {
            return true
        }
        return false
    }
    
    func CalcScore()
    {
        SaveScore.score += 1
        let arrayOfNum = Array(String(SaveScore.score))     //Tạo array chứa từng ký tự đã tách
        
        if SaveScore.score >= 0 && SaveScore.score <= 9
        {number1St.image = UIImage(named: "\(arrayOfNum[0]).png")}
        else if SaveScore.score >= 10 && SaveScore.score <= 99
        {
            number1St.image = UIImage(named: "\(arrayOfNum[0]).png")
            if number2Nd.isHidden == true
            {
                number2Nd.isHidden = false
                number2Nd.image = UIImage(named: "\(arrayOfNum[1]).png")
                number1St.frame.origin.x -= 35.0
            } else {number2Nd.image = UIImage(named: "\(arrayOfNum[1]).png")}
        }
        else if SaveScore.score >= 100 && SaveScore.score <= 999
        {
            number1St.image = UIImage(named: "\(arrayOfNum[0]).png")
            number2Nd.image = UIImage(named: "\(arrayOfNum[1]).png")
            if number3Rd.isHidden == true
            {
                number3Rd.isHidden = false
                number3Rd.image = UIImage(named: "\(arrayOfNum[2]).png")
                number1St.frame.origin.x -= 70.0
                number2Nd.frame.origin.x -= 35.0
            } else {number3Rd.image = UIImage(named: "\(arrayOfNum[2]).png")}
        }
        BestScoreAfter = SaveScore.Save()
    }
    
    func showScoreAfterGameOver()
    {
        let arrayOfNumScore = Array(String(SaveScore.score))            //Tạo array chứa từng ký tự đã tách của score
        
        if boardScore.isHidden == true
        {boardScore.isHidden = false}
        
        if gameOverBanner.isHidden == true
        {gameOverBanner.isHidden = false}
        
        if menuButton.isHidden == true
        {menuButton.isHidden = false}
        
        if menuButton.isEnabled == false
        {menuButton.isEnabled = true}
         
        if SaveScore.score >= 0 && SaveScore.score <= 9
        {
            if number1StScore.isHidden == true
            {
                number1StScore.isHidden = false
                number1StScore.image = UIImage(named: "small\(arrayOfNumScore[0]).png")
            }
        }
        else if SaveScore.score >= 10 && SaveScore.score <= 99
        {
            number1StScore.isHidden = false
            number1StScore.image = UIImage(named: "small\(arrayOfNumScore[0]).png")
            if number2NdScore.isHidden == true
            {
                number2NdScore.isHidden = false
                number2NdScore.image = UIImage(named: "small\(arrayOfNumScore[1]).png")
                number1StScore.frame.origin.x -= 25.0
            }
        }
        else if SaveScore.score >= 100 && SaveScore.score <= 999
        {
            number1StScore.isHidden = false
            number2NdScore.isHidden = false
            number1StScore.image = UIImage(named: "small\(arrayOfNumScore[0]).png")
            number2NdScore.image = UIImage(named: "small\(arrayOfNumScore[1]).png")
            if number3RdScore.isHidden == true
            {
                number3RdScore.isHidden = false
                number3RdScore.image = UIImage(named: "small\(arrayOfNumScore[2]).png")
                number1StScore.frame.origin.x -= 50.0
                number2NdScore.frame.origin.x -= 25.0
            }
        }
        
        if let storedScore: Int = BestScoreAfter as? Int
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
                    number1StBestScore.frame.origin.x -= 25.0
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
            }
        }
    }
}
