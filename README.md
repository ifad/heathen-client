<pre>
    )                          )          )
 ( /(        (       *   )  ( /(       ( /(
 )\()) (     )\    ` )  /(  )\()) (    )\())
((_)\  )\ ((((_)(   ( )(_))((_)\  )\  ((_)\
 _((_)((_) )\ _ )\ (_(_())  _((_)((_)  _((_)
| || || __|(_)_\(_)|_   _| | || || __|| \| |
| __ || _|  / _ \    | |   | __ || _| | .` |
|_||_||___|/_/ \_\   |_|   |_||_||___||_|\_|
</pre>
# Convert the heathens. 
***

# Heathen::Client

A Ruby client for the [Heathen](https://github.com/ifad/heathen) service.

## Installation

Add this line to your application's Gemfile:

    gem 'heathen-client'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install heathen-client

## Usage

### Set the Base URI

Before anything, you will need to set the url of the running Heathen service.
`Heathen::Client.client = Heathen::Client.new(base_uri: "http://<heathen url>")`

Without the above line, the client will attempt to make API calls against `http://localhost:9292`.

Heathen::Client::pdf takes an options hash with a `file` or `url` key. The `file` key can map to a filesystem path string, or an instance of `IO`. The method returns an instance of `Heathen::Client::Response`.

### Convert a Word document to PDF

In one shot:

```
Heathen::Client.pdf(file: "/path/to/word.doc").get do |data|
  File.open("/path/to/saved.pdf", "wb") do |dest|
    dest.write(data)
  end
end
```

For the lazy:

`response = Heathen::Client.pdf(file: "/path/to/word.doc")`

A little later:

```
File.open("/path/to/saved.pdf", "wb") do |dest|
  response.get { |data| dest.write(data) }
end
```

### Get the original

```
File.open("/path/to/saved_original.doc", "wb") do |dest|
  response.get(:original) { |data| dest.write(data) }
end
```

### Converting an image to PDF with searching/selection

`response = Heathen::Client.ocr(file: "/path/to/text_image.tiff")`
Downloading/saving is the same as shown above.

# License

MIT

# Copyright

&copy; IFAD 2013
