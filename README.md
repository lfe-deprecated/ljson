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

The following are all done from the LFE REPL:

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


