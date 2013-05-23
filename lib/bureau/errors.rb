module Bureau
  module Errors
    BaseError = Class.new(RuntimeError)

    EmptyCollectionError                        = Class.new(BaseError)
    MissingDefaultColumnsError               = Class.new(BaseError)
    MissingDefaultCollectionError               = Class.new(BaseError)
  end
end
