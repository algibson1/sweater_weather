class ErrorSerializer 
  def initialize(error)
    @error = error
  end

  def to_json
    {
      errors: [
        {
          detail: @error.message
        }
      ]
    }
  end
end