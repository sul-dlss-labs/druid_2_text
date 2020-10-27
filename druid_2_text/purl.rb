# frozen_string_literal: true

require 'faraday'
require 'nokogiri'

class Druid2Text
  class Purl
    MIMETYPE = 'application/pdf'.freeze

    attr_reader :druid
    def initialize(druid)
      @druid = druid
    end

    def file_names
      ng_xml.xpath("//contentMetadata/resource/file[@mimetype=\"#{MIMETYPE}\"]").map do |file|
        "https://stacks.stanford.edu/file/druid:#{druid}/#{file['id'].gsub(' ', '%20')}"
      end.flatten.compact
    end

    def files
      ng_xml.xpath('//contentMetadata/resource/file')
    end

    private

    def ng_xml
      ::Nokogiri::XML.parse(response)
    end

    def response
      @response ||= ::Faraday.get(url).body
    rescue => e
      puts "Request for #{druid} failed with #{e}" if Druid2Text::DEBUG
      ''
    end

    def url
      "https://purl.stanford.edu/#{druid}.xml"
    end
  end
end
