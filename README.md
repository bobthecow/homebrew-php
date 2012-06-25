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

_[Brew Tap]_

Run the following in your commandline:

    brew tap josegonzalez/homebrew-php

## Usage

Tap the repository into your brew installation:

    brew tap josegonzalez/homebrew-php

Then install php53, php54, or any formulae you might need:

    brew install php54

That's it!

### PEAR Extensions

If installing `php53` or `php54`, please note that all extensions installed with the included `pear` will be installed to the respective php's bin path. For example, supposing you installed `PHP_CodeSniffer` as follows:

    pear install PHP_CodeSniffer

It would be nice to be able to use the `phpcs` command via commandline, or other utilities. You will need to add the installed php's `bin` directory to your path. The following would be added to your `.bashrc` or `.bash_profile` when running the `php54` brew:

    export PATH="$(brew --prefix php54)/bin:$PATH"

Some caveats:

- Remember to use the proper php version in that export. So if you installed the `php53` formula, use `php53` instead of `php54` in the export.
- Updating your installed php will result in the binaries no longer existing within your path. In such cases, you will need to reinstall the pear extensions. Alternatives include installing `pear` outside of `homebrew-php` or using the `homebrew-php` version of your extension.
- Uninstalling your `homebrew-php` php formula will also remove the extensions.

## Bug Reports

Please include the following information in your bug report:

- OS X Version: ex. 10.7.3, 10.6.3
- Homebrew Version: `brew -v`
- PHP Version in use: stock-apple, homebrew-php stable, homebrew-php devel, homebrew-php head, custom
- XCode Version: 4.3, 4.0, 3 etc.
  - If using 4.3, verify whether you have the `Command Line Tools` installed as well
- Output of `gcc -v`
- Output of `php -v`
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
           * Add the following lines to #{etc}/php.ini:
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

All official PHP extensions should be built for all stable versions of PHP included in `homebrew-php`. As of this writing, these version are `5.3.13` and `5.4.3`.

## Todo

* ~~Proper PHP Versioning? See issue [#1](https://github.com/josegonzalez/homebrew-php/issues/8)~~
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
