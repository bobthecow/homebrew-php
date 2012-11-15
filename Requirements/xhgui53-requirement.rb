require File.join(File.dirname(__FILE__), 'homebrew-php-requirement')

class Xhgui53Requirement < HomebrewPhpRequirement
  def satisfied?
    !Formula.factory("php53-xhprof").installed?
  end

  def message
    "Php53-Xhgui cannot be installed when Php53-Xhprof is installed"
  end
end
