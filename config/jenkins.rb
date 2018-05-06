JenkinsConfiguration = (YAML.load(ERB.new(File.read('./config/jenkins.yml')).result)).tap do |hash|
  hash['authorization'] = Base64.strict_encode64("#{hash['username']}:#{hash['password']}")
end
