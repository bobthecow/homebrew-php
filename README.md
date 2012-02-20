# Overview

This repository contains **PHP-related** formulae for [Homebrew](https://github.com/mxcl/homebrew).

(This replaces the php formulae that used to live under [adamv's homebrew-alt repository](https://github.com/adamv/homebrew-alt).)

The purpose of this repository is to allow PHP developers to quickly retrieve
working, up-to-date formulae. The mainline homebrew repositories are maintianed
by non-php developers, so testing/maintaining PHP-related brews has fallen by
the wayside. If you are a PHP developer using homebrew, please contribute to
this repository.


## Quick Start

To install homebrew-php formulae, use one of the following:

 * `brew install [raw GitHub URL]`
 * `brew install [full path to formula from your local homebrew-php clone]`

For more details, see below: "Installing homebrew-php Formulae".



# How This Repository Is Organized

  *   **Formula**<br>
      These brews provide php-related functionality, whether they be extensions,
      dependencies, or the PHP-Core itself.

      (Homebrew policy discourages duplicates, except in some specific cases.)


# Installing homebrew-php Formulae

There are two methods to install packages from this repository.


## Method 1: Raw URL

First, find the raw URL for the formula you want. For example, the raw URL for
the `php` formula is:

```
    https://github.com/josegonzalez/homebrew-php/raw/master/Formula/php.rb
```


Once you know the raw URL, simply use `brew install [raw URL]`, like so:

```
    brew install https://github.com/josegonzalez/homebrew-php/raw/master/Formula/php.rb
```


## Method 2: Repository Clone

First, clone this repository.  Be sure to choose a good location!  

For example, clone to `LibraryPHP` under `/usr/local`:

```
    git clone https://github.com/josegonzalez/homebrew-php.git /usr/local/LibraryPHP
```


Once you've got your clone, simply use `brew install [full path to formula]`.

For example, to install `php`:

```
    brew install /usr/local/LibraryPHP/Formula/php.rb
```


That's it!
