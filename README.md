# Homebrew-PHP

A centralized repository for PHP-related brews.

## Common Issues

Bugs inevitably happen - none of us is running EVERY conceivable setup - but hopefully the install process can be made smoother through the following tips:

- Upgrade your Mac to the latest patch version. So if you are on `10.7.0`, upgrade to `10.7.4` etc.
- Ensure XCode is installed and up to date.
- If you are using XCode 4, install the `Command Line Tools`.
- If you already have the `Command Line Tools`, try installing the [`OS X GCC Installer`](https://github.com/kennethreitz/osx-gcc-installer/). Many users have reported success after doing so.
- Delete your `~/.pearrc` file before attempting to install a `PHP` version, as the pear step will fail if an existing, incompatible version exists.
- If you are using Mountain Lion `10.8.x`, please install [XQuartz](http://xquartz.macosforge.org/landing/) so that the `png.h` header exists for compilation of certain brews. Mountain Lion removes X11, which contained numerous headers. A permanent fix is forthcoming.
- If you upgraded to Mountain Lion `10.8.x`, please also upgrade to the latest XCode, 4.4.
- File an awesome bug report, using the information in the next section.

Doing all of these might be a hassle, but will more than likely ensure you either have a working install or get help as soon as possible.

### Filing Bug Reports

Please include the following information in your bug report:

- OS X Version: ex. 10.7.3, 10.6.3
- Homebrew Version: `brew -v`
- PHP Version in use: stock-apple, homebrew-php stable, homebrew-php devel, homebrew-php head, custom
- XCode Version: 4.4, 4.3, 4.0, 3 etc.
  - If you are on Mountain Lion `10.8.x`, please also upgrade to the latest XCode, 4.4.
  - If using 4.3, verify whether you have the `Command Line Tools` installed as well
  - If on Snow Leopard, you may want to install the [`OS X GCC Installer`](https://github.com/kennethreitz/osx-gcc-installer/)
- Output of `gcc -v`
- Output of `php -v`
- Output of `brew install -V path/to/homebrew-php/formula.rb` within a [gist](http://gist.github.com). Please append any options you added to the `brew install` command.
- Output of `brew doctor` within a [gist](http://gist.github.com)

This will help us diagnose your issues much quicker, as well as find commonalities between different reported issues.

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
* Snow Leopard, Lion, Mountain Lion. Untested everywhere else
* The homebrew `dupes` tap - `brew tap homebrew/dupes`

## Installation

_[Brew Tap]_

Setup the `homebrew/dupes` tap which has dependencies we need:

    brew tap homebrew/dupes

Then, run the following in your commandline:

    brew tap josegonzalez/homebrew-php

## Usage

Tap the `homebrew/dupes` repository into your brew installation:

    brew tap homebrew/dupes

Tap the repository into your brew installation:

    brew tap josegonzalez/homebrew-php

**Note:** For a list of available configuration options run:

    brew options php54

Then install php53, php54, or any formulae you might need:

    brew install php54

That's it!

Please also follow the instructions from brew info at the end of the install to ensure you properly installed your PHP version.

### Installing Multiple Versions

Using multiple PHP versions from `homebrew-php` is pretty straightforward.

If using Apache, you will need to update the `LoadModule` call. For convenience, simply comment out the old PHP version:

    # /etc/apache2/httpd.conf
    # Swapping from PHP53 to PHP54
    # LoadModule php5_module    /usr/local/Cellar/php53/5.3.15/libexec/apache2/libphp5.so
    LoadModule php5_module    /usr/local/Cellar/php54/5.4.5/libexec/apache2/libphp5.so

If using FPM, you will need to unload the `plist` controlling php, or manually stop the daemon, via your command line:

    # Swapping from PHP53 to PHP54
    cp /usr/local/Cellar/php54/5.4.5/homebrew-php.josegonzalez.php54.plist ~/Library/LaunchAgents/
    launchctl unload -w ~/Library/LaunchAgents/homebrew-php.josegonzalez.php53.plist
    launchctl load -w ~/Library/LaunchAgents/homebrew-php.josegonzalez.php54.plist

If you would like to swap the PHP you use on the command line, you should update the `$PATH` variable in either your `.bashrc` or `.bash_profile`:

    # Swapping from PHP53 to PHP54
    # export PATH="$(brew --prefix josegonzalez/php/php53)/bin:$PATH"
    export PATH="$(brew --prefix josegonzalez/php/php54)/bin:$PATH"

Please be aware that you must make this type of change EACH time you swap between PHP `minor` versions. You will typically only need to update the Apache/FPM when upgrading your php `patch` version.

### PEAR Extensions

If installing `php53` or `php54`, please note that all extensions installed with the included `pear` will be installed to the respective php's bin path. For example, supposing you installed `PHP_CodeSniffer` as follows:

    pear install PHP_CodeSniffer

It would be nice to be able to use the `phpcs` command via commandline, or other utilities. You will need to add the installed php's `bin` directory to your path. The following would be added to your `.bashrc` or `.bash_profile` when running the `php54` brew:

    export PATH="$(brew --prefix php54)/bin:$PATH"

Some caveats:

- Remember to use the proper php version in that export. So if you installed the `php53` formula, use `php53` instead of `php54` in the export.
- Updating your installed php will result in the binaries no longer existing within your path. In such cases, you will need to reinstall the pear extensions. Alternatives include installing `pear` outside of `homebrew-php` or using the `homebrew-php` version of your extension.
- Uninstalling your `homebrew-php` php formula will also remove the extensions.

## Contributing

The following kinds of brews are allowed:

- PHP Extensions: They may be built with PECL, but installation via homebrew is sometimes much easier.
- PHP Utilities: php-version, php-build fall under this category
- Common PHP Web Applications: phpmyadmin goes here. Note that Wordpress would not because it requires other migration steps, such as database migrations etc.
- PHP Frameworks: These are to be reviewed on a case-by-case basis. Generally, only a recent, stable version of a popular framework will be allowed.

If you have any concerns as to whether your formula belongs in PHP, just open a pull request with the formula and we'll take it from there.

### PHP Extension definitions

PHP Extensions MUST be prefixed with `phpVERSION`. For example, instead of the `Solr` formula for PHP54 in `solr.rb`, we would have `Php54Solr` inside of `php54-solr.rb`. This is to remove any possible conflicts with mainline homebrew formulae.

The template for the `php54-example` pecl extension would be as follows. Please use it as an example for any new extension formulae:

    require File.join(File.dirname(__FILE__), 'abstract-php-extension')

    class Php54Example < AbstractPhpExtension
      homepage 'http://pecl.php.net/package/example'
      url 'http://pecl.php.net/get/example-1.0.tgz'
      sha1 'SOMEHASHHERE'
      version '1.0'
      head 'https://svn.php.net/repository/pecl/example/trunk', :using => :svn

      depends_on 'autoconf' => :build
      depends_on 'php54' if build.include?('--with-homebrew-php') && !Formula.factory('php54').installed?


      def install
        Dir.chdir "example-#{version}" unless build.head?

        # See https://github.com/mxcl/homebrew/pull/5947
        ENV.universal_binary

        safe_phpize
        system "./configure", "--prefix=#{prefix}"
        system "make"
        prefix.install "modules/example.so"
        write_config_file unless build.include? "without-config-file"
      end
    end

Defining extensions inheriting AbstractPhp5 will provide a `write_config_file` which add `ext-{extension}.ini` to `conf.d`, don’t forget to remove it manually upon extension removal. Please see [AbstractPhpExtension.rb](Formula/AbstractPhpExtension.rb) for more details.

Please note that your formula installation may deviate significantly from the above; caveats should more or less stay the same, as they give explicit instructions to users as to how to ensure the extension is properly installed.

The ordering of Formula attributes, such as the `homepage`, `url`, `sha1`, etc. should follow the above order for consistency. The `version` is only included when the url does not include a version in the filename. `head` installations are not required.

All official PHP extensions should be built for all stable versions of PHP included in `homebrew-php`. As of this writing, these version are `5.3.15` and `5.4.5`.

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
