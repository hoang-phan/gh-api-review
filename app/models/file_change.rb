class FileChange < ActiveRecord::Base
  belongs_to :commit

  def self.build_random_comments
    all.each_with_object({}) do |file, random_comments|
      file.build_comments do |key, value|
        random_comments[key] = value
      end
    end
  end

  def analyze
    update(suggestions: build_suggestions)
  end

  def build_comments(&block)
    return unless suggestions.present?
    suggestions.each do |ln, line_suggestions|
      line_suggestions.each do |suggestion|
        build_line_random_comments(suggestion, &block)
      end
    end
  end

  private

  def build_line_random_comments(suggestion)
    name, matches = suggestion['name'], suggestion['matches']
    key = ([name] + matches).join('<,>')
    value = RANDOM_COMMENTS[name].map do |template|
      build_comment(template, matches)
    end
    yield key, value
  end

  def build_comment(template, matches)
    result = template
    matches.each_with_index do |match, index|
      result = result.gsub("<#{index}>", match.to_s)
    end
    result.gsub(/<s(\d+)>/, HTTP_STATUS_TABLE)
  end

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
      matched_rules = []
      LINE_RULES.each do |rule|
        next if matched_rules.include?(rule['name'])
        regexes = rule['regex']
        regex = regexes[file_type] || regexes['all']
        if regex.present? && (matches = line.match(regex)) && match_constraints(matches, rule['constraint'])
          matched_rules << rule['name']
          yield (ln.to_i - rule['offset'].to_i).to_s, rule['name'], matches.to_a.drop(1)
        end
      end
    end
  end

  def file_type
    filename.split('.').last
  end

  def match_constraints(matches, constraint)
    return true unless constraint
    return false if matches.try(:size).to_i < 2

    first_match = matches[1]

    case constraint
      when 'plural' then first_match.pluralize != first_match
      when 'singular' then first_match.singularize != first_match
    end
  end
end
