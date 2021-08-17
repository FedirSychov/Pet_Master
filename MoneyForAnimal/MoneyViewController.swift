//
//  MoneyViewController.swift
//  PetMaster
//
//  Created by Fedor Sychev on 14.08.2021.
//

import UIKit
import Charts

class MoneyViewController: UIViewController {
    
    var data: [Expenditure]?
    
    var dataForChart = [PieChartDataEntry]()
    
    var ChartData: PieChartData?
    
    var myControllers = [UIViewController]()
    
    var chosenAnimal: Animal?

    @IBOutlet weak var MoneyCountLabel: UILabel!
    @IBOutlet weak var statisticsButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var historyButton: UIButton!
    @IBOutlet weak var animalPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetupView()
        setupPickers()
        countMoney()
    }
    
    func setupPickers() {
        animalPicker.delegate = self
        animalPicker.dataSource = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "goToAddExp":
            if let addExpVC = segue.destination as? AddExpenditureViewController {
                addExpVC.addDelegate = self
            }
        default:
            print("error")
        }
    }
    
    @IBAction func OpenStatistics(_ sender: Any) {
        setNewVCs()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.presentPageVC()
        }
    }
    
    private func SetupView() {
        Design.setupBackground(controller: self)
        Design.SetupBaseButton(button: statisticsButton)
        Design.SetupBaseButton(button: addButton)
        Design.SetupBaseButton(button: historyButton)
    }
    
    func countMoney() {
        var Summ: Double = 0
        self.data = Saved.shared.currentExpenditures.allExpenditures
        let previousMonth = Calendar.current.date(byAdding: .month, value: 0, to: Date())
        //MARK: - this must be
        //let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: Date())
        let targetDate = Calendar.current.dateComponents([.year, .month], from: previousMonth!)
        for expenditure in self.data! {
            let thisDate = Calendar.current.dateComponents([.year, .month], from: expenditure.date)
            if self.chosenAnimal == nil {
                if thisDate == targetDate {
                    Summ += expenditure.summ
                }
            } else {
                if thisDate == targetDate && expenditure.animal == self.chosenAnimal!.name {
                    Summ += expenditure.summ
                }
            }
        }
        self.MoneyCountLabel.text = "\(NSLocalizedString("expenditures_this_month", comment: ""))\(Double(round(100*Summ))/100)"
    }
}

//MARK: - Info view controller
extension MoneyViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func setNewVCs() {
        super.viewDidLoad()
        
        let tempData = Saved.shared.currentExpenditures.allExpenditures
        var num: Int
        if tempData.count == 0 {
            num = 1
        } else {
            num = months(from: Saved.shared.currentExpenditures.allExpenditures[0].date)
        }
        
