require 'formula'

class Phpenv < Formula
  homepage 'https://github.com/CHH/phpenv'
  head 'https://github.com/CHH/phpenv.git'

  def options
    [
      ['--skip-install', "Do not run phpenv-install.sh"],
    ]
  end

  def install
    prefix.install Dir['*']
    system "mkdir #{prefix}/share && mv #{prefix}/man #{prefix}/share"
    system("#{prefix}/bin/phpenv-install.sh") unless ARGV.include? '--skip-install'
  end

  def caveats;
    output = "To finish installing phpenv:\n"
    output << " * Run phpenv-install.sh\n" if ARGV.include? '--skip-install'
    output << " * Add ~/.phpenv/bin to your $PATH\n"
    output << " * Add \"eval $(phpenv init -)\" at the end of your ~/.bashrc\n"
    output << " * Restart your shell"
    output
  end
end
