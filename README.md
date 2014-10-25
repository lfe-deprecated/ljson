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
    $ rebar get-deps
    $ rebar compile
```


## Usage

Encode simple LFE data to JSON:

```cl
> (io:format "~p~n" (list (ljson:encode #(a b))))
<<"{\"a\":\"b\"}">>
ok
> (io:format "~p~n" (list (ljson:encode '(#(a b) #(c d)))))
<<"{\"a\":\"b\",\"c\":\"d\"}">>
ok
>
```

Decode simple JSON:

```cl
> (io:format "~p~n" (list (ljson:decode "{\"a\": \"b\"}")))
{<<"a">>,<<"b">>}
ok
> (io:format "~p~n" (list (ljson:decode "{\"a\":\"b\",\"c\":\"d\"}")))
[{<<"a">>,<<"b">>},{<<"c">>,<<"d">>}]
ok
> (io:format "~p~n"
    (list
      (ljson:decode
      	#B(123 34 97 34 58 34 98 34 44 34 99 34 58 34 100 34 125))))
[{<<"a">>,<<"b">>},{<<"c">>,<<"d">>}]
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
* dict - (wrapped as ``pairs``) for large key/value lists
* proplists/lists of tuples - for small key/value lists


