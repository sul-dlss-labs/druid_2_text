# frozen_string_literal: true

class Druid2Text
  class TextFileWriter
    def initialize(druid:, text:)
      @druid = druid
      @text = text
      write
    end

    def write
      puts "#{druid} has no text" if text.empty? && Druid2Text::DEBUG
      File.open("#{text_results_directory}/#{druid}.txt", 'w') do |f|
        f.write text
      end
    end

    private

    attr_reader :druid, :text

    def text_results_directory
      "#{__dir__}/../results"
    end
  end
end
