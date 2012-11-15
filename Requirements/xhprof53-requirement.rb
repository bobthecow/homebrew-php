require File.join(File.dirname(__FILE__), 'homebrew-php-requirement')

class Xhprof53Requirement < HomebrewPhpRequirement
  def satisfied?
    !Formula.factory("php53-xhgui").installed?
  end

  def message
    "Php53-Xhprof cannot be installed when Php53-Xhgui is installed"
  end
end
