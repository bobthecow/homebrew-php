require 'formula'

class AbstractPhpExtension < Formula
  depends_on 'autoconf' => :build

  def initialize name='__UNKNOWN__', path=nil
    raise "One does not simply install an AbstractPhpExtension"
  end

  def php_branch
    matches = /^Php5([3-9]+)/.match(self.class.name)
    if matches
      "5." + matches[1]
    else
      raise "Unable to guess PHP branch for #{self.class.name}"
    end
  end

  def extension
    matches = /^Php5[3-9](.+)/.match(self.class.name)
    if matches
      matches[1].downcase
    else
      raise "Unable to guess PHP extension name for #{self.class.name}"
    end
  end

  def extension_type
    # extension or zend_extension
    "extension"
  end

  def module_path
    prefix / "#{extension}.so"
  end

  def config_file
    begin
      <<-EOS.undent
      [#{extension}]
      #{extension_type}="#{module_path}"
      EOS
    rescue Exception => e
      nil
    end
  end

  def caveats
    caveats = [ "To finish installing #{extension} for PHP #{php_branch}:" ]

    if ARGV.include? "--without-config-file"
      caveats << "  * Add the following line to #{etc}/php.ini:\n\n"
      caveats << config_file
    else
      caveats << "  * #{config_scandir_path}/#{config_filename} was created,"
      caveats << "    do not forget to remove it upon extension removal."
    end

    caveats << <<-EOS
  * Restart your webserver.
  * Write a PHP page that calls "phpinfo();"
  * Load it in a browser and look for the info on the yaml module.
  * If you see it, you have been successful!
EOS

    caveats.join("\n")
  end

  def config_path
    etc / "php" / php_branch
  end

  def config_scandir_path
    config_path / "conf.d"
  end

  def config_filename
    "ext-" + extension + ".ini"
  end

  def config_filepath
    config_scandir_path / config_filename
  end

  def write_config_file
    if config_file && !config_filepath.file?
      config_scandir_path.mkpath
      config_filepath.write(config_file)
    end
  end

  def options
    options = []
    options << ["--without-config-file", "Do not add #{config_filename} to #{config_scandir_path}"] if config_file
    options
  end
end
