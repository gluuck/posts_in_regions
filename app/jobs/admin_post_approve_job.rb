class AdminPostApproveJob < ApplicationJob
  queue_as :default

  def perform(post)
    post.to_approve!
  end
end

