import NumberLink

var options = NumberLinkGenerator.Options.default
options.limit = 100
options.isVerbose = true

try? NumberLinkGenerator(options: options).generate(width: 5, height: 5, amountOfPins: 4)
