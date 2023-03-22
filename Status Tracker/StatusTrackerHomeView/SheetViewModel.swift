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
    @Published var changedDate:String?
    @Published var showDateList:Bool = false
    @Published var filteredItems: [DataElement] = []
    @Published var textFields: [DataElement] = []
    @Published var taskText = ""
    @Published var updatedDate = ""
    @Published var isUpdated: Bool = false
    @Published var selectedDate: String = ""

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
            formattedDate = newDateString + " | " + newDayString
        }
        return formattedDate
    }
    
    func updateDateFormate(date:String)  {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ" // set the input date format
        if let date = dateFormatter.date(from: date){
            dateFormatter.dateFormat = "M/d/yy"
           selectedDate = dateFormatter.string(from: date)
        }
        
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
    func getData() {
        isLoader = true
        guard let url = URL(string: "https://script.google.com/macros/s/AKfycbymV4tuDSWb1Ql4SBW-8eWG0zNpZMcZ2-tKnS03s-68GuH9B1BYM5pvgWeP-9h2oWIOMA/exec?action=get") else {
            fatalError("Invalid URL")
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { [weak self] (data, response, error) in
            guard let self = self else { return }
            if let error = error {
                print(error)
                return
            }
            guard let data = data else {
                return
            }
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(SheetModel.self, from: data)
                DispatchQueue.main.async {
                    self.dataList = result
                    self.filteredItems = result.items?.last?.datas ?? []
                    self.changedDay = self.dateFormate(date: result.items?.last?.date ?? "")
                    self.textFields = self.valueMapDataElement()
                    self.updateDateFormate(date: result.items?.last?.date ?? "")
                    self.isLoader = false
                }
            } catch {
            }
        }
        dataTask.resume()
    }
    
    func updateDate() {
        isLoader = true
        var palaniTask: String = ""
        var balajiTask: String = ""
        var saranTask: String = ""
        var fazilTask: String = ""
        var maruthuTask: String = ""
        var abdullahTask: String = ""
            for nonUpdateData in textFields {
                if nonUpdateData.name == "palani" {
                    palaniTask = nonUpdateData.text
                }
                if nonUpdateData.name == "balaji" {
                    balajiTask = nonUpdateData.text
                }
                if nonUpdateData.name == "saran" {
                   saranTask = nonUpdateData.text
                }
                if nonUpdateData.name == "fazil" {
                    fazilTask = nonUpdateData.text
                }
                if nonUpdateData.name == "maruthu" {
                    maruthuTask = nonUpdateData.text

                }
                if nonUpdateData.name == "abdullah" {
                    abdullahTask = nonUpdateData.text
                }
            }
   var urlString = "https://script.google.com/macros/s/AKfycby2MrORf9DeGL1sM0F0oDSg4ijg_-Oe5drhHvgoU8wB6uiODyiz4TCy7Z4BKRMZb37EWQ/exec?action=UPDATE"
        urlString += "&date="
        urlString += selectedDate
        urlString += "&palani="
        urlString += palaniTask
        urlString += "&fazil="
        urlString += balajiTask
        urlString += "&saran="
        urlString += saranTask
        urlString += "&balaji="
        urlString += fazilTask
        urlString += "&maruthu="
        urlString += maruthuTask
        urlString += "&abdullah="
        urlString += abdullahTask
        guard let requestUrl = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else {
                        fatalError("Invalid URL")
                    }
  var request = URLRequest(url: requestUrl)
            request.httpMethod = "GET"
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request) { [weak self] (data, response, error) in
                guard let self = self else { return }
                if let error = error {
                    print(error)
                    return
                }
                guard let data = data else {
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(SheetModel.self, from: data)
                    DispatchQueue.main.async {
                        self.dataList = result
                        self.isLoader = false
                        print("=====>?\(self.textFields)")
                    }
                } catch {
                }
            }
            dataTask.resume()
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
//POSTAPI ->//https://script.google.com/macros/s/AKfycby2MrORf9DeGL1sM0F0oDSg4ijg_-Oe5drhHvgoU8wB6uiODyiz4TCy7Z4BKRMZb37EWQ/exec?action=UPDATE&date=3/8/23&palani=fazil hjhjjknk&fazil=taskgtrrttrtrbtgbt&saran=syed&balaji=palani&maruthu=syed&abdullah=uyg34touy3gu3iugrowerugwieruygi
