//
//  HttpResult.swift
//  Quote of Ice and Fire
//
//  Created by Adolfo on 18/2/16.
//  Copyright (c) 2016 Desappstre Studio. All rights reserved.
//

import Foundation

/**
	Posibles resultados al ejecutat una peticion HTTP
	para el feed de información de incidencias de la EMT.

	Los posibles valores devolvemos son:

	- Success: Recuperamos el contenido del stream
	- RequestError: Problema en la peticion HTTP
	- ConnectionError: Error general
	- JsonParingError: No se ha podido procesar el documento JSON
*/
internal enum HttpResult
{
	/// La operacion ha terminado bien.
	/// Devolvemos el stream de datos reacuperados
	case Success(json: [String: AnyObject])
	/// Algo ha salido mal.
	/// Devolvemos un mensaje con la descripcion del error
	/// y el codigo HTTP asociado
	case RequestError(code: Int, message: String)
	/// Error general
	case ConnectionError(reason: String)
	/// Error documento JSON
	case JsonParingError
}