        for n in 1...num {
            let vc = UIViewController()
            Design.setupBackground(controller: vc)
            
            let previousMonth = Calendar.current.date(byAdding: .month, value: 1 - n, to: Date())
            
            let temp = Calendar.current.dateComponents([.year, .month], from: previousMonth!)
            
            let header: String = "\(NSLocalizedString("month", comment: "")): \(temp.month!)/\(temp.year!)"
            
            setupPresentedVC(vc: vc, header: header, month: 1 - n)
            
            myControllers.append(vc)
            
            let allpies1 : [PieChartView] = getSubviewsOf(view: myControllers[n - 1].view)
            allpies1[0].data = ChartData
            animate(chart: allpies1[0])
        }
    }
    
    private func months(from date: Date) -> Int {
            return Calendar.current.dateComponents([.month], from: date, to: Date()).month! + 1
    }
    
    private func setupPresentedVC(vc: UIViewController, header: String, month: Int) {
        let headerLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 400, height: 40))
        headerLabel.textAlignment = .center
        headerLabel.text = header
        
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        headerLabel.font = UIFont(name: "Avenir Next Medium", size: 26)
        
        let constraints = [
            headerLabel.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor),
            headerLabel.topAnchor.constraint(equalTo: vc.view.topAnchor, constant: 50)
        ]
        
        vc.view.addSubview(headerLabel)
        
        NSLayoutConstraint.activate(constraints)
        
        let chart = PieChartView(frame: CGRect(x: 0, y: 0, width: 320, height: 600))
        
        let entertainmentDataEntry = PieChartDataEntry(value: 0)
        let foodDataEntry = PieChartDataEntry(value: 0)
        let vetDataEntry = PieChartDataEntry(value: 0)
        let otherDataEntry = PieChartDataEntry(value: 0)
        
        let previousMonth = Calendar.current.date(byAdding: .month, value: month, to: Date())
        let targetDate = Calendar.current.dateComponents([.year, .month], from: previousMonth!)
        for expenditure in self.data! {
            let thisDate = Calendar.current.dateComponents([.year, .month], from: expenditure.date)
            if self.chosenAnimal == nil {
                if thisDate == targetDate {
                    if expenditure.moneyFor == .entertainment {
                        entertainmentDataEntry.value += expenditure.summ
                    } else if expenditure.moneyFor == .food {
                        foodDataEntry.value += expenditure.summ
                    } else if expenditure.moneyFor == .vet {
                        vetDataEntry.value += expenditure.summ
                    } else {
                        otherDataEntry.value += expenditure.summ
                    }
                }
            } else {
                if thisDate == targetDate && expenditure.animal == self.chosenAnimal!.name {
                    if expenditure.moneyFor == .entertainment {
                        entertainmentDataEntry.value += expenditure.summ
                    } else if expenditure.moneyFor == .food {
                        foodDataEntry.value += expenditure.summ
                    } else if expenditure.moneyFor == .vet {
                        vetDataEntry.value += expenditure.summ
                    } else {
                        otherDataEntry.value += expenditure.summ
                    }
                }
            }
        }
        
        entertainmentDataEntry.label = "\(NSLocalizedString("entertainment", comment: "")): \(Double(round(entertainmentDataEntry.value*100))/100)"
        foodDataEntry.label = "\(NSLocalizedString("food", comment: "")): \(Double(round(foodDataEntry.value*100))/100)"
        vetDataEntry.label = "\(NSLocalizedString("vet", comment: "")): \(Double(round(vetDataEntry.value*100))/100)"
        otherDataEntry.label = "\(NSLocalizedString("other", comment: "")): \(Double(round(otherDataEntry.value*100))/100)"
        
        dataForChart = [entertainmentDataEntry, foodDataEntry, vetDataEntry, otherDataEntry]
        let chartDataSet = PieChartDataSet(entries: dataForChart, label: nil)
        
        chartDataSet.entryLabelColor = UIColor.clear

        let chartData = PieChartData(dataSet: chartDataSet)
        
        let pFormatter = NumberFormatter()
        chartData.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        chartData.setValueTextColor(UIColor.clear)
        
        let colors = [ UIColor.green, UIColor.blue, UIColor.red, UIColor.gray]
        chartDataSet.colors = colors
        chart.data = chartData
        
        self.ChartData = chartData

        chart.holeColor = UIColor.clear
        chart.entryLabelFont = UIFont(name: "Avenir Next Medium", size: 26)
        chart.noDataTextColor = UIColor.clear
        
        chart.holeRadiusPercent = 0.8
        
        let l = chart.legend
        
        l.horizontalAlignment = .left
        l.verticalAlignment = .bottom
        l.orientation = .vertical
        l.xEntrySpace = 50
        l.yEntrySpace = 0
        l.yOffset = 0
        l.font = UIFont(name: "Avenir Next Medium", size: 26)!
        
        // entry label styling
        chart.entryLabelColor = .white
        chart.entryLabelFont = .systemFont(ofSize: 12, weight: .light)
                
        animate(chart: chart)
        
        let newView = UIView(frame: CGRect(x: (vc.view.frame.width - chart.frame.width)/2, y: 0, width: 1000, height: 1000))
        
        
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: vc.view.frame.width, height: vc.view.frame.height))
        
        let constraintsCrollView = [
            scrollView.leftAnchor.constraint(equalTo: vc.view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: vc.view.rightAnchor),
            scrollView.topAnchor.constraint(equalTo: vc.view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: vc.view.bottomAnchor)
        ]
        
        
        
        
        
        _ = [
            
            newView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0)
        ]
        
        newView.addSubview(chart)
        
        scrollView.addSubview(newView)
        
        vc.view.addSubview(scrollView)
        
        //NSLayoutConstraint.activate(constraintsView)
        NSLayoutConstraint.activate(constraintsCrollView)
    }
    
    private func animate(chart: PieChartView) {
        let number = Int.random(in: 1...6)
        
        switch number {
        case 1:
            chart.animate(xAxisDuration: 1.9, easingOption: .easeInOutBack)
        case 2:
            chart.animate(xAxisDuration: 1.6, easingOption: .easeInOutElastic)
        case 3:
            chart.animate(xAxisDuration: 1.4, easingOption: .easeOutQuad)
        case 4:
            chart.animate(xAxisDuration: 1.6, easingOption: .easeOutCirc)
        case 5:
            chart.animate(xAxisDuration: 1.8, easingOption: .easeInOutCirc)
        case 6:
            chart.animate(xAxisDuration: 1.6, easingOption: .easeInOutBack)
        default:
            chart.animate(xAxisDuration: 1.7, easingOption: .easeInOutBack)
        }
    }
    
    func presentPageVC() {
        guard let first = myControllers.first else {
            return
        }
        let vc = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        
        vc.delegate = self
        vc.dataSource = self
        
        //setNewVCs()
        
        vc.setViewControllers([first], direction: .forward, animated: true, completion: nil)
        
        present(vc, animated: true, completion: nil)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = myControllers.firstIndex(of: viewController), index > 0 else {
            return nil
        }
        let before = index - 1
        
        return myControllers[before]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = myControllers.firstIndex(of: viewController), index < (myControllers.count - 1) else {
            return nil
        }
        let after = index + 1
        
        return myControllers[after]
    }
    
    private func getSubviewsOf<T : UIView>(view:UIView) -> [T] {
        var subviews = [T]()

        for subview in view.subviews {
            subviews += getSubviewsOf(view: subview) as [T]

            if let subview = subview as? T {
                subviews.append(subview)
            }
        }

        return subviews
    }
}

extension MoneyViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Saved.shared.currentSaves.animals.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row == 0 {
            return NSLocalizedString("all", comment: "")
        } else {
            return Saved.shared.currentSaves.animals[row].name
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row == 0 {
            self.chosenAnimal = nil
        } else {
            self.chosenAnimal = Saved.shared.currentSaves.animals[row]
        }
        countMoney()
    }
}
