//
//  XMLMapper.swift
//  XMLMapper
//
//  Created by Giorgos Charitakis on 14/09/2017.
//
//

import Foundation

public final class XMLMapper<N: XMLBaseMappable> {
//    public var shouldIncludeNilValues = false /// If this is set to true, toXML output will include null values for any variables that are not set.
    
    public init() {
        
    }
    
    // MARK: Mapping functions that map to an existing object toObject
    
    /// Maps a XML object to an existing Mappable object if it is a XML dictionary, or returns the passed object as is
    public func map(XMLObject: Any?, toObject object: N) -> N {
        if let XML = XMLObject as? [String: Any] {
            return map(XML: XML, toObject: object)
        }
        return object
    }
    
    /// Map a XML string onto an existing object
    public func map(XMLString: String, toObject object: N) -> N {
        if let XML = XMLMapper.parseXMLStringIntoDictionary(XMLString: XMLString) {
            return map(XML: XML, toObject: object)
        }
        return object
    }
    
    /// Maps a XML dictionary to an existing object that conforms to Mappable.
    /// Usefull for those pesky objects that have crappy designated initializers like NSManagedObject
    public func map(XML: [String: Any], toObject object: N) -> N {
        var mutableObject = object
        let map = XMLMap(mappingType: .fromXML, XML: XML, toObject: true)
        mutableObject.mapping(with: map)
        return mutableObject
    }
    
    //MARK: Mapping functions that create an object
    
    /// Map a XML string to an object that conforms to Mappable
    public func map(XMLString: String) -> N? {
        if let XML = XMLMapper.parseXMLStringIntoDictionary(XMLString: XMLString) {
            return map(XML: XML)
        }
        
        return nil
    }
    
    /// Maps a XML object to a Mappable object if it is a XML dictionary or NSString, or returns nil.
    public func map(XMLObject: Any?) -> N? {
        if let XML = XMLObject as? [String: Any] {
            return map(XML: XML)
        }
        
        return nil
    }
    
    /// Maps a XML dictionary to an object that conforms to Mappable
    public func map(XML: [String: Any]) -> N? {
        let map = XMLMap(mappingType: .fromXML, XML: XML)
        
        if let klass = N.self as? XMLMappable.Type { // Check if object is Mappable
            if var object = klass.init(map: map) as? N {
                object.mapping(with: map)
                return object
            }
        } else {
            // Ensure BaseMappable is not implemented directly
            assert(false, "XMLBaseMappable should not be implemented directly. Please implement Mappable, StaticMappable or ImmutableMappable")
        }
        
        return nil
    }
    
    // MARK: Mapping functions for Arrays and Dictionaries
    
    /// Maps a XML array to an object that conforms to Mappable
    public func mapArray(XMLString: String) -> [N]? {
        let parsedXML: Any? = XMLMapper.parseXMLString(XMLString: XMLString)
        
        if let objectArray = mapArray(XMLObject: parsedXML) {
            return objectArray
        }
        
        // failed to parse XML into array form
        // try to parse it into a dictionary and then wrap it in an array
        if let object = map(XMLObject: parsedXML) {
            return [object]
        }
        
        return nil
    }
    
    /// Maps a XML object to an array of Mappable objects if it is an array of XML dictionary, or returns nil.
    public func mapArray(XMLObject: Any?) -> [N]? {
        if let XMLArray = XMLObject as? [[String: Any]] {
            return mapArray(XMLArray: XMLArray)
        }
        
        return nil
    }
    
    /// Maps an array of XML dictionary to an array of Mappable objects
    public func mapArray(XMLArray: [[String: Any]]) -> [N] {
        // map every element in XML array to type N
        let result = XMLArray.flatMap(map)
        return result
    }
    
    /// Maps a XML object to a dictionary of Mappable objects if it is a XML dictionary of dictionaries, or returns nil.
    public func mapDictionary(XMLString: String) -> [String: N]? {
        let parsedXML: Any? = XMLMapper.parseXMLString(XMLString: XMLString)
        return mapDictionary(XMLObject: parsedXML)
    }
    
