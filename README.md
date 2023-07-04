# ljson

DEPRECATED - use the [jsx](https://github.com/talentdeficit/jsx) Erlang library instead!

[![Build Status][travis badge]][travis]
[![LFE Versions][lfe badge]][lfe]
[![Erlang Versions][erlang badge]][versions]
[![Tags][github tags badge]][github tags]
[![Downloads][hex downloads]][hex package]

*An LFE library which provides a unified JSON experience*

[![Project Logo][logo]][logo-large]


#### Contents

* [Introduction](#introduction-)
* [Dependencies](#dependencies-)
* [Installation](#installation-)
* [Usage](#usage-)
* [Future](#future-)
* [License](#license-)


## Introduction [&#x219F;](#contents)

This library was educated by
[Chiron](http://en.wikipedia.org/wiki/Chiron#Students)
to avenge the crimes against JSON and its heirs in the Erlang world. It is
destined to search for the
[Golden Macro](http://en.wikipedia.org/wiki/Golden_Fleece), as
revealed by the
[Cloud Goddess](http://en.wikipedia.org/wiki/Nephele).


## Dependencies [&#x219F;](#contents)

As of version 0.4.0, this project assumes that you have
[rebar3](https://github.com/rebar/rebar3) installed somwhere in your `$PATH`.
It no longer uses the old version of rebar. If you do not wish to use rebar3,
you may use the most recent rebar2-compatible release of ljson: 0.3.1.


## Installation [&#x219F;](#contents)

Just add it to your `rebar.config` deps:

```erlang
{deps, [
  ...
  {ljson, {git, "git@github.com:lfex/ljson.git", "master"}}
    ]}.
```

And then do the usual:

```bash
$ make compile
```


## Usage [&#x219F;](#contents)

The following usage examples are all done from the LFE REPL:

```
$ make repl-no-deps
Starting an LFE REPL ...
Erlang/OTP 17 [erts-6.2] [source] [64-bit] [smp:4:4] [async-threads:10] ...

LFE Shell V6.2 (abort with ^G)
>
```


Encode simple LFE data to JSON:

```cl
> (ljson:encode 'a)
#"\"a\""
ok
> (ljson:encode "a")
#"[97]"
ok
> (ljson:encode 1)
#"1"
ok
> (ljson:encode 3.14)
#"3.14"
ok
> (ljson:encode '(a b c 42))
#"[\"a\",\"b\",\"c\",42]"
ok
> (ljson:encode #(a b))
#"{\"a\":\"b\"}"
ok
> (ljson:encode '(#(a b) #(c d)))
#"{\"a\":\"b\",\"c\":\"d\"}"
ok
>
```


Decode simple JSON:

```cl
> (ljson:decode #b("\"a\""))
#"a"
ok
> (ljson:decode "\"a\""))
#"a"
ok
> (ljson:decode #b("[97]"))
"a"
ok
> (ljson:decode #b("1"))
1
ok
> (ljson:decode #b("3.14"))
3.14
ok
> (ljson:decode #b("[\"a\",\"b\",\"c\",42]"))
(#"a" #"b" #"c" 42)
ok
> (ljson:decode "{\"a\": \"b\"}")
#(#"a" #"b")
ok
> (ljson:decode "{\"a\":\"b\",\"c\":\"d\"}")
(#(#"a" #"b") #(#"c" #"d"))
ok
> (ljson:decode
    #B(123 34 97 34 58 34 98 34 44 34 99 34 58 34 100 34 125))
(#(#"a" #"b") #(#"c" #"d"))
ok
```

Decode a JSON data structure (note that, for formatting purposes, the data
below has been presented separated with newlines; this won't work in the
LFE REPL -- you'll need to put it all on one line):

```cl
> (set json-data "{
  \"First Name\": \"Jón\",
  \"Last Name\": \"Þórson\",
  \"Is Alive?\": true,
  \"Age\": 25,
  \"Height_cm\": 167.6,
  \"Address\": {
    \"Street Address\": \"í Gongini 5 Postsmoga 108\",
    \"City\": \"Tórshavn\",
    \"Country\": \"Faroe Islands\",
    \"Postal Code\": \"100\"
  },
  \"Phone Numbers\": [
    {
      \"Type\": \"home\",
      \"Number\": \"20 60 30\"
    },
    {
      \"Type\": \"office\",
      \"Number\": \"+298 20 60 20\"
    }
  ],
  \"Children\": [],
  \"Spouse\": null}")
> (set data (ljson:decode json-data))
(#(#"First Name" #"Jón")
 #(#"Last Name" #"Þórson")
 #(#"Is Alive?" true)
 #(#"Age" 25)
 #(#"Height_cm" 167.6)
 #(#"Address"
   (#(#"Street Address" #"í Gongini 5 Postsmoga 108")
    #(#"City" #"Tórshavn")
    #(#"Country" #"Faroe Islands")
    #(#"Postal Code" #"100")))
 #(#"Phone Numbers"
   ((#(#"Type" #"home") #(#"Number" #"20 60 30"))
    (#(#"Type" #"office") #(#"Number" #"+298 20 60 20"))))
 #(#"Children" ())
 #(#"Spouse" null))
```

Now let's take it full circle by encoding it again:

```cl
> (ljson:prettify (ljson:encode data))
{
  "First Name": "Jón",
  "Last Name": "Þórson",
  "Is Alive?": true,
  "Age": 25,
  "Height_cm": 167.6,
  "Address": {
    "Street Address": "í Gongini 5 Postsmoga 108",
    "City": "Tórshavn",
    "Country": "Faroe Islands",
    "Postal Code": "100"
  },
  "Phone Numbers": [
    {
      "Type": "home",
      "Number": "20 60 30"
    },
    {
      "Type": "office",
      "Number": "+298 20 60 20"
    }
  ],
  "Children": [],
  "Spouse": null
}
ok
```

Let's do the same, but this time from LFE data:

```cl
> (set lfe-data
   `(#(#b("First Name") ,(binary ("Jón" utf8)))
     #(#b("Last Name") ,(binary ("Þórson" utf8)))
     #(#b("Is Alive?") true)
     #(#b("Age") 25)
     #(#b("Height_cm") 167.6)
     #(#b("Address")
      #((#(#b("Street Address") ,(binary ("í Gongini 5 Postsmoga 108" utf8)))
        #(#b("City") ,(binary ("Tórshavn" utf8)))
        #(#b("Country") #b("Faroe Islands"))
        #(#b("Postal Code") #b("100")))))
     #(#b("Phone Numbers")
      (#((#(#b("Type") #b("home")) #(#b("Number") #b("20 60 30"))))
       #((#(#b("Type") #b("office")) #(#b("Number") #b("+298 20 60 20"))))))
     #(#b("Children") ())
     #(#b("Spouse") null)))
(#(#B(...)))
> (ljson:prettify (ljson:encode lfe-data))
{
  "First Name": "Jón",
  "Last Name": "Þórson",
  "Is Alive?": true,
  "Age": 25,
  "Height_cm": 167.6,
  "Address": {
    "Street Address": "í Gongini 5 Postsmoga 108",
    "City": "Tórshavn",
    "Country": "Faroe Islands",
    "Postal Code": "100"
  },
  "Phone Numbers": [
    {
      "Type": "home",
      "Number": "20 60 30"
    },
    {
      "Type": "office",
      "Number": "+298 20 60 20"
    }
  ],
  "Children": [],
  "Spouse": null
}
ok
```


Extract elements from the original converted data structure as well as
our LFE data structure we just entered directly, above:

```cl
> (ljson:get data '("First Name"))
#"Jón"
> (ljson:get data '("Address" "City"))
#"Tórshavn"
> (ljson:get data '("Phone Numbers" 1 "Type"))
#"home"
> (ljson:get lfe-data '("First Name") )
#"Jón"
> (ljson:get lfe-data '("Address" "City")data)
#"Tórshavn"
> (ljson:get lfe-data '("Phone Numbers" 1 "Type"))
#"home"
```

You may also use atom or binary keys:

```cl
> (ljson:get lfe-data '(|Phone Numbers| 1 Number))
#"20 60 30"
> (ljson:get lfe-data '(#"Phone Numbers" 1 #"Number"))
#"20 60 30"
```

Extract elements directly from JSON:

```cl
> (ljson:get json-data '("First Name") #(json))
#"\"J\\u00f3n\""
> (ljson:get json-data '("Address" "City") #(json))
#"\"T\\u00f3rshavn\""
> (ljson:get json-data '("Phone Numbers" 1 "Type") #(json))
#"\"home\""
```


## Under the Deck [&#x219F;](#contents)

The Argonauts that are rowing this thing consist of the following:

* mochijson2 - for encoding of nested data
* jsx - for decoding, `prettify` and `minify`
* dict - (wrapped as `pairs`) for large key/value lists
* proplists/lists of tuples - for small key/value lists


## License [&#x219F;](#contents)

Apache Version 2 License

Copyright © 2014-2015, Dreki Þórgísl

Copyright © 2015, arpunk

Copyright © 2015-2019, Duncan McGreggor <oubiwann@gmail.com>


<!-- Named page links below: /-->

[logo]: priv/images/jason-argonauts-small.png
[logo-large]: http://dropr.com/coenhamelink/15218/jason_and_the_argonauts/+?p=97582
[org]: https://github.com/lfex
[github]: https://github.com/lfex/ljson
[gitlab]: https://gitlab.com/lfex/ljson
[travis]: https://travis-ci.org/lfex/ljson
[travis badge]: https://img.shields.io/travis/lfex/ljson.svg
[lfe]: https://github.com/rvirding/lfe
[lfe badge]: https://img.shields.io/badge/lfe-1.3.0-blue.svg
[erlang badge]: https://img.shields.io/badge/erlang-17.5%20to%2022.0-blue.svg
[versions]: https://github.com/lfex/ljson/blob/master/.travis.yml
[github tags]: https://github.com/lfex/ljson/tags
[github tags badge]: https://img.shields.io/github/tag/lfex/ljson.svg
[github downloads]: https://img.shields.io/github/downloads/lfex/ljson/total.svg
[hex badge]: https://img.shields.io/hexpm/v/ljson.svg?maxAge=2592000
[hex package]: https://hex.pm/packages/ljson
[hex downloads]: https://img.shields.io/hexpm/dt/ljson.svg
