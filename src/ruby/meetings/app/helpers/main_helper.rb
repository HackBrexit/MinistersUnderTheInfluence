module MainHelper
  def url_for_locale(locale)
    base_host = request.host_with_port.split('.')
    base_host[0]=locale
    link_host = base_host.join('.')
    "#{request.protocol}#{link_host}#{request.fullpath}"
  end
end
