//
//  ViewController.swift
//  AstonProject001
//
//  Created by Георгий Евсеев on 21.09.23.
//

import UIKit

protocol FirstControllerDelegate {
    func passData(_ data: [ViewController])
}

class ViewController: UIViewController, ViewControllerDelegate {
    var myScore: Int = 0

    var interval: Double = 2

    var currentPlayer = Player(name: "New player", score: 0)

    func updateValue(newValue: Int) {
        myScore = newValue

        for player in players {
            if player.name == currentPlayer.name {
                player.score = myScore
            }
        }
    }

    var delegate: FirstControllerDelegate?

    func sendData() {
        let arrayOfInstances = [ViewController]()
        delegate?.passData(arrayOfInstances)
    }

    var currentPlane = 0

    var players: [Player] = [Player(name: "Vasiliy", score: 1000000), Player(name: "Peter", score: 150000)]

    var plane = UIImageView()
    var planeName = String()

    var myButton1 = UIButton()
    var myButton2 = UIButton()
    var myButton3 = UIButton()
    var myButton4 = UIButton()
    var myButton5 = UIButton()
    var myButton6 = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
        planeName = "plane1"
        drowPlaneView()
        drawButton1()
        drawButton2()
        drawButton3()
        drawButton4()
        drawButton5()
        drawButton6()
    }

    func drowPlaneView() {
        plane.frame = CGRect(x: view.frame.width / 2 - 75, y: 120, width: 150, height: 150)
        plane.tintColor = UIColor.white
        plane.backgroundColor = .black
        plane.image = UIImage(named: planeName)
        view.addSubview(plane)
    }

    func drawButton1() {
        myButton1.frame = CGRect(x: view.frame.width / 2 - 150, y: view.frame.height - 410, width: 300, height: 40)
        myButton1.tintColor = UIColor.orange
        myButton1.backgroundColor = .black
        myButton1.setTitle("PRESS to add a player", for: .normal)
        myButton1.addTarget(self, action: #selector(addNewPlayer), for: .touchUpInside)
        view.addSubview(myButton1)
    }

    func drawButton2() {
        myButton2.frame = CGRect(x: view.frame.width / 2 - 150, y: view.frame.height - 260, width: 300, height: 40)
        myButton2.tintColor = UIColor.white
        myButton2.backgroundColor = .orange
        myButton2.setTitle("Start", for: .normal)
        myButton2.addTarget(self, action: #selector(start(_sender:)), for: .touchUpInside)
    }

    func drawButton3() {
        myButton3.frame = CGRect(x: view.frame.width / 2 - 150, y: view.frame.height - 210, width: 300, height: 40)
        myButton3.tintColor = UIColor.white
        myButton3.backgroundColor = .orange
        myButton3.setTitle("Leaders", for: .normal)
        myButton3.addTarget(self, action: #selector(listOfLeaders(_sender:)), for: .touchUpInside)
        view.addSubview(myButton3)
    }

    func drawButton4() {
        myButton4.frame = CGRect(x: view.frame.width / 2 - 150, y: view.frame.height - 160, width: 300, height: 40)
        myButton4.tintColor = UIColor.white
        myButton4.backgroundColor = .orange
        myButton4.setTitle("Difficult: Easy", for: .normal)
        myButton4.addTarget(self, action: #selector(changeDifficult), for: .touchUpInside)
        view.addSubview(myButton4)
    }

    func drawButton5() {
        myButton5.frame = CGRect(x: view.frame.width / 2 - 150, y: 200, width: 25, height: 18)
        myButton5.tintColor = UIColor.orange
        myButton5.backgroundColor = .black
        myButton5.setTitle("<", for: .normal)
        myButton5.addTarget(self, action: #selector(tappedBack), for: .touchUpInside)
        view.addSubview(myButton5)
    }

    func drawButton6() {
        myButton6.frame = CGRect(x: view.frame.width / 2 + 110, y: 200, width: 25, height: 18)
        myButton6.tintColor = UIColor.orange
        myButton6.backgroundColor = .black
        myButton6.setTitle(">", for: .normal)
        myButton6.addTarget(self, action: #selector(tapped), for: .touchUpInside)
        view.addSubview(myButton6)
    }

    @objc func start(_sender: UIButton) {
        let vc2 = GameViewController()
        vc2.planeName = planeName
        vc2.delegate = self

        navigationController?.pushViewController(vc2, animated: false)
    }

    @objc func changeDifficult(_sender: UIButton) {
        interval -= 0.5
        
        if interval < 1 {
            interval = 2
        }
        switch interval {
        case 2:
            interval = 2
            myButton4.setTitle("Difficult: Easy", for: .normal)
        case 1.5:
            interval = 1.5
            myButton4.setTitle("Difficult: Normal", for: .normal)
        case 1:
            interval = 1
            myButton4.setTitle("Difficult: Hard", for: .normal)

        default:
            break
        }
    }

    @objc func listOfLeaders(_sender: UIButton) {
        let vc3 = TableViewController(players: players)
        navigationController?.pushViewController(vc3, animated: false)
    }

    @objc func tapped(_ sender: UIButton) {
        currentPlane += 1

        if currentPlane > 2 {
            currentPlane = 0
        }
        switch currentPlane {
        case 0:
            planeName = "plane1"
            plane.image = UIImage(named: "plane1")
        case 1:
            planeName = "plane2"
            plane.image = UIImage(named: "plane2")
        case 2:
            planeName = "plane3"
            plane.image = UIImage(named: "plane3")

        default:
            break
        }
    }

    @objc func tappedBack(_ sender: UIButton) {
        currentPlane -= 1

        if currentPlane < 0 {
            currentPlane = 2
        }
        switch currentPlane {
        case 0:
            planeName = "plane1"
            plane.image = UIImage(named: "plane1")
        case 1:
            planeName = "plane2"
            plane.image = UIImage(named: "plane2")
        case 2:
            planeName = "plane3"
            plane.image = UIImage(named: "plane3")

        default:
            break
        }
    }

    @objc func addNewPlayer() {
        let ac = UIAlertController(title: "Enter Name", message: nil, preferredStyle: .alert)
        ac.addTextField()

        let submitAction = UIAlertAction(title: "Enter", style: .default) { [weak self, weak ac] _ in
            guard let name = ac?.textFields?[0].text else { return }
            self?.submit(name)
        }

        ac.addAction(submitAction)
        present(ac, animated: true)
    }

    func submit(_ newName: String) {
        currentPlayer.name = newName
        myScore = 0
        players.append(Player(name: currentPlayer.name, score: 0))
        myButton1.setTitle(currentPlayer.name, for: .normal)
        view.addSubview(myButton2)
    }
}
