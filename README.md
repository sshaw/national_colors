# National Colors

A JSON file containing each country's national colors, in the proper order.


Scraped from https://en.wikipedia.org/wiki/National_colours which seems to be the only place
that has the **correct colors** in the **correct order**.

## Regenerating

A small [Ruby](https://www.ruby-lang.org/en/) script is used to scrape the Wikipedia page. To run it,
perform the following commands from this repository's root directory:

    cd src
    gem install normalize_country nokogiri
    ruby extract.rb

Alternatively, if you prefer [Bundler](https://bundler.io/):

    cd src
    bundle install
    bundle exec ruby extract.rb

The JSON will be written to `national_colors.json`. To use a different filename:

```
ruby extract.rb my_amaaaaaaaazing_filename.json
```

## html-colors

Mapping of CSS color names to hex values are done via a JSON file stolen from the
[html-colors](https://github.com/radiovisual/html-colors) node package.

## License

Released under the MIT License: http://www.opensource.org/licenses/MIT
