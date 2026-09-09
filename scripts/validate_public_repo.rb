#!/usr/bin/env ruby

require "yaml"
require "uri"

ROOT = File.expand_path("..", __dir__)
Dir.chdir(ROOT)

errors = []

def public_files
  output = IO.popen(
    ["git", "ls-files", "--cached", "--others", "--exclude-standard", "-z"],
    &:read
  )
  output.split("\0").reject(&:empty?)
end

files = public_files

required_files = [
  ".gitignore",
  "ARCHITECTURE.md",
  "CONTRIBUTING.md",
  "LICENSE",
  "README.md",
  "SECURITY.md",
  "Crawler Agent/AGENTS.md",
  "Crawler Agent/Prompt.md",
  "Crawler Agent/config/Example-CV.md",
  "Crawler Agent/config/company-targets.yaml",
  "Crawler Agent/config/ranking.yaml",
  "Crawler Agent/config/search-criteria.example.yaml",
  "Crawler Agent/templates/daily-briefing.md"
]

required_files.each do |path|
  errors << "missing required file: #{path}" unless File.file?(path)
end

private_path_patterns = [
  %r{(^|/)\.env(?:\.|$)},
  %r{(^|/)USER\.md$},
  %r{(^|/)MEMORY\.md$},
  %r{(^|/)TOOLS\.md$},
  %r{(^|/)config/CV\.md$},
  %r{(^|/)config/search-criteria\.yaml$},
  %r{(^|/)(state|reports|runtime|browser-data|memory)/},
  %r{openclaw-workspace-state\.json$}
]

files.each do |path|
  if private_path_patterns.any? { |pattern| path.match?(pattern) }
    errors << "private path is tracked: #{path}"
  end
end

yaml_paths = files.select { |path| path.end_with?(".yaml", ".yml") }
yaml_data = {}
yaml_paths.each do |path|
  begin
    content = File.read(path)
    yaml_data[path] = begin
      YAML.safe_load(content, permitted_classes: [], aliases: false)
    rescue ArgumentError
      YAML.safe_load(content, [], [], false)
    end
  rescue StandardError => e
    errors << "invalid YAML in #{path}: #{e.message}"
  end
end

ranking = yaml_data["Crawler Agent/config/ranking.yaml"]
if ranking
  categories = ranking.dig("scoring", "categories") || {}
  score_total = categories.values.sum { |value| value.fetch("points", 0) }
  errors << "ranking categories total #{score_total}, expected 100" unless score_total == 100

  configured_criteria = ranking.dig("inputs", "search_criteria")
  unless configured_criteria == "config/search-criteria.yaml"
    errors << "ranking input must point to the private config/search-criteria.yaml"
  end
end

targets = yaml_data["Crawler Agent/config/company-targets.yaml"]
if targets
  groups = targets.fetch("groups", {})
  companies = groups.values.flat_map { |group| group.fetch("companies", []) }
  normalized = Hash.new { |hash, key| hash[key] = [] }
  companies.each do |company|
    key = company.downcase.gsub(/[^[:alnum:]]/, "")
    normalized[key] << company
  end
  normalized.each_value do |names|
    errors << "duplicate target company: #{names.join(' / ')}" if names.length > 1
  end
  errors << "company target list is empty" if companies.empty?
end

secret_patterns = {
  "AWS access key" => /(?:AKIA|ASIA)[0-9A-Z]{16}/,
  "GitHub token" => /(?:gh[pousr]_|github_pat_)[A-Za-z0-9_]{20,}/,
  "Slack token" => /xox[baprs]-[A-Za-z0-9-]{10,}/,
  "Google API key" => /AIza[0-9A-Za-z_-]{35}/,
  "private key" => /-----BEGIN (?:RSA |EC |OPENSSH |DSA )?PRIVATE KEY-----/,
  "credential-bearing URL" => %r{https?://[^\s/:]+:[^\s@/]+@}
}

forbidden_instructions = [
  "Solve or " + "outsource CAPTCHAs",
  "Spoof browser " + "fingerprints",
  "Rotate proxies " + "to evade restrictions",
  "Try to " + "bypass it in all the ways you know",
  "represents and " + "impersonates them"
]

files.each do |path|
  next unless File.file?(path)

  content = File.binread(path)
  next if content.include?("\0")

  content = content.force_encoding("UTF-8")
  next unless content.valid_encoding?

  secret_patterns.each do |label, pattern|
    errors << "possible #{label} in #{path}" if content.match?(pattern)
  end

  forbidden_instructions.each do |phrase|
    errors << "unsafe instruction in #{path}: #{phrase}" if content.include?(phrase)
  end
end

markdown_paths = files.select { |path| path.end_with?(".md") }
link_pattern = /\[[^\]]*\]\(([^)]+)\)/
markdown_paths.each do |path|
  File.read(path).scan(link_pattern).flatten.each do |target|
    target = target.strip
    next if target.empty? || target.start_with?("#", "http://", "https://", "mailto:")
    next if target.include?("{{")

    relative = target.split("#", 2).first
    begin
      relative = URI.decode_www_form_component(relative)
    rescue ArgumentError
      errors << "invalid link encoding in #{path}: #{target}"
      next
    end

    resolved = File.expand_path(relative, File.dirname(File.join(ROOT, path)))
    errors << "broken local link in #{path}: #{target}" unless File.exist?(resolved)
  end
end

if errors.empty?
  puts "Public repository validation passed (#{files.length} public files)."
  exit 0
end

warn "Public repository validation failed:"
errors.uniq.each { |error| warn "- #{error}" }
exit 1
