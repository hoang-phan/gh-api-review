class FileChange < ActiveRecord::Base
  belongs_to :commit

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
