//
//  DiscogsWrapper.swift
//  DiscogsWrapper
//
//  Created by Benny Lach on 07.06.15.
//  Copyright (c) 2015 BL. All rights reserved.
//

import Foundation

typealias ToupleCompletionBlock = (((pagination: [String: AnyObject], releases: [DiscogsRelease])?, error: NSError?) -> Void)
typealias CompletionBlock = ((responseObject: AnyObject?, error: NSError?) -> Void)

class DiscogsWrapper {
    
    static let sharedInstance = DiscogsWrapper()
    private let baseUrl: String = "api.discogs.com"
    
    var userAgent: String = "Swifty DiscogsWrapper 0.1/ githubURLHere"
    var scheme: String = "https"
    var pagination: Int = 100
    
    private init() {}
    
    // MARK: - Artist functions
    
    /// Function to fetch a DiscogsArtist object for an given artistId
    ///
    /// :param: artistId The Id of the artist you want to fetch
    ///
    /// :returns: If no error occured, an object of type DiscogsArtist containing all availiable information will be returned. If an error occured the object is nil instead. If so, check the returned error or the response to investigate the problem.
    func getArtist(artistId: Int, completion: CompletionBlock) {
        startGetRequest("/artists/\(artistId)", parameters: nil, completion: { (responseDict, response, error) -> Void in
            if responseDict != nil {
                let artist = DiscogsArtist(artistDict: responseDict!)
                completion(responseObject: artist, error: nil)
            } else {
                completion(responseObject: nil, error: error)
            }
        })
    }
    
    /// Function to fetch a dictionary containing all Releases for an given artistId. Pagination is working here!
    ///
    /// :param: artistId The Id of the artist you want to fetch
    ///
    /// :returns: If no error occured, a Dictionary containing all availiable releases will be returned. If an error occured the Dictionary is nil instead. If so, check the returned error or the response to investigate the problem.
    func getReleasesOfArtist(artistId: Int, completion: ToupleCompletionBlock) {
        startGetRequest("/artists/\(artistId)/releases", parameters: ["per_page": pagination], completion: { (responseDict, response, error) -> Void in
            if let response = responseDict {
                if let paginationDict = response["pagination"] as? [String: AnyObject] {
                    if let releaseArray = response["releases"] as? [[String: AnyObject]] {
                        var array: [DiscogsRelease] = []
                        for release in releaseArray {
                            array.append(DiscogsRelease(releaseDict: release))
                        }
                        completion((pagination: paginationDict, releases: array), error: nil)
                    }
                }
            } else {
                completion(nil, error: error)
            }
        })
    }
    
    // MARK: - Release functions
    
    /// Function to fetch a DiscogsRelease object for a given releaseId
    ///
    /// :param: releaseId The Id of the release you want to fetch
    ///
    /// :returns: If no error occured, an object of type DiscogsRelease containing all availiable information will be returned. If an error occured the release is nil instead.  If so, check the returned error or the response to investigate the problem.
    func getRelease(releaseId: Int, completion: CompletionBlock) {
        startGetRequest("/releases/\(releaseId)", parameters: nil) { (responseDict, response, error) -> Void in
            if responseDict != nil {
                let release = DiscogsRelease(releaseDict: responseDict!)
                completion(responseObject: release, error: nil)
            } else {
                completion(responseObject: nil, error: error)
            }
        }
    }
    
    // MARK: - MasterRelease functions
    
    /// Function to fetch a DiscogsMasterRelease object for a given masterID
    ///
    /// :param: masterId The Id of the master release you want to fetch
    ///
    /// :returns: If no error occured, a DiscogsMasterRelease object containing all availiable information will be returned. If an error occured the artist is nil instead.  If so, check the returned error or the response to investigate the problem.
    func getMasterRelease(masterId: Int, completion: CompletionBlock) {
        startGetRequest("/masters/\(masterId)", parameters: nil) { (responseDict, response, error) -> Void in
            if let response = responseDict {
                let masterRelease = DiscogsMasterRelease(masterDict: response)
                completion(responseObject: masterRelease, error: nil)
            } else {
                completion(responseObject: nil, error: error)
            }
        }
    }
    
    /// Function to fetch a dictionary containing all versions of a given masterId. Pagination is working here!
    ///
    /// :param: masterId The Id of the master release you want to fetch
    ///
    /// :returns: If no error occured, a Dictionary containing all availiable versions will be returned. If an error occured the Dictionary is nil instead.  If so, check the returned error or the response to investigate the problem.
    func getMasterReleaseVersions(masterID: Int, completion: ToupleCompletionBlock) {
        startGetRequest("/masters/\(masterID)", parameters: ["per_page": pagination]) { (responseDict, response, error) -> Void in
            if let response = responseDict {
                if let paginationDict = response["pagination"] as? [String: AnyObject] {
                    if let releaseArray = response["releases"] as? [[String: AnyObject]] {
                        var array: [DiscogsRelease] = []
                        for release in releaseArray {
                            array.append(DiscogsRelease(releaseDict: release))
                        }
                        completion((pagination: paginationDict, releases: array), error: nil)
                    }
                }
            } else {
                completion(nil, error: error)
            }
        }
    }

