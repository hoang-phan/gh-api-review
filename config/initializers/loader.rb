LINE_RULES = JSON.parse(File.read(Rails.root.join('config', 'line_rules.json')))
RANDOM_COMMENTS = JSON.parse(File.read(Rails.root.join('config', 'random_comments.json')))
ALL_SNIPPETS = YAML.load_file(Rails.root.join('config', 'snippets.yml'))
HTTP_STATUS_TABLE = YAML.load_file(Rails.root.join('config', 'http_statuses.yml'))
