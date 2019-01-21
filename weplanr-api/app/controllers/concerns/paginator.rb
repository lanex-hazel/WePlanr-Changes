module Paginator
  extend ActiveSupport::Concern

  DEFAULT_SIZE = 10

  def paginate records, page = { number: 1, size: DEFAULT_SIZE }
    size = (page[:size].to_i > 0) ? page[:size].to_i : DEFAULT_SIZE
    offset = (page[:number].to_i - 1) * size

    records.offset(offset).limit(size)
  end
end
