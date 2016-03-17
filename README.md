# ljson

<a href="http://dropr.com/coenhamelink/15218/jason_and_the_argonauts/+?p=97582"><img src="resources/images/jason-argonauts-small.png" /></a>

#### Contents

* [Introduction](#introduction-)
* [Dependencies](#dependencies-)
* [Installation](#installation-)
* [Usage](#usage-)
* [Future](#future-)


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
[rebar3](https://github.com/rebar/rebar3) installed somwhere in your ``$PATH``.
It no longer uses the old version of rebar. If you do not wish to use rebar3,
you may use the most recent rebar2-compatible release of ljson: 0.3.1.


## Installation [&#x219F;](#contents)

Just add it to your ``rebar.config`` deps:

```erlang
  {deps, [
    ...
    {ljson, ".*",
      {git, "git@github.com:lfex/ljson.git", "master"}}
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
> (ljson:get '("First Name") data)
#"Jón"
> (ljson:get '("Address" "City") data)
#"Tórshavn"
> (ljson:get '("Phone Numbers" 1 "Type") data)
#"home"
> (ljson:get '("First Name") lfe-data)
#"Jón"
> (ljson:get '("Address" "City") lfe-data)
#"Tórshavn"
> (ljson:get '("Phone Numbers" 1 "Type") lfe-data)
#"home"
```

You may also use atom or binary keys:

```cl
> (ljson:get '(|Phone Numbers| 1 Number) lfe-data)
#"20 60 30"
> (ljson:get '(#b("Phone Numbers") 1 #b("Number")) lfe-data)
#"20 60 30"
```

Extract elements directly from JSON:

```cl
> (ljson:get '("First Name") json-data #(json))
#"\"J\\u00f3n\""
> (ljson:get '("Address" "City") json-data #(json))
#"\"T\\u00f3rshavn\""
> (ljson:get '("Phone Numbers" 1 "Type") json-data #(json))
#"\"home\""
```


## Under the Deck [&#x219F;](#contents)

The Argonauts that are rowing this thing consist of the following:

* mochijson2 - for encoding of nested data
* jsx - for decoding, ``prettify`` and ``minify``
* dict - (wrapped as ``pairs``) for large key/value lists
* proplists/lists of tuples - for small key/value lists


