class Analyzer
  include Sidekiq::Worker

  def perform(commit_id)
    if commit = Commit.find_by_id(commit_id)
      commit.file_changes.find_each do |file|
        file_type = file.filename.split('.').last
        suggestions = {}
        file.line_changes['+'].each do |ln, values|
          if values[0].present?
            LINE_RULES.each do |rule|
              regexes = rule['regex']
              regex = regexes[file_type] || regexes['all']
              if regex.present? && values[0].match(regex)
                suggestions[(ln.to_i - rule['offset'].to_i).to_s] = (suggestions[ln] || []) << rule['name']
              end
            end
          end
        end
        file.update(suggestions: suggestions)
      end
    end
  end
end