    /// Maps a XML object to a dictionary of Mappable objects if it is a XML dictionary of dictionaries, or returns nil.
    public func mapDictionary(XMLObject: Any?) -> [String: N]? {
        if let XML = XMLObject as? [String: [String: Any]] {
            return mapDictionary(XML: XML)
        }
        
        return nil
    }
    
    /// Maps a XML dictionary of dictionaries to a dictionary of Mappable objects
    public func mapDictionary(XML: [String: [String: Any]]) -> [String: N]? {
        // map every value in dictionary to type N
        let result = XML.filterMap(map)
        if result.isEmpty == false {
            return result
        }
        
        return nil
    }
    
    /// Maps a XML object to a dictionary of Mappable objects if it is a XML dictionary of dictionaries, or returns nil.
    public func mapDictionary(XMLObject: Any?, toDictionary dictionary: [String: N]) -> [String: N] {
        if let XML = XMLObject as? [String : [String : Any]] {
            return mapDictionary(XML: XML, toDictionary: dictionary)
        }
        
        return dictionary
    }
    
    /// Maps a XML dictionary of dictionaries to an existing dictionary of Mappable objects
    public func mapDictionary(XML: [String: [String: Any]], toDictionary dictionary: [String: N]) -> [String: N] {
        var mutableDictionary = dictionary
        for (key, value) in XML {
            if let object = dictionary[key] {
                _ = map(XML: value, toObject: object)
            } else {
                mutableDictionary[key] = map(XML: value)
            }
        }
        
        return mutableDictionary
    }
    
    /// Maps a XML object to a dictionary of arrays of Mappable objects
    public func mapDictionaryOfArrays(XMLObject: Any?) -> [String: [N]]? {
        if let XML = XMLObject as? [String: [[String: Any]]] {
            return mapDictionaryOfArrays(XML: XML)
        }
        
        return nil
    }
    
    ///Maps a XML dictionary of arrays to a dictionary of arrays of Mappable objects
    public func mapDictionaryOfArrays(XML: [String: [[String: Any]]]) -> [String: [N]]? {
        // map every value in dictionary to type N
        let result = XML.filterMap {
            mapArray(XMLArray: $0)
        }
        
        if result.isEmpty == false {
            return result
        }
        
        return nil
    }
    
    /// Maps an 2 dimentional array of XML dictionaries to a 2 dimentional array of Mappable objects
    public func mapArrayOfArrays(XMLObject: Any?) -> [[N]]? {
        if let XMLArray = XMLObject as? [[[String: Any]]] {
            var objectArray = [[N]]()
            for innerXMLArray in XMLArray {
                let array = mapArray(XMLArray: innerXMLArray)
                objectArray.append(array)
            }
            
            if objectArray.isEmpty == false {
                return objectArray
            }
        }
        
        return nil
    }
    
    // MARK: Utility functions for converting strings to XML objects
    
    /// Convert a XML String into a Dictionary<String, Any> using XMLSerialization
    public static func parseXMLStringIntoDictionary(XMLString: String) -> [String: Any]? {
        let parsedXML: Any? = XMLMapper.parseXMLString(XMLString: XMLString)
        return parsedXML as? [String: Any]
    }
    
    /// Convert a XML String into an Object using XMLSerialization
    public static func parseXMLString(XMLString: String) -> Any? {
        var parsedXML: Any?
        do {
            parsedXML = try XMLSerialization.xmlObject(withString: XMLString)
        } catch let error {
            print(error)
            parsedXML = nil
        }
        return parsedXML
    }

}

extension XMLMapper {
    
    // MARK: Functions that create XML from objects
    
    ///Maps an object that conforms to Mappable to a XML dictionary <String, Any>
    public func toXML(_ object: N) -> [String: Any] {
        var mutableObject = object
        let map = XMLMap(mappingType: .toXML, XML: [:])
        mutableObject.mapping(with: map)
        return map.XML
    }
    
    ///Maps an array of Objects to an array of XML dictionaries [[String: Any]]
    public func toXMLArray(_ array: [N]) -> [[String: Any]] {
        return array.map {
            // convert every element in array to XML dictionary equivalent
            self.toXML($0)
        }
    }
    
