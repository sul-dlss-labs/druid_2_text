# Druid2Text

**NOTE:** This is a Proof of Concept and not currently intended for production use.

This library takes a druid (the identifier for an object in the Stanford Digital Repository) and attempts to turn it into text. This currently only supports converting PDFs to text (intended for extracting plain text from Electronic Thesis & Dissertation PDFs), but could be extended to support other conversions (or objects that already contain plain text).

## Basic Usage

The examples here assume you're in the root of the repository and running in a ruby environment (e.g. `irb`)

By default the library will take an array of druids and write text files with the corresponding druid as the filename (+ `.txt`) in the `results` directory and dump the contents of any PDFs in the object to that file as text.

```ruby
require './druid_2_text'

Druid2Text.call(druids: ['pd570yx1816'])
```

## Configuring

You can print deubugging information by setting the `Druid2Text::DEBUG` constant to `true`.

```ruby
Druid2Text::DEBUG = true
```

You can also pass in a class to handle the results (that will be used instead of the default `Druid2Text::TextFileWriter` handler).

This class will be instantiated with the druid and the text and the class is responsible for handling the rest.

```ruby
class MyCustomHandler
  def initialize(druid:, text:)
    puts druid
    puts text
  end
end

Druid2Text.call(druids: ['pd570yx1816'], results_handler: MyCustomHandler)
```

## Processing Data Manually

In addition to providing a handler class, you can also pass a block to process the page data manually.

```ruby
Druid2Text.call(druids: ['pd570yx1816']) do |druid, pages|
  page_count = pages.count
  puts "#{druid} has #{page_count} pages"
  puts "#{pages.map(&:length).max} is the longest page"

  # Print the last half of the document with page indexes
  pages.each_with_index do |page, index|
    next if index < (page_count / 2)
    puts "Page index: #{index}"
    puts page
  end
end
```
