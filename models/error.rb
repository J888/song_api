class Error  
  def self.message(*messages) 
    {
      errors: messages.flatten
    }
  end
end
