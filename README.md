# Homebrew-PHP

A centralized repository for PHP-related brews.

## Background

This repository contains **PHP-related** formulae for [Homebrew](https://github.com/mxcl/homebrew).

(This replaces the php formulae that used to live under [adamv's homebrew-alt repository](https://github.com/adamv/homebrew-alt).)

The purpose of this repository is to allow PHP developers to quickly retrieve
working, up-to-date formulae. The mainline homebrew repositories are maintianed
by non-php developers, so testing/maintaining PHP-related brews has fallen by
the wayside. If you are a PHP developer using homebrew, please contribute to
this repository.

## Requirements

* Homebrew
* Snow Leopard or Lion - Untested against Mountain Lion

## Installation

_[Manual]_

* Download this: `http://github.com/josegonzalez/homebrew-php/zipball/master`
* Unzip that download.
* Copy the resulting folder to `/usr/local`
* Rename the folder you just copied to `LibraryPHP`

_[GIT Clone]_

In your `/usr/local` directory type

    git clone git://github.com/josegonzalez/homebrew-php.git LibraryPHP

## Usage

### Quick Start

To install homebrew-php formulae, use one of the following:

 * `brew install [raw GitHub URL]`
 * `brew install [full path to formula from your local homebrew-php clone]`

For more details, see below: "Installing homebrew-php Formulae".

### Installing homebrew-php Formulae

There are two methods to install packages from this repository.

#### Method 1: Raw URL

First, find the raw URL for the formula you want. For example, the raw URL for
the `php` formula is:

    https://github.com/josegonzalez/homebrew-php/raw/master/Formula/php.rb

Once you know the raw URL, simply use `brew install [raw URL]`, like so:

    brew install https://github.com/josegonzalez/homebrew-php/raw/master/Formula/php.rb

#### Method 2: Repository Clone

First, clone this repository.  Be sure to choose a good location!

For example, clone to `LibraryPHP` under `/usr/local`:

    git clone https://github.com/josegonzalez/homebrew-php.git /usr/local/LibraryPHP

Once you've got your clone, simply use `brew install [full path to formula]`.

For example, to install `php`:

    brew install /usr/local/LibraryPHP/Formula/php.rb

That's it!

## Todo

* Proper PHP Versioning? See issue [#1](https://github.com/josegonzalez/homebrew-php/issues/8)
* Pull out all PHP-related brews from Homebrew

## License

Copyright (c) 2012 Jose Diaz-Gonzalez and other contributors

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.