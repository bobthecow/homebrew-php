require File.join(File.dirname(__FILE__), 'homebrew-php-requirement')

class Xhprof54Requirement < HomebrewPhpRequirement
  def satisfied?
    !Formula.factory("php54-xhgui").installed?
  end

  def message
    "Php54-Xhprof cannot be installed when Php54-Xhgui is installed"
  end
end
