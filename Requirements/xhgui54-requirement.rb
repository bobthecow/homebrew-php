require File.join(File.dirname(__FILE__), 'homebrew-php-requirement')

class Xhgui54Requirement < HomebrewPhpRequirement
  def satisfied?
    !Formula.factory("php54-xhprof").installed?
  end

  def message
    "Php54-Xhgui cannot be installed when Php54-Xhprof is installed"
  end
end
