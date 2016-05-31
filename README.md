# Quotes of Thrones
Swift client for the quotes service develop by [@wsizoo](https://github.com/wsizoo). 

* [GitHub repository](https://github.com/wsizoo/game-of-thrones-quotes)
* [Server](https://got-quotes.herokuapp.com/quotes)


All quotes are based on the characters of the *A Song of Ice and Fire* books serie by **George R.R. Martin**.

## Usage

Add the following files to your iOS project...

* QuoteClient
* HttpResult
* QuoteResult

...and ask for some quotes.

An Unit Test file is supplied but It's not mandatory in order to build yout project.

## Example

```swift
//
// Get Random Quote
//
QuoteClient.quoteInstance.randomQuote { (result) -> (Void) in
    switch result
    {
        case let QuoteResult.Success(result: (quote, character)):
            print("\(quote)\r\n\t- \(character)")
        case let QuoteResult.Error(reason):
            print("error: \(reason)")
    }
}
```

You can also get quotes filtered by character

```swift
QuoteClient.quoteInstance.quoteByCharacter("Tyrion") { (result) -> (Void) in
    switch result
    {
        case let QuoteResult.Success(result: (quote, character)):
            print("\(quote)\r\n\t- \(character)")
        case let QuoteResult.Error(reason):
            print("error: \(reason)")
    }
}
```
## Contact

You can find me in my Twitter account [@fitomad](https://twitter.com/fitomad)
