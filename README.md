# ljson

<a href="http://dropr.com/coenhamelink/15218/jason_and_the_argonauts/+?p=97582"><img src="resources/images/jason-argonauts-small.png" /></a>

## Introduction

This library was educated by
[Chiron](http://en.wikipedia.org/wiki/Chiron#Students)
to avenge the crimes against JSON and its heirs in the Erlang world. It is
destined to search for the
[Golden Macro](http://en.wikipedia.org/wiki/Golden_Fleece), as
revealed by the
[Cloud Goddess](http://en.wikipedia.org/wiki/Nephele).


## Installation

Just add it to your ``rebar.config`` deps:

```erlang
  {deps, [
    ...
    {ljson, ".*",
      {git, "git@github.com:thorgisl/ljson.git", "master"}}
      ]}.
```

And then do the usual:

```bash
    $ make compile
```


## Usage

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
> (ljson:print (ljson:encode 'a))
<<"\"a\"">>
ok
> (ljson:print (ljson:encode "a"))
<<"[97]">>
ok
> (ljson:print (ljson:encode 1))
<<"1">>
ok
> (ljson:print (ljson:encode 3.14))
<<"3.14">>
ok
> (ljson:print (ljson:encode '(a b c 42)))
<<"[\"a\",\"b\",\"c\",42]">>
ok
> (ljson:print (ljson:encode #(a b)))
<<"{\"a\":\"b\"}">>
ok
> (ljson:print (ljson:encode '(#(a b) #(c d))))
<<"{\"a\":\"b\",\"c\":\"d\"}">>
ok
>
```


Decode simple JSON:

```cl
> (ljson:print (ljson:decode #b("\"a\"")))
<<"a">>
ok

;; ljson can just as easily decode string as binary:
> (ljson:print (ljson:decode "\"a\"")))
<<"a">>
ok

> (ljson:print (ljson:decode #b("[97]")))
"a"
ok
> (ljson:print (ljson:decode #b("1")))
1
ok
> (ljson:print (ljson:decode #b("3.14")))
3.14
ok
> (ljson:print (ljson:decode #b("[\"a\",\"b\",\"c\",42]")))
[<<"a">>,<<"b">>,<<"c">>,42]
ok
> (ljson:print (ljson:decode "{\"a\": \"b\"}"))
{<<"a">>,<<"b">>}
ok
> (ljson:print (ljson:decode "{\"a\":\"b\",\"c\":\"d\"}"))
[{<<"a">>,<<"b">>},{<<"c">>,<<"d">>}]
ok
> (ljson:print
    (ljson:decode
	    #B(123 34 97 34 58 34 98 34 44 34 99 34 58 34 100 34 125)))
[{<<"a">>,<<"b">>},{<<"c">>,<<"d">>}]
ok
>
```

Decode a JSON data structure (note that, for formatting purposes, the data
below has been presented separated with newlines; this won't work in the
LFE REPL -- you'll need to put it all on one line):

```cl
> (set json-data "{
  \"First Name\": \"JÃ³n\",
  \"Last Name\": \"ÃÃ³rson\",
  \"Is Alive?\": true,
  \"Age\": 25,
  \"Height_cm\": 167.6,
  \"Address\": {
    \"Street Address\": \"Ã­ Gongini 5 Postsmoga 108\",
    \"City\": \"TÃ³rshavn\",
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
(#(#B(70 105 114 115 116 32 78 97 109 101) #B(74 195 179 110))
 #(#B(76 97 115 116 32 78 97 109 101) #B(195 158 195 179 114 115 111 110))
 #(#B(73 115 32 65 108 105 118 101 63) true)
 #(#B(65 103 101) 25)
 #(#B(72 101 105 103 104 116 95 99 109) 167.6)
 #(#B(65 100 100 114 101 115 115)
   #((#(#B(83 116 114 101 101 116 32 65 100 100 114 101 115 115)
        #B(195 173 32 71 111 110 103 105 110 105 32 53 32 80 111 115 116 115 109 111 103 ...))
      #(#B(67 105 116 121) #B(84 195 179 114 115 104 97 118 110))
      #(#B(67 111 117 110 116 114 121)
        #B(70 97 114 111 101 32 73 115 108 97 110 100 115))
      #(#B(80 111 115 116 97 108 32 67 111 100 101) #B(49 48 48)))))
 #(#B(80 104 111 110 101 32 78 117 109 98 101 114 115)
   (#((#(#B(84 121 112 101) #B(104 111 109 101))
       #(#B(78 117 109 98 101 114) #B(50 48 32 54 48 32 51 48))))
    #((#(#B(84 121 112 101) #B(111 102 102 105 99 101))
       #(#B(78 117 109 98 101 114)
         #B(43 50 57 56 32 50 48 32 54 48 32 50 48))))))
 #(#B(67 104 105 108 100 114 101 110) ())
 #(#B(83 112 111 117 115 101) null))
> (ljson:print data)
[{<<"First Name">>,<<"Jón"/utf8>>},
 {<<"Last Name">>,<<"Þórson"/utf8>>},
 {<<"Is Alive?">>,true},
 {<<"Age">>,25},
 {<<"Height_cm">>,167.6},
 {<<"Address">>,
  {[{<<"Street Address">>,<<"í Gongini 5 Postsmoga 108"/utf8>>},
    {<<"City">>,<<"Tórshavn"/utf8>>},
    {<<"Country">>,<<"Faroe Islands">>},
    {<<"Postal Code">>,<<"100">>}]}},
 {<<"Phone Numbers">>,
  [{[{<<"Type">>,<<"home">>},{<<"Number">>,<<"20 60 30">>}]},
   {[{<<"Type">>,<<"office">>},{<<"Number">>,<<"+298 20 60 20">>}]}]},
 {<<"Children">>,[]},
 {<<"Spouse">>,null}]
ok
>
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
>
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

Extract elements from LFE data structure:

```cl
> (ljson:print (ljson:get #("First Name") data))
<<"Jón"/utf8>>
ok
> (ljson:print (ljson:get #("Address" "City") data))
<<"Tórshavn"/utf8>>
ok
> (ljson:print (ljson:get #(("Phone Numbers") first "Type") data))
<<"home">>
ok
```

Extract elements from JSON:

```cl
> (ljson:print (ljson:get #("First Name") json-data #(json)))
<<"\"J\\u00f3n\"">>
ok
> (ljson:print (ljson:get #("Address" "City") json-data #(json)))
<<"\"T\\u00f3rshavn\"">>
ok
> (ljson:print (ljson:get #(("Phone Numbers") first "Type") json-data #(json)))
<<"\"home\"">>
ok
```


## Under the Deck

The Argonauts that are rowing this thing consist of the following:

* mochijson2 - for encoding
* jiffy - for decoding
* ej - for extracing and updating JSON data elements
* jsx - for ``prettify`` and ``minify``
* dict - (wrapped as ``pairs``) for large key/value lists
* proplists/lists of tuples - for small key/value lists


