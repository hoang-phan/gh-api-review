GITHUB_ENV = YAML.load_file("#{Rails.root}/config/github.yml")
$client = Octokit::Client.new(access_token: GITHUB_ENV['access_token'])