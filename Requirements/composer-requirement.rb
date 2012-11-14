require File.join(File.dirname(__FILE__), 'homebrew-php-requirement')

class ComposerRequirement < HomebrewPhpRequirement
  def satisfied?
    `curl -s http://getcomposer.org/installer | /usr/bin/env php -d allow_url_fopen=On -d detect_unicode=Off -d date.timezone=UTC -- --check`.include? "All settings correct"
  end

  def message
<<-EOS
Composer PHP requirements check has failed. Please run the following command to identify and fix any issues:
    curl -s http://getcomposer.org/installer | /usr/bin/env php -d allow_url_fopen=On -d detect_unicode=Off -d date.timezone=UTC -- --check
EOS
  end
end
