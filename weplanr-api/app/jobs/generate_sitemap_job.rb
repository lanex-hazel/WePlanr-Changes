class GenerateSitemapJob

  def self.perform(production: true)
    sitemap = Sitemap.new
    sitemap.generate_xml
    sitemap.save_to_disk

    ping_google if production
  end

  def self.ping_google
    HTTParty.get('http://google.com/ping?sitemap=http://www.weplanr.com/sitemap.xml')
  end


  class Sitemap
    SAVE_PATH = File.join(*%w(/home deploy app shared sitemap.xml))

    STATIC_PAGES = %w(
      https://www.weplanr.com/
      https://www.weplanr.com/index
      https://www.weplanr.com/vendor/app
      https://www.weplanr.com/vendor/register
    )

    XLMNS_META = {
      xmlns: 'http://www.sitemaps.org/schemas/sitemap/0.9',
      'xmlns:image' => 'http://www.google.com/schemas/sitemap-image/1.1'
    }


    def generate_xml
      sitemap = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml| 
        xml.urlset(XLMNS_META) do

          STATIC_PAGES.each do |page|
            xml.url { xml.loc page }
          end

          Vendor.searchable.includes(:photos).includes(:tags).each do |vendor|
            xml.url do
              xml.loc 'https://www.weplanr.com/profile/' << vendor.slug

              vendor.photos.limit(7).each do |photo|
                xml.send('image:image') do
                  xml.send('image:loc', photo.url)
                  xml.send('image:caption', vendor.tag_list.join(' ')) if vendor.tag_list.any?
                end
              end

            end
          end

        end
      end

      @xml = sitemap.to_xml
    end

    def save_to_disk
      xml_file = File.open(SAVE_PATH, 'w')
      xml_file.puts @xml
      xml_file.close
    end
  end

end
