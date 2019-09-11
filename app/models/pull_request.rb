# frozen_string_literal: true

class PullRequest
  attr_reader :github_pull_request

  def initialize(github_pull_request)
    @github_pull_request = github_pull_request
  end

  delegate :id, :title, :body, :url, :created_at,
           :label_names, to: :github_pull_request

  def state
    if label_names.include?('invalid')
      'invalid'
    else
      'eligible'
    end
  end

  def eligible?
    state == 'eligible'
  end

  def mature?
    pr_date = DateTime.parse(@github_pull_request.created_at)
    maturation_duration = ENV['MATURATION_DAYS'].to_i.days

    pr_date < (DateTime.now - maturation_duration)
  end
end
