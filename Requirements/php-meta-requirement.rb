require File.join(File.dirname(__FILE__), 'homebrew-php-requirement')

class PhpMetaRequirement < HomebrewPhpRequirement
  def satisfied?
    %w{php53 php54}.any? { |php| Formula.factory(php).installed? }
  end

  def message
    "Missing PHP53 or PHP54 from homebrew-php. Please install one or the other before continuing"
  end
end
