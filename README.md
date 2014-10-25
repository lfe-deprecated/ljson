# ljson

<a href="http://dropr.com/coenhamelink/15218/jason_and_the_argonauts/+?p=97582"><img src="resources/images/jason-argonauts-small.png" /></a>

## Introduction

This library was educated by
[Chiron](http://en.wikipedia.org/wiki/Chiron#Students)
to avenge the crimes against JSON and its heirs in the Erlang world. It is
destined to search for
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
  \"First Name\": \"John\",
  \"Last Name\": \"Smith\",
  \"Is Alive?\": true,
  \"Age\": 25,
  \"Height_cm\": 167.6,
  \"Address\": {
    \"Atreet Address\": \"21 2nd Street\",
    \"City\": \"New York\",
    \"State\": \"NY\",
    \"Postal Code\": \"10021-3100\"
  },
  \"Phone Numbers\": [
    {
      \"Type\": \"home\",
      \"Number\": \"212 555-1234\"
    },
    {
      \"Type\": \"office\",
      \"Number\": \"646 555-4567\"
    }
  ],
  \"Children\": [],
  \"Spouse\": null}")
> (set data (ljson:decode json-data))
(#(#B(70 105 114 115 116 32 78 97 109 101) #B(74 111 104 110))
 #(#B(76 97 115 116 32 78 97 109 101) #B(83 109 105 116 104))
 #(#B(73 115 32 65 108 105 118 101 63) true)
 #(#B(65 103 101) 25)
 #(#B(72 101 105 103 104 116 95 99 109) 167.6)
 #(#B(65 100 100 114 101 115 115)
   #((#(#B(65 116 114 101 101 116 32 65 100 100 114 101 115 115)
        #B(50 49 32 50 110 100 32 83 116 114 101 101 116))
      #(#B(67 105 116 121) #B(78 101 119 32 89 111 114 107))
      #(#B(83 116 97 116 101) #B(78 89))
      #(#B(80 111 115 116 97 108 32 67 111 100 101)
        #B(49 48 48 50 49 45 51 49 48 48)))))
 #(#B(80 104 111 110 101 32 78 117 109 98 101 114 115)
   (#((#(#B(84 121 112 101) #B(104 111 109 101))
       #(#B(78 117 109 98 101 114) #B(50 49 50 32 53 53 53 45 49 50 51 52))))
    #((#(#B(84 121 112 101) #B(111 102 102 105 99 101))
       #(#B(78 117 109 98 101 114) #B(54 52 54 32 53 53 53 45 52 53 54 55))))))
 #(#B(67 104 105 108 100 114 101 110) ())
 #(#B(83 112 111 117 115 101) null))
> (ljson:print data)
 {<<"Is Alive?">>,true},
 {<<"Age">>,25},
 {<<"Height_cm">>,167.6},
 {<<"Address">>,
  {[{<<"Atreet Address">>,<<"21 2nd Street">>},
    {<<"City">>,<<"New York">>},
    {<<"State">>,<<"NY">>},
    {<<"Postal Code">>,<<"10021-3100">>}]}},
 {<<"Phone Numbers">>,
  [{[{<<"Type">>,<<"home">>},{<<"Number">>,<<"212 555-1234">>}]},
   {[{<<"Type">>,<<"office">>},{<<"Number">>,<<"646 555-4567">>}]}]},
 {<<"Children">>,[]},
 {<<"Spouse">>,null}]
ok
>
```

Now let's take it full circle by encoding it again:

```cl
> (ljson:prettify (ljson:encode data))
{
  "First Name": "John",
  "Last Name": "Smith",
  "Is Alive?": true,
  "Age": 25,
  "Height_cm": 167.6,
  "Address": {
    "Atreet Address": "21 2nd Street",
    "City": "New York",
    "State": "NY",
    "Postal Code": "10021-3100"
  },
  "Phone Numbers": [
    {
      "Type": "home",
      "Number": "212 555-1234"
    },
    {
      "Type": "office",
      "Number": "646 555-4567"
    }
  ],
  "Children": [],
  "Spouse": null
}
ok
>
```

Extract elements from JSON:

```cl

```

Extract elements from data structure:

```cl

```

## Under the Deck

The Argonauts that are rowing this thing consist of the following:

* mochijson2 - for encoding
* jiffy - for decoding
* ej - for extracing and updating JSON data elements
* jsx - for ``prettify`` and ``minify``
* dict - (wrapped as ``pairs``) for large key/value lists
* proplists/lists of tuples - for small key/value lists


