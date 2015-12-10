module CollectionFetch
  def fetch_single_attribute(scope, field, &block)
    remote_values = remote_values(scope, field, &block)

    (remote_values - scope.pluck(field)).each do |value|
      scope.create(field => value)
    end

    scope.where.not(field => remote_values).delete_all
  end

  def remote_values(scope, field)
    page_num, remote_values = 1, []

    while (remote_result = yield page_num).present?
      remote_values += remote_result.map { |result| result[field] }
      page_num += 1
    end

    remote_values
  end
end
