# frozen_string_literal: true

require_relative 'druid_2_text/purl'
require_relative 'druid_2_text/pdf_2_text'
require_relative 'druid_2_text/text_file_writer'

class Druid2Text
  DEBUG = false

  def self.call(druids:, results_handler: TextFileWriter)
    druids.each do |druid|
      files = Purl.new(druid).file_names
      pdf_pages = []

      files.each do |file|
        puts "Processing #{file} (#{druid})" if DEBUG
        pdf = Pdf2Text.new(file)
        if block_given?
          yield druid, pdf.pages
        else
          pdf_pages << pdf.pages.join("\n\n")
        end
      end

      results_handler.new(druid: druid, text: pdf_pages.join("\n\n")) unless block_given?
    end
  end
end
