class PhpMetaRequirement < Requirement
  def fatal?; true; end

  def satisfied?
    %w{php53 php54}.any? { |php| Formula.factory(php).installed? }
  end

  def message; "Missing PHP53 or PHP54 from homebrew-php. Please install one or the other before continuing"; end
end
