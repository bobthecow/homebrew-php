class PharRequirement < Requirement
  def fatal?; true; end

  def satisfied?
    `php -m`.downcase.include? "phar"
  end

  def message
<<-EOS
PHP Phar support is required for this formula
EOS
  end
end
