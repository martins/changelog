if PivotalTracker
  # PivotalTrcker project id
  ENV['PTR_PRID'] = ''

  # Manually set account API Token for PivotalTracker
  PivotalTracker::Client.token = ''
  PivotalTracker::Client.use_ssl = true
end