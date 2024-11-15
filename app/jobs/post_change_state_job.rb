class PostChangeStateJob < ApplicationJob
  queue_as :default 

  def perform(post, state)
    post.send(state)
  end
end