module CollectionFetch
  def fetch_single_attribute(scope, field)
    page_num, remote_values = 1, []
    db_values = scope.pluck(field)

    while (remote_result = yield page_num).present?
      remote_values += remote_result.map { |result| result[field] }
      page_num += 1
    end

    (remote_values - db_values).each do |value|
      scope.create(field => value)
    end

    scope.where.not(field => remote_values).destroy_all
  end
end
