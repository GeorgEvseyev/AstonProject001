
//  GameViewController.swift
//  AstonProject001
//
//  Created by Георгий Евсеев on 21.09.23.

import UIKit

protocol ViewControllerDelegate: AnyObject {
    func updateValue(newValue: Int)
}

class GameViewController: UIViewController, FirstControllerDelegate {
    weak var delegate: ViewControllerDelegate?

    func passData(_ data: [ViewController]) {
    }
    

    var interval: Double = 2
    
    var gameView: UIView!
    var planeName = String()
    var scoreLabel: UILabel!
    var reliefViewLeft: UIImageView!
    var reliefViewRight: UIImageView!
    var playerImageView: UIImageView!
    var enemyView: UIImageView!
    var bulletImageView: UIImageView!
    var enemyViews: [UIImageView]! = []

    var bulletTimer: Timer?
    var reliefTimer: Timer?
    var enemyTimer: Timer?
    var scoreTimer: Timer?

    var score = 0 {
        didSet {
            if scoreLabel != nil {
                scoreLabel.text = "\(score)"
                delegate?.updateValue(newValue: score)
            } else {
                return
            }
        }
    }

    var enemy = ["enemyplane1", "enemyplane2"]

    override func viewDidLoad() {
        super.viewDidLoad()

        delegate?.updateValue(newValue: score)

        let firstViewController = ViewController()
        firstViewController.delegate = self

        gameView = UIView(frame: view.bounds)
        gameView.backgroundColor = .black
        view.addSubview(gameView)

        view.addSubview(gameView)

        drowScoreBar()
        createPlayerImageView()
        startReliefAnimation()
        createTargetImageView()
        createBulletImageView()
        startScoreTimer()
        startBulletTimer()
        startReliefTimer()
        startEnemyTimer()
    }

    func drowScoreBar() {
        scoreLabel = UILabel(frame: CGRect(x: view.bounds.width - 100, y: 70, width: 100, height: 15))
        scoreLabel.text = "\(score)"
        scoreLabel.backgroundColor = .black
        scoreLabel.textColor = .orange
        view.addSubview(scoreLabel)
    }

    @objc func startReliefAnimation() {
        reliefViewLeft = UIImageView(frame: CGRect(x: 0, y: view.frame.height, width: 15, height: 340))
        reliefViewLeft.image = UIImage(named: "landscapeleft")
        reliefViewLeft.frame.origin.y = -view.frame.height
        reliefViewRight = UIImageView(frame: CGRect(x: view.frame.width - 15, y: view.frame.height, width: 15, height: 340))
        reliefViewRight.image = UIImage(named: "landscaperight")
        reliefViewRight.frame.origin.y = -view.frame.height
        let endYPosition = view.frame.height

        UIView.animate(withDuration: 5, delay: 0, options: [.repeat, .curveLinear], animations: {
            self.reliefViewLeft.frame.origin.y = endYPosition
        }, completion: nil)

        view.addSubview(reliefViewLeft)

        UIView.animate(withDuration: 5, delay: 0, options: [.repeat, .curveLinear], animations: {
            self.reliefViewRight.frame.origin.y = endYPosition
        }, completion: nil)

        view.addSubview(reliefViewRight)
        if playerImageView.frame.intersects(reliefViewLeft.frame) || playerImageView.frame.intersects(reliefViewRight.frame) {
            gameOver()
        }
    }

    func startReliefTimer() {
        reliefTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(startReliefAnimation), userInfo: nil, repeats: true)
    }

    func startEnemyTimer() {
        enemyTimer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(createTargetImageView), userInfo: nil, repeats: true)
    }

    func createPlayerImageView() {
        playerImageView = UIImageView(frame: CGRect(x: 150, y: view.bounds.height - 100, width: 60, height: 60))
        playerImageView.image = UIImage(named: planeName)
        playerImageView.backgroundColor = .black
        view.addSubview(playerImageView)
    }

    @objc func createTargetImageView() {
        enemyView = UIImageView(frame: CGRect(x: view.bounds.height / 2, y: 50, width: 60, height: 60))
        enemyView.image = UIImage(named: enemy.randomElement() ?? "enemyplane2")
        gameView.addSubview(enemyView)
        enemyViews.append(enemyView)
        for enemyView in enemyViews {
            let randomX = CGFloat(arc4random_uniform(UInt32(view.bounds.width - 15)))
            UIView.animate(withDuration: 1.5, delay: 0, options: [.curveLinear], animations: {
                enemyView.center.x = randomX
                enemyView.center.y += 50
            }) { _ in

                if enemyView.frame.maxY >= self.view.bounds.height {
                    enemyView.center.y = 100
                }

            }
        }
    }

    func createBulletImageView() {
        bulletImageView = UIImageView(frame: CGRect(x: playerImageView.frame.midX - 10, y: playerImageView.frame.minY - 30, width: 10, height: 20))
        bulletImageView.backgroundColor = .black
        bulletImageView.image = UIImage(named: "penguin")
        view.addSubview(bulletImageView)
    }

    func startScoreTimer() {
        scoreTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            self.score += 1
        }
    }

    func startBulletTimer() {
        bulletTimer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { _ in
            self.moveBullet()
            self.checkCollision()
        }
    }


    func stopBulletTimer() {
        bulletTimer?.invalidate()
        bulletTimer = nil
    }

    func moveBullet() {
        bulletImageView.frame.origin.y -= 5
        if bulletImageView.frame.minY < 0 {
            stopBulletTimer()
            bulletImageView.isHidden = true
        }
    }

    func checkCollision() {
        var i = -1
        for enemyView in enemyViews {
            i += 1
            if enemyView.frame.intersects(bulletImageView.frame) {
                stopBulletTimer()
                bulletImageView.isHidden = true
                enemyView.isHidden = true
                enemyViews.remove(at: i)
                print("The target is destroy!")
                score += 100
            }
            if enemyView.frame.intersects(playerImageView.frame) {
                gameOver()
            }
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location(in: view)
            playerImageView.center.x = touchLocation.x
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if bulletImageView.isHidden {
            bulletImageView.frame.origin.x = playerImageView.frame.midX - 10
            bulletImageView.frame.origin.y = playerImageView.frame.minY - 30
            bulletImageView.isHidden = false
            startBulletTimer()
        }
    }

    func gameOver() {
        let alert = UIAlertController(title: "Game Over", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "The End", style: .cancel, handler: nil))
        playerImageView.image = UIImage(named: "Explosion")
        scoreTimer?.invalidate()
        scoreTimer = nil
        enemyTimer?.invalidate()
        enemyTimer = nil
        scoreTimer?.invalidate()
        scoreTimer = nil
        present(alert, animated: true, completion: nil)
        finish()
    }

    func finish() {
        let vc1 = ViewController()
        vc1.delegate = self

        navigationController?.pushViewController(vc1, animated: false)
    }
}
