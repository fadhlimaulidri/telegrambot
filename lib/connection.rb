require 'pry'
class Connection
  # To use, scheme is http or https
  # e.g. conn = Connection.new("http", "localhost:7662")
  # conn.post("/tests/coba", { staging_action: "backburner:restart" })
  attr_accessor :scheme, :host

  Timeout = 60
  OpenTimeout = 60

  def initialize(scheme, host)
    @scheme = scheme
    @host = host
    @auth = "Basic #{::JenkinsConfiguration['authorization']}"
  end

  # query is for url query
  # payload is for json body
  def post(url, query = {}, payload = {})
    restclient({
      method: :post,
      url: "#{@scheme}://#{@host}/#{url}",
      timeout: Timeout,
      open_timeout: OpenTimeout,
      payload: payload.to_json,
      headers: {
        authorization: @auth,
        content_type: :json,
        accept: :json,
        params: query
      }
    })
  end

  def restclient(opts, &block)
    payload = opts.reject { |k, v| k == :headers }
    ::RestClient::Request.execute(opts, &block)
  rescue => e
    raise ::AlphaBrokerBot::ConnectionError.new
  end
end
