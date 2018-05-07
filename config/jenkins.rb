JenkinsConfiguration = (YAML.load(ERB.new(File.read('./config/jenkins.yml')).result)).tap do |hash|
  hash['staging']['authorization'] = Base64.strict_encode64("#{hash['staging']['username']}:#{hash['staging']['password']}")
  hash['data_center']['authorization'] = Base64.strict_encode64("#{hash['data_center']['username']}:#{hash['data_center']['password']}")
end
