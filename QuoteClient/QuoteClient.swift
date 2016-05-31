//
//  QuoteClient.swift
//  Quotes of Ice and Fire
//
//  Created by Adolfo on 26/05/16.
//  Copyright (c) 2016 desappstre e{S}tudio. All rights reserved.
//

import Foundation

///
/// Closure donde devolvemos el resultado de lectura del feed
///
/// - Parameter result: Un valor de la enumeracion que informa del 
///     exito o fracaso de la operacion
///
public typealias QuoteCompletionHandler = (result: QuoteResult) -> (Void)

///
/// All API request will be *returned* here
///
private typealias HttpRequestCompletionHandler = (result: HttpResult) -> (Void)

/**
    Cliente de acceso al servicio de citas
    de **Juego de Tronos** desarrollado por [wsizoo](https://github.com/wsizoo)

    Más información sobre el servicio:
    * [Servidor](https://got-quotes.herokuapp.com/quotes)
    * [GitHub](https://github.com/wsizoo/game-of-thrones-quotes)

    - Author: Adolfo // [@fitomad](https://twitter.com/fitomad)
    - Version: 1.0
*/
public class QuoteClient
{
	/// Singleton
	public static let quoteInstance: QuoteClient = QuoteClient()

	/// El recurso donde se encuentra el servicio
	private let baseURL: String

	/// The API client HTTP session
    private var httpSession: NSURLSession!
    /// API client HTTP configuration
    private var httpConfiguration: NSURLSessionConfiguration!

    /**
        Configuramos la conexion `HTTP`
    */
	private init()
	{
		self.baseURL = "https://got-quotes.herokuapp.com/quotes"

		self.httpConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        self.httpConfiguration.HTTPMaximumConnectionsPerHost = 10

        let http_queue: NSOperationQueue = NSOperationQueue()
        http_queue.maxConcurrentOperationCount = 10

        self.httpSession = NSURLSession(configuration:self.httpConfiguration,
                                             delegate:nil,
                                        delegateQueue:http_queue)
	}

	/**
        Obtenemos una cita sin importar el personaje 

        - Parameter completionHandler: Aqui es donde devolvemos los datos de la cita
	*/
	public func randomQuote(completionHandler: QuoteCompletionHandler) -> Void
	{
		let finalURL: NSURL = NSURL(string: self.baseURL)!

		self.requestURL(finalURL, returnHandler: completionHandler)
	}

	/**
        Obtienen una cita de un *personaje* especifico

        - Parameters:
            - character: Persona del que queremos una cita
            - completionHandler: Aqui realizamos la devolucion de datos
	*/
	public func quoteByCharacter(character: String, completionHandler: QuoteCompletionHandler) -> Void
	{
		let finalURL: NSURL = NSURL(string: "\(self.baseURL)?char=\(character)")!

		self.requestURL(finalURL, returnHandler: completionHandler)
	}

	//
	// MARK: - Private Methods
	//

    /**
        Extrae los datos de la cita del resultado `JSON`

        - Parameter dictionary: Documento `JSON` con el resultado obtenido del servidor
        - Returns: Una tupla (cita y persona) con los datos de la cita 
    */
	private func parseQuoteFromDictionary(dictionary: [String: AnyObject]) -> (quote: String, character: String)?
	{
		guard let quote = dictionary["quote"] as? String, character = dictionary["character"] as? String else
		{
			return nil
		}

		return (quote: quote, character: character)
	}

	/**
        Se encarga de hacer las llamadas `HTTP` para los dos tipos
        de peticiones que podemos hacer al servidor.

        El resultado de las dos operaciones es el mismo por lo que no
        es necesario ningun tipo de tratamiento especial.

        - Parameters:
            - url: Recurso que solicitamos
            - returnHandler: Resultado de la peticion
        - SeeAlso: `randomQuote` y `quoteByCharacter`
	*/
	private func requestURL(url: NSURL, returnHandler handler: QuoteCompletionHandler) -> Void
	{
		self.processHttpRequestForURL(url) { (result: HttpResult) -> (Void) in
            switch result
            {
                case let HttpResult.Success(data):
                	if let result = self.parseQuoteFromDictionary(data)
                	{
                		handler(result: QuoteResult.Success(result: result))
                	}
                	else
                	{
                		handler(result: QuoteResult.Error(reason: "json content error"))
                	}
                case let HttpResult.RequestError(_, message):
                    handler(result: QuoteResult.Error(reason: message))
                case let HttpResult.ConnectionError(reason):
                    handler(result: QuoteResult.Error(reason: reason))
                case HttpResult.JsonParingError:
                	handler(result: QuoteResult.Error(reason: "json parse error"))
            }
        }
	}

	/**
        Peticion a una URL

        - Parameters:
            - url: Request URL
            - completionHandler: The HTTP response will be found here.
    */
    private func processHttpRequestForURL(url: NSURL, httpHandler: HttpRequestCompletionHandler) -> Void
    {
        let request: NSURLRequest = NSURLRequest(URL: url)

        let data_task: NSURLSessionDataTask = self.httpSession.dataTaskWithRequest(request, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if let error = error
            {
                httpHandler(result: HttpResult.ConnectionError(reason: error.localizedDescription))
            }

            guard let data = data, http_response = response as? NSHTTPURLResponse else
            {
                httpHandler(result: HttpResult.ConnectionError(reason: NSLocalizedString("HTTP_CONNECTION_ERROR", comment: "")))
                return
            }

            switch http_response.statusCode
            {
                case 200:
                    if let resultado = (try? NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.AllowFragments)) as? [String: AnyObject]
                    {
                        httpHandler(result: HttpResult.Success(json: resultado))
                    }
                    else
                    {
                        httpHandler(result: HttpResult.JsonParingError)
                    }
                default:
                    let code: Int = http_response.statusCode
                    let message: String = NSHTTPURLResponse.localizedStringForStatusCode(code)

                    httpHandler(result: HttpResult.RequestError(code: code, message: message))
            }
        })

        data_task.resume()
    }
}