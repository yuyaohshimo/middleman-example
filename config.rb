page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false

configure :development do
  activate :livereload
end

activate :directory_indexes

activate :dato,
  token: '34efe0503b553b72c90d3f758b294b9258b774c9b1e1c1d471',
  base_url: 'https://datocms-middleman-example.netlify.com'

set :url_root, 'https://datocms-middleman-example.netlify.com'

ignore "/templates/*"

dato.characters.each do |character|
  proxy "/characters/#{character.slug}.html", "/templates/character.html",
    locals: { character: character }
end

dato.seasons.each do |season|
  proxy "/seasons/#{season.slug}.html", "/templates/season.html",
    locals: { season: season }
end

dato.episodes.each do |episode|
  proxy "/episodes/#{episode.slug}.html", "/templates/episode.html",
    locals: { episode: episode }
end

activate :pagination

paginate dato.episodes.sort_by(&:first_aired), "/episodes", "/templates/episodes.html"

configure :build do
  activate :minify_css
  activate :minify_javascript
end

helpers do
  def markdown(text)
    renderer = Redcarpet::Render::HTML.new
    Redcarpet::Markdown.new(renderer).render(text)
  end

  def image_or_missing(image)
    if image
      yield image
    else
      image_tag "/images/missing-image.png"
    end
  end
end
