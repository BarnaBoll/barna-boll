# app/views/sitemaps/index.xml.builder

xml.instruct! :xml, version: "1.0", encoding: "UTF-8"

xml.urlset xmlns: "http://www.sitemaps.org/schemas/sitemap/0.9" do
  now = Time.current

  [
    [ root_url,     "weekly",  "1.0" ],
    [ about_url,    "monthly", "0.7" ],
    [ features_url, "monthly", "0.8" ],
    [ business_url, "monthly", "0.7" ],
    [ help_url,     "weekly",  "0.6" ],
    [ contact_url,  "weekly",  "0.9" ],
    [ privacy_url,  "yearly",  "0.3" ],
    [ terms_url,    "yearly",  "0.3" ]
  ].each do |loc, freq, priority|
    xml.url do
      xml.loc        loc
      xml.lastmod    now.strftime("%Y-%m-%d")
      xml.changefreq freq
      xml.priority   priority
    end
  end
end
