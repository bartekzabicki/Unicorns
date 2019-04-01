//
//  Networking.swift
//  GithubViewer
//
//  Created by Bartek Żabicki on 16.02.2018.
//  Copyright © 2018 bartekzabicki. All rights reserved.
//

import UIKit

public typealias JSON = [String: Any]
public typealias Headers = [String: String]
public typealias NetworkingError = Networking.NetworkError
public typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void

// MARK: - Protocols

public protocol URLSessionProtocol {
  func dataTask(with url: URL, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol
  func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol
}

public protocol URLSessionDataTaskProtocol {
  func resume()
}

extension URLSession: URLSessionProtocol {
  public func dataTask(with url: URL, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
    return (dataTask(with: url, completionHandler: completionHandler) as URLSessionDataTask) as URLSessionDataTaskProtocol
  }
  
  public func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
    return (dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTask) as URLSessionDataTaskProtocol
  }
  
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {}

// MARK: - Networking

final public class Networking {
  
  // MARK: - Singleton
  
  public static var shared = Networking()
  private init(){}
  
  // MARK: - Properties
  
  public static var session: URLSessionProtocol = Networking.shared.defaultSession()
  public var timeoutIntervalForRequest = 15.0
  public var shouldUseMultipartAutomatically = true
  
  // MARK: - Enums
  
  public enum NetworkMethod: String {
    case post = "POST"
    case get = "GET"
    case delete = "DELETE"
    case put = "PUT"
  }
  
  public enum Encoding: String {
    case json = "application/json"
    case url = "application/x-www-form-urlencoded"
  }
  
  // MARK: - Error
  
  public struct NetworkError: Error, LocalizedError {
    
    public let code: Int
    public let description: String
    
    init(code: Int, description: String) {
      self.description = description
      self.code = code
      Log.e("[Networking Error] \(code) - \(description)")
    }
    
    init(code: Int, data: Data) {
      var message = "Expecting JSON as result"
      if let json = ((try? JSONSerialization.jsonObject(with: data, options: []) as? JSON) as JSON??) {
        if let description = json?["reason"] as? String {
          message = description
        } else if let key = json?.keys.first, let description = (json?[key] as? [String])?.first {
          message = description
        } else if let decodedMessage = String(data: data, encoding: .utf8) {
          message = decodedMessage
        }
      }
      self.init(code: code, description: message)
    }
    
  }
  
  // MARK: - Static functions
  
  public func request(with url: URL?, method: NetworkMethod, parameters: JSON? = nil,
                      headers: JSON? = nil, encoding: Encoding = .json, onSuccess: @escaping ((Data) -> Void),
                      onError: @escaping ((NetworkError) -> Void)) {
    guard let url = url else {
      print("Cannot run request without url")
      return
    }
    var request = URLRequest(url: url)
    request.httpMethod = method.rawValue
    headers?.forEach { element in
      if let value = element.value as? String {
        request.addValue(value, forHTTPHeaderField: element.key)
      }
    }
    switch method {
    case .post, .put:
      if let parameters = parameters, parameters.contains(where: {$0.value is Data}), shouldUseMultipartAutomatically {
        Log.i("Setup multipart")
        request = setupMultipart(request: request, with: parameters)
      } else {
        Log.i("Setup standard request")
        if let setupedRequest = setupRequestWith(request: request, parameters: parameters, headers: headers, encoding: encoding) {
          request = setupedRequest
        }
      }
    default:break
    }
    let session = Networking.session
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
    _ = session.dataTask(with: request) { (data, response, error) in
      guard let data = data, let statusCode = (response as? HTTPURLResponse)?.statusCode else {
        let error = NetworkError(code: (response as? HTTPURLResponse)?.statusCode ?? 0,
                                 description: error?.localizedDescription ?? "No error")
        onError(error)
        return
      }
      
      switch statusCode {
      case 200...299:
        onSuccess(data)
      case 400...600:
        debugPrint(request)
        onError(NetworkError(code: statusCode, data: data))
      default: break
      }
      }.resume()
  }
  
  public func request(with urlString: String, method: NetworkMethod, parameters: JSON? = nil,
               headers: JSON? = nil, encoding: Encoding = .json, onSuccess: @escaping ((Data) -> Void),
               onError: @escaping ((NetworkError) -> Void)) {
    guard let url = URL(string: urlString) else {
      print("Cannot get URL from \(urlString)")
      return
    }
    request(with: url,
            method: method,
            parameters: parameters,
            headers: headers,
            encoding: encoding,
            onSuccess: onSuccess,
            onError: onError)
  }
  
  // MARK: - Private functions
  
  private func defaultSession() -> URLSession {
    let sessionConfiguration = URLSessionConfiguration.default
    sessionConfiguration.timeoutIntervalForRequest = timeoutIntervalForRequest
    let session = URLSession(configuration: sessionConfiguration, delegate: nil, delegateQueue: OperationQueue.main)
    return session
  }
  
  private func setupRequestWith(request: URLRequest, parameters: JSON? = nil, headers: JSON?, encoding: Encoding) -> URLRequest? {
    var request = request
    request.addValue(encoding.rawValue, forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    guard let parameters = parameters else { return request }
    do {
      request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
    } catch {
      print("Cannot parse parameters into JSON")
      return nil
    }
    return request
  }
  
  private func setup(body: NSMutableData, with touple: (key: String, value: Data),
                     prefix boundaryPrefix: String) -> NSMutableData {
    let body = body
    body.appendString(boundaryPrefix)
    var fileExtension = "jpg"
    if let image = UIImage(data: touple.value), let _ = image.pngData() {
      fileExtension = "png"
    }
    body.appendString("""
      Content-Disposition: form-data; name=\"\(touple.key)\"; filename=\"\(touple.key).\(fileExtension)\"\r\n
      """)
    body.appendString("Content-Type: image/\(fileExtension)\r\n\r\n")
    body.append(touple.value)
    body.appendString("\r\n")
    return body
  }
  
  private func setupMultipart(request: URLRequest, with parameters: JSON) -> URLRequest {
    let boundary = "Boundary-\(UUID().uuidString)"
    var request = request
    request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    var body = NSMutableData()
    
    let boundaryPrefix = "--\(boundary)\r\n"
    var dataObjects:[(key: String, value: Data)] = []
    for (key, value) in parameters {
      if let data = value as? Data {
        dataObjects.append((key: key, value: data))
      } else {
        body.appendString(boundaryPrefix)
        body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
        body.appendString("\(value)\r\n")
      }
    }
    dataObjects.forEach({ touple in
      body = setup(body: body, with: touple, prefix: boundaryPrefix)
    })
    body.appendString("--".appending(boundary.appending("--")))
    request.httpBody = body as Data
    return request
  }
  
}

// MARK: - NSMutableData Extension - Specific to this Networking wrapper

extension NSMutableData {
  
  public func appendString(_ string: String) {
    let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
    append(data!)
  }
  
}
