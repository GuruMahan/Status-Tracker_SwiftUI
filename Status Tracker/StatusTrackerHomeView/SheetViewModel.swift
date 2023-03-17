//
//  ViewModel.swift
//  Status Tracker
//
//  Created by Guru Mahan on 13/03/23.
//

import SwiftUI

class SheetViewModel: ObservableObject{
    @Published var isLoader = false
    @Published var dataList: SheetModel?
    @Published var changedDay:String?
    @Published var showDateList:Bool = false
    @Published var filteredItems: [DataElement] = []
    @Published var textFields: [DataElement] = []
    @Published var taskText = ""
    
//    init() {
//      
//    }
//    
    //MARK: -> DateFormatter
    func dateFormate(date:String) -> String {
        var formattedDate: String = ""
        var newDateString: String = ""
        var newDayString: String = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ" // set the input date format
        if let date = dateFormatter.date(from: date){
            dateFormatter.dateFormat = " MMM d, yyyy"
            newDateString = dateFormatter.string(from: date)
            dateFormatter.dateFormat = "EEEE"
            newDayString = dateFormatter.string(from: date)
            formattedDate = newDateString + "|" + newDayString
            print("days====>",newDayString)
        }
        return formattedDate
    }
}

//MARK: -> UI Functionalities
extension SheetViewModel {
    func detailsColorCode(index:Int) -> String{
        switch index % 3 {
        case 1:
            return  "#FFD8E3"
        case 2:
            return  "#EADFF3"
            
        default:
            return "#FFEFE7"
        }
    }
    
    func nameViewColorCode(index:Int) -> String{
        switch index % 3 {
        case 1:
            return  "#EA698F"
        case 2:
            return  "#705186"
        default:
            return "#655757"
        }
    }
    
    func leftSideDividerColorCode(index:Int) -> String{
        switch index % 3 {
        case 1:
            return  "#ED7B9D"
        case 2:
            return  "#AA83C6"
        default:
            return "#E1D5D4"
        }
    }
}

//MARK: -> GoogleSheet ApiCall
extension SheetViewModel {
    func getData(){
        isLoader = true
        let urlString =  "https://script.google.com/macros/s/AKfycbzcPoBAz86gnLfIeAyljB4HwsFEYon6uPhvwTS0Xjk4vXib0nsZ-4zjiVi9lkRUVzW0_w/exec?action=get"
        let url = URL(string: urlString)
        if let url = url {
            var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
            request.httpMethod = "GET"
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request) { (data, response, error) in
                if error == nil {
                    do {
                        let decoder = JSONDecoder()
                        if let dat = data{
                            let result = try decoder.decode( SheetModel.self, from: dat)
                            print("result========>",result)
                           DispatchQueue.main.async {
                                self.dataList = result
                                self.filteredItems = result.items?.last?.datas ?? []
                                self.isLoader = false
                                self.changedDay = self.dateFormate(date:  self.dataList?.items?.last?.date ?? "")
                                self.textFields = self.valueMapDataElement()
                            print("=====>?\(self.textFields)")
                            }
                            print(result)
                        }
                    } catch {
                        print(error)
                    }
                }
            }
            dataTask.resume()
        }
    }
}
extension SheetViewModel {
    func valueMapDataElement() -> [DataElement] {
        var basics: [DataElement] = []
        for item in filteredItems {
            var copy = item.copy()
            if copy.name == "palani" {
                copy.text = item.task ?? ""
            }
            if copy.name == "balaji" {
                copy.text = item.task ?? ""
            }
            if copy.name == "saran" {
                copy.text = item.task ?? ""
            }
            if copy.name == "fazil" {
                copy.text = item.task ?? ""
            }
            if copy.name == "maruthu" {
                copy.text = item.task ?? ""
                
            }
            if copy.name == "abdullah" {
                copy.text = item.task ?? ""
            }
            basics.append(copy)
        }
        return basics
    }
}
//MARK: -> GoogleSheet Link:
//https://docs.google.com/spreadsheets/d/1brId26gnwb06OvCiLMZRMZeXiCc80Ve2nTLR2SjBASk/edit#gid=0
//MARK: -> GoogleSheet Api:
//"https://script.google.com/macros/s/AKfycbzcPoBAz86gnLfIeAyljB4HwsFEYon6uPhvwTS0Xjk4vXib0nsZ-4zjiVi9lkRUVzW0_w/exec?action=get"