    // MARK: - Label functions
    
    /// Function to fetch a DiscogsLabel object for a given labelId
    ///
    /// :param: labelId The Id of the master release you want to fetch
    ///
    /// :returns: If no error occured, a DiscgosLabel object containing all availiable information will be returned. If an error occured the artist is nil instead.  If so, check the returned error or the response to investigate the problem.
    func getLabel(labelId: Int, completion: CompletionBlock) {
        startGetRequest("/labels/\(labelId)", parameters: nil) { (responseDict, response, error) -> Void in
            if let labelDict = responseDict {
                let label = DiscogsLabel(labelDict: labelDict)
                completion(responseObject: label, error: nil)
            } else {
                completion(responseObject: nil, error: nil)
            }
        }
    }

    /// Function to fetch a dictionary containing all releases for a given labelId. Pagination is working here!
    ///
    /// :param: labelId The Id of the label you want to fetch
    ///
    /// :returns: If no error occured, a Dictionary containing all availiable releases will be returned. If an error occured the dictionary is nil instead.  If so, check the returned error or the response to investigate the problem.
    func getLabelReleases(labelId: Int, completion: ToupleCompletionBlock) {
        startGetRequest("/labels/\(labelId)/releases", parameters: ["per_page":pagination]) { (responseDict, response, error) -> Void in
            if let response = responseDict {
                if let paginationDict = response["pagination"] as? [String: AnyObject] {
                    if let releaseArray = response["releases"] as? [[String: AnyObject]] {
                        var array: [DiscogsRelease] = []
                        for release in releaseArray {
                            array.append(DiscogsRelease(releaseDict: release))
                        }
                        completion((pagination: paginationDict, releases: array), error: nil)
                    }
                }
            } else {
                completion(nil, error: error)
            }
        }
    }
    
    // MARK: - Inventory function
    
    /// Function to fetch a dictionary containing the public inventory of a specific user. Pagination is working here!
    ///
    /// :param: username The owner of the inventory you want to fetch
    /// :param: params A dictionary containing inventory specific parameters - http://www.discogs.com/developers/#page:marketplace,header:marketplace-inventory-get
    ///
    /// :returns: If no error occured, a dictionary containing all available listings will be returned. If an error occured the object is nil instead.  If so, check the returned error or the response to investigate the problem.
    func getInventory(username: String, params: [String:String]?, completion: CompletionBlock) {
        startGetRequest("/users/\(username)/inventory", parameters: params) { (responseDict, response, error) -> Void in
            completion(responseObject: responseDict, error: error)
        }
    }
    
    // MARK: - Fee function
    
    /// Function to calculate the fee for a specific amount. Default fee currency is USD
    ///
    /// :param: price The amount of money you want to calculate the fee for
    /// :param: currency If you want to calculate the fee for a specific currency use this value - http://www.discogs.com/developers/#page:marketplace,header:marketplace-fee-with-currency-get
    ///
    /// :returns: If no error occured a dictionary containing the fee information will be returned. If an error occured the dictionary is nil instead.  If so, check the returned error or the response to investigate the problem.
    func getFee(price: Double, currency: String?, completion: CompletionBlock) {
        var path = "\(price)"
        if currency != nil {
            path += "/\(currency!)"
        }
        startGetRequest("/fee/\(path)", parameters: nil) { (responseDict, response, error) -> Void in
            completion(responseObject: responseDict, error: error)
        }
    }
    
    // MARK: - Global User functions
    
    /// Function to fetch a public user profile
    ///
    /// :param: username The name of the user you want to fetch
    ///
    /// :returns: If no error occured, a DiscogsUser object containing all available information will be returned. If an error occured the object is nil instead.  If so, check the returned error or the response to investigate the problem.
    func getUser(username: String, completion: CompletionBlock) {
        startGetRequest("/users/\(username)", parameters: nil) { (responseDict, response, error) -> Void in
            if let userDict = responseDict {
                let user = DiscogsUser(userDict: userDict)
                completion(responseObject: user, error: nil)
            } else {
                completion(responseObject: nil, error: error)
            }
        }
    }
    
    /// Function to fetch submissions of a user. Pagination is workong here!
    ///
    /// :param: username The name of the user you want to fetch the submissions from
    ///
    /// :returns: If no error occured, a dictionary containing all submissions will be returned. If an error occured the object is nil instead.  If so, check the returned error or the response to investigate the problem.
    func getUserSubmissions(username: String, completion: CompletionBlock) {
        startGetRequest("/users/\(username)/submissions", parameters: ["per_page": pagination]) { (responseDict, response, error) -> Void in
            completion(responseObject: responseDict, error: error)
        }
    }
    
