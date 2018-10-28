//
//  ViewController.swift
//  Course Catalog
//
//  Created by Matt DeBoer on 10/4/18.
//  Copyright © 2018 Matt DeBoer. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mySwitch: UISwitch!
    
    var courseKeys: [String]!
    var isSelectedAll = [String: Bool]()
    var courses: [String : [String : String]]!
    var selectedCourses = [String : [String : String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        courses = loadCSCourses()
        courseKeys = Array(courses.keys).sorted()
        
        for (key, _) in courses {
            isSelectedAll[key] = false
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    struct Course
    {
        var courseName: String
        var shortDescription: String
        var isSelected: Bool
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if mySwitch.isOn{
            return selectedCourses.count
        }
        else{
            return courses.count
        }
    }
    //table view  check marks
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (mySwitch.isOn)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            let key = courseKeys[indexPath.row]
            let courseData = selectedCourses[key]
            cell.textLabel?.text = key
            cell.detailTextLabel?.text = courseData!["ShortDescription"]
            
            if (isSelectedAll[key]!)
            {
                cell.accessoryType = UITableViewCell.AccessoryType.checkmark
            }else {
                cell.accessoryType = UITableViewCell.AccessoryType.none
            }
            
            return cell
        }else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            let key = courseKeys[indexPath.row]
            let courseData = courses[key]
            cell.textLabel?.text = key
            cell.detailTextLabel?.text = courseData!["ShortDescription"]
            
            if (isSelectedAll[key]!)
            {
                cell.accessoryType = UITableViewCell.AccessoryType.checkmark
            }else {
                cell.accessoryType = UITableViewCell.AccessoryType.none
            }
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(mySwitch.isOn)
        {
            let key = courseKeys![indexPath.row]
            if (isSelectedAll[key]!){
                self.tableView.cellForRow(at: indexPath)?.accessoryType = .none
                selectedCourses.removeValue(forKey: key)
                courseKeys.remove(at: indexPath.row)
                isSelectedAll[key] = false
                tableView.reloadData()
            }else
            {
                self.tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
                isSelectedAll[key] = true
                tableView.reloadData()
                
            }
        }else
        {
            let key = courseKeys![indexPath.row]
            if (isSelectedAll[key]!){
                self.tableView.cellForRow(at: indexPath)?.accessoryType = .none
                selectedCourses.removeValue(forKey: key)
                isSelectedAll[key] = false
                tableView.reloadData()
            }else
            {
                self.tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
                selectedCourses.updateValue(Array(courses)[indexPath.row].value, forKey: key)
                isSelectedAll[key] = true
                tableView.reloadData()
                
            }
        }
    }
    //myswitch
    @IBAction func switchToggle(_ sender: UISwitch) {
        
        if(mySwitch.isOn)
        {
            courseKeys = Array(selectedCourses.keys).sorted()
        }else
        {
            courseKeys = Array(courses.keys).sorted()
        }
        tableView.reloadData()
    }
    
    func loadCSCourses() -> [String : [String : String]]? {
        let pListFileURL = Bundle.main.url(forResource: "CSCourses", withExtension: "plist", subdirectory: "")
        if let pListPath = pListFileURL?.path,
            let pListData = FileManager.default.contents(atPath: pListPath) {
            do {
                let pListObject = try PropertyListSerialization.propertyList(from: pListData, options:PropertyListSerialization.ReadOptions(), format:nil)
                guard let maybeCourses = pListObject as? [String : [String : String]] else {
                    return nil
                }
                return maybeCourses
            } catch {
                print("Error reading CSCourses plist file: \(error)")
                return nil
            }
        }
        return nil
    }
}
