# frozen_string_literal: true

require 'pdf-reader'
require 'open-uri'

class Druid2Text
  class Pdf2Text
    attr_reader :url
    def initialize(url)
      @url = url
    end

    def pages
      @pages ||= reader.pages.map do |page|
        sanitize(page.text)
      end
    end

    private

    def reader
      @reader ||= ::PDF::Reader.new(file)
    rescue => e
      puts "PDF Read failed for #{url} with #{e}" if Druid2Text::DEBUG
    end

    def file
      URI.open(url)
    end

    def training_data_dir
      './training_data'
    end

    def sanitize(t)
      t.gsub(/\n{2,}/, "\n")
    end
  end
end
