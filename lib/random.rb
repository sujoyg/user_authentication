class Random
  def self.password
    chars = ('A'..'Z').to_a + ('a'..'z').to_a + ('0'..'9').to_a
    (1..32).map { chars.sample }.join('')
  end
end