    ///Maps a dictionary of Objects that conform to Mappable to a XML dictionary of dictionaries.
    public func toXMLDictionary(_ dictionary: [String: N]) -> [String: [String: Any]] {
        return dictionary.map { k, v in
            // convert every value in dictionary to its XML dictionary equivalent
            return (k, self.toXML(v))
        }
    }
    
    ///Maps a dictionary of Objects that conform to Mappable to a XML dictionary of dictionaries.
    public func toXMLDictionaryOfArrays(_ dictionary: [String: [N]]) -> [String: [[String: Any]]] {
        return dictionary.map { k, v in
            // convert every value (array) in dictionary to its XML dictionary equivalent
            return (k, self.toXMLArray(v))
        }
    }
    
    /// Maps an Object to a XML string with option of pretty formatting
    public func toXMLString(_ object: N) -> String? {
        let XMLDict = toXML(object)
        
        return XMLMapper.toXMLString(XMLDict as Any)
    }
    
    /// Maps an array of Objects to a XML string with option of pretty formatting
    public func toXMLString(_ array: [N]) -> String? {
        let XMLDict = toXMLArray(array)
        
        return XMLMapper.toXMLString(XMLDict as Any)
    }
    
    /// Converts an Object to a XML string with option of pretty formatting
    public static func toXMLString(_ XMLObject: Any) -> String? {
        if let xmlRepresentable = XMLObject as? XMLRepresentable {
            return xmlRepresentable.xmlString
        }
        
        return nil
    }
}

extension XMLMapper where N: Hashable {
    
    /// Maps a XML array to an object that conforms to Mappable
    public func mapSet(XMLString: String) -> Set<N>? {
        let parsedXML: Any? = XMLMapper.parseXMLString(XMLString: XMLString)
        
        if let objectArray = mapArray(XMLObject: parsedXML) {
            return Set(objectArray)
        }
        
        // failed to parse XML into array form
        // try to parse it into a dictionary and then wrap it in an array
        if let object = map(XMLObject: parsedXML) {
            return Set([object])
        }
        
        return nil
    }
    
    /// Maps a XML object to an Set of Mappable objects if it is an array of XML dictionary, or returns nil.
    public func mapSet(XMLObject: Any?) -> Set<N>? {
        if let XMLArray = XMLObject as? [[String: Any]] {
            return mapSet(XMLArray: XMLArray)
        }
        
        return nil
    }
    
    /// Maps an Set of XML dictionary to an array of Mappable objects
    public func mapSet(XMLArray: [[String: Any]]) -> Set<N> {
        // map every element in XML array to type N
        return Set(XMLArray.flatMap(map))
    }
    
    ///Maps a Set of Objects to a Set of XML dictionaries [[String : Any]]
    public func toXMLSet(_ set: Set<N>) -> [[String: Any]] {
        return set.map {
            // convert every element in set to XML dictionary equivalent
            self.toXML($0)
        }
    }
    
    /// Maps a set of Objects to a XML string with option of pretty formatting
    public func toXMLString(_ set: Set<N>) -> String? {
        let XMLDict = toXMLSet(set)
        
        return XMLMapper.toXMLString(XMLDict as Any)
    }
}

extension Dictionary {
    internal func map<K: Hashable, V>(_ f: (Element) throws -> (K, V)) rethrows -> [K: V] {
        var mapped = [K: V]()
        
        for element in self {
            let newElement = try f(element)
            mapped[newElement.0] = newElement.1
        }
        
        return mapped
    }
    
    internal func map<K: Hashable, V>(_ f: (Element) throws -> (K, [V])) rethrows -> [K: [V]] {
        var mapped = [K: [V]]()
        
        for element in self {
            let newElement = try f(element)
            mapped[newElement.0] = newElement.1
        }
        
        return mapped
    }
    
    
    internal func filterMap<U>(_ f: (Value) throws -> U?) rethrows -> [Key: U] {
        var mapped = [Key: U]()
        
        for (key, value) in self {
            if let newValue = try f(value) {
                mapped[key] = newValue
            }
        }
        
        return mapped
    }
}
