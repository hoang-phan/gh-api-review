module RepositoryMacro
  def match_local(json)
    ( local = Repository.find_by external_id: json['id'] ) && local.full_name == json['full_name'] && local.html_url == json['html_url'] && local.avatar_url == json['owner']['avatar_url'] && local.owner == json['owner']['login']
  end
end