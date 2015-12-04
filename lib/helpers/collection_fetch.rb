module CollectionFetch
  def fetch_single_attribute(scope, remote_result, field)
    not_delete = []

    remote_result.each do |result|
      unless scope.exists?(field => result[field])
        scope.create(field => result[field])
      end
      not_delete << result[field]
    end

    scope.where.not(field => not_delete).destroy_all
  end
end
