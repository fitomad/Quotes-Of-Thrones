//
//  QuoteResult.swift
//  Quote of Ice and Fire
//
//  Created by Adolfo on 13/5/15.
//  Copyright (c) 2016 Desappstre Studio. All rights reserved.
//

import Foundation

/**
	Tipo donde devolvemos el resultado de las 
	operaciones de consulta al API
	
	- Success: Todo correcto
	- Error: Algo ha pasado... :(
*/
public enum QuoteResult
{
	/// Operacion terminada con exito
	case Success(result: (quote: String, character: String))
	///	Algo ha salido mal
	case Error(reason: String)
}