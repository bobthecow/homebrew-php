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

#### Method 3: Tap

Tap the repository into your brew installation

    brew tap josegonzalez/homebrew-php

Then install php

	brew install php

That's it!

## Bug Reports

Please include the following information in your bug report:

- OS X Version: ex. 10.7.3, 10.6.3
- Homebrew Version: `brew -v`
- PHP Version in use: stock-apple, homebrew-php stable, homebrew-php devel, homebrew-php head, custom
- XCode Version: 4.3, 4.0, 3 etc.
  - If using 4.3, verify whether you have the `Command Line Tools` installed as well
- Output of `gcc -v`
- Output of `brew install -V path/to/homebrew-php/formula.rb` within a [gist](http://gist.github.com). Please append any options you added to the `brew install` command.
- Output of `brew doctor` within a [gist](http://gist.github.com)

This will help us diagnose your issues much quicker, as well as find commonalities between different reported issues.

## Contributing

The following kinds of brews are allowed:

- PHP Extensions: They may be built with PECL, but installation via homebrew is sometimes much easier.
- PHP Utilities: php-version, php-build fall under this category
- Common PHP Web Applications: phpmyadmin goes here. Note that Wordpress would not because it requires other migration steps, such as database migrations etc.
- PHP Frameworks: These are to be reviewed on a case-by-case basis. Generally, only a recent, stable version of a popular framework will be allowed.

If you have any concerns as to whether your formula belongs in PHP, just open a pull request with the formula and we'll take it from there.

### PHP Extension definitions

PHP Extensions MUST be prefixed with `phpVERSION`. For example, instead of the `Solr` formula for PHP53 in `solr.rb`, we would have `Php53Solr` inside of `php53-solr.rb`. This is to remove any possible conflicts with mainline homebrew formulae.

The template for the `php53-example` pecl extension would be as follows. Please use it as an example for any new extension formulae:

    require 'formula'

    class Php53Example < Formula
      homepage 'http://pecl.php.net/package/example'
      url 'http://pecl.php.net/get/example-1.0.tgz'
      md5 'SOMEHASHHERE'
      version '1.0'
      head 'https://svn.php.net/repository/pecl/example/trunk', :using => :svn

      depends_on 'autoconf' => :build

      def install
        Dir.chdir "example-#{version}" unless ARGV.build_head?

        # See https://github.com/mxcl/homebrew/pull/5947
        ENV.universal_binary

        system "phpize"
        system "./configure", "--prefix=#{prefix}"
        system "make"
        prefix.install "modules/example.so"
      end

      def caveats; <<-EOS.undent
         To finish installing php53-example:
           * Add the following line to #{etc}/php.ini:
             [example]
             extension="#{prefix}/example.so"
           * Restart your webserver.
           * Write a PHP page that calls "phpinfo();"
           * Load it in a browser and look for the info on the example module.
           * If you see it, you have been successful!
         EOS
      end
    end

Please note that your formula installation may deviate significantly from the above; caveats should more or less stay the same, as they give explicit instructions to users as to how to ensure the extension is properly installed.

The ordering of Formula attributes, such as the `homepage`, `url`, `md5`, etc. should follow the above order for consistency. The `version` is only included when the url does not include a version in the filename. `head` installations are not required.

All official PHP extensions should be derived from the latest PHP stable version included in `homebrew-php`. As of this writing, the version is `5.3.13`.

## Todo

* Proper PHP Versioning? See issue [#1](https://github.com/josegonzalez/homebrew-php/issues/8)
* ~~Pull out all PHP-related brews from Homebrew~~

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