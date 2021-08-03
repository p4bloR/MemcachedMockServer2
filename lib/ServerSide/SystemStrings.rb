class SystemStrings
  @@more_input = 'MORE_INPUT_NEEDED'
  @@disconnected = "USER_DISCONNECTED"
  @@success = 'SUCCESS'
  @@error = "ERROR"
  @@stored = "STORED"
  @@not_stored = "NOT_STORED"
  @@exists = "EXISTS"
  @@not_found = "NOT_FOUND"
  @@value = "VALUE"
  @@end = "END"
  @@client_error = "CLIENT_ERROR"
  @@bad_data = "CLIENT_ERROR bad  data chunk"
  @@bad_format = "CLIENT_ERROR bad command line format"

  @@error_strings = [@@error, @@bad_format, @@bad_data]

  def self.error_strings
    return @@error_strings
  end

  def self.more_input
    return @@more_input
  end

  def self.disconnected
    return @@disconnected
  end

  def self.success
    return @@success
  end

  def self.error
    return @@error
  end

  def self.stored
    return @@stored
  end 

  def self.not_stored
    return @@not_stored
  end

  def self.exists
    return @@exists
  end

  def self.not_found
    return @@not_found
  end

  def self.value
    return @@value
  end

  def self.end
    return @@end
  end

  def self.client_error
    return @@client_error
  end

  def self.bad_data
    return @@bad_data
  end 

  def self.bad_format
    return @@bad_format
  end
end