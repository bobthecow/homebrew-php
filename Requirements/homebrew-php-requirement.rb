require File.join(File.dirname(__FILE__), 'homebrew-php-requirement')

class HomebrewPhpRequirement < Requirement
  def fatal?
    true
  end

  def satisfied?
    false
  end

  # Hack to allow homebrew tap to symlink
  # these and shut brew doctor up
  def keg_only?
    false
  end

  def message
    "A requirement as failed"
  end
end