    /// Function to fetch a users contributions. Pagination is workong here!
    ///
    /// :param: username The name of the user you want to fetch the contributions from
    ///
    /// :returns: If no error occured, a dictionary containing all contributions will be returned. If an error occured the object is nil instead. If so, check the returned error or the response to investigate the problem.
    func getUserContributions(username: String, completion: CompletionBlock) {
        startGetRequest("/users/\(username)/contributions", parameters: ["per_page": pagination]) { (responseDict, response, error) -> Void in
            completion(responseObject: responseDict, error: error)
        }
    }
    
    // MARK: - Global user collection functions
    
    /// Function to fetch all public folders for a user
    ///
    /// :param: username The name of the user you want to fetch the folders from
    ///
    /// :returns: If no error occured, a dictionary containing all public folders will be returned. If an error occured the object is nil instead. If so, check the returned error or the response to investigate the problem.
    func getUserCollectionFolders(username: String, completion: CompletionBlock) {
        startGetRequest("/users\(username)/collection/folders", parameters: nil) { (responseDict, response, error) -> Void in
            completion(responseObject: responseDict, error: error)
        }
    }
    
    /// Function to fetch the meta data of a folder from a specific user
    ///
    /// :param: username The name of the user you want to fetch the folders meta data from
    /// :param: folderId The Id of the folder you want to fetch the meta data from
    ///
    /// :returns: If no error occured, a dictionary containing the folders meta data will be returned. If an error occured the object is nil instead. If so, check the returned error or the response to investigate the problem.
    func getUserFolderMetaData(username: String, folderId: Int, completion: CompletionBlock) {
        startGetRequest("/users/\(username)/collection/folders/\(folderId))", parameters: nil) { (responseDict, response, error) -> Void in
            completion(responseObject: responseDict, error: error)
        }
    }
    
    /// Function to fetch all releases of a specific folder from a user. Pagination is working here!
    ///
    /// :param: username The name of the user you want to fetch the folders releases from
    /// :param: folderId The Id of the folder you want to fetch the releases from
    ///
    /// :returns: If no error occured, a dictionary containing the folders releases will be returned. If an error occured the object is nil instead. If so, check the returned error or the response to investigate the problem.
    func getUserFolderReleases(username:String, folderId:Int, completion:CompletionBlock) {
        startGetRequest("/users/\(username)/collection/folders/\(folderId)/releases", parameters: ["per_page": pagination]) { (responseDict, response, error) -> Void in
            completion(responseObject: responseDict, error: error)
        }
    }
    
    // MARK: - Global user wantlist functions
    
    /// Function to fetch the wantlist releases from a specific user. Pagination is working here!
    ///
    /// :param: username The name of the user you want to fetch the wantlist releases from
    ///
    /// :returns: If no error occured, a Dictionary containing the releases will be returned. If an error occured the object is nil instead. If so, check the response and error to investigate the problem.
    func getUserWantlist(username:String, completion:CompletionBlock) {
        startGetRequest("/users/\(username)/wants", parameters: ["per_page": pagination]) { (responseDict, response, error) -> Void in
            completion(responseObject: responseDict, error: error)
        }
    }

    // MARK: - API GET function unauthorized
    
    /// Function to make a raw GET request.
    ///
    /// :param: path The path of the endpoint you want to communicate to
    /// :param: parameters An optional dictionary containing properties you want to commit
    ///
    /// :returns: If no error occured, a dictionary will be returned. If an error occured the object is nil instead. If so, check the response and error to investigate the problem.
    func startGetRequest(path: String, parameters: [String: AnyObject]?, completion: (responseDict: [String: AnyObject]?, response: NSHTTPURLResponse?, error: NSError?) -> Void) {
        var urlString = scheme + "://" + baseUrl + path
        if let params = parameters {
            urlString =  urlString + "?"
            
            for key in params.keys {
                urlString = urlString + "\(key)=\(params[key]!)&"
            }
            urlString = urlString.substringToIndex(advance(urlString.endIndex, -1))
        }
        
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.HTTPAdditionalHeaders = ["User-Agent": userAgent]
        
        let session = NSURLSession(configuration: configuration)
        let url = NSURL(string: urlString)!
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        
        let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                completion(responseDict: nil, response: response as? NSHTTPURLResponse, error: error)
            } else {
                let parseResult = self.getJSONFromData(data)
                completion(responseDict: parseResult.0, response: response as? NSHTTPURLResponse, error: parseResult.1)
            }
        })
        task.resume()
    }
    
    /// MARK: - Private stuff
    private func getJSONFromData(data: NSData) -> (dict: [String: AnyObject]?, error: NSError?) {
        var error: NSError?
        
        if let parsedData = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &error) as? [String: AnyObject] {
            return (parsedData, error)
        }
        return (nil, error)
    }
}
