# ljson

<a href="http://dropr.com/coenhamelink/15218/jason_and_the_argonauts/+?p=97582"><img src="resources/images/jason-argonauts-small.png" /></a>

## Introduction

This library was raised by Chiron to avenge the crimes against JSON and its
heirs in the Erlang world. It is destined to search for Golden Macro, as
revealed by the Cloud Goddess.


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

Create a new data structure:

```cl

```

Encode simple to JSON:

```cl
> (io:format "~p~n" (list (ljson:encode #(a b))))
<<"{\"a\":\"b\"}">>
ok
>
```

Decode simple JSON:

```cl
> (io:format "~p~n" (list (ljson:decode "{\"a\": \"b\"}")))
{<<"a">>,<<"b">>}
ok
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


