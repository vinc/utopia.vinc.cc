map "/img" do
  run Rack::File.new("img")
end

map "/css" do
  run Rack::File.new("css")
end

class Application
  def call(env)
    images = Dir.glob("img/*.jpg").sort
    request = Rack::Request.new(env)
    page = (request.params["p"] || "1").to_i
    per_page = 50
    max_page = images.count / per_page

    content = "<html>"
    content += "<head><title>Utopia 2300 (#{page} / #{max_page})</title><link rel=\"stylesheet\" href=\"css/utopia.css\"></head>"
    content += "<body>"
    content += "<h1>Utopia 2300</h1>"
    content += "<p>The year is 2300 and the world is vastly different from what it was in the past. The population has peaked and has been steadily decreasing for the past two centuries. To allow nature to heal, half of the land on Earth has been set aside for the wilderness. This has resulted in the creation of vast and diverse ecosystems that are now thriving.</p>"
    content += "<p>In addition, the world has moved towards post-scarcity anarchist societies. Technology has advanced to the point where almost everything can be produced with ease and without the need for extensive resource extraction. This has led to the creation of societies that are based on principles of mutual aid, cooperation, and equality.</p>"
    content += "<p>The post-scarcity anarchist societies are diverse, with different communities and groups organizing themselves in different ways. Some are organized around small-scale communities that are self-sufficient and rely on local resources. Others are organized around networks of larger communities that share resources and knowledge.</p>"
    content += "<p>Despite the differences in organization, these societies share a commitment to non-hierarchical decision-making, direct democracy, and the abolition of all forms of oppression. They are also committed to the protection of the natural world and the promotion of biodiversity.</p>"
    images[(page * per_page)..((page + 1) * per_page)].each do |img|
      content += "<img src=\"/#{img}\" alt=\"#{img}\" title=\"#{img}\" height=\"256\" width=\"256\" />"
    end
    content += "<footer>"
    (1..max_page).each do |i|
      if i == page
        content += "<span>#{i}</span>"
      else
        content += "<a href=\"?p=#{i}\">#{i}</a>"
      end
    end
    content += "</footer>"
    content += "</body>"
    content += "</html>"
    [200, {}, [content]]
  end
end

run Application.new
