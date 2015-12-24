class FileChange < ActiveRecord::Base
  belongs_to :commit

  def self.build_random_comments
    random_comments = {}
    all.each do |file|
      next unless suggestions = file.suggestions
      suggestions.each do |ln, line_suggestions|
        line_suggestions.each do |suggestion|
          name = suggestion['name']
          matches = suggestion['matches']
          key = ([name] + matches).join('<,>')
          random_comments[key] = RANDOM_COMMENTS[name].map do |template|
            result = template
            matches.each_with_index do |match, index|
              result = result.gsub("<#{index}>", match.to_s)
            end
            result.gsub(/<s(\d+)>/, HTTP_STATUS_TABLE)
          end
        end
      end
    end
    random_comments
  end

  def analyze
    update(suggestions: build_suggestions)
  end

  private
  def build_suggestions
    line_changes.each_with_object({}) do |chunk, result|
      chunk['+'].each do |ln, values|
        match_rules(values[0], ln) do |lp, rule_name, matches|
          result[lp] = (result[lp] || []) << {
            'name' => rule_name,
            'matches' => matches
          }
        end
      end
    end
  end

  def match_rules(line, ln)
    if line.present?
      LINE_RULES.each do |rule|
        regexes = rule['regex']
        regex = regexes[file_type] || regexes['all']
        if regex.present? && (matches = line.match(regex))
          yield (ln.to_i - rule['offset'].to_i).to_s, rule['name'], matches.to_a.drop(1)
        end
      end
    end
  end

  def file_type
    filename.split('.').last
  end
end
