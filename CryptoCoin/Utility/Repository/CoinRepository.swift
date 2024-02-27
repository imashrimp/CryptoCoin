//
//  CoinSearchRepository.swift
//  CryptoCoin
//
//  Created by 권현석 on 2/26/24.
//

import Foundation
import RealmSwift

enum RealmError: String, Error {
    case realmError = "!!!!!!!Realm 에러!!!!!!!"
    case createError = "Realm CREATE 에러"
    case readError = "Realm READ 에러"
    case updateError = "Realm UPDATE 에러"
    case deleteError = "Realm DELETE 에러"
}

final class CoinRepository {

    private let realm: Realm
    
    init?() {
        do {
            self.realm = try Realm()
            print(Realm.Configuration.defaultConfiguration.fileURL)
        } catch {
            return nil
        }
    }
    
    //CREATE
    func saveCryptoCoin(id: String) {
        
        let data = SearchedCoinDTO(coinId: id)
        
        do {
            try realm.write {
                realm.add(data)
            }
        } catch {
            print(RealmError.createError.rawValue)
        }
    }
    
    //READ
    func readSavedCryptoCoinList() -> [SavedCoinEntity] {
        let savedCryptoCoinList = Array(realm.objects(SearchedCoinDTO.self))
        
        let savedCoinEntityArr: [SavedCoinEntity] = savedCryptoCoinList.map { SavedCoinEntity(coinID: $0.coinId) }
        
        return savedCoinEntityArr
    }
    
    func checkCoinSaveState(coinId: String) -> Bool {
        let data = realm.object(ofType: SearchedCoinDTO.self,
                                forPrimaryKey: coinId)
        
        guard let _ = data else {
            return false
        }
        return true
    }
    
    //DELETE
    func deleteCryptoCoin(id: String) {
        guard let data = realm.object(ofType: SearchedCoinDTO.self, forPrimaryKey: id) else { return }
        
        do {
            try realm.write {
                realm.delete(data)
            }
        } catch {
            print(RealmError.deleteError.rawValue)
        }
    }
}
