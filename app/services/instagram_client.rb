# app/services/instagram_client.rb
require "net/http"
require "json"

class InstagramClient
  GRAPH_API_BASE = "https://graph.facebook.com".freeze

  DEFAULT_MEDIA_FIELDS  =
    %w[id caption media_type media_url thumbnail_url permalink timestamp].freeze

  DEFAULT_STORY_FIELDS  =
    %w[id media_type media_url thumbnail_url permalink timestamp].freeze

  def initialize(
    ig_user_id:    ENV["INSTAGRAM_IG_USER_ID"],
    access_token:  ENV["INSTAGRAM_ACCESS_TOKEN"],
    api_version:   ENV["INSTAGRAM_GRAPH_API_VERSION"] || "v21.0"
  )
    @ig_user_id   = ig_user_id
    @access_token = access_token
    @api_version  = api_version
  end

  def recent_media(limit: 12)
    return [] if missing_config?
    get_edge("#{@ig_user_id}/media", fields: DEFAULT_MEDIA_FIELDS, limit: limit)
  end

  def current_stories(limit: 20)
    return [] if missing_config?
    get_edge("#{@ig_user_id}/stories", fields: DEFAULT_STORY_FIELDS, limit: limit)
  end

  private

  def missing_config?
    if @ig_user_id.blank? || @access_token.blank?
      Rails.logger.warn "InstagramClient missing config: INSTAGRAM_IG_USER_ID or INSTAGRAM_ACCESS_TOKEN"
      true
    else
      false
    end
  end

  def get_edge(path, fields:, limit:)
    uri = URI("#{GRAPH_API_BASE}/#{@api_version}/#{path}")
    params = {
      fields:       fields.join(","),
      access_token: @access_token,
      limit:        limit
    }
    uri.query = URI.encode_www_form(params)

    res = Net::HTTP.get_response(uri)

    unless res.is_a?(Net::HTTPSuccess)
      Rails.logger.warn "Instagram API error for #{path}: #{res.code} #{res.body}"
      return []
    end

    json = JSON.parse(res.body)
    json["data"] || []
  rescue StandardError => e
    Rails.logger.error "Instagram API exception for #{path}: #{e.class} #{e.message}"
    []
  end
end
