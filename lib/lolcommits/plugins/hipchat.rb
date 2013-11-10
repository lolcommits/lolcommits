module Lolcommits

  # Displayyour lolcommits on a hipchat room.
  # This plugin first uploads images to http://uploads.im
  # And then posts a message with the uploaded image.
  #
  # Required configuration:
  #
  #   enabled:    true
  #   auth_token: Your-HipChat-API-Token 
  #   room_id:    Room name to post
  #
  # Optional configuration:
  # 
  #   from:       defaults to last commit author
  #   color:      defaults to gray
  #   format:     message format, must be a ruby sprintf
  #               format which can take following keys:
  #
  #                 image_url, thumb_url, sha, author, message
  #
  #               default value is: 
                    "<a href='%{image_url}'><img src='%{thumb_url}'></a>"
  #
  #                  
  #
  class Hipchat < Plugin

    UPLOADS_IM_ENDPOINT = 'http://uploads.im/api'
    HIPCHAT_ROOM_ENDPOINT = 'https://api.hipchat.com/v1/rooms/message'
    DEFAULT_COLOR = 'gray'
    MESSAGE_FORMAT = "<a href='%{image_url}'><img src='%{thumb_url}'></a>"

    attr_accessor :auth_token, :room_id

    def initialize(runner)
      super
      self.name    = 'hipchat'
      self.default = false
      self.options.concat(%w[auth_token room_id])
    end

    def run
      response = RestClient.post(UPLOADS_IM_ENDPOINT, :file => File.new(runner.main_image))
      uploaded = JSON.parse(response.body)
      return unless uploaded['status_txt'] == 'OK'
      git   = Git.open('.')
      commit = git.log.first
      format = configuration['format'] || MESSAGE_FORMAT
      message = format %  {
        image_url: uploaded['data']['image_url'],
        thumb_url: uploaded['data']['thumb_url'],
        sha: commit.sha, 
        author: commit.author.name, 
        message: commit.message
      }
      color = configuration['color'] || DEFAULT_COLOR
      from  = configuration['from']  || git.log.first.author.name
      response = RestClient.post(HIPCHAT_ROOM_ENDPOINT,
                                 :color      => color,
                                 :from       => from,
                                 :auth_token => configuration['auth_token'],
                                 :room_id    => configuration['room_id'],
                                 :message    => message)
    end

  end

end
